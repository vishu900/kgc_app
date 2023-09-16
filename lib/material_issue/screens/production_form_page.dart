// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animated_button/animated_button.dart';
import 'package:dataproject2/material_issue/Url/url.dart';
import 'package:dataproject2/material_issue/model/party_list_model.dart';
import 'package:dataproject2/material_issue/model/process_order_model.dart';
import 'package:dataproject2/material_issue/model/selected_item_model.dart';
import 'package:dataproject2/material_issue/screens/process_order.dart';
import 'package:dataproject2/material_issue/screens/sale_order.dart';
import 'package:dataproject2/material_issue/screens/search_page.dart';
import 'package:dataproject2/material_issue/screens/select_item.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../custom_button.dart/k_button.dart';
import '../model/insert_model.dart';
import '../model/qtyModek.dart';

class ProductionFormPAge extends StatefulWidget {
  var code;
  var userid;

  ProductionFormPAge({super.key, required this.code, required this.userid});

  @override
  State<ProductionFormPAge> createState() => _ProductionFormPAgeState();
}

class _ProductionFormPAgeState extends State<ProductionFormPAge> {
  var accCode;
  var contactPersonCode;

  List<SelectedItemModel> selected_items_list = [];

  ProcessOrderModel? processOrder;

  List<String> tempHSN = [];

  // party list

  List<GetPartyListModel> partyItem = [];
  List<Map<String, dynamic>> _partyList = [];

  GetPartyListModel partyOption = GetPartyListModel(NAME: "", CODE: "");

  // driver list

  List<Map<String, dynamic>> driverName = [];
  Map<String, dynamic>? itemSelected;
  List<Map<String, dynamic>> _driverList = [];

  // HSN Code list

  List<String> hsnCodeName = [];
  String hsnCodeSelected = '';
  List<Map<String, dynamic>> _hsnCode = [];

  List<String> tempQtyList = [];

  int currentIndex = 0;

  String totalqty = "0", totalbag = "0", totalamount = "0", godown = "";

  // contact person list

  List<GetPartyListModel> contactPersonItem = [];
  GetPartyListModel contactPersonItemSelected =
      GetPartyListModel(NAME: "", CODE: "");
  List<Map<String, dynamic>> _contactPersonList = [];

  // save page

  List<Map<String, dynamic>> _savePage = [];
  List<Map<String, dynamic>> _docNo = [];

