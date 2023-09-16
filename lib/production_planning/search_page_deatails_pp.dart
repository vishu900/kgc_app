import 'package:animated_button/animated_button.dart';
import 'package:dataproject2/production_planning/process_order.dart';
import 'package:dataproject2/production_planning/sale_order.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dataproject2/production_planning/search_details_model.dart';
import 'package:dataproject2/production_planning/selected_item_model_pp.dart';
import 'package:dataproject2/production_planning/update_pp_model.dart';

class SearchPagedetailsPP extends StatefulWidget {
  GetSearchDetailsPP getSearchDetails;
  var code;
  var userid;
  SearchPagedetailsPP(
      {super.key,
      required this.code,
      required this.getSearchDetails,
      required this.userid});

  @override
  State<SearchPagedetailsPP> createState() => _SearchPagedetailsPPState();
}

class _SearchPagedetailsPPState extends State<SearchPagedetailsPP> {
  var accCode;
  var contactPersonCode;

  List<SelectedItemModelPP> selected_items_list = [];

  // ProcessOrderModel? processOrder;

  List<String> tempQtyList = [];

  List<UpdateModelPP> updateList = [];

  // driver list

  List<Map<String, dynamic>> driverName = [];
  Map<String, dynamic>? itemSelected;
  List<Map<String, dynamic>> _driverList = [];

  String totalqty = "0", totalbag = "0", totalamount = "0", godown = "";

  List<Map<String, dynamic>> _searchListDetails = [];

  @override
  void initState() {
    super.initState();
    // getDriverList();

    getSearchDetails();

    getPermission(widget.userid, "taskid", widget.code);
  }

  String myDataPermission = "";
  String myDeletePermission = "";

  List<Map<String, dynamic>> permission = [];

