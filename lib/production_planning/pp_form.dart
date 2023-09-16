import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:dataproject2/production_planning/process_order.dart';
import 'package:dataproject2/production_planning/sale_order.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:dataproject2/production_planning/modelPP.dart';
import 'package:http/http.dart' as http;
import 'package:dataproject2/production_planning/search_page_pp.dart';
import 'dart:convert';

import 'package:dataproject2/production_planning/selected_item_pp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PPForm extends StatefulWidget {
  var code;
  var userid;
  PPForm({super.key, required this.code, required this.userid});

  @override
  State<PPForm> createState() => _PPFormState();
}

class _PPFormState extends State<PPForm> {
  int aIndex = 0;

  List<GetPartyListModelPP> partyItem = [];
  List<Map<String, dynamic>> _partyList = [];
  GetPartyListModelPP partyOption = GetPartyListModelPP(NAME: "", CODE: "");

  String myDataPermission = "";
  String myDeletePermission = "";

  List<GetPartyListModelPP> contactPersonItem = [];
  GetPartyListModelPP contactPersonItemSelected =
      GetPartyListModelPP(NAME: "", CODE: "");
  List<Map<String, dynamic>> _contactPersonList = [];

  List<Map<String, dynamic>> selectedList = [];

  List<TextEditingController> qtyControllers = [];

  List<Map<String, dynamic>> approvalName = [];
  Map<String, dynamic>? itemSelected;
  List<Map<String, dynamic>> _approvalList = [];
  List<Map<String, dynamic>> permission = [];


  Future<void> getPermission(
      String username, String taskid, String compCode) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/GetPermissions?username=" +
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

  @override
  void initState() {
    super.initState();
    getPartyList();
    getContactList("518");
    getapprovalListPP();
    getPermission(widget.userid, "taskid", widget.code.toString());
  }

  var party_code;
  var contactPersonCode;

  Future<void> getPartyList() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/ProdPlanParty?comp_code=${widget.code}");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      _partyList = List.castFrom(jsonResponseList);

      partyItem.clear();
      // partyItem.add(GetPartyListModel(NAME: "", CODE: ""));

      for (final party in _partyList) {
        partyItem
            .add(GetPartyListModelPP(NAME: party['NAME'], CODE: party["CODE"]));
      }

      try {
        // getContactList(partyItem[1].CODE.toString());
      } catch (e) {
        print(e);
      }

