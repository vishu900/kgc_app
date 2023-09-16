import 'dart:collection';

import 'package:dataproject2/productionmodel/AddingResult.dart';
import 'package:dataproject2/productionmodel/DocNo.dart';
import 'package:dataproject2/productionmodel/Goods.dart';
import 'package:dataproject2/productionmodel/HdrRequest.dart';
import 'package:dataproject2/productionmodel/ListItem.dart';
import 'package:dataproject2/productionmodel/PendingOrder.dart';
import 'package:dataproject2/productionmodel/PendingOrderRequest.dart';
import 'package:dataproject2/productionmodel/PkCode.dart';
import 'package:dataproject2/productionmodel/StockRequest.dart';
import 'package:dataproject2/productionmodel/partynameresp.dart';
import 'package:dataproject2/productionservice/api.dart';
import 'package:dataproject2/productionview/PedingOrderTest.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? suspendingCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack!();
        }
        break;
    }
  }
}

class ProductionFormScreen extends StatefulWidget {
  final String partname;
  const ProductionFormScreen({Key? key, required this.partname})
      : super(key: key);

  @override
  _ProductionFormWidgetState createState() => _ProductionFormWidgetState();
}

class _ProductionFormWidgetState extends State<ProductionFormScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<PendingOrder> allSelected = [];
  List<Partnameresp> categoriesResponse = [];
  int selectedIndex = -1;
  TextEditingController _textFieldController1 = TextEditingController();

  var goodsmap = HashMap<int, List<Goods>>();


  String remarks = "";
  String partynameselect = "";
  String partycode = "";

  DateTime now = DateTime.now();
  DateTime prev = DateTime.now().subtract(Duration(days: 1));
  DateFormat formattedDate = DateFormat('dd.MM.yyyy');
  DateFormat tempCurrentTime = DateFormat('HHmm');

  // DateFormat("dd-MM-yy HH:mm:ss")
  //     .format(DateTime.now());

  DateFormat sendingDateFormat = DateFormat('dd-MMM-yyyy');
  DateFormat sendingDateFormatnew = DateFormat('dd-MMM-yyyy hh:mm a');
  DateFormat yearDate = DateFormat('yyyy');
  final TextEditingController textEditingControllersearch =
  TextEditingController();

  getpartyname() async {
    EasyLoading.show(
        status: 'Please Wait...', maskType: EasyLoadingMaskType.black);
    //  await FirebaseMessaging.instance.subscribeToTopic("allUsers");
    categoriesResponse = await UserRepository().getCompaniespartyname();

    setState(() {
      EasyLoading.dismiss();
      partynameselect = categoriesResponse[0].name.toString();
      partycode = categoriesResponse[0].code.toString();
    });
  }

  void initState() {
    getpartyname();
    super.initState();

    WidgetsBinding.instance.addObserver(
        LifecycleEventHandler(resumeCallBack: () async => setState(() {})));
  }

  @override
  void dispose() {
    textEditingControllersearch.dispose();
    super.dispose();
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

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFD63333),
        //    automaticallyImplyLeading: true,
        actions: [
          TextButton(
            onPressed: () {
              _checkQuantitywithFinalQuantity();
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
        surfaceTintColor: Colors.white,
        title: const Text('Production Form',
            style: TextStyle(color: Colors.white)),
        centerTitle: false,
        elevation: 4,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 4),
                child: Row(
                  children: [
                    Text("Material Receipt Against Production /PO",
                        style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Doc Date",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      int.parse(tempCurrentTime.format(now)) > 0000 &&
                          int.parse(tempCurrentTime.format(now)) < 0900
                          ? formattedDate.format(prev)
                          : formattedDate.format(now),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      financialYear,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${int.parse(yearDate.format(now))}" +
                          "-" +
                          "${int.parse(yearDate.format(now)) + 1}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 4, 12, 0),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 45.0,
                          child: Text(
                            "Party",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          )),
                      const SizedBox(
                        width: 20.0,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0, left: 10.0, top: 8.0),
                        child: Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.only(left: 10.0),
                          width: 268.0,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: partynameselect.isEmpty
                                  ? Text(
                                'Select Party Name',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              )
                                  : Text(
                                partynameselect,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              items: categoriesResponse
                                  .map((categoriesResponse) =>
                                  DropdownMenuItem<Partnameresp>(
                                    value: categoriesResponse,
                                    child: Text(
                                      categoriesResponse.name.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ))
                                  .toList(),
                              onChanged: (Partnameresp? value) {
                                setState(() {
                                  partynameselect = value!.name.toString();
                                  partycode = value.code.toString();
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 200,
                              itemHeight: 40,

                              searchController: textEditingControllersearch,
                              searchInnerWidget: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  controller: textEditingControllersearch,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Search company name',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (categoriesResponse, searchValue) {
                                return (categoriesResponse.value!.name
                                    .toString()
                                    .contains(searchValue.toUpperCase()));
                              },
                              //This to clear the search value when you close the menu
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  textEditingControllersearch.clear();
                                }
                              },
                              searchInnerWidgetHeight: 40,
                            ),
                          ),
                        ),
                      ),

                      //Text(widget.partname),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 0, 0),
                            child: ElevatedButton(
                                child: Text("Remarks".toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFFD63333)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            side: BorderSide(
                                                color: Color(0xFFD63333))))),
                                onPressed: () {
                                  _textFieldController1.text = remarks;

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          title: Text('Enter remarks value'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 16, 0, 0),
                                                child: TextField(
                                                  controller: _textFieldController1,
                                                  decoration: InputDecoration(
                                                    labelText: "Remarks",
                                                    hintText: "Remarks",
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0xFFD63333),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(4.0),
                                                        topRight:
                                                        Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0xFFD63333),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(4.0),
                                                        topRight:
                                                        Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(4.0),
                                                        topRight:
                                                        Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(4.0),
                                                        topRight:
                                                        Radius.circular(4.0),
                                                      ),
                                                    ),
                                                  ),
                                                  keyboardType: TextInputType.text,
                                                  maxLines: null,
                                                  minLines: 3,
                                                ),
                                              )
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                setState(() {
                                                  remarks =
                                                      _textFieldController1.text;
                                                  Navigator.pop(context);
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                }),
                          ),
                        )),
                    Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 0, 0),
                            child: ElevatedButton(
                                child: Text("Select Items".toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFFD63333)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            side: BorderSide(
                                                color: Color(0xFFD63333))))),
                                onPressed: () => {_selectItem()}),
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: Text(
                  "Selected Items",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: Color(0xFFD63333),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 160,
                child: ListView.builder(
                    itemCount: allSelected.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      PendingOrder p = allSelected[index];
                      return MyPendingItem(
                          pendingOrder: p,
                          isSelected: (bool value) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          isSelect: index == selectedIndex,
                          key: Key(p.prodOrderDtlPk.toString()),
                          isDeleted: (PendingOrder value) {
                            setState(() {
                              selectedIndex = -1;
                              allSelected.removeAt(index);
                            });
                          });
                    }),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: Text(
                  "Add Finished Goods",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: Color(0xFFD63333),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: selectedIndex == -1
                          ? 1
                          : goodsmap[allSelected[selectedIndex].prodOrderDtlPk]!
                          .length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        Goods p = selectedIndex == -1
                            ? Goods(pmName: '')
                            : goodsmap[allSelected[selectedIndex]
                            .prodOrderDtlPk]![index];
                        return MyFinishItem(
                          goods: p,
                          isSelected: (Goods value) {
                            setState(() {
                              if (value.is_edit) {
                                goodsmap[allSelected[selectedIndex]
                                    .prodOrderDtlPk]![index] = value;
                              } else {
                                goodsmap[allSelected[selectedIndex]
                                    .prodOrderDtlPk]!
                                    .insert(0, value);
                              }
                            });
                          },
                          isEmpty: p.isEmpty,
                          key: Key(p.prodOrderDtlPk.toString()),
                          selected_index: selectedIndex,
                          isDeleted: (Goods value) {
                            setState(() {
                              goodsmap[allSelected[selectedIndex]
                                  .prodOrderDtlPk]!
                                  .removeAt(index);
                            });
                          },
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectItem() async {
    if (partynameselect.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();

      prefs.setString("acc", partycode);
      prefs.setString("companyname", partynameselect);
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PendingOrderTest(allSelected)),
      );

      // After the Selection Screen returns a result, hide any previous snackbars
      // and show the new result.
      if (result != null) {
        allSelected = result as List<PendingOrder>;
      }

      setState(() {
        for (var selected in allSelected) {
          if (!goodsmap.containsKey(selected.prodOrderDtlPk)) {
            goodsmap.putIfAbsent(selected.prodOrderDtlPk!, () => <Goods>[]);
            var good = Goods();
            good.pmName = "";
            good.godown = "";
            good.lotNo = "";
            good.rollBagDesign = "0";
            good.prodDay = 0;
            good.prodNight = 0;
            good.remarks = "";
            goodsmap[selected.prodOrderDtlPk]!.add(good);
          }
        }
        selectedIndex = -1;
        if (allSelected.length == 1) {
          selectedIndex = 0;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please Select Party!"),
      ));
    }
  }

  List<Map> allStock = <Map>[];

  void _checkQuantitywithFinalQuantity() async {
    String errorString = "";
    if (allSelected.isEmpty) {
      errorString = "Please select items";
    }
    if (errorString.isEmpty) {
      for (var pendingorder in allSelected) {
        if (!goodsmap.containsKey(pendingorder.prodOrderDtlPk)) {
          errorString = "Data error please restart the app";
          break;
        } else {
          List<Goods>? goods = goodsmap[pendingorder.prodOrderDtlPk!];
          if (goods!.isEmpty || !matchPendingOrderQty(pendingorder, goods)) {
            errorString =
            "Please enter correct qty for ${pendingorder.catalogItemName}";
            break;
          } else {}
        }
      }
    }
    final prefs = await SharedPreferences.getInstance();
    String? acccodedata = prefs.getString("acc");

    if (!errorString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorString),
      ));
    } else {
      showAlertDialog(context);
      UserRepository rep = UserRepository();
      List<PkCode> response = await rep.getPkCodes(true);
      List<DocNo> docresponse = await rep.getDocNo(
          "${int.parse(yearDate.format(now)) - 1}${int.parse(yearDate.format(now))}");
      HdrRequest hdrRequest = HdrRequest();
      hdrRequest.accCode = int.parse(acccodedata ?? "518");
      hdrRequest.docNo = docresponse[0].docNo;
      hdrRequest.compCode = int.parse(prefs.getString("company")!);
      hdrRequest.remarks = remarks;
      hdrRequest.codePk = response[0].code;
      hdrRequest.insDate = int.parse(tempCurrentTime.format(now)) > 0000 &&
          int.parse(tempCurrentTime.format(now)) < 0900
          ? sendingDateFormat.format(prev)
          : sendingDateFormat.format(now);
      hdrRequest.docDate = int.parse(tempCurrentTime.format(now)) > 0000 &&
          int.parse(tempCurrentTime.format(now)) < 0900
          ? sendingDateFormat.format(prev)
          : sendingDateFormat.format(now);
      hdrRequest.udtDate = int.parse(tempCurrentTime.format(now)) > 0000 &&
    int.parse(tempCurrentTime.format(now)) < 0900
    ? sendingDateFormat.format(prev)
        : sendingDateFormat.format(now);
      int currentYear = DateTime.now().year;
      int nextYear = currentYear + 1;
      String financialYear;

      if (DateTime.now().month >= 4) {
        financialYear =
            currentYear.toString() + nextYear.toString().substring(0);
      } else {
        financialYear =
            (currentYear - 1).toString() + currentYear.toString().substring(0);
      }
      hdrRequest.docFinyear = int.parse(financialYear);

      hdrRequest.insUid = prefs.getString("user_id");
      hdrRequest.udtUid = prefs.getString("user_id");
      AddingResult postresponse = await rep.postHdr(hdrRequest);

      List<Map> pendingList =
      await getPendingOrderRequests(allSelected, hdrRequest.codePk);

      AddingResult postresponse1 = AddingResult();
      AddingResult postresponse2 = AddingResult();
      String? usernameid = prefs.getString("user_id");
      print("userdata" + usernameid!);
      //  if (postresponse.status!) {
      postresponse1 = await rep.postPendingOrder(pendingList);
      if (postresponse1.status!) {
        postresponse2 = await rep.postStock(allStock);
        if (postresponse2.status!) {
          Navigator.pop(context);

          bool? result = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  //  surfaceTintColor: Colors.white,
                  title: Text('Docnumber is ${hdrRequest.docNo}'),
                  content: Text(postresponse2.message!),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                );
              });
          Navigator.pop(context);
        } else {
          print("error two");
          Navigator.pop(context);
        }
      } else {
        print("error one");
        Navigator.pop(context);
      }
      // }
    }
  }

  bool matchPendingOrderQty(PendingOrder pendingorder, List<Goods> goods) {
    bool is_match = false;
    double qty = 0;
    for (var good in goods) {
      qty = qty + good.prodNight! + good.prodDay!;
    }
    if (qty == pendingorder.balQty) {
      is_match = true;
    }

    return is_match;
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 5), child: Text("Processing...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<List<Map>> getPendingOrderRequests(
      List<PendingOrder> allSelected, int? codePk) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map> pendingOrders = <Map>[];
    for (var selected in allSelected) {
      PendingOrderRequest pendingOrderRequest = PendingOrderRequest();
      pendingOrderRequest.udtUid = prefs.getString("user_id");
      pendingOrderRequest.insUid = prefs.getString("user_id");
      pendingOrderRequest.codeFk = codePk!;
      pendingOrderRequest.codePk = selected.pk_code;
      pendingOrderRequest.qualitystatus = "A";
      pendingOrderRequest.remarks = selected.remarks;
      pendingOrderRequest.countcode = selected.countCode;
      pendingOrderRequest.insDate = int.parse(tempCurrentTime.format(now)) > 0000 &&
          int.parse(tempCurrentTime.format(now)) < 0900
          ? sendingDateFormat.format(prev)
          : sendingDateFormat.format(now);
      pendingOrderRequest.udtDate = int.parse(tempCurrentTime.format(now)) > 0000 &&
    int.parse(tempCurrentTime.format(now)) < 0900
    ? sendingDateFormat.format(prev)
        : sendingDateFormat.format(now);
      pendingOrderRequest.gateentrydtlfk = 0;
      pendingOrderRequest.catalogitem = selected.catalogItem;
      pendingOrderRequest.brandcode = selected.brandCode;
      pendingOrderRequest.iop1uom = selected.iop1Uom;
      pendingOrderRequest.iop1val = selected.iop1Val;
      pendingOrderRequest.iop1code = selected.iop1Code;
      pendingOrderRequest.iop2code = selected.iop2Code;
      pendingOrderRequest.iop2uom = selected.iop2Uom;
      pendingOrderRequest.iop2val = selected.iop2Val;
      pendingOrderRequest.prodqty = selected.balQty;
      pendingOrderRequest.shadecode = selected.shadeCode;
      pendingOrderRequest.materialcode = selected.materialCode;
      pendingOrderRequest.qtyuom = selected.qtyUom;
      pendingOrderRequest.proctimehrs = selected.hrs;
      pendingOrderRequest.proctimemints = selected.mint;
      pendingOrderRequest.iop3code = selected.iop3Code;
      pendingOrderRequest.iop3uom = selected.iop3Uom;
      pendingOrderRequest.iop3val = selected.iop3Val;
      pendingOrderRequest.itemcode = selected.itemCode;
      pendingOrderRequest.prodOrderDtlFk = selected.prodOrderDtlPk;
      pendingOrders.add(pendingOrderRequest.toJson());

      getAllStock(selected.pk_code!, selected.prodOrderDtlPk,
          pendingOrderRequest.qtyuom);
    }

    return pendingOrders;
  }

  void getAllStock(int pk_code, int? prodOrderDtlPk, [int? qtyuom]) async {
    final prefs = await SharedPreferences.getInstance();
    List<Goods> goods = goodsmap[prodOrderDtlPk]!;
    for (var good in goods) {
      StockRequest stockRequest = StockRequest();
      stockRequest.prodday = good.prodDay;
      stockRequest.prodnight = good.prodNight;
      stockRequest.remarks = good.remarks;
      stockRequest.acccontpersoncode = good.selectedpmName!.code;
      stockRequest.qtyuom = qtyuom;
      stockRequest.insdate = int.parse(tempCurrentTime.format(now)) > 0000 &&
          int.parse(tempCurrentTime.format(now)) < 0900
          ? sendingDateFormat.format(prev)
          : sendingDateFormat.format(now);
      stockRequest.codefk = pk_code;
      stockRequest.godowncode = good.selectedGodown!.code;
      stockRequest.lotno = good.lotNo;
      stockRequest.rollno = good.rollBagDesign.toString();
      stockRequest.insuid = prefs.getString("user_id");
      stockRequest.udtdate = int.parse(tempCurrentTime.format(now)) > 0000 &&
          int.parse(tempCurrentTime.format(now)) < 0900
          ? sendingDateFormat.format(prev)
          : sendingDateFormat.format(now);
      stockRequest.codepk = good.pk_code;
      stockRequest.udtuid = prefs.getString("user_id");
      allStock.add(stockRequest.toJson());
    }
  }
}

