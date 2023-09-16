import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import '../Commons/ViewPDF.dart';
import '../Stock_opening/show_image_so.dart';
import 'CreateFullPDF.dart';
import 'DetailRequestModel.dart';

import 'detailsModel.dart';
import 'package:http/http.dart' as http;

class DetailsPagePR extends StatefulWidget {
  DetailRequestModel detailRequestModel;
  String fromto, comp_name, day_night;
  DetailsPagePR({Key? key, required this.detailRequestModel, required this.fromto, required this.comp_name, required this.day_night,}) : super(key: key);

  @override
  State<DetailsPagePR> createState() => _DetailsPagePRState();
}

class _DetailsPagePRState extends State<DetailsPagePR> {
  List<DetailsModel> searchList = [];
  double total_day = 0.0, total_night = 0.0;
  String isloading = "true";


  String dateformat(DateTime date) {
    String formattedDate = DateFormat('dd.MM.yyyy').format(date);
    return formattedDate;
  }

  Future<void> searchProduction(
      String fromdate,
      todate,
      partycode,
      catelogitem,
      materialcode,
      shadecode,
      compCode,
      ACC_CONT_PERSON_CODE,
      USERNAME,
      DOC_FINYEAR,
      BRAND_CODE,
      COUNT_CODE,
      ITEM_CODE,
      GODOWN_CODE) async {

    String add_query = "";
    if(widget.day_night=="Day"){
      add_query = " AND STK.PROD_DAY>0";
    } else if(widget.day_night=="Night"){
      add_query = " AND STK.PROD_NIGHT>0";
    } else {
      add_query = "";
    }

    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/SearchProductionReport?START_DATE=${fromdate}&END_DATE=${todate}"
        "&ACC_CODE=${partycode}"
        "&CATALOG_ITEM=${catelogitem}"
        "&MATERIAL_CODE=${materialcode}"
        "&SHADE_CODE=${shadecode}"
        "&COMP_CODE=${compCode}"
        "&ACC_CONT_PERSON_CODE=${ACC_CONT_PERSON_CODE}"
        "&USERNAME=${USERNAME}"
        "&DOC_FINYEAR=${DOC_FINYEAR}"
        "&BRAND_CODE=${BRAND_CODE}"
        "&COUNT_CODE=${COUNT_CODE}"
        "&ITEM_CODE=${ITEM_CODE}"
        "&GODOWN_CODE=${GODOWN_CODE}"+"&add_query=${add_query}");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    isloading = "no";

    List<Map<String, dynamic>> details = [];