  @override
  void initState() {
    super.initState();

    getPartyList();
    getDriverList();
    getPermission(widget.userid, "taskid", widget.code.toString());
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

  Future<void> getPartyList() async {
    final url = Uri.parse(
        "${Reusable.baseUrl}/webapi/api/Common/GetPartyListMI?comp_code=${widget.code}");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      _partyList = List.castFrom(jsonResponseList);

      partyItem.clear();

      for (final party in _partyList) {
        partyItem
            .add(GetPartyListModel(NAME: party['NAME'], CODE: party["CODE"]));
      }

      try {
        getContactList(partyItem[1].CODE.toString());
      } catch (e) {
        print(e);
      }

      if (partyItem.isNotEmpty) {
        partyOption = partyItem[1];
        accCode = partyItem[1].CODE.toString();
      }
    });
  }

  Future<void> getContactList(var accNo) async {
    try {
      final url = Uri.parse(
          "${Reusable.baseUrl}/webapi/api/Common/GetContactPersonMI?comp_code=" +
              widget.code +
              "&acc_code=" +
              accNo);
      final response = await http.get(url);
      final jsonResponseList = json.decode(response.body);
      setState(
        () {
          _contactPersonList = List.castFrom(jsonResponseList);
          contactPersonItem.clear();
          for (final contact in _contactPersonList) {
            contactPersonItem.add(GetPartyListModel(
                NAME: contact["NAME"], CODE: contact["CODE"]));
          }
          if (contactPersonItem.isNotEmpty) {
            contactPersonItemSelected = contactPersonItem[0];
            contactPersonCode = contactPersonItem[0].CODE;
          }
        },
      );
    } on SocketException catch (e) {
      print("FROM SOCKET EXCEPTION");
    } catch (e) {
      print(e.toString());
    }
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

  Future<void> getDocNo(String compCode, String docFinYear) async {
    final url = Uri.parse(
        "${Reusable.baseUrl}/webapi/api/Common/GetDocNo?compCode=" +
            compCode +
            "&docFinYear=" +
            docFinYear);
    final response = await http.get(url);
    // final jsonResponseList = json.decode(response.body);

    try {
      if (response.body.toString().contains("DocNo:")) {
        int currentYear = DateTime.now().year;
        int nextYear = currentYear + 1;
        String financialYear;

        if (DateTime.now().month >= 4) {
          financialYear =
              currentYear.toString() + nextYear.toString().substring(0);
        } else {
          financialYear = (currentYear - 1).toString() +
              currentYear.toString().substring(0);
        }

        final String docNumberNew =
            response.body.toString().split(":")[1].toString();

        final String codePk = response.body.toString().split(":")[2].toString();

        String docDate = DateFormat("dd.MM.yyyy").format(DateTime.now());

        String sysdt = DateFormat("dd-MM-yy").format(DateTime.now());

        String finYear = financialYear;
        String insDate = DateFormat("dd-MM-yy").format(DateTime.now());
        for (int i = 0; i < insertModelList!.length; i++) {
          await getSavePage(
            docDate,
            finYear,
            accCode,
            contactPersonCode,
            "remarks",
            insDate,
            "APPDBA",
            insDate,
            "APPDBA",
            itemSelected!["CODE"],
            insertModelList![i].PROD_ORDER_BOM_FK.toString().contains("{") ||
                    insertModelList![i].PROD_ORDER_BOM_FK.toString() == "null"
                ? "0"
                : insertModelList![i].PROD_ORDER_BOM_FK.toString(),
            insertModelList![i].godownCode,
            insertModelList![i].lotNo,
            insertModelList![i].ROLL_NO,
            insertModelList![i].QTY,
            insertModelList![i].INQTY,
            insertModelList![i].OUTQTY,
            insertModelList![i].QTY_UOM_NUM,
            tempHSN[i],
            insertModelList![i].RATE,
            insertModelList![i].AMOUNT,
            insertModelList![i].CATALOG_ITEM,
            insertModelList![i].COUNT_CODE,
            insertModelList![i].ITEM_CODE,
            insertModelList![i].material_code,
            insertModelList![i].brand_code,
            sysdt,
            insertModelList![i].shade_code,
            insertModelList![i].iop1_code,
            insertModelList![i].iop1_val,
            insertModelList![i].iop1_uom,
            insertModelList![i].iop2_code,
            insertModelList![i].iop2_val,
            insertModelList![i].iop2_uom,
            insertModelList![i].iop3_code,
            insertModelList![i].iop3_val,
            insertModelList![i].iop3_uom,
            docNumberNew,
            codePk,
          );
        }

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
                      selected_items_list.clear();
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  List<List> allHsnCodes = [];

  Future<void> getHSNCODE(var matcode) async {
    final url = Uri.parse(
        "${Reusable.baseUrl}/webapi/api/Common/HSNCODE?MATERIAL_CODE=" +
            matcode.toString());
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    setState(
      () {
        _hsnCode = List.castFrom(jsonResponseList);
        hsnCodeName.clear();

        List<String> names = [];

        for (final Hsn in _hsnCode) {
          hsnCodeName.add(Hsn["HSN_CODE"].toString());
          names.add(Hsn["HSN_CODE"].toString());
        }
        allHsnCodes.add(names);

        for (var tempNames in allHsnCodes) {
          tempHSN.add(tempNames[0].toString());
        }

        if (hsnCodeName.isNotEmpty) {
          hsnCodeSelected = hsnCodeName[0];
        }
      },
    );
  }

  Future<void> getSavePage(
    String docDate,
    docFinYear,
    accCode,
    contPersonCode,
    remarks,
    insDate,
    insUid,
    udtDate,
    udtUid,
    driverCode,
    PROD_ORDER_BOM_FK,
    GODOWN_CODE,
    LOT_NO,
    ROLL_NO,
    QTY,
    INQTY,
    OUTQTY,
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
    docNo,
    codePk,
  ) async {
    Random random = Random();

    // Generate a random integer between 0 and 99
    int randomNumber = random.nextInt(100);

    final url = Uri.parse(
        "${Reusable.baseUrl}/webapi/api/Common/insertprodorder?" +
            "compCode=" +
            widget.code +
            "&docDate=" +
            docDate.toString() +
            "&docFinYear=" +
            docFinYear.toString() +
            "&accCode=" +
            accCode.toString() +
            "&contPersonCode=" +
            contPersonCode.toString() +
            "&remarks=" +
            remarks.toString() +
            "&insDate=" +
            insDate.toString() +
            "&insUid=" +
            insUid.toString() +
            "&udtDate=" +
            udtDate.toString() +
            "&udtUid=" +
            udtUid.toString() +
            "&driverCode=" +
            driverCode.toString() +
            "&PROD_saveORDER_BOM_FK=" +
            PROD_ORDER_BOM_FK.toString() +
            "&GODOWN_CODE=" +
            GODOWN_CODE.toString() +
            "&LOT_NO=" +
            LOT_NO.toString() +
            "&ROLL_NO=" +
            ROLL_NO.toString() +
            "&QTY=" +
            QTY.toString() +
            "&INQTY=" +
            INQTY.toString() +
            "&OUTQTY=" +
            OUTQTY.toString() +
            "&QTY_UOM=" +
            QTY_UOM.toString() +
            "&HSN_CODE=" +
            HSN_CODE.toString() +
            "&RATE=" +
            RATE.toString() +
            "&AMOUNT=" +
            AMOUNT.toString() +
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
            shade_code +
            "&iop1_code=" +
            iop1_code +
            "&iop1_val=" +
            iop1_val +
            "&iop1_uom=" +
            iop1_uom +
            "&iop2_code=" +
            iop2_code +
            "&iop2_val=" +
            iop2_val +
            "&iop2_uom=" +
            iop2_uom +
            "&iop3_code=" +
            iop3_code +
            "&iop3_val=" +
            iop3_val +
            "&iop3_uom=" +
            iop3_uom +
            "&docNo=" +
            docNo +
            "&codePk=" +
            codePk);
    final response = await http.get(url);
    print("Docnumber: " + docNo + " " + randomNumber.toString());
    if (response.body.toString().contains("Successfull")) {
      // ignore: use_build_context_synchronously
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Data Saved Successfull"),
              content: const Text("Doc Number: "),
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
                      selected_items_list.clear();
                    });
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

  List<InsertModel>? insertModelList = [];

  List<QtyModel>? qtyList;

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
      onTap: (){
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
          title: const Text("Production Form"),
          actions: [
            myDataPermission == "A" ||
                    myDataPermission == "M" ||
                    myDataPermission == "S" ||
                    myDataPermission == "I"
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MIsearch(
                              code: widget.code, userid: widget.userid)));
                    },
                    child: const Icon(Icons.search),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () async {
                  if (selected_items_list.length == 0) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: const Text("No Item selected "),
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
                                    selected_items_list.clear();
                                  });
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    String docDate =
                        DateFormat("dd.MM.yyyy").format(DateTime.now());
    
                    String sysdt = DateFormat("dd-MM-yy").format(DateTime.now());
    
                    String finYear = financialYear;
                    String insDate =
                        DateFormat("dd-MM-yy").format(DateTime.now());
    
                    await getDocNo(widget.code, finYear);
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        body: myDataPermission == "A" || myDataPermission == "I"
            ? SingleChildScrollView(
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
                      const SizedBox(height: 15.0),
                      Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const Text(
                                  "Party",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(width: 20.0),
                                SizedBox(
                                  height: 50,
                                  width: 240,
                                  child: DropdownSearch<GetPartyListModel>(
                                    items: partyItem,
                                    itemAsString: (GetPartyListModel partyItem) =>
                                        partyItem.NAME,
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                    ),
                                    dropdownButtonProps:
                                        const DropdownButtonProps(
                                      color: Colors.red,
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      textAlignVertical: TextAlignVertical.center,
                                      dropdownSearchDecoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, right: 5),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onChanged: (GetPartyListModel? value) {
                                      setState(() {
                                        partyOption = value!;
                                        accCode = value.CODE.toString();
                                        getContactList(accCode);
                                      });
                                    },
                                    selectedItem: partyOption,
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
                                  "Contact Person",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                const SizedBox(width: 10.0),
                                SizedBox(
                                  height: 50,
                                  width: 178,
                                  child: DropdownSearch<GetPartyListModel>(
                                    items: contactPersonItem,
                                    itemAsString:
                                        (GetPartyListModel contactPersonItem) =>
                                            contactPersonItem.NAME,
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                    ),
                                    dropdownButtonProps:
                                        const DropdownButtonProps(
                                      color: Colors.red,
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      textAlignVertical: TextAlignVertical.center,
                                      dropdownSearchDecoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              left: 10, right: 5),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                                    onChanged: (GetPartyListModel? value) {
                                      setState(() {
                                        contactPersonItemSelected = value!;
                                        contactPersonCode = value.CODE;
                                      });
                                    },
                                    selectedItem: contactPersonItemSelected,
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
                                    dropdownButtonProps:
                                        const DropdownButtonProps(
                                      color: Colors.red,
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      textAlignVertical: TextAlignVertical.center,
                                      dropdownSearchDecoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, right: 5),
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
                      const SizedBox(height: 5.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MIButton(
                              onPressed: () {},
                              backgroundColor: const Color(
                                0xffd53233,
                              ),
                              borderColor: const Color(0xffd53233),
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: const Text("REMARKS"),
                            ),
                            const SizedBox(width: 15.0),
                            MIButton(
                              onPressed: () async {
                                if (accCode == null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Error"),
                                        content: const Text(
                                            "Please Select Party First!"),
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
                                  selected_items_list =
                                      await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MISelectedItems(
                                        comp_code: widget.code,
                                        acc_code: accCode,
                                        CONT_PERSON_CODE: contactPersonCode,
                                      ),
                                    ),
                                  );
                                  setState(
                                    () {
                                      tempHSN.clear();
                                      tempQtyList.clear();
    
                                      double tempQty = 0.0;
                                      double tempBag = 0.0;
                                      double tempAmount = 0.0;
    
                                      for (var selectedItem
                                          in selected_items_list) {
                                        tempQty = tempQty +
                                            double.parse(
                                                selectedItem.Qty.toString()
                                                        .contains("{")
                                                    ? "0"
                                                    : selectedItem.Qty);
    
                                        tempQtyList
                                            .add(selectedItem.Qty.toString());
                                        tempBag = tempBag +
                                            double.parse(
                                                selectedItem.RollNo.toString()
                                                        .contains("{")
                                                    ? "0"
                                                    : selectedItem.RollNo);
                                        tempAmount = tempAmount +
                                            double.parse(
                                                selectedItem.Amount.toString()
                                                        .contains("{")
                                                    ? "0"
                                                    : selectedItem.Amount);
    
                                        getHSNCODE(selectedItem.hsnCode);
                                        insertModelList!.add(InsertModel(
                                          PROD_ORDER_BOM_FK:
                                              selectedItem.PROD_ORDER_BOM_FK,
                                          godownCode: selectedItem.godowncode,
                                          lotNo: selectedItem.lotNo,
                                          ROLL_NO: selectedItem.RollNo,
                                          QTY: selectedItem.Qty,
                                          INQTY: selectedItem.Qty,
                                          OUTQTY: "0",
                                          QTY_UOM: selectedItem.UOM,
                                          HSN_CODE:
                                              selectedItem.hsnCode.toString(),
                                          RATE: selectedItem.Rate.toString(),
                                          AMOUNT: selectedItem.Amount.toString(),
                                          CATALOG_ITEM:
                                              selectedItem.catalogCode.toString(),
                                          COUNT_CODE:
                                              selectedItem.countCode.toString(),
                                          ITEM_CODE:
                                              selectedItem.ITEM_CODE.toString(),
                                          material_code: selectedItem.materialCode
                                              .toString(),
                                          brand_code:
                                              selectedItem.brandCode.toString(),
                                          shade_code:
                                              selectedItem.shade_code.toString(),
                                          iop1_code:
                                              selectedItem.iop1_code.toString(),
                                          iop1_val:
                                              selectedItem.iop1_val.toString(),
                                          iop1_uom:
                                              selectedItem.iop1_uom.toString(),
                                          iop2_code:
                                              selectedItem.iop2_code.toString(),
                                          iop2_val:
                                              selectedItem.iop2_val.toString(),
                                          iop2_uom:
                                              selectedItem.iop2_uom.toString(),
                                          iop3_code:
                                              selectedItem.iop3_code.toString(),
                                          iop3_val:
                                              selectedItem.iop3_val.toString(),
                                          iop3_uom:
                                              selectedItem.iop2_uom.toString(),
                                          QTY_UOM_NUM:
                                              selectedItem.QTY_UOM_NUM.toString(),
                                        ));
                                      }
    
                                      setState(() {
                                        totalqty = tempQty.toString();
                                        totalbag = tempBag.toString();
                                        totalamount = tempAmount.toString();
                                      });
    
                                      if (selected_items_list.isNotEmpty) {
                                        setState(() {
                                          godown = selected_items_list[0]
                                              .godownName
                                              .toString();
                                        });
                                      }
    
                                      processOrder = selected_items_list.isEmpty
                                          ? ProcessOrderModel(
                                              CATALOG_ITEM_NAME: "",
                                              catalogCode: "",
                                              orderDate: "",
                                              prdOrderNo: "",
                                              pro_odr_name: "")
                                          : ProcessOrderModel(
                                              CATALOG_ITEM_NAME:
                                                  selected_items_list[0].name,
                                              prdOrderNo: selected_items_list[0]
                                                  .prdOrderNo,
                                              catalogCode: selected_items_list[0]
                                                  .catalogCode,
                                              orderDate: selected_items_list[0]
                                                  .orderDate,
                                              pro_odr_name: selected_items_list[0]
                                                  .pro_odr_name,
                                            );
                                    },
                                  );
                                }
                              },
                              backgroundColor: const Color(
                                0xffd53233,
                              ),
                              borderColor: const Color(0xffd53233),
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: const Text("SELECT ITEMS"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5.0),
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
                            height: 400,
                            child: PageView.builder(
                              onPageChanged: (value) {
                                setState(() {
                                  currentIndex = value;
                                  godown = selected_items_list[value]
                                      .godownName
                                      .toString();
                                });
                                processOrder = ProcessOrderModel(
                                    CATALOG_ITEM_NAME:
                                        selected_items_list[value].name,
                                    prdOrderNo:
                                        selected_items_list[value].prdOrderNo,
                                    catalogCode:
                                        selected_items_list[value].catalogCode,
                                    orderDate:
                                        selected_items_list[value].orderDate,
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
                                                      TextFormField(
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                                decimal: true),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  '[0-9.,]')),
                                                        ],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            tempHSN[index] =
                                                                value;
                                                          });
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              'Enter the HSN Code',
                                                        ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter the HSN Code';
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (value) {},
                                                      ),
                                                      const SizedBox(height: 16),
                                                      const Text(
                                                          "Select HSN Code"),
                                                      const SizedBox(height: 8),
                                                      SizedBox(
                                                        height: 40,
                                                        width: 180,
                                                        child: DropdownSearch(
                                                          items: allHsnCodes
                                                                  .isEmpty
                                                              ? []
                                                              : allHsnCodes[0],
                                                          popupProps:
                                                              const PopupProps
                                                                  .menu(
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
                                                            setState(() {
                                                              tempHSN[index] =
                                                                  value;
                                                            });
                                                          },
                                                          selectedItem: tempHSN
                                                                  .isEmpty
                                                              ? []
                                                              : tempHSN[index],
                                                        ),
                                                      ),
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
                                                        .RollNo,
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
                                                              const EdgeInsets
                                                                  .only(left: 16),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                          ),
                                                          child: TextField(
                                                            enabled: false,
                                                            keyboardType:
                                                                TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      '[0-9.,]')),
                                                            ],
                                                            controller:
                                                                TextEditingController(
                                                              text: tempQtyList[
                                                                  index],
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                            ),
                                                            decoration:
                                                                const InputDecoration(
                                                              border: InputBorder
                                                                  .none,
                                                              contentPadding:
                                                                  EdgeInsets.zero,
                                                            ),
                                                            onChanged: (value) {
                                                              // setState(() {
                                                              //   selected_items_list[
                                                              //               index]
                                                              //           .Qty =
                                                              //       value.toString();
                                                              //   insertModelList![index]
                                                              //           .QTY =
                                                              //       value.toString();
                                                              // });
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
                                                                builder:
                                                                    (context) {
                                                                  double
                                                                      receivedQty =
                                                                      double.parse(
                                                                          selected_items_list[index]
                                                                              .Qty);
                                                                  double
                                                                      currentQty =
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
                                                                      keyboardType:
                                                                          TextInputType.numberWithOptions(
                                                                              decimal:
                                                                                  true),
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter
                                                                            .allow(
                                                                                RegExp('[0-9.,]')),
                                                                      ],
                                                                      controller:
                                                                          TextEditingController(
                                                                              text:
                                                                                  currentQty.toString()),
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
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                title: const Text("Error"),
                                                                                content: const Text("The enter Qty cannot greater than available Qty!"),
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
                                                                              double.parse(value.toString());
                                                                        }
                                                                      },
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(),
                                                                        child: const Text(
                                                                            'Cancel'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            tempQtyList[index] =
                                                                                currentQty.toString();
                                                                            insertModelList![index].INQTY =
                                                                                currentQty.toString();
    
                                                                            insertModelList![index].QTY =
                                                                                currentQty.toString();
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Save'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            iconSize: 16,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
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
                                                        .UOM,
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
                                                        .Rate,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    selected_items_list[index]
                                                        .Amount,
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
                          SizedBox(
                            height: 180,
                            child: PageView.builder(
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
                                    if (processOrder != null) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ProcessOrder(
                                              processorderData: processOrder!),
                                        ),
                                      );
                                    }
                                  },
                                  backgroundColor: const Color(
                                    0xffd53233,
                                  ),
                                  borderColor: const Color(0xffd53233),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                  child: const Text("PROCESS ORDER"),
                                ),
                                const SizedBox(width: 5.0),
                                MIButton(
                                  onPressed: () {
                                    if (processOrder != null) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => MISaleOrder(
                                              processOrderModel: processOrder!, SALE_ORDER_DTL_PK: selected_items_list[currentIndex].SALE_ORDER_DTL_PK),
                                        ),
                                      );
                                    }
                                  },
                                  backgroundColor: const Color(
                                    0xffd53233,
                                  ),
                                  borderColor: const Color(0xffd53233),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 30),
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
              )
            : Container(),
      ),
    );
  }
}