      if (partyItem.isNotEmpty) {
        partyOption = partyItem[1];
        party_code = partyItem[1].CODE.toString();
      }
    });
  }

  Future<void> getContactList(String ACC_CODE) async {
    try {
      final url = Uri.parse(
          "http://103.204.185.17:24978/webapi/api/Common/ProdPlanContactPerson?comp_code=" +
              widget.code.toString()+"&ACC_CODE="+ACC_CODE.toString());
      final response = await http.get(url);
      final jsonResponseList = json.decode(response.body);
      setState(
        () {
          _contactPersonList = List.castFrom(jsonResponseList);
          contactPersonItem.clear();
          contactPersonItem.add(GetPartyListModelPP(NAME: "", CODE: ""));

          for (final contact in _contactPersonList) {
            contactPersonItem.add(GetPartyListModelPP(
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

  Future<void> getapprovalListPP() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/GetUsersPP?compCode=${widget.code}");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

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

  List<Map<String, dynamic>> removeDuplicates(
      List<Map<String, dynamic>> people) {
    List<Map<String, dynamic>> distinct;
    List<Map<String, dynamic>> dummy = List.from(people);

    for (int i = 0; i < dummy.length; i++) {
      for (int j = i + 1; j < dummy.length; j++) {
        if (dummy[i]["PROD_ORDER_DTL_PK"] == dummy[j]["PROD_ORDER_DTL_PK"]) {
          dummy.removeAt(j);
          j--;
        }
      }
    }

    distinct = dummy;
    print(distinct);

    return distinct.map((e) => e).toList();
  }

  Future<void> getDocNoPP(String compCode, String docFinYear) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/GetPPDocNo?compCode=" +
            compCode +
            "&docFinYear=" +
            docFinYear);
    final response = await http.get(url);

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

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // String userId = prefs.getString('user_id') ?? '';

        print("ListLength"+ selectedList.length.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();

        for (var i = 0; i < selectedList.length; i++) {
          await getSavePagePP(
            widget.code,
            docFinYear,
            partyOption.CODE.toString(),
            contactPersonItemSelected.CODE.toString(),
            _approvalList[aIndex]["USER_ID"],
              prefs.getString('user_id')!,
            selectedList[i]["PROD_ORDER_DTL_PK"],
            qtyControllers[i].text,
            response.body.toString().split(":")[1], response.body.toString().split(":")[2]
          );
        }

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Data Saved Successfull"),
              content:
                  Text("Doc Number: ${response.body.toString().split(":")[1]}"),
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
                      selectedList.clear();
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

  Future<void> getSavePagePP(
    COMP_CODE,
    FinYear,
    ACC_CODE,
    CONT_PERSON_CODE,
    APPROVAL_UID,
    INS_UID,
    PROD_ORDER_DTL_PK,
    PLAN_QTY,
    DOC_NO, codePkHDR
  ) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/InsertProductionPlan?" +
            "COMP_CODE=" +
            widget.code +
            "&FinYear=" +
            FinYear.toString() +
            "&ACC_CODE=" +
            ACC_CODE.toString() +
            "&CONT_PERSON_CODE=" +
            CONT_PERSON_CODE.toString() +
            "&APPROVAL_UID=" +
            APPROVAL_UID.toString() +
            "&INS_UID=" +
            INS_UID.toString() +
            "&PROD_ORDER_DTL_PK=" +
            PROD_ORDER_DTL_PK.toString() +
            "&PLAN_QTY=" +
            PLAN_QTY.toString() +
            "&DOC_NO=" +
            DOC_NO.toString()+
    "&codePkHDR="+codePkHDR.toString());
    final response = await http.get(url);

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
                      selectedList.clear();
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
      appBar: AppBar(
        backgroundColor: const Color(0xffd53233),
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios)),
        title: const Text("Production Planning"),
        actions: [
          myDataPermission == "A" ||
              myDataPermission == "M" ||
              myDataPermission == "S" ||
              myDataPermission == "I"
          ?
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      SearchPagePP(code: widget.code, userid: widget.userid)));
            },
            child: const Icon(Icons.search),
          ): Container(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () async {
                if (selectedList.isEmpty) {
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
                                  selectedList.clear();
                                });
                              },
                            ),
                          ],
                        );
                      });
                } else if (contactPersonItemSelected.CODE.toString() == "") {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Please select Contact Person "),
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
                                  selectedList.clear();
                                });
                              },
                            ),
                          ],
                        );
                      });
                } else if (partyOption.CODE.toString() == "") {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Please select Party "),
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
                                  selectedList.clear();
                                });
                              },
                            ),
                          ],
                        );
                      });
                } else {
                  String finYear = financialYear;

                  await getDocNoPP(widget.code, finYear);
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
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Doc Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat("dd.MM.yyyy").format(
                        DateTime.now(),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      financialYear,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text(
                      "Party",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 20.0),
                    SizedBox(
                      width: 240,
                      child: DropdownSearch<GetPartyListModelPP>(
                        items: partyItem,
                        itemAsString: (GetPartyListModelPP partyItem) =>
                            partyItem.NAME,
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
                        onChanged: (GetPartyListModelPP? value) {
                          setState(() {
                            partyOption = value!;
                            party_code = value.CODE.toString();
                            getContactList(value.CODE.toString());

                            // getContactList(party_code);
                          });
                        },
                        selectedItem: partyOption,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text(
                      "Contact Person",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 20.0),
                    SizedBox(
                      width: 170,
                      child: DropdownSearch<GetPartyListModelPP>(
                        items: contactPersonItem,
                        itemAsString: (GetPartyListModelPP contactPersonItem) =>
                            contactPersonItem.NAME,
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
                              )),
                        ),
                        onChanged: (GetPartyListModelPP? value) {
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
              SizedBox(height: 10.0),
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text(
                          "Approval",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 35.0),
                        SizedBox(
                          height: 50,
                          width: 195,
                          child: DropdownSearch<Map<String, dynamic>>(
                            itemAsString:
                                (Map<String, dynamic> _approvalList) =>
                                    _approvalList["NAME"].toString() == "null"
                                        ? ""
                                        : _approvalList["NAME"].toString(),
                            items: _approvalList,
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
                                  aIndex = _approvalList.indexOf(value!);
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
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () async {
                  selectedList = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SelectedItemPP(
                        COMP_CODE: widget.code,
                        PARTY_CODE: party_code,
                      ),
                    ),
                  );
                  setState(() {
                    selectedList = removeDuplicates(selectedList);
                    // SelectedList;
                    for (int i = 0; i < selectedList.length; i++) {
                      qtyControllers.add(TextEditingController());
                    }
                    for (int i = 0; i < selectedList.length; i++) {
                      qtyControllers[i].text =
                          selectedList[i]["QTY"].toString();
                    }
                  });
                },
                child: const Text("Selected Item"),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 680,
                child: PageView.builder(
                  itemCount: selectedList.length,
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
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Order No"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Order Date"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    selectedList[index]["ORDER_NO"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    DateFormat('dd.MM.yy').format(
                                      DateTime.parse(
                                        selectedList[index]["ORDER_DATE"]
                                            .toString(),
                                      ),
                                    ),
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
                                    "${selectedList[index]["CATALOG_ITEM"]} - ${selectedList[index]["CATALOG_NAME"]}",
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
                                    "${selectedList[index]["COUNT_CODE"]} - ${selectedList[index]["COUNT_NAME"]}",
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
                                    "${selectedList[index]["ITEM_CODE"]} - ${selectedList[index]["ITEM_NAME"]}",
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
                                    "${selectedList[index]["MATERIAL_CODE"]} - ${selectedList[index]["MATERIAL_NAME"]}",
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
                                    "${selectedList[index]["SHADE_CODE"]} - ${selectedList[index]["SHADE_NAME"]}",
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
                                    "${selectedList[index]["BRAND_CODE"]} - ${selectedList[index]["BRAND_NAME"]}",
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
                                    "${selectedList[index]["PROC_CODE"]} - ${selectedList[index]["PROC_NAME"]}",
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
                                              qtyControllers[index].clear();
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
                                Expanded(
                                  flex: 1,
                                  child: Text("Bal Qty"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Rate"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    selectedList[index]["UOM_ABV"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    selectedList[index]["BAL_QTY"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    selectedList[index]["RATE"].toString(),
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
                                  child: Text("Prod Day"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Prod Night"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Total Prod"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    selectedList[index]["PROD_DAY"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    selectedList[index]["PROD_NIGHT"]
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    selectedList[index]["TOT_PROD"].toString(),
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
                                    '${index + 1}/${selectedList.length}',
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
                                            selectedList[index]
                                            ["SALE_ORDER_DTL_PK"]),
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
                                          selectedList[index]
                                          ["PROD_ORDER_HDR_PK"],
                                          SALE_ORDER_DTL_PK:
                                          selectedList[index]
                                          ["SALE_ORDER_DTL_PK"],
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
      ): Container(),
    );
  }
}
