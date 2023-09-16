import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dataproject2/material_issue/screens/production_form_page.dart';

class CompaniesListPage extends StatefulWidget {
  String userID;

  CompaniesListPage({Key? key, required this.userID}) : super(key: key);

  @override
  State<CompaniesListPage> createState() => _CompaniesListPageState();
}

class _CompaniesListPageState extends State<CompaniesListPage> {
  List<Map<String, dynamic>> _displayList = [];

  List<String> _imageUrls = [
    "images/kmtoverseaslogo.png",
    "images/appstore.png",
    "images/indiatextilelogo.png",
    "images/kmtlogo.png",
  ];

  @override
  void initState() {
    super.initState();
    getCompanyList();
  }

  Future<void> getCompanyList() async {
    final url = Uri.parse(
        "http://103.204.185.17:24977/webapi/api/Common/GetCompanyFromTask?p_Taskid=MATERIAL_ISSUE_4_PROD_ORD&p_userid=" +
            widget.userID);
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    setState(() {
      _displayList = List.castFrom(jsonResponseList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffd53233),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Matrial Issue"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: ListView.builder(
          itemCount: _displayList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductionFormPAge(
                    code: _displayList[index]["Code"].toString(),
                    userid: widget.userID,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                child: ListTile(
                  leading: SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      _imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  ),
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