class MyFinishItem extends StatefulWidget {
  final Key? key;
  Goods? goods;
  bool? isEmpty = false;
  int? selected_index;

  final ValueChanged<Goods>? isSelected;
  final ValueChanged<Goods>? isDeleted;

  MyFinishItem(
      {this.goods,
        this.isSelected,
        this.isEmpty,
        this.key,
        this.selected_index,
        this.isDeleted});

  @override
  _MyFinishItemState createState() => _MyFinishItemState();
}

class _MyFinishItemState extends State<MyFinishItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Stack(children: [
          SafeArea(
            child: GestureDetector(
              onTap: () => {
                setState(() {
                  if (widget.selected_index! >= 0) {
                    Goods good = Goods(pmName: '');
                    if (!widget.isEmpty!) {
                      good = widget.goods!;
                    }
                    _showBottomSheet(widget.isSelected, good);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please select some item"),
                    ));
                  }
                })
              },
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        color: Color(0x34000000),
                        offset: Offset(-2, 5),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Person / Machine : ${widget.goods?.pmName}',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFFD63333),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                Text(
                                  'Godown: ${widget.goods?.godown ?? "add godown"}',
                                  style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                                  child: Text(
                                    'Lot no: ${widget.goods!.lotNo ?? "0"}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                                  child: Text(
                                    'Roll/Bag/Design: ${widget.goods!.rollBagDesign ?? "0"}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                                  child: Text(
                                    'Prod Day: ${widget.goods!.prodDay ?? 0} Prod Night: ${widget.goods!.prodNight ?? 0}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                                  child: Text(
                                    'Remarks: ${widget.goods!.remarks ?? ""}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: widget.goods!.isEmpty
                                    ? const Icon(
                                  Icons.add_box,
                                  color: Color(0xFFD63333),
                                )
                                    : const Icon(Icons.delete),
                                onPressed: () {
                                  if (widget.selected_index! >= 0) {
                                    if (!widget.isEmpty!) {
                                      widget.isDeleted!(widget.goods!);
                                    } else {
                                      Goods good = Goods(pmName: '');
                                      _showBottomSheet(widget.isSelected, good);
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Please select some item"),
                                    ));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  void _showBottomSheet(ValueChanged<Goods>? isSelected, [Goods? good]) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ProductionItemForm(
            isSelected: isSelected,
            close: (value) {
              Navigator.pop(context);
            },
            selected: good,
          ),
        );
      },
    );
  }
}

