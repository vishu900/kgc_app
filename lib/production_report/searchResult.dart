import 'dart:convert';

import 'package:dataproject2/production_report/CreatePDF.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Commons/ViewPDF.dart';
import 'DetailRequestModel.dart';
import 'details_page.dart';

class SearchResultPr extends StatefulWidget {
  String fromdate,
      todate,
      partycode,
      catelogitem,
      materialcode,
      shadecode,
      compCode,
      username,
      DOC_FINYEAR,
      BRAND_CODE,
      contactOption,
      COUNT_CODE,
      ITEM_CODE,
      GODOWN_CODE,
      fromto,
      comp_name,
      day_night;
  SearchResultPr(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.partycode,
      required this.catelogitem,
      required this.materialcode,
      required this.shadecode,
      required this.compCode,
      required this.username,
      required this.DOC_FINYEAR,
      required this.BRAND_CODE,
      required this.contactOption,
      required this.COUNT_CODE,
      required this.ITEM_CODE,
      required this.GODOWN_CODE,
      required this.fromto,
      required this.comp_name,
      required this.day_night,})
      : super(key: key);

  @override
  State<SearchResultPr> createState() => _SearchResultPrState();
}

class _SearchResultPrState extends State<SearchResultPr> {
  TextStyle headingStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  String isloading = "true";

  List<Map<String, dynamic>> searchList = [];
  List<Map<String, dynamic>> sumList = [];
  List<Color> bgColors = [];

  double total_day = 0.0, total_night = 0.0;

  List<Map<String, dynamic>> removeDuplicates(
      List<Map<String, dynamic>> people) {
    List<Map<String, dynamic>> distinct;
    List<Map<String, dynamic>> dummy =
        List.from(people); // Create a copy of the original list

    for (int i = 0; i < dummy.length; i++) {
      for (int j = i + 1; j < dummy.length; j++) {
        if (dummy[i]["ACC_CONT_PERSON_CODE"] ==
            dummy[j]["ACC_CONT_PERSON_CODE"]) {
          dummy.removeAt(j);
          j--; // Decrement j since we removed an element from the list
        }
      }
    }

    distinct = dummy;
    print(distinct);

    return distinct.map((e) => e).toList();
  }

  Future<void> searchProduction() async {
    total_day = 0.0;
    total_night = 0.0;
    sumList.clear();
    String add_query = "";
    if(widget.day_night=="Day"){
      add_query = " AND STK.PROD_DAY>0";
    } else if(widget.day_night=="Night"){
      add_query = " AND STK.PROD_NIGHT>0";
    } else {
      add_query = "";
    }
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/SearchProductionReport?START_DATE=${widget.fromdate}"
        "&END_DATE=${widget.todate}"
        "&ACC_CODE=${widget.partycode}"
        "&CATALOG_ITEM=${widget.catelogitem}"
        "&MATERIAL_CODE=${widget.materialcode}"
        "&SHADE_CODE=${widget.shadecode}"
        "&COMP_CODE=${widget.compCode}"
        "&ACC_CONT_PERSON_CODE=${widget.contactOption}"
        "&USERNAME=${widget.username}"
        "&DOC_FINYEAR=${widget.DOC_FINYEAR}"
        "&BRAND_CODE=${widget.BRAND_CODE}"
        "&COUNT_CODE=${widget.COUNT_CODE}"
        "&ITEM_CODE=${widget.ITEM_CODE}"
        "&GODOWN_CODE=${widget.GODOWN_CODE}"+"&add_query=${add_query}");
    //USERNAME
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    List<Map<String, dynamic>> tempSearchList = [];

    isloading = "no";

