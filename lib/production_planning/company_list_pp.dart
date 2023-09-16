import 'package:dataproject2/production_planning/pp_form.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CompanyListPP extends StatefulWidget {
  // String userId;

  const CompanyListPP({
    super.key,

    //  required this.userId,
  });

  @override
  State<CompanyListPP> createState() => _CompanyListPPState();
}

class _CompanyListPPState extends State<CompanyListPP> {
  List<Map<String, dynamic>> _displayList = [];

  @override
  void initState() {
    super.initState();
    getCompanyList();
  }

  Future<void> getCompanyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        "http://103.204.185.17:24977/webapi/api/Common/GetCompanyFromTask?p_Taskid=PROD_PLAN_MA&p_userid="+prefs.getString('user_id')!);
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    setState(
      () {
        _displayList = List.castFrom(jsonResponseList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffd53233),
        leading: GestureDetector(
            onTap: Navigator.of(context).pop,
            child: const Icon(Icons.arrow_back_ios)),
        title: const Text(
          "Companies",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: ListView.builder(
          itemCount: _displayList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PPForm(
                    code: _displayList[index]["Code"].toString(),
                    userid: prefs.getString('user_id')!,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                child: ListTile(
                  title: Text(
                    _displayList[index]["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