    setState(() {
      details = List.castFrom(jsonResponseList);

      for (var det in details) {


          total_day = total_day + double.parse(det["PROD_DAY"].toString());
          total_night = total_night + double.parse(det["PROD_NIGHT"].toString());
          searchList.add(DetailsModel(
              machine_code: det["CONTACT_PERSON"].toString(),
              date: det["DOC_DATE"].toString(),
              process: det["DOC_NO"].toString(),
              po_number: det["PO_NO"].toString(),
              catalog_code: det["CATALOG_ITEM"].toString(),
              catalog_name: det["CATALOG_NAME"].toString(),
              prod_day: det["PROD_DAY"].toString(),
              prod_night: det["PROD_NIGHT"].toString(),
              party_name: det["PARTY_NAME"].toString(),
              gate_entry: det["GATE_ENTRY_DTL_FK"].toString(),
              count_code: det["COUNT_NAME"].toString(),
              material_name: det["MATERIAL_NAME"].toString(),
              shade: det["SHADE_NAME"].toString(),
              brand: det["BRAND_NAME"].toString(),
              prod_qty: det["PROD_QTY"].toString(),
              uom: det["UOM_ABV"].toString(),
              godown: det["GODOWN_NAME"].toString(),
              username: det["INS_UID"].toString(),
              ins_date: DateFormat("dd.MM.yyyy").format(DateTime.parse(det["INS_DATE"].toString().split("T")[0])) +" - "+ det["INS_DATE"].toString().split("T")[1]));

        // else if(widget.day_night == "Day"){
        //  // if(double.parse(det["PROD_DAY"].toString())>0){
        //     total_day = total_day + double.parse(det["PROD_DAY"].toString());
        //     total_night = total_night + double.parse(det["PROD_NIGHT"].toString());
        //     searchList.add(DetailsModel(
        //         machine_code: det["CONTACT_PERSON"].toString(),
        //         date: det["DOC_DATE"].toString(),
        //         process: det["DOC_NO"].toString(),
        //         po_number: det["PO_NO"].toString(),
        //         catalog_code: det["CATALOG_ITEM"].toString(),
        //         catalog_name: det["CATALOG_NAME"].toString(),
        //         prod_day: det["PROD_DAY"].toString(),
        //         prod_night: det["PROD_NIGHT"].toString(),
        //         party_name: det["PARTY_NAME"].toString(),
        //         gate_entry: det["GATE_ENTRY_DTL_FK"].toString(),
        //         count_code: det["COUNT_NAME"].toString(),
        //         material_name: det["MATERIAL_NAME"].toString(),
        //         shade: det["SHADE_NAME"].toString(),
        //         brand: det["BRAND_NAME"].toString(),
        //         prod_qty: det["PROD_QTY"].toString(),
        //         uom: det["UOM_ABV"].toString(),
        //         godown: det["GODOWN_NAME"].toString(),
        //         username: det["INS_UID"].toString(),
        //         ins_date: det["INS_DATE"].toString().split("T")[1]));
        //
        // }else if(widget.day_night == "Night"){
        //   //if(double.parse(det["PROD_NIGHT"].toString())>0){
        //     total_day = total_day + double.parse(det["PROD_DAY"].toString());
        //     total_night = total_night + double.parse(det["PROD_NIGHT"].toString());
        //     searchList.add(DetailsModel(
        //         machine_code: det["CONTACT_PERSON"].toString(),
        //         date: det["DOC_DATE"].toString(),
        //         process: det["DOC_NO"].toString(),
        //         po_number: det["PO_NO"].toString(),
        //         catalog_code: det["CATALOG_ITEM"].toString(),
        //         catalog_name: det["CATALOG_NAME"].toString(),
        //         prod_day: det["PROD_DAY"].toString(),
        //         prod_night: det["PROD_NIGHT"].toString(),
        //         party_name: det["PARTY_NAME"].toString(),
        //         gate_entry: det["GATE_ENTRY_DTL_FK"].toString(),
        //         count_code: det["COUNT_NAME"].toString(),
        //         material_name: det["MATERIAL_NAME"].toString(),
        //         shade: det["SHADE_NAME"].toString(),
        //         brand: det["BRAND_NAME"].toString(),
        //         prod_qty: det["PROD_QTY"].toString(),
        //         uom: det["UOM_ABV"].toString(),
        //         godown: det["GODOWN_NAME"].toString(),
        //         username: det["INS_UID"].toString(),
        //         ins_date: det["INS_DATE"].toString().split("T")[1]));
        //   //}
        // }


      }
      searchList.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchProduction(
        widget.detailRequestModel.fromdate,
        widget.detailRequestModel.todate,
        widget.detailRequestModel.partycode,
        widget.detailRequestModel.catelogitem,
        widget.detailRequestModel.materialcode,
        widget.detailRequestModel.shadecode,
        widget.detailRequestModel.compCode,
        widget.detailRequestModel.ACC_CONT_PERSON_CODE,
        widget.detailRequestModel.username,
        widget.detailRequestModel.DOC_FINYEAR,
        widget.detailRequestModel.BRAND_CODE,
        widget.detailRequestModel.COUNT_CODE,
        widget.detailRequestModel.ITEM_CODE,
        widget.detailRequestModel.GODOWN_CODE,
    );
  }

  TextStyle headingStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16);

