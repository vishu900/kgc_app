import 'package:animated_button/animated_button.dart';
import 'package:dataproject2/material_issue/Url/url.dart';
import 'package:dataproject2/material_issue/custom_button.dart/k_button.dart';
import 'package:dataproject2/material_issue/model/process_order_model.dart';
import 'package:dataproject2/material_issue/model/selected_item_model.dart';
import 'package:dataproject2/material_issue/model/updateModel.dart';
import 'package:dataproject2/material_issue/screens/process_order.dart';
import 'package:dataproject2/material_issue/screens/sale_order.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/insert_model.dart';
import '../model/qtyModek.dart';
import '../model/search_details_model.dart';

class SearchDetailsPage extends StatefulWidget {
  GetSearchDetails getSearchDetails;
  var code;
  var userid;
  SearchDetailsPage(
      {super.key,
      required this.code,
      required this.getSearchDetails,
      required this.userid});

  @override
  State<SearchDetailsPage> createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  var accCode;
  var contactPersonCode;

  List<SelectedItemModel> selected_items_list = [];

  ProcessOrderModel? processOrder;

  List<String> tempQtyList = [];

  List<UpdateModel> updateList = [];

  // driver list

  List<Map<String, dynamic>> driverName = [];
  Map<String, dynamic>? itemSelected;
  List<Map<String, dynamic>> _driverList = [];

  String totalqty = "0", totalbag = "0", totalamount = "0", godown = "";

  List<Map<String, dynamic>> _searchListDetails = [];

  @override
  void initState() {
    super.initState();
    getDriverList();

    getSearchDetails();

    getPermission(widget.userid, "taskid", widget.code);
  }

  String myDataPermission = "";
  String myDeletePermission = "";

  List<Map<String, dynamic>> permission = [];

  Future<void> getPermission(
      String username, String taskid, String compCode) async {
    final url = Uri.parse(
        "${Reusable.baseUrl}/webapi/api/Common/GetPermissions?username=" +
            username +
            "&taskid=MATERIAL_ISSUE_4_PROD_ORD" +
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
        "${Reusable.baseUrl}/webapi/api/Common/deleteifone?codepk=" +
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
        "${Reusable.baseUrl}/webapi/api/Common/delete?codepk=" + codepk);
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
        "${Reusable.baseUrl}/webapi/api/Common/update?newqty=" +
            newqty +
            "&codepk=" +
            codepk +
            "&newhsn=" +
            newhsn);
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

  Future<void> getDriverList() async {
    final url = Uri.parse("${Reusable.baseUrl}/webapi/api/Common/GetDrviverMI");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    setState(
      () {
        _driverList = List.castFrom(jsonResponseList);
        driverName.clear();

        for (final driver in _driverList) {
          driverName.add(driver);
        }
        if (driverName.isNotEmpty) {
          itemSelected = driverName[0];
        }
      },
    );
  }

  List<Map<String, dynamic>> process_order = [];

  Future<void> getProcessOrder(String code_pk) async {
    final url = Uri.parse("${Reusable.baseUrl}/webapi/api/Common/searchprocessorder?code_pk="+code_pk);
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    setState(
          () {
            process_order = List.castFrom(jsonResponseList);
      },
    );
  }

