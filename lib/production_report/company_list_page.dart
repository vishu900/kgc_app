import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'searchPage.dart';

import 'itemResultModel.dart';

class CompanyListPagePR extends StatefulWidget {

  String userID;

  CompanyListPagePR({super.key, required this.userID});

  @override
  State<CompanyListPagePR> createState() => _CompanyListPagePRState();
}

class _CompanyListPagePRState extends State<CompanyListPagePR> {
  List<Map<String, dynamic>> _displayList = [];

  List<ItemResultModel> selectionList = [];

  @override
  void initState() {
    super.initState();
    getCompanyList();
  }

  Future<void> getCompanyList() async {
    final url = Uri.parse(
        "http://103.204.185.17:24977/webapi/api/Common/GetCompanyFromTask?p_Taskid=PROD_REP_MA&p_userid=" +
            widget.userID);
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
            child: Icon(Icons.arrow_back_ios)),
        title: const Text("Companies"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: ListView.builder(
          itemCount: _displayList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              print(
                "rahul" + _displayList[index]["Code"].toString(),
              );

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SearchPage(
                    compCode: _displayList[index]["Code"].toString(), comp_name: _displayList[index]["name"],
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