  TextStyle headingStyleRed =
      TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: isloading == "init"
              ? Text("")
              : isloading == "true"
              ? Text("")
              :Text(
            searchList[0].machine_code,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          actions: [
            InkWell(
              onTap: () async {
                String time = DateFormat("dd-MM-yy-HH-mm-ss").format(DateTime.now());
                String name = "Production-Report-"+time+".pdf";
                final pdfPath = await CreateFullPDF.generatePDF(name, widget.fromto, widget.comp_name, total_day, total_night, searchList[0].machine_code, searchList);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewPDF(filePath: pdfPath.path)));
              },
              child: Icon(Icons.picture_as_pdf, color: Colors.white,),
            ),
            SizedBox(width: 10,)
          ],
        ),
        body: isloading == "init"
            ? Container()
            : isloading == "true"
            ? Center(child: CircularProgressIndicator())
            :Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: widget.day_night == "Night"? MainAxisAlignment.start:
                MainAxisAlignment.spaceBetween,
                children: [
                  widget.day_night == "Night"? Container():
                  Column(
                    children: [
                      Text(
                        "Prod Day",
                        style: headingStyleRed,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        total_day.toStringAsFixed(3),
                        style: headingStyleRed,
                      ),
                    ],
                  ),
                  widget.day_night == "Day"? Container():
                  Column(
                    children: [
                      Text(
                        "Prod Night",
                        style: headingStyleRed,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        total_night.toStringAsFixed(3),
                        style: headingStyleRed,
                      ),
                    ],
                  ),
                  widget.day_night == "Day" || widget.day_night == "Night"? Container():
                  Column(
                    children: [
                      Text(
                        "Prod Total",
                        style: headingStyleRed,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        (total_day + total_night).toStringAsFixed(3),
                        style: headingStyleRed,
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
                    return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
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
                          Text(
                            searchList[index].catalog_code.toString() +
                                "-" +
                                searchList[index].catalog_name,
                            style: headingStyle,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Text(
                                "Insertion Date-Time: ",
                                style: headingStyle,
                              ),
                              Text(searchList[index].ins_date)
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Row(
                              //   children: [
                              //     Text(
                              //       "Date: ",
                              //       style: headingStyle,
                              //     ),
                              //     Text(dateformat(
                              //         DateTime.parse(searchList[index].date)))
                              //   ],
                              // ),
                              Row(
                                children: [
                                  Text(
                                    "PO Number: ",
                                    style: headingStyle,
                                  ),
                                  Text(searchList[index].po_number.toString())
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Username:",
                                      style: headingStyle,
                                    ),
                                    Text(searchList[index].username.toString()),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Party",
                                      style: headingStyle,
                                    ),
                                    Text(searchList[index]
                                        .party_name
                                        .toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Gate Entry",
                                      style: headingStyle,
                                    ),
                                    Text(searchList[index]
                                        .gate_entry
                                        .toString()),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Count Code",
                                      style: headingStyle,
                                    ),
                                    Text(searchList[index]
                                        .count_code
                                        .toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Material",
                                      style: headingStyle,
                                    ),
                                    Text(searchList[index]
                                        .material_name
                                        .toString()),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Shade",
                                      style: headingStyle,
                                    ),
                                    Text(searchList[index].shade.toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Brand",
                                      style: headingStyle,
                                    ),
                                    Text(searchList[index].brand.toString()),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Prod QTY",
                                      style: headingStyle,
                                    ),
                                    Text(searchList[index].prod_qty.toString() +
                                        " " +
                                        searchList[index].uom.toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Godown",
                                      style: headingStyle,
                                    ),
                                    Text(searchList[index].godown.toString()),
                                  ],
                                ),
                              ),
                              widget.day_night == "Night"? Container():
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Prod Day",
                                      style: headingStyle,
                                    ),
                                    Text(
                                        double.parse(searchList[index].prod_day)
                                            .toStringAsFixed(3)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              widget.day_night == "Day"? Container():
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Prod Night",
                                      style: headingStyle,
                                    ),
                                    Text(double.parse(searchList[index]
                                            .prod_night
                                            .toString())
                                        .toStringAsFixed(3)),
                                  ],
                                ),
                              ),
                              widget.day_night == "Day" || widget.day_night == "Night"? Container():
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Prod",
                                      style: headingStyle,
                                    ),
                                    Text((double.parse(searchList[index]
                                                .prod_day
                                                .toString()) +
                                            double.parse(searchList[index]
                                                .prod_night
                                                .toString()))
                                        .toStringAsFixed(3)),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ShowimageSO(
                                        itemCode:
                                            searchList[index].catalog_code,
                                        //"44266"
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Show Images",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.red),
                                ),
                              ),
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
                    );
                  }),
            ),
          ],
        ));
  }
}