  Future<void> getSearchDetails() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/SearchItemsDetail?code_pk=" +
            widget.getSearchDetails.code_Pk.toString());
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    double tempbag = 0.0;
    double tempqty = 0.0;
    double tempamount = 0.0;

    setState(
      () {
        _searchListDetails = List.castFrom(jsonResponseList);
        tempQtyList.clear();
        getProcessOrder(_searchListDetails[0]["CODE_PK"].toString());
        for (var searchItems in _searchListDetails) {
          updateList.add(UpdateModel(
              newqty: searchItems["QTY"].toString(),
              codepk: searchItems["CODE_PK"].toString(),
              newhsn: searchItems["HSN_CODE"]));

          tempbag = tempbag + double.parse(searchItems["ROLL_NO"].toString());
          tempqty = tempqty + double.parse(searchItems["QTY"].toString());
          tempamount = tempamount +
              double.parse(searchItems["AMOUNT"].toString() == "null"
                  ? "0"
                  : searchItems["AMOUNT"].toString());

          tempQtyList.add(searchItems["QTY"].toString());
          selected_items_list.add(
            SelectedItemModel(
              RollNo: searchItems["ROLL_NO"],
              Qty: searchItems["QTY"],
              UOM: searchItems["QTY_UOM"],
              Rate: searchItems["RATE"],
              Amount: searchItems["AMOUNT"],
              index: "",
              name: searchItems["CATALOG_ITEM_NAME"],
              hsnCode: searchItems["HSN_CODE"],
              catalogCode: "",
              prdOrderNo: "",
              orderDate: "",
              PROD_ORDER_BOM_FK: "",
              godowncode: searchItems["GODOWN_NAME"],
              lotNo: "",
              countCode: "",
              brandCode: "",
              materialCode: "",
              ITEM_CODE: "",
              shade_code: "",
              iop1_code: "",
              iop1_val: "",
              iop1_uom: "",
              iop2_code: "",
              iop2_val: "",
              iop2_uom: "",
              iop3_code: "",
              iop3_val: "",
              iop3_uom: "",
              QTY_UOM_NUM: "",
              godownName: searchItems["GODOWN_NAME"],
              pro_odr_name: searchItems["CATALOG_ITEM_NAME"],
              SALE_ORDER_DTL_PK: null,
            ),
          );

          processOrder = ProcessOrderModel(
              CATALOG_ITEM_NAME: selected_items_list[0].name,
              prdOrderNo: selected_items_list[0].prdOrderNo,
              catalogCode: selected_items_list[0].catalogCode,
              orderDate: selected_items_list[0].orderDate,
              pro_odr_name: selected_items_list[0].pro_odr_name);
        }
        totalbag = tempbag.toString();
        totalamount = tempamount.toString();
        totalqty = tempqty.toString();
        godown = selected_items_list[0].godownName.toString();
      },
    );
  }

  List<InsertModel>? insertModelList = [];

  List<QtyModel>? qtyList;

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
                  for (var modifyValue in updateList) {
                    update(
                        modifyValue.newqty.toString(),
                        modifyValue.codepk.toString(),
                        modifyValue.newhsn.toString());
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const Text(
                  "Material Issue Against Production /PO",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffd53233),
                  ),
                ),
                Row(
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
                const SizedBox(height: 5.0),
                Row(
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
                const SizedBox(height: 5.0),
                Row(
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
                const SizedBox(height: 15.0),
                Row(
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
                const SizedBox(height: 15.0),
                Row(
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
                const SizedBox(height: 15.0),
                Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text(
                            "Driver Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 35.0),
                          SizedBox(
                            height: 50,
                            width: 180,
                            child: DropdownSearch<Map<String, dynamic>>(
                              itemAsString:
                                  (Map<String, dynamic> _driverList) =>
                                      _driverList["NAME"],
                              items: _driverList,
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                              ),
                              dropdownButtonProps: const DropdownButtonProps(
                                color: Colors.red,
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                textAlignVertical: TextAlignVertical.center,
                                dropdownSearchDecoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(
                                  () {
                                    itemSelected = value!;
                                  },
                                );
                              },
                              selectedItem: itemSelected,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                Column(
                  children: [
                    SizedBox(
                      height: 360,
                      child: PageView.builder(
                        onPageChanged: (value) {
                          setState(() {
                            getProcessOrder(_searchListDetails[value]["CODE_PK"].toString());
                            godown = selected_items_list[value]
                                .godownName
                                .toString();
                          });
                          processOrder = ProcessOrderModel(
                              CATALOG_ITEM_NAME:
                                  selected_items_list[value].name,
                              prdOrderNo: selected_items_list[value].prdOrderNo,
                              catalogCode:
                                  selected_items_list[value].catalogCode,
                              orderDate: selected_items_list[value].orderDate,
                              pro_odr_name:
                                  selected_items_list[value].pro_odr_name);
                        },
                        itemCount: selected_items_list.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, bottom: 18.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selected_items_list[index].name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("HSN Code"),
                                                const SizedBox(height: 8),
                                                // TextFormField(
                                                //   controller: TextEditingController(
                                                //       text: _searchListDetails[
                                                //                           index]
                                                //                       ["HSN_CODE"]
                                                //                   .toString() ==
                                                //               "null"
                                                //           ? "0"
                                                //           : _searchListDetails[
                                                //                       index]
                                                //                   ["HSN_CODE"]
                                                //               .toString()),
                                                //   keyboardType:
                                                //       TextInputType.number,
                                                //   onChanged: (value) {
                                                //     setState(() {
                                                //       updateList[index].newhsn =
                                                //           value.toString();
                                                //     });
                                                //   },
                                                //   // onSaved: (value) {},
                                                // ),
                                                TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                    text: _searchListDetails[
                                                                        index]
                                                                    ["HSN_CODE"]
                                                                .toString() ==
                                                            "null"
                                                        ? "0"
                                                        : _searchListDetails[
                                                                    index]
                                                                ["HSN_CODE"]
                                                            .toString(),
                                                  ),
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: true),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp('[0-9.,]')),
                                                  ],
                                                  onChanged: (value) {
                                                    // Update the value when it's changed
                                                    _searchListDetails[index]
                                                        ["HSN_CODE"] = value;
                                                    // setState(() {
                                                    updateList[index].newhsn =
                                                        value.toString();
                                                    // });
                                                  },
                                                  onSaved: (value) {
                                                    // Save the new value when the form is submitted
                                                    _searchListDetails[index]
                                                        ["HSN_CODE"] = value;
                                                  },
                                                ),
                                                const SizedBox(height: 16),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        children: const [
                                          Expanded(
                                            flex: 1,
                                            child: Text("Roll No/Bag No"),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text("Qty"),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text("Uom"),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              selected_items_list[index]
                                                          .RollNo
                                                          .toString() ==
                                                      "null"
                                                  ? "0"
                                                  : selected_items_list[index]
                                                      .RollNo
                                                      .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              height: 40,
                                              child: Stack(
                                                alignment:
                                                    Alignment.centerRight,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: TextField(
                                                      enabled: false,
                                                      keyboardType: TextInputType
                                                          .numberWithOptions(
                                                              decimal: true),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                '[0-9.,]')),
                                                      ],
                                                      controller:
                                                          TextEditingController(
                                                        text:
                                                            tempQtyList[index],
                                                      ),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          // updateList[index]
                                                          //         .newqty =
                                                          //     value.toString();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                    width: 40,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            double receivedQty =
                                                                double.parse(
                                                                    selected_items_list[
                                                                            index]
                                                                        .Qty
                                                                        .toString());
                                                            double currentQty =
                                                                double.parse(
                                                                    tempQtyList[
                                                                        index]);
                                                            // String newQty =
                                                            //     currentQty
                                                            //         .toString();
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Edit Quantity'),
                                                              content:
                                                                  TextField(
                                                                // enabled: false,
                                                                keyboardType: TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          '[0-9.,]')),
                                                                ],
                                                                controller: TextEditingController(
                                                                    text: currentQty
                                                                        .toString()),
                                                                onChanged:
                                                                    (value) {
                                                                  currentQty =
                                                                      double.parse(
                                                                          value);
                                                                  if (currentQty >
                                                                      receivedQty) {
                                                                    // newQty =
                                                                    //     receivedQty
                                                                    //         .toString();

                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text("Error"),
                                                                          content:
                                                                              const Text("The enter Qty cannot greater than available Qty!"),
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
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  } else {
                                                                    currentQty =
                                                                        double.parse(
                                                                            value.toString());

                                                                    updateList[index]
                                                                            .newqty =
                                                                        currentQty
                                                                            .toString();
                                                                  }
                                                                },
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      tempQtyList[
                                                                              index] =
                                                                          currentQty
                                                                              .toString();

                                                                      // insertModelList![index]
                                                                      //         .QTY =
                                                                      //     currentQty.toString();
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Save'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      iconSize: 16,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      icon: const Icon(
                                                          Icons.edit),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              selected_items_list[index]
                                                  .UOM
                                                  .toString(),
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
                                            child: Text("Rate"),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text("Amount"),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              selected_items_list[index]
                                                          .Rate
                                                          .toString() ==
                                                      "null"
                                                  ? "0"
                                                  : selected_items_list[index]
                                                      .Rate
                                                      .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              selected_items_list[index]
                                                          .Amount
                                                          .toString() ==
                                                      "null"
                                                  ? "0"
                                                  : selected_items_list[index]
                                                      .Amount
                                                      .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 18.0,
                                  right: 18.0,
                                  bottom: 18.0,
                                  top: 20.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Expanded(
                                            flex: 1,
                                            child: Text("Godown"),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text("Total Bag"),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              godown,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              totalbag,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Expanded(
                                            flex: 1,
                                            child: Text("Total Qty"),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text("Total Amount"),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              totalqty,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              totalamount,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MIButton(
                            onPressed: () {


                              processOrder = ProcessOrderModel(CATALOG_ITEM_NAME: process_order[0]["CATALOG_ITEM"].toString(),
                                  prdOrderNo: process_order[0]["ORDER_NO"].toString(),
                                  catalogCode: process_order[0]["CATALOG_ITEM"].toString(),
                                  orderDate: process_order[0]["ORDER_DATE"].toString(),
                                  pro_odr_name: process_order[0]["CATALOG_ITEM_NAME"].toString());



                              if (processOrder != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProcessOrder(
                                        processorderData: processOrder!),
                                  ),
                                );
                                print("ProcessOrder: catitemname " +
                                    processOrder!.CATALOG_ITEM_NAME);
                                print("ProcessOrder: catalog code " +
                                    processOrder!.catalogCode);
                                print("ProcessOrder: date " +
                                    processOrder!.orderDate);
                                print("ProcessOrder: prodorderno " +
                                    processOrder!.prdOrderNo);
                                print("ProcessOrder:  prodordername" +
                                    processOrder!.pro_odr_name);
                              }
                              else {
                                print("ProcessOrder");
                              }
                            },
                            backgroundColor: const Color(
                              0xffd53233,
                            ),
                            borderColor: const Color(0xffd53233),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Text("PROCESS ORDER"),
                          ),
                          const SizedBox(width: 5.0),
                          MIButton(
                            onPressed: () {
                              if (processOrder != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MISaleOrder(
                                      processOrderModel: processOrder!,
                                      SALE_ORDER_DTL_PK: process_order[0]["SALE_ORDER_DTL_PK"].toString(),
                                    ),
                                  ),
                                );
                              }
                            },
                            backgroundColor: const Color(
                              0xffd53233,
                            ),
                            borderColor: const Color(0xffd53233),
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: const Text("SALE ORDER"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
