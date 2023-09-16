import 'package:animated_button/animated_button.dart';
import 'package:dataproject2/Stock_opening/model/search_details_so_model.dart';
import 'package:dataproject2/Stock_opening/stock_details.dart';
import 'package:dataproject2/newmodel/ItemMasterModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SearchDetaisSO extends StatefulWidget {
  GetSearchDetailsSO getSearchDetailsSO;
  var code;

  // List<ItemResultModel> selectedItem;
  // final ComingFrom? comingFrom;

  SearchDetaisSO({
    super.key,
    required this.code,
    required this.getSearchDetailsSO,
    // required this.selectedItem,
    //  this.comingFrom
  });

  @override
  State<SearchDetaisSO> createState() => _SearchDetaisSOState();
}

class _SearchDetaisSOState extends State<SearchDetaisSO> {
  TextEditingController hsnController = TextEditingController(text: "0");
  TextEditingController lotController = TextEditingController(text: "0");
  TextEditingController rollController = TextEditingController(text: "0");
  TextEditingController rateController = TextEditingController(text: "0");
  TextEditingController qtyController = TextEditingController(text: "0");
  TextEditingController catController = TextEditingController();

  int gIndex = 0;
  int aIndex = 0;

  List<Map<String, dynamic>> _searchOpening = [];

// approval

  List<Map<String, dynamic>> approvalName = [];
  Map<String, dynamic>? itemSelected;
  List<Map<String, dynamic>> _approvalList = [];

// godown

  List<Map<String, dynamic>> godownName = [];
  Map<String, dynamic>? godownitemSelected;
  List<Map<String, dynamic>> _godownList = [];

  List<String> hsnCodeName = [];
  String hsnCodeSelected = '';
  List<Map<String, dynamic>> _hsnCode = [];

  List<String> tempHSN = [];

  List<ItemMasterModel> itemMasterList = [];

  int position = 0;
  String? imgBaseUrl = '';
  int _current = 0;
  double? screenWidth;

  String myDataPermission = "";
  String myDeletePermission = "";

