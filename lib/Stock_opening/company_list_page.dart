import 'package:dataproject2/Stock_opening/ViewItemDetail.dart';
import 'package:dataproject2/Stock_opening/model/ItemResultModel.dart';
import 'package:dataproject2/Stock_opening/selected_company_code.dart';
import 'package:dataproject2/Stock_opening/stocko_opening_2.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompanyListPageSI extends StatefulWidget {
  final ComingFrom? comingFrom;
  String userId;

  CompanyListPageSI({super.key, this.comingFrom, required this.userId});

  @override
  State<CompanyListPageSI> createState() => _CompanyListPageSIState();
}

class _CompanyListPageSIState extends State<CompanyListPageSI> {
  List<Map<String, dynamic>> _displayList = [];

  List<ItemResultModel> selectionList = [];

  @override
  void initState() {
    super.initState();
    getCompanyList();
  }

  Future<void> getCompanyList() async {
    final url = Uri.parse(
        "http://103.204.185.17:24977/webapi/api/Common/GetCompanyFromTask?p_Taskid=STOCK_OPENING&p_userid=" +
            widget.userId);
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
              selectedCompanyCode().code =
                  _displayList[index]["Code"].toString();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Stock2(
                    code: _displayList[index]["Code"].toString(),
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