    setState(() {
      tempSearchList = removeDuplicates(List.castFrom(jsonResponseList));

      for(var tempItem in tempSearchList){
        if(widget.day_night == "Both"){
          searchList.add(tempItem);
        }
        else if(widget.day_night == "Day"){
          if(double.parse(tempItem["PROD_DAY"].toString())>0){
            searchList.add(tempItem);
          }
        }else if(widget.day_night == "Night"){
          if(double.parse(tempItem["PROD_NIGHT"].toString())>0){
            searchList.add(tempItem);
          }
        }
      }

      searchList.sort((a, b) => a["DOC_DATE"].compareTo(b["DOC_DATE"]));

      for (int i = 0; i < searchList.length; i++) {
        bgColors.add(Colors.white);

        GetProductionTotal(searchList[i]["ACC_CONT_PERSON_CODE"].toString());
      }
    });
  }

  Future<bool> GetProductionTotal(String ACC_CONT_PERSON_CODE) async {
    print("MyCP1" + ACC_CONT_PERSON_CODE.toString());
    String add_query = "";
    if(widget.day_night=="Day"){
      add_query = " AND STK.PROD_DAY>0";
    } else if(widget.day_night=="Night"){
      add_query = " AND STK.PROD_NIGHT>0";
    } else {
      add_query = "";
    }
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/GetProductionTotal?START_DATE=${widget.fromdate}"
        "&END_DATE=${widget.todate}"
        "&ACC_CODE=${widget.partycode}"
        "&CATALOG_ITEM=${widget.catelogitem}"
        "&MATERIAL_CODE=${widget.materialcode}"
        "&SHADE_CODE=${widget.shadecode}"
        "&COMP_CODE=${widget.compCode}"
        "&ACC_CONT_PERSON_CODE=${ACC_CONT_PERSON_CODE}"
        "&USERNAME=${widget.username}"
        "&DOC_FINYEAR=${widget.DOC_FINYEAR}"
        "&BRAND_CODE=${widget.BRAND_CODE}"
        "&COUNT_CODE=${widget.COUNT_CODE}"
        "&ITEM_CODE=${widget.ITEM_CODE}"
        "&GODOWN_CODE=${widget.GODOWN_CODE}"+"&add_query=${add_query}");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    // total_day = 0.0;
    //total_day = 0.0;
    // total_night = 0.0;
    setState(() {
      for (var data in List.castFrom(jsonResponseList)) {
        sumList.add(data);

        total_day = total_day + double.parse(data["TOTAL_DAY"].toString());
        total_night =
            total_night + double.parse(data["TOTAL_NIGHT"].toString());
      }
    });
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchProduction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prod Report Search Result"),
        actions: [

          InkWell(
              onTap: () async {
                String time = DateFormat("dd-MM-yy-HH-mm-ss").format(DateTime.now());
                String name = "Production-Report-Summery-"+time+".pdf";
                  final pdfPath = await CreatePDF.generatePDF(name, widget.fromto, widget.comp_name, searchList, sumList, total_day, total_night);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewPDF(filePath: pdfPath.path)));
              },
              child: Icon(Icons.picture_as_pdf, color: Colors.white,)),
          SizedBox(width: 10,),
        ],
      ),
      body: isloading == "init"
          ? Container()
          : isloading == "true"
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: widget.day_night == "Night"
                  ? MainAxisAlignment.start // Align "Prod Night" on the left
                  : MainAxisAlignment.spaceBetween,
              children: [
                widget.day_night == "Night"? Container():
                Column(
                  children: [
                    Text(
                      "Prod Day",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      total_day.toStringAsFixed(3),
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                widget.day_night == "Day"? Container():
                Column(
                  children: [
                    Text(
                      "Prod Night",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      total_night.toStringAsFixed(3),
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                widget.day_night == "Day" || widget.day_night == "Night"? Container():
                Column(
                  children: [
                    Text(
                      "Prod Total",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      (total_day + total_night).toStringAsFixed(3),
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
                      child: ListView.builder(
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            String daySum = "";
                            String nightSum = "";
                            for (var tempSum in sumList) {
                              if (tempSum["ACC_CONT_PERSON_CODE"] ==
                                  searchList[index]["ACC_CONT_PERSON_CODE"]) {
                                daySum =
                                    tempSum["TOTAL_DAY"].toStringAsFixed(3);
                                nightSum =
                                    tempSum["TOTAL_NIGHT"].toStringAsFixed(3);
                              }
                            }

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  bgColors[index] = Color(0xFFFF7E7E);
                                });

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => DetailsPagePR(
                                            detailRequestModel:
                                                DetailRequestModel(
                                              fromdate: widget.fromdate,
                                              todate: widget.todate,
                                              partycode: widget.partycode,
                                              catelogitem: widget.catelogitem,
                                              materialcode: widget.materialcode,
                                              shadecode: widget.shadecode,
                                              compCode:
                                                  widget.compCode.toString(),
                                              ACC_CONT_PERSON_CODE: searchList[
                                                          index]
                                                      ["ACC_CONT_PERSON_CODE"]
                                                  .toString(),
                                              username: widget.username,
                                              DOC_FINYEAR: widget.DOC_FINYEAR,
                                              BRAND_CODE: widget.BRAND_CODE,
                                              COUNT_CODE: widget.COUNT_CODE,
                                              ITEM_CODE: widget.ITEM_CODE,
                                              GODOWN_CODE: widget.GODOWN_CODE,
                                            ), fromto: widget.fromto, comp_name: widget.comp_name,
                                        day_night: widget.day_night,
                                          )),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: bgColors[index],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Machine Code/Contact Person: ",
                                          style: headingStyle,
                                        ),
                                        Expanded(
                                            child: Text(searchList[index]
                                                ["CONTACT_PERSON"]))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Party: ",
                                          style: headingStyle,
                                        ),
                                        Expanded(
                                            child: Text(searchList[index]
                                                ["PARTY_NAME"]))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment: widget.day_night == "Night"? MainAxisAlignment.start:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        widget.day_night == "Night"? Container():
                                        Column(
                                          children: [
                                            Text(
                                              "Prod Day",
                                              style: headingStyle,
                                            ),
                                            Text(daySum),
                                          ],
                                        ),
                                        widget.day_night == "Day"? Container():
                                        Column(
                                          children: [
                                            Text(
                                              "Prod Night",
                                              style: headingStyle,
                                            ),
                                            Text(nightSum),
                                          ],
                                        ),
                                        widget.day_night == "Day" || widget.day_night == "Night"? Container():
                                        Column(
                                          children: [
                                            Text(
                                              "Total Prod",
                                              style: headingStyle,
                                            ),
                                            Text((double.parse(daySum) +
                                                    double.parse(nightSum))
                                                .toStringAsFixed(3)),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          (index + 1).toString() +
                                              "/" +
                                              searchList.length.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.red),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
        ],
      ),
    );
  }
}