  List<Map<String, dynamic>> permission = [];
  String userid = "";
  Future<void> get_uid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('user_id')!;
      getPermission(userid, "taskid", widget.code);
    });
  }

  Future<void> getPermission(
      String username, String taskid, String compCode) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/GetPermissions?username=" +
            username +
            "&taskid=STOCK_OPENING" +
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

  Future<void> getapprovalList() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/GetUsers?compCode=${widget.code}");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('companyCode', widget.code);

    setState(
      () {
        _approvalList = List.castFrom(jsonResponseList);
        approvalName.clear();

        print("Appuid: " + widget.getSearchDetailsSO.Approval.toString());

        approvalName.add({"": ""});
        for (final approval in _approvalList) {
          approvalName.add(approval);

          if (approval["USER_ID"] ==
              widget.getSearchDetailsSO.Approval.toString()) {
            itemSelected = approval;
          }
        }
        // if (approvalName.isNotEmpty) {
        //   itemSelected = approvalName[0];
        // }
      },
    );
  }

  Future<void> getgodownList() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/GetGodown?compCode=${widget.code}");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('companyCode', widget.code);

    setState(
      () {
        _godownList = List.castFrom(jsonResponseList);
        godownName.clear();

        godownName.add({"": ""});

        for (final godown in _godownList) {
          godownName.add(godown);
          print(
              "SelectedGodown: " + widget.getSearchDetailsSO.Godown.toString());
          print("SelectedGodownmatch: " + godown["CODE"].toString());
          if (godown["CODE"].toString() ==
              widget.getSearchDetailsSO.Godown.toString()) {
            print("SelectedGodownmatching: " + "Match");
            godownitemSelected = godown;
          }
        }
        // if (godownName.isNotEmpty) {
        //   godownitemSelected = godownName[0];
        // }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // debugPrint('ViewItemDetail ${widget.selectedItem.length}');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _getItemDetails();
      getapprovalList();
      getgodownList();
      get_uid();
      hsnController.text = widget.getSearchDetailsSO.hsn;
      lotController.text = widget.getSearchDetailsSO.lotno;
      rollController.text = widget.getSearchDetailsSO.roll;
      rateController.text = widget.getSearchDetailsSO.rate;
      qtyController.text = widget.getSearchDetailsSO.qty;

      // getSearchOpening();
    });

    // debugPrint('ComingFrom ${widget.comingFrom}');
  }

  Future<void> getSearchOpening(String code) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/SearchStockOpening?catalog_item=" +
            code);
    final response = await http.get(url);
    print("rahul" + response.body);
    final jsonResponseList = json.decode(response.body);
    setState(
      () {
        _searchOpening = List.castFrom(jsonResponseList);

        // isButtonClicked = false;
      },
    );
  }

  Future<void> getupdateStock(
      String approval_uid,
      String doc_pk,
      String hsn_code,
      String godown_code,
      String lot_no,
      String roll_number,
      String rate,
      String qty,
      String doc_no,
      udt_date,
      udt_uid) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/updatestockopening?" +
            "approval_uid=" +
            approval_uid +
            "&hsn_code=" +
            hsn_code +
            "&godown_code=" +
            godown_code +
            "&lot_no=" +
            lot_no +
            "&roll_number=" +
            roll_number +
            "&rate=" +
            rate +
            "&qty=" +
            qty +
            "&doc_no=" +
            doc_no +
            "&doc_pk=" +
            doc_pk +
            "&udt_date=" +
            udt_date +
            "&udt_uid=" +
            udt_uid);
    // print("New Qty: " + newqty);
    // print("CodePk: " + codepk);

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

  Future<void> deleteStockOpening(String doc_pk, String doc_no) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/deleteStockOpening?doc_pk=" +
            doc_pk +
            "&doc_no=" +
            doc_no);

    print("doc_no: " + doc_no);
    print("doc_pk: " + doc_pk);

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

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;
    int nextYear = currentYear + 1;
    String financialYear;

    if (DateTime.now().month >= 4) {
      financialYear = currentYear.toString() + nextYear.toString().substring(0);
    } else {
      financialYear =
          (currentYear - 1).toString() + currentYear.toString().substring(0);
    }
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios),
            ),
            automaticallyImplyLeading: false,
            title: const Text("STOCK OPENING"),
            actions: [
              GestureDetector(
                onTap: () async {
                  if (lotController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("lot no is required"),
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
                                // Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (hsnController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Hsn Code is required"),
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
                                // Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (rollController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Roll no is required"),
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
                                // Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (rateController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Rate is required"),
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
                                // Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (qtyController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Qty is required"),
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
                                // Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (itemSelected!.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Approval user is required"),
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
                                // Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (godownitemSelected!.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Godown is required"),
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
                                // Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String userId = prefs.getString('user_id') ?? '';
                    print("MyUID: " + userId);
                    if (myDataPermission == "A" || myDataPermission == "M") {
                      getupdateStock(
                        itemSelected!["USER_ID"].toString(),
                        widget.getSearchDetailsSO.codePk,
                        hsnController.text,
                        godownitemSelected!["CODE"].toString(),
                        lotController.text.toUpperCase(),
                        rollController.text,
                        rateController.text,
                        qtyController.text,
                        widget.getSearchDetailsSO.docNo,
                        DateFormat("dd-MM-yy HH:mm:ss")
                            .format(DateTime.now())
                            .toString(),
                        userId,
                      );
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
                  }
                  // print("gvvg" + itemSelected!["USER_ID"].toString());
                  // print("gvvg" + godownitemSelected!["CODE"].toString());
                  // print("gvvg" + widget.getSearchDetailsSO.codePk,);
                  // print("gvvg" + itemSelected!["USER_ID"].toString(),);
                  // print("gvvg" + itemSelected!["USER_ID"].toString(),);
                  // print("gvvg" + widget.getSearchDetailsSO.docNo);
                  // print("gvvg" + qtyController.text);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Center(child: Text("Modify")),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Doc Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          widget.getSearchDetailsSO.docDate,
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          widget.getSearchDetailsSO.finYear,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Ctalog Code",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          widget.getSearchDetailsSO.catalogCode,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                // height: double.maxFinite,
                child: PageView.builder(
                  onPageChanged: (value) {},
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) =>
                      SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18.0, bottom: 18.0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      StockDetails(
                                                        code: widget.code, 
                                                      catItem: widget.getSearchDetailsSO.catalogCode,
                                                      // _searchOpening[index]["CODE"],
                                                      
                                                      
                                                      ),
                                                      ),
                                                      );
                                        },
                                        child: Text('Stock Details'),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (myDeletePermission == "Y") {
                                            deleteStockOpening(
                                              widget.getSearchDetailsSO.codePk,
                                              widget.getSearchDetailsSO.docNo,
                                            );
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
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Catalog Item Name",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    widget.getSearchDetailsSO.catalogItemName,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Column(
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Approval",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(width: 35.0),
                                            SizedBox(
                                              height: 50,
                                              width: 180,
                                              child: DropdownSearch<
                                                  Map<String, dynamic>>(
                                                itemAsString: (Map<String,
                                                            dynamic>
                                                        _approvalList) =>
                                                    _approvalList["NAME"]
                                                                .toString() ==
                                                            "null"
                                                        ? ""
                                                        : _approvalList["NAME"]
                                                            .toString(),
                                                items: _approvalList,
                                                popupProps:
                                                    const PopupProps.menu(
                                                  showSearchBox: true,
                                                ),
                                                dropdownButtonProps:
                                                    const DropdownButtonProps(
                                                  color: Colors.red,
                                                ),
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 10, right: 5),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      aIndex = _approvalList
                                                          .indexOf(value!);
                                                      itemSelected = value;
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
                                  const SizedBox(height: 15.0),
                                  Column(
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Godown",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(width: 35.0),
                                            SizedBox(
                                              height: 50,
                                              width: 180,
                                              child: DropdownSearch<
                                                  Map<String, dynamic>>(
                                                itemAsString: (Map<String,
                                                            dynamic>
                                                        _godownList) =>
                                                    _godownList["NAME"]
                                                                .toString() ==
                                                            "null"
                                                        ? ""
                                                        : _godownList["NAME"]
                                                            .toString(),
                                                items: _godownList,
                                                popupProps:
                                                    const PopupProps.menu(
                                                  showSearchBox: true,
                                                ),
                                                dropdownButtonProps:
                                                    const DropdownButtonProps(
                                                  color: Colors.red,
                                                ),
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 10, right: 5),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      gIndex = _godownList
                                                          .indexOf(value!);
                                                      godownitemSelected =
                                                          value;
                                                    },
                                                  );
                                                },
                                                selectedItem:
                                                    godownitemSelected,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Hsn Code"),
                                            TextFormField(
                                              controller: hsnController,
                                              // TextEditingController(
                                              //   text: "0",
                                              //   // _searchListDetails[
                                              //   //                     index]
                                              //   //                 ["HSN_CODE"]
                                              //   //             .toString() ==
                                              //   //         "null"
                                              //   //     ? "0"
                                              //   //     : _searchListDetails[
                                              //   //             index]["HSN_CODE"]
                                              //   //         .toString(),
                                              // ),
                                              keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                  decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9.,]')),
                                              ],
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: () {
                                                    hsnController.text = "0";
                                                  },
                                                ),
                                              ),

                                              onChanged: (value) {
                                                // Update the value when it's changed
                                                // _searchListDetails[index]
                                                //     ["HSN_CODE"] = value;
                                                // setState(() {

                                                // updateList[index].newhsn =
                                                //     value.toString();
                                                // });
                                              },
                                              onSaved: (value) {
                                                // Save the new value when the form is submitted
                                                // _searchListDetails[index]
                                                //     ["HSN_CODE"] = value;
                                              },
                                            ),
                                          ],
                                        ),
                                      )
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
                                            const Text("Lot NO"),
                                            TextFormField(
                                              controller: lotController,
                                              // TextEditingController(
                                              //   text: "0",
                                              //   // _searchListDetails[
                                              //   //                     index]
                                              //   //                 ["HSN_CODE"]
                                              //   //             .toString() ==
                                              //   //         "null"
                                              //   //     ? "0"
                                              //   //     : _searchListDetails[
                                              //   //             index]["HSN_CODE"]
                                              //   //         .toString(),
                                              // ),
                                              // keyboardType: const TextInputType
                                              //         .numberWithOptions(
                                              //     decimal: true),
                                              // inputFormatters: [
                                              //   FilteringTextInputFormatter
                                              //       .allow(RegExp('[0-9.,]')),
                                              // ],
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: () {
                                                    // Clear the text field
                                                  },
                                                ),
                                              ),
                                              onChanged: (value) {
                                                // Update the value when it's changed
                                                // _searchListDetails[index]
                                                //     ["HSN_CODE"] = value;
                                                // setState(() {

                                                // updateList[index].newhsn =
                                                //     value.toString();
                                                // });
                                              },
                                              onSaved: (value) {
                                                // Save the new value when the form is submitted
                                                // _searchListDetails[index]
                                                //     ["HSN_CODE"] = value;
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Roll No/Brand"),
                                            TextFormField(
                                              controller: rollController,
                                              // TextEditingController(
                                              //   text: "0",
                                              //   // _searchListDetails[
                                              //   //                     index]
                                              //   //                 ["HSN_CODE"]
                                              //   //             .toString() ==
                                              //   //         "null"
                                              //   //     ? "0"
                                              //   //     : _searchListDetails[
                                              //   //             index]["HSN_CODE"]
                                              //   //         .toString(),
                                              // ),
                                              // keyboardType: const TextInputType
                                              //         .numberWithOptions(
                                              //     decimal: true),
                                              // inputFormatters: [
                                              //   FilteringTextInputFormatter
                                              //       .allow(RegExp('[0-9.,]')),
                                              // ],
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: () {
                                                    rollController.text = "0";
                                                  },
                                                ),
                                              ),
                                              onChanged: (value) {
                                                // Update the value when it's changed
                                                // _searchListDetails[index]
                                                //     ["HSN_CODE"] = value;
                                                // setState(() {
                                                // updateList[index].newhsn =
                                                //     value.toString();
                                                // });
                                              },
                                              onSaved: (value) {
                                                // Save the new value when the form is submitted
                                                // _searchListDetails[index]
                                                //     ["HSN_CODE"] = value;
                                              },
                                            ),
                                            const SizedBox(height: 5.0),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Rate"),
                                            TextFormField(
                                              controller: rateController,
                                              // TextEditingController(
                                              //     text: "0"
                                              //     //  itemMasterList[index].rate,

                                              //     // _searchListDetails[
                                              //     //                     index]
                                              //     //                 ["HSN_CODE"]
                                              //     //             .toString() ==
                                              //     //         "null"
                                              //     //     ? "0"
                                              //     //     : _searchListDetails[
                                              //     //             index]["HSN_CODE"]
                                              //     //         .toString(),
                                              //     ),
                                              keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                  decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9.,]')),
                                              ],
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: () {
                                                    rateController.text = "0";
                                                  },
                                                ),
                                              ),
                                              onChanged: (value) {
                                                // Update the value when it's changed
                                                // _searchListDetails[index]
                                                //     ["HSN_CODE"] = value;
                                                // setState(() {
                                                // updateList[index].newhsn =
                                                //     value.toString();
                                                // });
                                                // rateController.text = "0";
                                              },
                                              onSaved: (value) {
                                                // Save the new value when the form is submitted
                                                // _searchListDetails[index]
                                                //     ["HSN_CODE"] = value;
                                              },
                                            ),
                                            const SizedBox(height: 5.0),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
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
                                              controller: qtyController,
                                              keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                  decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9.,]')),
                                              ],
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: () {
                                                    rollController.text = "0";
                                                  },
                                                ),
                                              ),
                                              onChanged: (value) {},
                                              onSaved: (value) {},
                                            ),
                                            const SizedBox(height: 5.0),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "UOM",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    widget.getSearchDetailsSO.Uom,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 40.0),
                                ],
                              ),
                            ),
                          ),
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
    );
  }

  // _getItemDetails() {
  //   String? userId = AppConfig.prefs.getString('user_id');

  //   var data;
  //   var type;

  //   widget.selectedItem.forEach((e) {
  //     if (data == null) {
  //       data = '${e.id}';
  //     } else {
  //       data = "$data,${e.id}";
  //     }
  //   });

  //   widget.selectedItem.forEach((e) {
  //     if (type == null) {
  //       type = '${e.itemType}';
  //     } else {
  //       type = "$type,${e.itemType}";
  //     }
  //   });

  //   Commons().showProgressbar(this.context);

  //   var json = jsonEncode(<String, dynamic>{
  //     'user_id': userId,
  //     'item_ids': data.toString(),
  //     'item_type': type.toString(),

  //     /// e.g: Item-> 1 Catalog-> 2
  //     'full_detail': '1' //,2,2
  //   });

  //   WebService()
  //       .post(this.context, AppConfig.getItemDetails, json)
  //       .then((value) => {Navigator.pop(this.context), _parse(value!)});

  //   debugPrint('params $json');
  // }

  // _parse(Response value) {
  //   if (value.statusCode == 200) {
  //     var data = jsonDecode(value.body);

  //     if (data['error'] == 'false') {
  //       imgBaseUrl = data['image_tiff_path'];

  //       var contentList = data['content'] as List;
  //       var contentListCatalog = data['catalog_content'] as List;
  //       //var blockedCatalog = data['block_catalog'] as List?;
  //       itemMasterList.clear();

  //       itemMasterList.addAll(contentListCatalog
  //           .map((e) => ItemMasterModel.fromJSONCatalog(e))
  //           .toList());
  //       itemMasterList.addAll(
  //           contentList.map((e) => ItemMasterModel.fromJSON(e)).toList());

  //       setState(() {
  //         getHSNCODE(itemMasterList[0].materialCode);
  //       });
  //     }
  //   }
  // }

  // _blockUnBlock(String? code, String status) {
  //   Map jsonBody = {
  //     'user_id': getUserId(),
  //     'catalog_item_code': code,
  //     'block_status': status
  //   };

  //   web.WebService.fromApi(
  //           AppConfig.blockUnBlockCatalog, this as NetworkResponse, jsonBody)
  //       .callPostService(this.context);
  // }
}