  Future<void> getPermission(
      String username, String taskid, String compCode) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/GetPermissions?username=" +
            username +
            "&taskid=PROD_PLAN_MA" +
            "&compCode=" +
            compCode);
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      permission = List.castFrom(jsonResponseList);
      myDataPermission = permission[0]["MODE_FLAG"].toString();
      myDeletePermission = permission[0]["DEL_FLAG"].toString();
    });
  }

  Future<void> deleteSingle(String codepk, String codepkhdr) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/deleteifOnePP?codepk=" +
            codepk +
            "&codepkhdr=" +
            codepkhdr);
    print("codepkhdr: " + codepkhdr);
    print("CodePk: " + codepk);

    final response = await http.get(url);
    final result = response.body.toString();
    setState(
      () {
        if (result == "Successfull") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Successfull"),
                content: const Text("Deleted Successfull"),
                actions: [
                  AnimatedButton(
                    width: 100,
                    height: 40,
                    color: Colors.red,
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Future<void> deleteMultiple(String codepk) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/deletePP?codepk=" + codepk);
    print("CodePk: " + codepk);

    final response = await http.get(url);
    final result = response.body.toString();
    setState(
      () {
        if (result == "Successfull") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Successfull"),
                content: const Text("Deleted Successfull"),
                actions: [
                  AnimatedButton(
                    width: 100,
                    height: 40,
                    color: Colors.red,
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Future<void> update(String newqty, String codepk, String newhsn) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/updatePP?newqty=" +
            newqty +
            "&codepk=" +
            codepk);
    print("New Qty: " + newqty);
    print("CodePk: " + codepk);

    final response = await http.get(url);
    final result = response.body.toString();
    setState(
      () {
        if (result == "Successfull") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Successfull"),
                content: const Text("Data Updated Successfull"),
                actions: [
                  AnimatedButton(
                    width: 100,
                    height: 40,
                    color: Colors.red,
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  List<TextEditingController> qtyControllers = [];

  Future<void> getSearchDetails() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/SearchItemsDetailPP?code_pk=" +
            widget.getSearchDetails.code_Pk.toString());
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    double tempbag = 0.0;
    double tempqty = 0.0;
    double tempamount = 0.0;

    setState(
      () {
        _searchListDetails = List.castFrom(jsonResponseList);
        // tempQtyList.clear();
        // getProcessOrder(_searchListDetails[0]["CODE_PK"].toString());
        for (var searchItems in _searchListDetails) {
          updateList.add(UpdateModelPP(
          newqty: searchItems["PLAN_QTY"].toString(),
          codepk: searchItems["CODE_PK"].toString(),
          newhsn: ""));

          // tempbag = tempbag + double.parse(searchItems["ROLL_NO"].toString());
          // tempqty = tempqty + double.parse(searchItems["QTY"].toString());
          // tempamount = tempamount +
          // double.parse(searchItems["AMOUNT"].toString() == "null"
          // ? "0"
          // : searchItems["AMOUNT"].toString());

          // tempQtyList.add(searchItems["QTY"].toString());

          qtyControllers.add(TextEditingController());

          selected_items_list.add(SelectedItemModelPP(
            CATALOG_ITEM: searchItems["CATALOG_ITEM"],
            CATALOG_NAME: searchItems["CATALOG_NAME"],
            COUNT_CODE: searchItems["COUNT_CODE"],
            COUNT_NAME: searchItems["COUNT_NAME"],
            ITEM_CODE: searchItems["ITEM_CODE"],
            ITEM_NAME: searchItems["ITEM_NAME"],
            MATERIAL_CODE: searchItems["MATERIAL_CODE"],
            MATERIAL_NAME: searchItems["MATERIAL_NAME"],
            SHADE_CODE: searchItems["SHADE_CODE"],
            SHADE_NAME: searchItems["SHADE_NAME"],
            BRAND_CODE: searchItems["BRAND_CODE"],
            BRAND_NAME: searchItems["BRAND_NAME"],
            PROC_CODE: searchItems["PROC_CODE"],
            PROC_NAME: searchItems["PROC_NAME"],
            PLAN_QTY: searchItems["PLAN_QTY"],
            UOM_ABV: searchItems["UOM_ABV"],
            SALE_ORDER_DTL_PK: searchItems["SALE_ORDER_DTL_PK"].toString(),
            PROD_ORDER_HDR_FK: searchItems["PROD_ORDER_HDR_FK"].toString(),
          )

              );


        }
        for(int i=0; i<_searchListDetails.length; i++){
          qtyControllers[i].text = _searchListDetails[i]["PLAN_QTY"].toString();
          print("PlanQty: "+_searchListDetails[i]["PLAN_QTY"].toString());
        }
        totalbag = tempbag.toString();
        totalamount = tempamount.toString();
        totalqty = tempqty.toString();
        // godown = selected_items_list[0].godownName.toString();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffd53233),
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios)),
          title: const Text("Search Item Details"),
          actions: [
            GestureDetector(
              onTap: () {

                if (myDataPermission == "A" || myDataPermission == "M") {
                  for (int i = 0; i <updateList.length; i++) {
                    update(
                        qtyControllers[i].text.toString(),
                        updateList[i].codepk.toString(),
                        updateList[i].newhsn.toString());
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Error"),
                        content: const Text(
                            "You Don't Have Permission to Perform this task"),
                        actions: [
                          AnimatedButton(
                            width: 100,
                            height: 40,
                            color: Colors.red,
                            child: const Text(
                              "OK",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 20, right: 15),
                child: Text(
                  "Modify",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Doc No",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      widget.getSearchDetails.docNo,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Doc Date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      DateFormat('dd.MM.yy').format(
                        DateTime.parse(
                          widget.getSearchDetails.docDate.toString(),
                        ),
                      ),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Fin Year",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      widget.getSearchDetails.finYear,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Party",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      widget.getSearchDetails.party,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Contact Person",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      widget.getSearchDetails.contPerson,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "Selected Items",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(
                    0xffd53233,
                  ),
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                height: 600,
                child: PageView.builder(
                  itemCount: selected_items_list.length,
                  itemBuilder: (context, index) => Padding(
                    padding:
                        const EdgeInsets.only(left: 18, right: 18, bottom: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          children: [

                            const SizedBox(height: 5.0),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //Delete Here

                                    if (myDeletePermission == "Y") {
                                      if (updateList.length > 1) {
                                        deleteMultiple(
                                            updateList[index]
                                                .codepk
                                                .toString());
                                      } else {
                                        deleteSingle(
                                            updateList[index]
                                                .codepk
                                                .toString(),
                                            widget.getSearchDetails
                                                .code_Pk
                                                .toString());
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                            const Text("Error"),
                                            content: const Text(
                                                "You Don't Have Permission to Perform this task"),
                                            actions: [
                                              AnimatedButton(
                                                width: 100,
                                                height: 40,
                                                color: Colors.red,
                                                child: const Text(
                                                  "OK",
                                                  style: TextStyle(
                                                    color:
                                                    Colors.white,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(
                                                      context)
                                                      .pop();
                                                  Navigator.of(
                                                      context)
                                                      .pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Catalog Item - Catalog Name"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${selected_items_list[index].CATALOG_ITEM} - ${selected_items_list[index].CATALOG_NAME}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Count Code - Count Name"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${selected_items_list[index].COUNT_CODE} - ${selected_items_list[index].COUNT_NAME}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Item Code - Item Name"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${selected_items_list[index].ITEM_CODE} - ${selected_items_list[index].ITEM_NAME}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Material Code - Material Name"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${selected_items_list[index].MATERIAL_CODE} - ${selected_items_list[index].MATERIAL_NAME}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Shade Code - Shade Name"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${selected_items_list[index].SHADE_CODE} - ${selected_items_list[index].SHADE_NAME}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Brand Code - Brand Name"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${selected_items_list[index].BRAND_CODE} - ${selected_items_list[index].BRAND_NAME}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Proc Code - Proc Name"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${selected_items_list[index].PROC_CODE} - ${selected_items_list[index].PROC_NAME}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Qty"),
                                      TextFormField(
                                        controller: qtyControllers[index],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9.,]')),
                                        ],
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.clear),
                                            onPressed: () {
                                              // qtyControllers[index].clear();
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("ABV"),
                                ),
                                // Expanded(
                                //   flex: 1,
                                //   child: Text("Bal Qty"),
                                // ),
                                // Expanded(
                                //   flex: 1,
                                //   child: Text("Rate"),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    selected_items_list[index]
                                        .UOM_ABV
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Container(
                              alignment: Alignment.center,
                              height: 20.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${index + 1}/${selected_items_list.length}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => SaleOrderPP(
                                            SALE_ORDER_DTL_PK:
                                            selected_items_list[index].SALE_ORDER_DTL_PK),
                                      ),
                                    );
                                  },
                                  child: const Text("Sale Order"),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProcessOrederPP(
                                          PROD_ORDER_HDR_PK:
                                          selected_items_list[index].PROD_ORDER_HDR_FK,
                                          SALE_ORDER_DTL_PK:
                                          selected_items_list[index].SALE_ORDER_DTL_PK,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text("Process Order"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}