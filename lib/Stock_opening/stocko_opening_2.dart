import 'package:animated_button/animated_button.dart';
import 'package:dataproject2/Stock_opening/ItemSearchCatalog.dart';
import 'package:dataproject2/Stock_opening/search_page_so.dart';
import 'package:dataproject2/Stock_opening/show_image_so.dart';
import 'package:dataproject2/Stock_opening/stock_details.dart';
import 'package:dataproject2/newmodel/ItemMasterModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Stock2 extends StatefulWidget {
  var code;

  // List<ItemResultModel> selectedItem;
  // final ComingFrom? comingFrom;

  Stock2({
    super.key,
    required this.code,
    // required this.selectedItem,
    //  this.comingFrom
  });

  @override
  State<Stock2> createState() => _Stock2State();
}

class _Stock2State extends State<Stock2> {
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

  bool isButtonClicked = false;

  String myDataPermission = "";
  String myDeletePermission = "";

  List<Map<String, dynamic>> permission = [];

  Future<void> getPermission(
      String username, String taskid, String compCode) async {
    print("MyPermissions Username:" + username + " CompCode: " + compCode);

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
      print("MyPermissions " + myDataPermission + " " + myDeletePermission);
    });
  }

  void _reloadScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => Stock2(code: widget.code)),
    );
  }

  // List<List> allHsnCodes = [];

  // Future<void> getHSNCODE(var matcode) async {
  //   final url = Uri.parse(
  //       "http://103.204.185.17:24978/webapi/api/Common/HSNCODE?MATERIAL_CODE=" +
  //           matcode.toString());
  //   final response = await http.get(url);
  //   final jsonResponseList = json.decode(response.body);
  //   setState(
  //     () {
  //       _hsnCode = List.castFrom(jsonResponseList);
  //       hsnCodeName.clear();

  //       List<String> names = [];

  //       for (final Hsn in _hsnCode) {
  //         hsnCodeName.add(Hsn["HSN_CODE"].toString());
  //         names.add(Hsn["HSN_CODE"].toString());
  //       }
  //       allHsnCodes.add(names);

  //       for (var tempNames in allHsnCodes) {
  //         tempHSN.add(tempNames[0].toString());
  //       }

  //       if (hsnCodeName.isNotEmpty) {
  //         hsnCodeSelected = hsnCodeName[0];
  //       }
  //     },
  //   );
  // }

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

        approvalName.add({"": ""});
        for (final approval in _approvalList) {
          approvalName.add(approval);
        }
        if (approvalName.isNotEmpty) {
          itemSelected = approvalName[0];
        }
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
        }
        if (godownName.isNotEmpty) {
          godownitemSelected = godownName[0];
        }
      },
    );
  }

  Future<void> getSavePage(
      compCode,
      docDate,
      docFinYear,
      accCode,
      contPersonCode,
      remarks,
      insUid,
      driverCode,
      PROD_ORDER_BOM_FK,
      GODOWN_CODE,
      LOT_NO,
      ROLL_NO,
      QTY,
      QTY_UOM,
      HSN_CODE,
      RATE,
      AMOUNT,
      CATALOG_ITEM,
      COUNT_CODE,
      ITEM_CODE,
      material_code,
      brand_code,
      sysdate,
      shade_code,
      iop1_code,
      iop1_val,
      iop1_uom,
      iop2_code,
      iop2_val,
      iop2_uom,
      iop3_code,
      iop3_val,
      iop3_uom,
      APPROVAL_UID,
      dateTime) async {
    final url = Uri.parse(
      "http://103.204.185.17:24978/webapi/api/Common/InsertStockOpening?" +
          "compCode=" +
          widget.code +
          "&docDate=" +
          docDate.toString() +
          "&docFinYear=" +
          docFinYear.toString() +
          "&accCode=" +
          "23" +
          "&contPersonCode=" +
          "Abc" +
          "&remarks=" +
          remarks.toString() +
          "&APPROVAL_UID=" +
          APPROVAL_UID.toString() +
          "&insUid=" +
          insUid.toString() +
          "&PROD_ORDER_BOM_FK=" +
          "Abc" +
          "&GODOWN_CODE=" +
          GODOWN_CODE.toString() +
          "&LOT_NO=" +
          LOT_NO.toString().toUpperCase() +
          "&ROLL_NO=" +
          ROLL_NO.toString().toUpperCase() +
          "&QTY=" +
          QTY.toString() +
          "&HSN_CODE=" +
          HSN_CODE.toString() +
          "&RATE=" +
          RATE.toString() +
          "&AMOUNT=" +
          "Abc" +
          "&CATALOG_ITEM=" +
          CATALOG_ITEM.toString() +
          "&COUNT_CODE=" +
          COUNT_CODE.toString() +
          "&ITEM_CODE=" +
          ITEM_CODE.toString() +
          "&material_code=" +
          material_code.toString() +
          "&brand_code=" +
          brand_code.toString() +
          "&sysdate=" +
          sysdate +
          "&shade_code=" +
          shade_code.toString() +
          "&iop1_code=" +
          iop1_code.toString() +
          "&iop1_val=" +
          iop1_val.toString() +
          "&iop1_uom=" +
          iop1_uom.toString() +
          "&iop2_code=" +
          iop2_code.toString() +
          "&iop2_val=" +
          iop2_val.toString() +
          "&iop2_uom=" +
          iop2_uom.toString() +
          "&iop3_code=" +
          iop3_code.toString() +
          "&iop3_val=" +
          iop3_val.toString() +
          "&iop3_uom=" +
          iop3_uom.toString() +
          "&driverCode=" +
          "0" +
          "&QTY_UOM=" +
          QTY_UOM.toString() +
          "&dateTime=" +
          dateTime,
    );
    final response = await http.get(url);

    if (!response.body.toString().contains("Successfull")) {
      // ignore: use_build_context_synchronously
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Data Saved Successfull"),
              content:
                  Text("Doc Number: " + response.body.toString().split(":")[1]),
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
                    setState(() {
                      //Clearing
                      _searchOpening.clear();
                      _approvalList.clear();
                      _godownList.clear();
                      qtyController.text = "0";
                      hsnController.text = "0";
                      rollController.text = "0";
                      lotController.text = "0";
                      rateController.text = "0";
                      catController.text = "0";

                      itemSelected = {"": ""};
                      godownitemSelected = {"": ""};

                      isButtonClicked = false;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        // _getItemDetails();
                        getapprovalList();
                        getgodownList();

                        get_uid();

                        // getSearchOpening();
                      });
                    });
                    //  _reloadScreen();
                  },
                ),
              ],
            );
          });
    }
    setState(
      () {},
    );
  }

  String userid = "";

  Future<void> get_uid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('user_id')!;
      print("MyPermissions" + userid);
      getPermission(userid, "taskid", widget.code);
    });
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
              myDataPermission == "A" ||
                      myDataPermission == "M" ||
                      myDataPermission == "S" ||
                      myDataPermission == "I"
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SearchPageSO(
                                  code: widget.code,
                                )));
                      },
                      child: Icon(Icons.search),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: isButtonClicked
                    ? ElevatedButton(
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: null, // Disable button when clicked
                      )
                    : InkWell(
                        onTap: () async {
                          setState(() {
                            isButtonClicked = true;
                          });

                          if (qtyController.text == "0" ||
                              qtyController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("ERROR"),
                                    content: Text("Qty must be greater than 0"),
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
                                          setState(() {
                                            isButtonClicked = false;
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else if (hsnController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("ERROR"),
                                    content: Text("HSN Code is required"),
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
                                          setState(() {
                                            isButtonClicked = false;
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else if (lotController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("ERROR"),
                                    content: Text("Lot No Code is required"),
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
                                          setState(() {
                                            isButtonClicked = false;
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else if (rollController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("ERROR"),
                                    content: Text("Roll No/Brand is required"),
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
                                          setState(() {
                                            isButtonClicked = false;
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else if (rateController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("ERROR"),
                                    content: Text("Rate required"),
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
                                          setState(() {
                                            isButtonClicked = false;
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String userId = prefs.getString('user_id') ?? '';
                            print("MyUID: " + userId);
                            print("TESTUOM: " + _searchOpening[0]["CAT_UOM"].toString());

                            getSavePage(
                                widget.code,
                                DateFormat("dd.MM.yyyy").format(DateTime.now()),
                                financialYear,
                                "Abc",
                                "Abc",
                                "Abc",
                                userId,
                                "Abc",
                                "Abc",
                                _godownList[gIndex]["CODE"],
                                lotController.text,
                                rollController.text,
                                qtyController.text,
                                _searchOpening[0]["CAT_UOM"],
                                hsnController.text,
                                rateController.text,
                                "Amount",
                                _searchOpening[0]["CODE"],
                                _searchOpening[0]["COUNT_CODE"],
                                _searchOpening[0]["ITEM_CODE"],
                                _searchOpening[0]["MATERIAL_CODE"],
                                _searchOpening[0]["BRAND_CODE"],
                                DateFormat("dd-MM-yy HH:mm:ss")
                                    .format(DateTime.now()),
                                _searchOpening[0]["SHADE_CODE"],
                                _searchOpening[0]["IOP1_CODE"],
                                _searchOpening[0]["IOP1_VAL"],
                                _searchOpening[0]["IOP1_UOM"],
                                _searchOpening[0]["IOP2_CODE"],
                                _searchOpening[0]["IOP2_VAL"],
                                _searchOpening[0]["IOP2_UOM"],
                                _searchOpening[0]["IOP3_CODE"],
                                _searchOpening[0]["IOP3_VAL"],
                                _searchOpening[0]["IOP3_UOM"],
                                _approvalList[aIndex]["USER_ID"],
                                DateFormat("dd-MM-yy HH:mm:ss")
                                    .format(DateTime.now())
                                    .toString());
                          }
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              )
            ],
          ),
          body: myDataPermission == "A" || myDataPermission == "I"
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
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
                                DateFormat("dd.MM.yyyy").format(
                                  DateTime.now(),
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
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                financialYear,
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
                                "Catalog Code",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(
                                height: 40,
                                width: 200,
                                child: TextFormField(
                                  controller: catController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ItemSearchCatalog()));
                                      },
                                      icon: const Icon(Icons.search),
                                    ),
                                  ),
                                  // controller: TextEditingController(
                                  //   text: ""

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
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]')),
                                  ],
                                  onChanged: (value) {
                                    // Update the value when it's changed
                                    // _searchListDetails[index]
                                    //     ["HSN_CODE"] = value;
                                    // setState(() {
                                    // updateList[index].newhsn =
                                    //     value.toString();
                                    // });
                                    getSearchOpening(value.toString());
                                  },
                                  onSaved: (value) {
                                    // Save the new value when the form is submitted
                                    // _searchListDetails[index]
                                    //     ["HSN_CODE"] = value;
                                  },
                                ),
                                // child: TextFormField(

                                //   // controller: finyearController,
                                //   keyboardType: const TextInputType.numberWithOptions(
                                //       decimal: true),
                                //   inputFormatters: [
                                //     FilteringTextInputFormatter.allow(
                                //         RegExp('[0-9.,]')),
                                //   ],
                                //   decoration: InputDecoration(

                                //     hintText: 'Enter Catalog Code',
                                //     border: const OutlineInputBorder(),
                                //     contentPadding: const EdgeInsets.symmetric(
                                //         vertical: 8.0, horizontal: 16.0),
                                //     suffixIcon: IconButton(
                                //       onPressed: () {
                                //         // finyearController.clear();
                                //         Navigator.of(context).push(MaterialPageRoute(
                                //             builder: (_) => ItemSearch()));
                                //       },
                                //       icon: const Icon(Icons.search),
                                //     ),
                                //   ),
                                // )
                                //
                                //
                                // ,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                            ElevatedButton(
                                              onPressed: () {
                                                if (_searchOpening.isNotEmpty) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          StockDetails(
                                                              code: widget.code,
                                                              catItem:
                                                                  _searchOpening[
                                                                          0]
                                                                      ["CODE"]),
                                                    ),
                                                  );
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title:
                                                            const Text("Error"),
                                                        content: const Text(
                                                            "Select Catalog Item first"),
                                                        actions: [
                                                          AnimatedButton(
                                                            width: 100,
                                                            height: 40,
                                                            color: Colors.red,
                                                            child: const Text(
                                                              "OK",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              // Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Text('Stock Details'),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          _searchOpening.length == 0
                                              ? ""
                                              : _searchOpening[0]
                                                      ["CATALOG_NAME"]
                                                  .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                              : _approvalList[
                                                                      "NAME"]
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
                                                            TextAlignVertical
                                                                .center,
                                                        dropdownSearchDecoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 5),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(
                                                          () {
                                                            aIndex =
                                                                _approvalList
                                                                    .indexOf(
                                                                        value!);
                                                            itemSelected =
                                                                value;
                                                          },
                                                        );
                                                      },
                                                      selectedItem:
                                                          itemSelected,
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                              : _godownList[
                                                                      "NAME"]
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
                                                            TextAlignVertical
                                                                .center,
                                                        dropdownSearchDecoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 5),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(
                                                          () {
                                                            gIndex = _godownList
                                                                .indexOf(
                                                                    value!);
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
                                                    keyboardType:
                                                        const TextInputType
                                                                .numberWithOptions(
                                                            decimal: true),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              '[0-9.,]')),
                                                    ],
                                                    decoration: InputDecoration(
                                                      suffixIcon: IconButton(
                                                        icon: Icon(Icons.clear),
                                                        onPressed: () {
                                                          hsnController.text =
                                                              "0";
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
                                                          rollController.text =
                                                              "0";
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
                                                    keyboardType:
                                                        const TextInputType
                                                                .numberWithOptions(
                                                            decimal: true),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              '[0-9.,]')),
                                                    ],
                                                    decoration: InputDecoration(
                                                      suffixIcon: IconButton(
                                                        icon: Icon(Icons.clear),
                                                        onPressed: () {
                                                          rateController.text =
                                                              "0";
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
                                                    keyboardType:
                                                        const TextInputType
                                                                .numberWithOptions(
                                                            decimal: true),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              '[0-9.,]')),
                                                    ],
                                                    decoration: InputDecoration(
                                                      suffixIcon: IconButton(
                                                        icon: Icon(Icons.clear),
                                                        onPressed: () {
                                                          rollController.text =
                                                              "0";
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
                                          _searchOpening.length == 0
                                              ? ""
                                              : _searchOpening[0]["UOM_ABV"]
                                                  .toString(),
                                          // itemMasterList[index].Uom!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 40.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (_searchOpening.isNotEmpty) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          ShowimageSO(
                                                        itemCode:
                                                            _searchOpening[0]
                                                                ["CODE"],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                "Show image",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xffd53233),
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
                    ),
                  ],
                )
              : Container(),
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