//  use in fiture

// import 'package:dataproject2/itemMaster/ItemSearch.dart';
// import 'package:dataproject2/itemMaster/show_image.dart';
// import 'package:dataproject2/itemMaster/stock_details.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class StockOpening2 extends StatefulWidget {
//   const StockOpening2({super.key});

//   @override
//   State<StockOpening2> createState() => _StockOpening2State();
// }

// class _StockOpening2State extends State<StockOpening2> {
//   List<String> hsnCodeName = [];
//   String hsnCodeSelected = '';
//   List<Map<String, dynamic>> _hsnCode = [];

//   List<String> tempHSN = [];

//   List<List> allHsnCodes = [];

//   Future<void> getHSNCODE(var matcode) async {
//     final url = Uri.parse(
//         "http://103.204.185.17:24978/webapi/api/Common/HSNCODE?MATERIAL_CODE=" +
//             matcode.toString());
//     final response = await http.get(url);
//     final jsonResponseList = json.decode(response.body);
//     setState(
//       () {
//         _hsnCode = List.castFrom(jsonResponseList);
//         hsnCodeName.clear();

//         List<String> names = [];

//         for (final Hsn in _hsnCode) {
//           hsnCodeName.add(Hsn["HSN_CODE"].toString());
//           names.add(Hsn["HSN_CODE"].toString());
//         }
//         allHsnCodes.add(names);

