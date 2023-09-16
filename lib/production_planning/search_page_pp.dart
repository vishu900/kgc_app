import 'dart:ffi';
import 'dart:io';
import 'package:animated_button/animated_button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:dataproject2/production_planning/search_details_model.dart';
import 'package:dataproject2/production_planning/search_page_deatails_pp.dart';
import 'dart:convert';

import 'modelPP.dart';

class SearchPagePP extends StatefulWidget {
  var code;
  var userid;
  SearchPagePP({super.key, required this.code, required this.userid});

  @override
  State<SearchPagePP> createState() => _SearchPagePPState();
}

class _SearchPagePPState extends State<SearchPagePP> {
  int aIndex = 0;

  var accCode;
  var contactPersonCode;

  var party_code;

  TextEditingController docdateController = TextEditingController();
  TextEditingController finyearController = TextEditingController();
  TextEditingController docnoController = TextEditingController();

  List<GetPartyListModelPP> partyItem = [];
  List<Map<String, dynamic>> _partyList = [];

  GetPartyListModelPP partyOption = GetPartyListModelPP(NAME: "", CODE: "");

  List<GetPartyListModelPP> contactPersonItem = [];
  GetPartyListModelPP contactPersonItemSelected =
      GetPartyListModelPP(NAME: "", CODE: "");
  List<Map<String, dynamic>> _contactPersonList = [];

  List<Map<String, dynamic>> approvalName = [];
  Map<String, dynamic>? itemSelected;
  List<Map<String, dynamic>> _approvalList = [];

  @override
  void initState() {
    super.initState();
    getPartyList();
    getContactList();
  }

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
        accCode = party_code;

      }
    });
  }

  Future<void> getContactList() async {
    try {
      final url = Uri.parse(
          "http://103.204.185.17:24978/webapi/api/Common/ProdPlanContactPerson?comp_code=" +
              widget.code);
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

  List<Map<String, dynamic>> _searchItem = [];
  List<Map<String, dynamic>> tempsearch = [];

  Future<void> getSearchItem() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/SearchProdPlan?doc_date=" +
            docdateController.text +
            "&doc_finyear=" +
            finyearController.text +
            "&acc_code=" +
            accCode.toString() +
            "&cont_person_code=" +
            (contactPersonCode.toString() == "null"
                ? ""
                : contactPersonCode.toString()) +
            "&doc_no=" +
            docnoController.text);
    print("MyContPer:"+ accCode.toString());
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    setState(
      () {
        tempsearch = List.castFrom(jsonResponseList);
        _searchItem.clear();
        for (var searched in tempsearch) {
          if (searched["COMP_CODE"].toString() == widget.code.toString()) {
            _searchItem.add(searched);
          }
        }
      },
    );
  }

  // Future<void> getapprovalListPP() async {
  //   final url = Uri.parse(
  //       "http://103.204.185.17:24978/webapi/api/Common/GetUsersPP?compCode=${widget.code}");
  //   final response = await http.get(url);
  //   final jsonResponseList = json.decode(response.body);

  //   setState(
  //     () {
  //       _approvalList = List.castFrom(jsonResponseList);
  //       approvalName.clear();
  //       approvalName.add({"": ""});

  //       for (final approval in _approvalList) {
  //         approvalName.add(approval);
  //       }
  //       if (approvalName.isNotEmpty) {
  //         itemSelected = approvalName[0];
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Search Items"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Doc Date",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: TextFormField(
                      controller: docdateController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter document date',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                                onTap: () {
                                  docdateController.clear();
                                },
                                child: const Icon(Icons.clear)),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () async {
                                final DateTime? selectedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );
                                if (selectedDate != null) {
                                  docdateController.text =
                                      DateFormat('dd.MM.yyyy')
                                          .format(selectedDate);
                                }
                              },
                              child: const Icon(Icons.calendar_today),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Fin Year",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: TextFormField(
                      controller: finyearController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter Fin Year',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        suffixIcon: IconButton(
                          onPressed: () {
                            finyearController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Doc No",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: TextFormField(
                      controller: docnoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter Doc No',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        suffixIcon: IconButton(
                          onPressed: () {
                            docnoController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Party",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // const SizedBox(width: 10.0),
                  SizedBox(
                    width: 200,
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
                          accCode = value.CODE.toString();
                          // getContactList(accCode);
                        });
                      },
                      selectedItem: partyOption,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Contact Person",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  SizedBox(
                    width: 200,
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
              const SizedBox(height: 10),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (docdateController.text.isEmpty &&
                          finyearController.text.isEmpty &&
                          accCode.toString() == "" &&
                          contactPersonCode.toString() == "null" &&
                          docnoController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text(
                                  "Please enter some search query in at least 1 search field!"),
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
                        setState(() {
                          getSearchItem();
                        });
                      }
                    },
                    child: const Text('Search Item'),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _searchItem.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 25, top: 10),
                    child: InkWell(
                      onTap: () {
                        var search_detailsPP = GetSearchDetailsPP(
                          code_Pk: _searchItem[index]["CODE_PK"],
                          finYear: _searchItem[index]["DOC_FINYEAR"].toString(),
                          docNo: _searchItem[index]["DOC_NO"].toString(),
                          docDate: _searchItem[index]["DOC_DATE"].toString(),
                          party: _searchItem[index]["PARTY_NAME"].toString(),
                          partyCode: _searchItem[index]["ACC_CODE"].toString(),
                          contPerson:
                              _searchItem[index]["CONT_PERSON_NAME"].toString(),
                          contPersonCode:
                              _searchItem[index]["CONT_PERSON_CODE"].toString(),
                        );

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SearchPagedetailsPP(
                                  code: widget.code,
                                  getSearchDetails: search_detailsPP,
                                  userid: widget.userid,
                                )));
                      },
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
                                    child: Text(
                                      "Doc No",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Doc Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Doc Fin Year",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _searchItem[index]["DOC_NO"].toString(),
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
                                          _searchItem[index]["DOC_DATE"]
                                              .toString(),
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _searchItem[index]["DOC_FINYEAR"]
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
                                    child: Text(
                                      "Party",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Text("Driver"),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _searchItem[index]["PARTY_NAME"]
                                          .toString(),
                                      style: const TextStyle(),
                                    ),
                                  ),

                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Text(
                                  //     _searchItem[index]["DRIVER_CODE"]
                                  //         .toString(),
                                  //     style: const TextStyle(
                                  //       fontWeight: FontWeight.w600,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: const [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Company",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _searchItem[index]["COMP_NAME"]
                                          .toString(),
                                      style: const TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: const [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Cont Person",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _searchItem[index]["CONT_PERSON_NAME"]
                                          .toString(),
                                      style: const TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${index + 1}/${_searchItem.length}',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