class ProductionItemForm extends StatefulWidget {
  ValueChanged<Goods>? isSelected;
  ValueChanged<Goods>? close;
  Goods? selected;

  ProductionItemForm({this.isSelected, this.close, this.selected});

  @override
  _ProductionItemFormState createState() => _ProductionItemFormState();
}

class _ProductionItemFormState extends State<ProductionItemForm> {
  String? dropDownValue;
  TextEditingController textController = TextEditingController();
  TextEditingController? textController1 = TextEditingController();
  TextEditingController? textController2 = TextEditingController();
  TextEditingController? textController3 = TextEditingController();
  TextEditingController? textController4 = TextEditingController();
  TextEditingController? textController5 = TextEditingController();
  TextEditingController? textController6 = TextEditingController();
  DateFormat tempCurrentTime = DateFormat('HHmm');
  DateTime now = DateTime.now();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  ListItem? selectedPerson;

  ListItem? selectedGodown;

  @override
  void initState() {
    super.initState();

    textController2!.text = "0";
    textController3!.text = "0";
    textController4!.text = "0";
    textController5!.text = "0";
    textController5!.text = "0";

    selectedGodown = widget.selected?.selectedGodown;
    selectedPerson = widget.selected?.selectedpmName;
    if (widget.selected?.pmName != null) {
      textController.text = widget.selected!.pmName!;
    }
    if (widget.selected?.godown != null) {
      textController1!.text = widget.selected!.godown!;
    }
    if (widget.selected?.lotNo != null) {
      textController2!.text = widget.selected!.lotNo!;
    }
    if (widget.selected?.rollBagDesign != null) {
      textController3!.text = widget.selected!.rollBagDesign!.toString();
    }
    if (widget.selected?.prodDay != null) {
      textController4!.text = widget.selected!.prodDay!.toString();
    }
    if (widget.selected?.prodNight != null) {
      textController5!.text = widget.selected!.prodNight!.toString();
    }
    if (widget.selected?.remarks != null) {
      textController6!.text = widget.selected!.remarks!.toString();
    }
  }