//         for (var tempNames in allHsnCodes) {
//           tempHSN.add(tempNames[0].toString());
//         }

//         if (hsnCodeName.isNotEmpty) {
//           hsnCodeSelected = hsnCodeName[0];
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     int currentYear = DateTime.now().year;
//     int nextYear = currentYear + 1;
//     String financialYear;

//     if (DateTime.now().month >= 4) {
//       financialYear = currentYear.toString() + nextYear.toString().substring(0);
//     } else {
//       financialYear =
//           (currentYear - 1).toString() + currentYear.toString().substring(0);
//     }
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("STOCK OPENING"),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Doc Date",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       Text(
//                         DateFormat("dd.MM.yyyy").format(
//                           DateTime.now(),
//                         ),
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Fin Year",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       Text(
//                         financialYear,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Catalog Code",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       SizedBox(
//                         height: 40,
//                         width: 200,
//                         child: TextFormField(
//                           // controller: finyearController,
//                           keyboardType: const TextInputType.numberWithOptions(
//                               decimal: true),
//                           inputFormatters: [
//                             FilteringTextInputFormatter.allow(
//                                 RegExp('[0-9.,]')),
//                           ],
//                           decoration: InputDecoration(
//                             hintText: 'Enter Catalog Code',
//                             border: const OutlineInputBorder(),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 8.0, horizontal: 16.0),
//                             suffixIcon: IconButton(
//                               onPressed: () {
//                                 // finyearController.clear();
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (_) => ItemSearch()));
//                               },
//                               icon: const Icon(Icons.search),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               // height: double.maxFinite,
//               child: PageView.builder(
//                 onPageChanged: (value) {},
//                 itemCount: 5,
//                 itemBuilder: (context, index) => SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             left: 18.0, right: 18.0, bottom: 18.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.0),
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.5),
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 15, vertical: 15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     const Text(
//                                       "Catalog Item Name",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                     ElevatedButton(
//                                       onPressed: () {

//                                         Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (_) => StockDetails()));

//                                       },
//                                       child: Text('Item Details'),
//                                     )
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5.0),
//                                 const Text(
//                                   "Catalog Item Name",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 1,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           const Text("HSN Code"),
//                                           const SizedBox(height: 8),
//                                           TextFormField(
//                                             keyboardType: TextInputType
//                                                 .numberWithOptions(
//                                                     decimal: true),
//                                             inputFormatters: [
//                                               FilteringTextInputFormatter
//                                                   .allow(RegExp('[0-9.,]')),
//                                             ],
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 tempHSN[index] = value;
//                                               });
//                                             },
//                                             decoration: const InputDecoration(
//                                               hintText: 'Enter the HSN Code',
//                                             ),
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return 'Please enter the HSN Code';
//                                               }
//                                               return null;
//                                             },
//                                             onSaved: (value) {},
//                                           ),
//                                           const SizedBox(height: 16),
//                                           const Text("Select HSN Code"),
//                                           const SizedBox(height: 8),
//                                           SizedBox(
//                                             height: 40,
//                                             width: 180,
//                                             child: DropdownSearch(
//                                               items: allHsnCodes.isEmpty
//                                                   ? []
//                                                   : allHsnCodes[0],
//                                               popupProps:
//                                                   const PopupProps.menu(
//                                                 showSearchBox: true,
//                                               ),
//                                               dropdownButtonProps:
//                                                   const DropdownButtonProps(
//                                                 color: Colors.red,
//                                               ),
//                                               dropdownDecoratorProps:
//                                                   DropDownDecoratorProps(
//                                                 textAlignVertical:
//                                                     TextAlignVertical.center,
//                                                 dropdownSearchDecoration:
//                                                     InputDecoration(
//                                                   contentPadding:
//                                                       const EdgeInsets.only(
//                                                           left: 10, right: 5),
//                                                   border: OutlineInputBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                   ),
//                                                 ),
//                                               ),
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   tempHSN[index] = value;
//                                                 });
//                                               },
//                                               selectedItem: tempHSN.isEmpty
//                                                   ? []
//                                                   : tempHSN[index],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5.0),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 1,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           const Text("Lot NO"),
//                                           TextFormField(
//                                             controller: TextEditingController(
//                                               text: "",
//                                               // _searchListDetails[
//                                               //                     index]
//                                               //                 ["HSN_CODE"]
//                                               //             .toString() ==
//                                               //         "null"
//                                               //     ? "0"
//                                               //     : _searchListDetails[
//                                               //             index]["HSN_CODE"]
//                                               //         .toString(),
//                                             ),
//                                             keyboardType: const TextInputType
//                                                     .numberWithOptions(
//                                                 decimal: true),
//                                             inputFormatters: [
//                                               FilteringTextInputFormatter
//                                                   .allow(RegExp('[0-9.,]')),
//                                             ],
//                                             onChanged: (value) {
//                                               // Update the value when it's changed
//                                               // _searchListDetails[index]
//                                               //     ["HSN_CODE"] = value;
//                                               // setState(() {
//                                               // updateList[index].newhsn =
//                                               //     value.toString();
//                                               // });
//                                             },
//                                             onSaved: (value) {
//                                               // Save the new value when the form is submitted
//                                               // _searchListDetails[index]
//                                               //     ["HSN_CODE"] = value;
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5.0),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 1,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           const Text("Roll No"),
//                                           TextFormField(
//                                             controller: TextEditingController(
//                                               text: "",
//                                               // _searchListDetails[
//                                               //                     index]
//                                               //                 ["HSN_CODE"]
//                                               //             .toString() ==
//                                               //         "null"
//                                               //     ? "0"
//                                               //     : _searchListDetails[
//                                               //             index]["HSN_CODE"]
//                                               //         .toString(),
//                                             ),
//                                             keyboardType: const TextInputType
//                                                     .numberWithOptions(
//                                                 decimal: true),
//                                             inputFormatters: [
//                                               FilteringTextInputFormatter
//                                                   .allow(RegExp('[0-9.,]')),
//                                             ],
//                                             onChanged: (value) {
//                                               // Update the value when it's changed
//                                               // _searchListDetails[index]
//                                               //     ["HSN_CODE"] = value;
//                                               // setState(() {
//                                               // updateList[index].newhsn =
//                                               //     value.toString();
//                                               // });
//                                             },
//                                             onSaved: (value) {
//                                               // Save the new value when the form is submitted
//                                               // _searchListDetails[index]
//                                               //     ["HSN_CODE"] = value;
//                                             },
//                                           ),
//                                           const SizedBox(height: 5.0),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 1,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           const Text("Rate"),
//                                           TextFormField(
//                                             controller: TextEditingController(
//                                               text: "",
//                                               // _searchListDetails[
//                                               //                     index]
//                                               //                 ["HSN_CODE"]
//                                               //             .toString() ==
//                                               //         "null"
//                                               //     ? "0"
//                                               //     : _searchListDetails[
//                                               //             index]["HSN_CODE"]
//                                               //         .toString(),
//                                             ),
//                                             keyboardType: const TextInputType
//                                                     .numberWithOptions(
//                                                 decimal: true),
//                                             inputFormatters: [
//                                               FilteringTextInputFormatter
//                                                   .allow(RegExp('[0-9.,]')),
//                                             ],
//                                             onChanged: (value) {
//                                               // Update the value when it's changed
//                                               // _searchListDetails[index]
//                                               //     ["HSN_CODE"] = value;
//                                               // setState(() {
//                                               // updateList[index].newhsn =
//                                               //     value.toString();
//                                               // });
//                                             },
//                                             onSaved: (value) {
//                                               // Save the new value when the form is submitted
//                                               // _searchListDetails[index]
//                                               //     ["HSN_CODE"] = value;
//                                             },
//                                           ),
//                                           const SizedBox(height: 5.0),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 1,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           const Text("Qty"),
//                                           TextFormField(
//                                             controller: TextEditingController(
//                                               text: "",
//                                               // _searchListDetails[
//                                               //                     index]
//                                               //                 ["HSN_CODE"]
//                                               //             .toString() ==
//                                               //         "null"
//                                               //     ? "0"
//                                               //     : _searchListDetails[
//                                               //             index]["HSN_CODE"]
//                                               //         .toString(),
//                                             ),
//                                             keyboardType: const TextInputType
//                                                     .numberWithOptions(
//                                                 decimal: true),
//                                             inputFormatters: [
//                                               FilteringTextInputFormatter
//                                                   .allow(RegExp('[0-9.,]')),
//                                             ],
//                                             onChanged: (value) {
//                                               // Update the value when it's changed
//                                               // _searchListDetails[index]
//                                               //     ["HSN_CODE"] = value;
//                                               // setState(() {
//                                               // updateList[index].newhsn =
//                                               //     value.toString();
//                                               // });
//                                             },
//                                             onSaved: (value) {
//                                               // Save the new value when the form is submitted
//                                               // _searchListDetails[index]
//                                               //     ["HSN_CODE"] = value;
//                                             },
//                                           ),
//                                           const SizedBox(height: 5.0),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10.0),
//                                 const Text(
//                                   "UOM",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5.0),
//                                 const Text(
//                                   "In Kg",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 40.0),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             builder: (_) => ShowImage(),
//                                           ),
//                                         );
//                                       },
//                                       child: const Text(
//                                         "Show image",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           color: Color(0xffd53233),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       alignment: Alignment.center,
//                                       height: 20.0,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: const [
//                                           Text(
//                                             "1/100",
//                                             style: TextStyle(
//                                               fontSize: 16.0,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// end