  @override
  void dispose() {
    textController1?.dispose();
    textController2?.dispose();
    textController3?.dispose();
    textController4?.dispose();
    textController5?.dispose();
    textController6?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFF0F1316),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 7,
                              color: Color(0x2F1D2429),
                              offset: Offset(0, 3),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 4, 0),
                                    child: TypeAheadField(
                                      textFieldConfiguration:
                                      TextFieldConfiguration(
                                        controller: textController,
                                        autofocus: true,
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(
                                            fontStyle: FontStyle.italic),
                                        decoration: InputDecoration(
                                          labelText: "Machine/Person",
                                          hintText: "Machine/Person",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD63333),
                                              width: 1,
                                            ),
                                            borderRadius:
                                            const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD63333),
                                              width: 1,
                                            ),
                                            borderRadius:
                                            const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                            const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedErrorBorder:
                                          OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                            const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onSuggestionSelected:
                                          (ListItem selection) {
                                        selectedPerson = selection;
                                        textController.text = selection.name!;
                                        print(
                                            'You just selected $textController.text');
                                      },
                                      suggestionsCallback: (pattern) async {
                                        return await UserRepository().getList(
                                            UserRepository().machine,
                                            textController.text);
                                      },
                                      itemBuilder: (BuildContext context,
                                          ListItem itemData) {
                                        return ListTile(
                                          title: Text(itemData.name!),
                                        );
                                      },
                                    ))),
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(4, 0, 8, 0),
                                child: TypeAheadField(
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                    controller: textController1,
                                    autofocus: true,
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .copyWith(fontStyle: FontStyle.italic),
                                    decoration: InputDecoration(
                                      labelText: "Godown",
                                      hintText: "Godown",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onSuggestionSelected: (ListItem selection) {
                                    selectedGodown = selection;
                                    textController1!.text = selection.name!;
                                    print(
                                        'You just selected $textController1!.text');
                                  },
                                  suggestionsCallback: (pattern) async {
                                    return await UserRepository().getList(
                                        UserRepository().godown,
                                        textController1!.text);
                                  },
                                  itemBuilder: (BuildContext context,
                                      ListItem itemData) {
                                    return ListTile(
                                      title: Text(itemData.name!),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 4, 0),
                                  child: TextFormField(
                                    controller: textController2,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: "Lot no",
                                      hintText: "0",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    keyboardType:
                                    TextInputType.numberWithOptions(
                                        decimal: true),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 8, 0),
                                  child: TextFormField(
                                    controller: textController3,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: "Roll/bag/design",
                                      hintText: "0",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    keyboardType:
                                    TextInputType.numberWithOptions(
                                        decimal: true),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 4, 0),
                                  child: TextFormField(
                                    enabled: (int.parse(tempCurrentTime.format(now)) > 0900 &&
                                        int.parse(tempCurrentTime.format(now)) < 2100)
                                        ? true
                                        : false,
                                    controller: textController4,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: "Prod day",
                                      hintText: "0",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    keyboardType:
                                    TextInputType.numberWithOptions(
                                        decimal: true),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 8, 0),
                                  child: TextFormField(
                                    enabled: int.parse(tempCurrentTime.format(now)) > 0900 &&
                                        int.parse(tempCurrentTime.format(now)) < 2100
                                        ? false
                                        : true,
                                    controller: textController5,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: "Prod night",
                                      hintText: "0",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    keyboardType:
                                    TextInputType.numberWithOptions(
                                        decimal: true),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 8, 0),
                                  child: TextFormField(
                                    controller: textController6,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: "Remarks",
                                      hintText: "Remarks",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFD63333),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    maxLines: null,
                                    minLines: 4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 8, 0),
                                  child: ElevatedButton(
                                      child: Text("Save Item".toUpperCase(),
                                          style: TextStyle(fontSize: 14)),
                                      style: ButtonStyle(
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xFFD63333)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  side:
                                                  BorderSide(color: Color(0xFFD63333))))),
                                      onPressed: () {
                                        _saveItem();
                                      }),
                                ),
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
        ));
  }

  _saveItem() async {
    if (selectedPerson == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select Machine/Person"),
      ));
      return;
    }
    if (selectedGodown == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select Godown"),
      ));
      return;
    }
    if (textController2!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please input lot no"),
      ));
      return;
    }
    if (textController3!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please input Roll/bag/design"),
      ));
      return;
    }
    if (textController4!.text.isEmpty && textController5!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please input production"),
      ));
      return;
    }

    var good = Goods(pmName: '');

    good.pmName = selectedPerson!.name!;
    good.godown = textController1!.text;
    good.lotNo = textController2!.text;
    good.rollBagDesign = textController3!.text;

    if (textController4!.text.isEmpty) {
      good.prodDay = 0;
    } else {
      good.prodDay = double.parse(textController4!.text);
    }
    if (textController5!.text.isEmpty) {
      good.prodNight = 0;
    } else {
      good.prodNight = double.parse(textController5!.text);
    }

    good.remarks = textController6!.text;
    good.selectedGodown = selectedGodown;

    good.selectedpmName = selectedPerson;
    good.isEmpty = false;
    if (widget.selected!.selectedpmName != null) {
      good.is_edit = true;
    } else {
      List<PkCode> response = await UserRepository().getPkstockCodes();
      good.pk_code = response[0].code ?? 0;
    }
    widget.isSelected!(good);
    widget.close!(good);
  }
}

class MyPendingItem extends StatefulWidget {
  final Key? key;
  PendingOrder? pendingOrder;
  bool? isSelect = false;
  final ValueChanged<bool>? isSelected;
  final ValueChanged<PendingOrder>? isDeleted;

  MyPendingItem(
      {this.pendingOrder,
        this.isSelected,
        this.isSelect,
        this.key,
        this.isDeleted});

  @override
  _MyPendingItemState createState() => _MyPendingItemState();
}

class _MyPendingItemState extends State<MyPendingItem> {
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Stack(children: <Widget>[
          SafeArea(
            child: GestureDetector(
              onTap: () => {
                setState(() {
                  widget.isSelected!(widget.pendingOrder!.is_selected);
                })
              },
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4, 8, 4, 8),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        color: Color(0x34000000),
                        offset: Offset(-2, 5),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 4,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFD63333),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Catalog: ${widget.pendingOrder!.catalogItem.toString()} ~ ${widget.pendingOrder!.catalogItemName.toString()}',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFFD63333),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  'Order no: ${widget.pendingOrder!.orderNo!}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 3.0,
                                ),
                                Text(
                                  'Process: ${widget.pendingOrder!.processName!}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 3.0,
                                ),
                                Text(
                                  'Hrs: ${widget.pendingOrder!.hrs!} Mins :${widget.pendingOrder!.mint!}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                Flexible(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0, 4, 0, 0),
                                          child: Text(
                                            'Prod qty: ${widget.pendingOrder!.balQty!} ${widget.pendingOrder!.qtyUomName!}',
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  widget.isDeleted!(widget.pendingOrder!);
                                },
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFFD63333),
                                ),
                                onPressed: () {
                                  _textFieldController.text =
                                      widget.pendingOrder!.balQty!.toString();
                                  _textFieldController1.text =
                                  widget.pendingOrder!.remarks!;
                                  _textFieldController2.text =
                                      widget.pendingOrder!.hrs!.toString();
                                  _textFieldController3.text =
                                      widget.pendingOrder!.mint!.toString();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          //surfaceTintColor: Colors.white,
                                          title: Text('Enter production value'),
                                          content: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(0, 16, 0, 0),
                                                      child: TextField(
                                                        controller:
                                                        _textFieldController,
                                                        decoration: InputDecoration(
                                                          labelText:
                                                          "Production qty",
                                                          hintText:
                                                          "Production qty",
                                                          enabledBorder:
                                                          OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                              Color(0xFFD63333),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                              topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                              topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                          OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                              Color(0xFFD63333),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                              topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                              topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                            ),
                                                          ),
                                                          errorBorder:
                                                          OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                              Color(0x00000000),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                              topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                              topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                            ),
                                                          ),
                                                          focusedErrorBorder:
                                                          OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                              Color(0x00000000),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                              topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                              topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                            ),
                                                          ),
                                                        ),
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                            decimal: true),
                                                      )),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                            padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 16,
                                                                4, 0),
                                                            child: TextField(
                                                              controller:
                                                              _textFieldController2,
                                                              decoration:
                                                              InputDecoration(
                                                                labelText: "Hrs",
                                                                hintText: "Hrs",
                                                                enabledBorder:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Color(
                                                                        0xFFD63333),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        4.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        4.0),
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Color(
                                                                        0xFFD63333),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        4.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        4.0),
                                                                  ),
                                                                ),
                                                                errorBorder:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Color(
                                                                        0x00000000),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        4.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        4.0),
                                                                  ),
                                                                ),
                                                                focusedErrorBorder:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Color(
                                                                        0x00000000),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        4.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        4.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              keyboardType:
                                                              TextInputType
                                                                  .number,
                                                            )),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                            padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(4, 16,
                                                                0, 0),
                                                            child: TextField(
                                                              controller:
                                                              _textFieldController3,
                                                              decoration:
                                                              InputDecoration(
                                                                labelText: "Mins",
                                                                hintText: "Mins",
                                                                enabledBorder:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Color(
                                                                        0xFFD63333),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        4.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        4.0),
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Color(
                                                                        0xFFD63333),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        4.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        4.0),
                                                                  ),
                                                                ),
                                                                errorBorder:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Color(
                                                                        0x00000000),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        4.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        4.0),
                                                                  ),
                                                                ),
                                                                focusedErrorBorder:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Color(
                                                                        0x00000000),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        4.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        4.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              keyboardType:
                                                              TextInputType
                                                                  .number,
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(0, 16, 0, 0),
                                                    child: TextField(
                                                      controller:
                                                      _textFieldController1,
                                                      decoration: InputDecoration(
                                                        labelText: "Remarks",
                                                        hintText: "Remarks",
                                                        enabledBorder:
                                                        OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color:
                                                            Color(0xFFD63333),
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                            topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                            topRight:
                                                            Radius.circular(
                                                                4.0),
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color:
                                                            Color(0xFFD63333),
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                            topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                            topRight:
                                                            Radius.circular(
                                                                4.0),
                                                          ),
                                                        ),
                                                        errorBorder:
                                                        OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color:
                                                            Color(0x00000000),
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                            topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                            topRight:
                                                            Radius.circular(
                                                                4.0),
                                                          ),
                                                        ),
                                                        focusedErrorBorder:
                                                        OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color:
                                                            Color(0x00000000),
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                            topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                            topRight:
                                                            Radius.circular(
                                                                4.0),
                                                          ),
                                                        ),
                                                      ),
                                                      keyboardType:
                                                      TextInputType.text,
                                                      maxLines: null,
                                                      minLines: 3,
                                                    ),
                                                  )
                                                ],
                                              )),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                setState(() {
                                                  if (!_textFieldController
                                                      .text.isEmpty) {
                                                    widget.pendingOrder!.balQty =
                                                        double.parse(
                                                            _textFieldController
                                                                .text);
                                                    widget.pendingOrder!.remarks =
                                                        _textFieldController1.text;
                                                    if (!_textFieldController2
                                                        .text.isEmpty) {
                                                      widget.pendingOrder!.hrs =
                                                          int.parse(
                                                              _textFieldController2
                                                                  .text);
                                                    }
                                                    if (!_textFieldController3
                                                        .text.isEmpty) {
                                                      widget.pendingOrder!.mint =
                                                          int.parse(
                                                              _textFieldController3
                                                                  .text);
                                                    }

                                                    Navigator.pop(context);
                                                  } else {}
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          widget.isSelect!
              ? Positioned(
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Icon(
                Icons.check_circle,
                color: Colors.blue,
              ),
            ),
          )
              : Container()
        ]));
  }
}
