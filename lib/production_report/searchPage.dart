import 'dart:convert';
import 'package:dataproject2/production_report/finYearModel.dart';
import 'package:dataproject2/production_report/searchResult.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DetailRequestModel.dart';
import 'detailsModel.dart';
import 'details_page.dart';
import 'party_list_model.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  String compCode, comp_name;
  SearchPage({Key? key, required this.compCode, required this.comp_name}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  TextEditingController shadeController = TextEditingController();

  String day_night = "Both";

  String dateformat(DateTime date) {
    String formattedDate = DateFormat('dd.MM.yyyy').format(date);
    return formattedDate;
  }

  List<Map<String, dynamic>> approvalName = [];
  Map<String, dynamic>? itemSelected;
  List<Map<String, dynamic>> _approvalList = [];

  List<GetPartyListModel> partyItem = [];
  List<Map<String, dynamic>> _partyList = [];

  GetPartyListModel partyOption = GetPartyListModel(NAME: "", CODE: "");

  TextStyle headingStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  String selectedUnit = "";

  Future<void> getapprovalList(String START_DATE, END_DATE) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/getFiltersPR?COMP_CODE=${widget.compCode.toString()}"
        "&START_DATE=${START_DATE}"
        "&END_DATE=${END_DATE}"
        "&task=Users");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('companyCode', widget.compCode);

    setState(
      () {
        _approvalList.clear();
        _approvalList.add({"USER_ID": ""});
        _approvalList.addAll(List.castFrom(jsonResponseList));
        approvalName.clear();
        approvalName.add({"USER_ID": ""});

        for (final approval in _approvalList) {
          approvalName.add(approval);
        }
        if (approvalName.isNotEmpty) {
          itemSelected = approvalName[0];
        }
      },
    );
  }

  Future<void> getPartyList(String START_DATE, END_DATE) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/getFiltersPR?COMP_CODE=${widget.compCode.toString()}"
        "&START_DATE=${START_DATE}"
        "&END_DATE=${END_DATE}"
        "&task=Party");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      _partyList = List.castFrom(jsonResponseList);

      partyItem.clear();
      partyItem.add(GetPartyListModel(NAME: "", CODE: ""));
      for (final party in _partyList) {
        partyItem
            .add(GetPartyListModel(NAME: party['NAME'], CODE: party["CODE"]));
      }

     for(int i=0; i<partyItem.length; i++){
       if(partyItem[i].CODE.toString()=="518"){
         partyOption = partyItem[i];
       }
     }

      if (partyItem.isNotEmpty) {

      }
    });
  }

  List<Map<String, dynamic>> contactList = [];
  List<GetPartyListModel> contactItem = [];
  GetPartyListModel contactOption = GetPartyListModel(NAME: "", CODE: "");

  Future<void> getContact(String START_DATE, END_DATE) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/getFiltersPR?COMP_CODE=${widget.compCode.toString()}"
        "&START_DATE=${START_DATE}"
        "&END_DATE=${END_DATE}"
        "&task=Machine");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      contactList = List.castFrom(jsonResponseList);

      contactItem.clear();
      contactItem.add(GetPartyListModel(NAME: "", CODE: ""));
      for (final contact in contactList) {
        contactItem.add(
            GetPartyListModel(NAME: contact['NAME'], CODE: contact["CODE"]));
      }

      if (contactItem.isNotEmpty) {
        contactOption = contactItem[0];
      }
    });
  }



  List<Map<String, dynamic>> catalogList = [];
  List<GetPartyListModel> catalogItem = [];
  GetPartyListModel catalogOption = GetPartyListModel(NAME: "", CODE: "");

  Future<void> getCatalog(String START_DATE, END_DATE) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/getFiltersPR?COMP_CODE=${widget.compCode.toString()}"
            "&START_DATE=${START_DATE}"
            "&END_DATE=${END_DATE}"
            "&task=Catalog");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      catalogList = List.castFrom(jsonResponseList);

      catalogItem.clear();
      catalogItem.add(GetPartyListModel(NAME: "", CODE: ""));
      for (final contact in catalogList) {
        catalogItem.add(
            GetPartyListModel(NAME: contact['NAME'], CODE: contact["CODE"]));
      }

      if (catalogItem.isNotEmpty) {
        catalogOption = catalogItem[0];
      }
    });
  }

  List<Map<String, dynamic>> materialList = [];
  List<GetPartyListModel> materialItem = [];
  GetPartyListModel materialOption = GetPartyListModel(NAME: "", CODE: "");

  Future<void> getMaterials(String START_DATE, END_DATE) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/getFiltersPR?COMP_CODE=${widget.compCode.toString()}"
        "&START_DATE=${START_DATE}"
        "&END_DATE=${END_DATE}"
        "&task=Material");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      materialList = List.castFrom(jsonResponseList);

      materialItem.clear();
      materialItem.add(GetPartyListModel(NAME: "", CODE: ""));
      for (final contact in materialList) {
        materialItem.add(
            GetPartyListModel(NAME: contact['NAME'], CODE: contact["CODE"]));
      }

      if (materialItem.isNotEmpty) {
        materialOption = materialItem[0];
      }
    });
  }

  List<Map<String, dynamic>> shadeList = [];
  List<GetPartyListModel> shadeItem = [];
  GetPartyListModel shadeOption = GetPartyListModel(NAME: "", CODE: "");

  Future<void> getShade(String START_DATE, END_DATE) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/getFiltersPR?COMP_CODE=${widget.compCode.toString()}"
        "&START_DATE=${START_DATE}"
        "&END_DATE=${END_DATE}"
        "&task=Shade");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      shadeList = List.castFrom(jsonResponseList);

      shadeItem.clear();
      shadeItem.add(GetPartyListModel(NAME: "", CODE: ""));
      for (final contact in shadeList) {
        shadeItem.add(
            GetPartyListModel(NAME: contact['NAME'], CODE: contact["CODE"]));
      }

      if (shadeItem.isNotEmpty) {
        shadeOption = shadeItem[0];
      }
    });
  }

  List<Map<String, dynamic>> brandList = [];
  List<GetPartyListModel> brandItem = [];
  GetPartyListModel brandOption = GetPartyListModel(NAME: "", CODE: "");

  Future<void> getBrand(String START_DATE, END_DATE) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/getFiltersPR?COMP_CODE=${widget.compCode.toString()}"
        "&START_DATE=${START_DATE}"
        "&END_DATE=${END_DATE}"
        "&task=Brand");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      brandList = List.castFrom(jsonResponseList);

      brandItem.clear();
      brandItem.add(GetPartyListModel(NAME: "", CODE: ""));
      for (final contact in brandList) {
        brandItem.add(
            GetPartyListModel(NAME: contact['NAME'], CODE: contact["CODE"]));
      }

      if (brandItem.isNotEmpty) {
        brandOption = brandItem[0];
      }
    });
  }

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

  List<Map<String, dynamic>> searchList = [];

  String isloading = "init";

  int aIndex = 0;

  List<Map<String, dynamic>> countList = [];
  List<GetPartyListModel> countItem = [];
  GetPartyListModel countOption = GetPartyListModel(NAME: "", CODE: "");

  Future<void> getCount(String START_DATE, END_DATE) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/getFiltersPR?COMP_CODE=${widget.compCode.toString()}"
        "&START_DATE=${START_DATE}"
        "&END_DATE=${END_DATE}"
        "&task=Count");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      countList = List.castFrom(jsonResponseList);

      countItem.clear();
      countItem.add(GetPartyListModel(NAME: "", CODE: ""));
      for (final contact in countList) {
        countItem.add(
            GetPartyListModel(NAME: contact['NAME'], CODE: contact["CODE"]));
      }

      if (countItem.isNotEmpty) {
        countOption = countItem[0];
      }
    });
  }

  List<Map<String, dynamic>> itemList = [];
  List<GetPartyListModel> itemItem = [];
  GetPartyListModel itemOption = GetPartyListModel(NAME: "", CODE: "");

  Future<void> getItem(String START_DATE, END_DATE) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/getFiltersPR?COMP_CODE=${widget.compCode.toString()}"
        "&START_DATE=${START_DATE}"
        "&END_DATE=${END_DATE}"
        "&task=Item");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      itemList = List.castFrom(jsonResponseList);

      itemItem.clear();
      itemItem.add(GetPartyListModel(NAME: "", CODE: ""));
      for (final contact in itemList) {
        itemItem.add(
            GetPartyListModel(NAME: contact['NAME'], CODE: contact["CODE"]));
      }

      if (itemItem.isNotEmpty) {
        itemOption = itemItem[0];
      }
    });
  }

  List<Map<String, dynamic>> godownList = [];
  List<GetPartyListModel> godownItem = [];
  GetPartyListModel godownOption = GetPartyListModel(NAME: "", CODE: "");

  Future<void> getGodown(String START_DATE, END_DATE) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/getFiltersPR?COMP_CODE=${widget.compCode.toString()}"
        "&START_DATE=${START_DATE}"
        "&END_DATE=${END_DATE}"
        "&task=Godown");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      godownList = List.castFrom(jsonResponseList);

      godownItem.clear();
      godownItem.add(GetPartyListModel(NAME: "", CODE: ""));
      for (final contact in godownList) {
        godownItem.add(
            GetPartyListModel(NAME: contact['NAME'], CODE: contact["CODE"]));
      }

      if (godownItem.isNotEmpty) {
        godownOption = godownItem[0];
      }
    });
  }

  List<Map<String, dynamic>> finYearList = [];
  List<FinYearModel> finYearItem = [];
  FinYearModel finYearOption =
      FinYearModel(FINYEAR: '', FROM_DATE: '', TO_DATE: '');

  Future<void> getFinyear() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/FinYear?COMP_CODE=${widget.compCode.toString()}");
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);

    setState(() {
      finYearList = List.castFrom(jsonResponseList);
      print("MyFinYear " + response.body);

      finYearItem.clear();
      finYearItem.add(FinYearModel(FINYEAR: '', FROM_DATE: '', TO_DATE: ''));
      for (final contact in finYearList) {
        print("MyFinYear " + contact['FINYEAR'].toString());
        finYearItem.add(FinYearModel(
            FINYEAR: contact['FINYEAR'].toString(),
            FROM_DATE: contact["FROM_DATE"].toString(),
            TO_DATE: contact["TO_DATE"].toString()));
      }

      if (finYearItem.isNotEmpty) {
        finYearOption = finYearItem[0];
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yy').format(currentDate);
    toDateController.text = formattedDate;
    fromDateController.text = formattedDate;
    getFinyear();

    getPartyList(formattedDate, formattedDate);
    getContact(formattedDate, formattedDate);
    getCatalog(formattedDate, formattedDate);
    getapprovalList(formattedDate, formattedDate);
    getShade(formattedDate, formattedDate);
    getMaterials(formattedDate, formattedDate);

    getCount(formattedDate, formattedDate);
    getItem(formattedDate, formattedDate);
    getGodown(formattedDate, formattedDate);

    getBrand(formattedDate, formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Production Report",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 5),
            child: Text(
              "Select Date Range:",
              style: headingStyle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 40,
                width: 150,
                child: TextFormField(
                  onChanged: (value) {
                    // Add Change API
                    //getDateWise();

                    finYearOption = finYearItem[0];

                    String pattern = r"\d{2}\.\d{2}\.\d{2}";

                    bool fromdatePattern =
                        RegExp(pattern).hasMatch(fromDateController.text);
                    bool todatePattern =
                        RegExp(pattern).hasMatch(toDateController.text);

                    if (fromdatePattern && todatePattern) {
                      print("DateMatching1");
                      getBrand(fromDateController.text, toDateController.text);

                      getCount(fromDateController.text, toDateController.text);
                      getItem(fromDateController.text, toDateController.text);
                      getGodown(fromDateController.text, toDateController.text);

                      getPartyList(
                          fromDateController.text, toDateController.text);
                      getContact(
                          fromDateController.text, toDateController.text);
                      getCatalog(
                          fromDateController.text, toDateController.text);
                      getapprovalList(
                          fromDateController.text, toDateController.text);
                      getShade(fromDateController.text, toDateController.text);
                      getMaterials(
                          fromDateController.text, toDateController.text);
                    } else {
                      print("NotDateMatching1");
                      getBrand("", "");

                      getCount("", "");
                      getItem("", "");
                      getGodown("", "");

                      getPartyList("", "");
                      getContact("", "");
                      getCatalog("", "");
                      getapprovalList("", "");
                      getShade("", "");
                      getMaterials("", "");
                    }
                  },
                  controller: fromDateController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    hintText: 'From Date',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              fromDateController.clear();
                            },
                            child: Icon(Icons.clear)),
                        SizedBox(width: 5.0),
                        InkWell(
                          onTap: () async {
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              finYearOption = finYearItem[0];
                              fromDateController.text =
                                  DateFormat('dd.MM.yy').format(selectedDate);
                              String pattern = r"\d{2}\.\d{2}\.\d{2}";

                              bool fromdatePattern = RegExp(pattern)
                                  .hasMatch(fromDateController.text);
                              bool todatePattern = RegExp(pattern)
                                  .hasMatch(toDateController.text);

                              if (fromdatePattern && todatePattern) {
                                print("DateMatching2");

                                getCount(fromDateController.text,
                                    toDateController.text);
                                getItem(fromDateController.text,
                                    toDateController.text);
                                getGodown(fromDateController.text,
                                    toDateController.text);

                                getPartyList(fromDateController.text,
                                    toDateController.text);
                                getContact(fromDateController.text,
                                    toDateController.text);
                                getCatalog(fromDateController.text,
                                    toDateController.text);
                                getapprovalList(fromDateController.text,
                                    toDateController.text);
                                getShade(fromDateController.text,
                                    toDateController.text);
                                getMaterials(fromDateController.text,
                                    toDateController.text);
                                getBrand(fromDateController.text,
                                    toDateController.text);
                              } else {
                                print("NotDateMatching2");
                                getBrand("", "");

                                getCount("", "");
                                getItem("", "");
                                getGodown("", "");

                                getPartyList("", "");
                                getContact("", "");
                                getCatalog("", "");
                                getapprovalList("", "");
                                getShade("", "");
                                getMaterials("", "");
                              }
                            }
                          },
                          child: Icon(Icons.calendar_today),
                        ),
                        SizedBox(width: 8,)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text("-"),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 40,
                width: 150,
                child: TextFormField(
                  onChanged: (value) {
                    finYearOption = finYearItem[0];
                    // Add Change API
                    //getDateWise();
                    String pattern = r"\d{2}\.\d{2}\.\d{2}";

                    bool fromdatePattern =
                        RegExp(pattern).hasMatch(fromDateController.text);
                    bool todatePattern =
                        RegExp(pattern).hasMatch(toDateController.text);

                    if (fromdatePattern && todatePattern) {
                      print("DateMatching2");
                      getCount(fromDateController.text, toDateController.text);
                      getItem(fromDateController.text, toDateController.text);
                      getGodown(fromDateController.text, toDateController.text);
                      getBrand(fromDateController.text, toDateController.text);
                      getPartyList(
                          fromDateController.text, toDateController.text);
                      getContact(
                          fromDateController.text, toDateController.text);
                      getCatalog(
                          fromDateController.text, toDateController.text);
                      getapprovalList(
                          fromDateController.text, toDateController.text);
                      getShade(fromDateController.text, toDateController.text);
                      getMaterials(
                          fromDateController.text, toDateController.text);
                    } else {
                      print("NotDateMatching2");
                      getCount("", "");
                      getItem("", "");
                      getGodown("", "");
                      getBrand("", "");
                      getPartyList("", "");
                      getContact("", "");
                      getCatalog("", "");
                      getapprovalList("", "");
                      getShade("", "");
                      getMaterials("", "");
                    }
                  },
                  controller: toDateController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    hintText: 'To Date',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              toDateController.clear();
                            },
                            child: Icon(Icons.clear)),
                        SizedBox(width: 5.0),
                        InkWell(
                          onTap: () async {
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              finYearOption = finYearItem[0];
                              toDateController.text =
                                  DateFormat('dd.MM.yy').format(selectedDate);
                              String pattern = r"\d{2}\.\d{2}\.\d{2}";

                              bool fromdatePattern = RegExp(pattern)
                                  .hasMatch(fromDateController.text);
                              bool todatePattern = RegExp(pattern)
                                  .hasMatch(toDateController.text);

                              if (fromdatePattern && todatePattern) {
                                print("DateMatching2");
                                getCount(fromDateController.text,
                                    toDateController.text);
                                getItem(fromDateController.text,
                                    toDateController.text);
                                getGodown(fromDateController.text,
                                    toDateController.text);
                                getBrand(fromDateController.text,
                                    toDateController.text);
                                getPartyList(fromDateController.text,
                                    toDateController.text);
                                getContact(fromDateController.text,
                                    toDateController.text);
                                getCatalog(fromDateController.text,
                                    toDateController.text);
                                getapprovalList(fromDateController.text,
                                    toDateController.text);
                                getShade(fromDateController.text,
                                    toDateController.text);
                                getMaterials(fromDateController.text,
                                    toDateController.text);
                              } else {
                                print("NotDateMatching2");
                                getCount("", "");
                                getItem("", "");
                                getGodown("", "");
                                getBrand("", "");
                                getPartyList("", "");
                                getContact("", "");
                                getCatalog("", "");
                                getapprovalList("", "");
                                getShade("", "");
                                getMaterials("", "");
                              }
                            }
                          },
                          child: Icon(Icons.calendar_today),
                        ),
                        SizedBox(width: 8,)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "Brand",
                        style: headingStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                      width: 150,
                      child: DropdownSearch<GetPartyListModel>(
                        items: brandItem,
                        itemAsString: (GetPartyListModel brandItem) =>
                            brandItem.NAME,
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
                                //borderRadius: BorderRadius.circular(5),
                                ),
                          ),
                        ),
                        onChanged: (GetPartyListModel? value) {
                          setState(() {
                            brandOption = value!;
                            // accCode = value.CODE.toString();
                            // getContactList(accCode);
                          });
                        },
                        selectedItem: brandOption,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "FinYear",
                        style: headingStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                      width: 150,
                      child: DropdownSearch<FinYearModel>(
                        items: finYearItem,
                        itemAsString: (FinYearModel finYearItem) =>
                            finYearItem.FINYEAR,
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
                                //borderRadius: BorderRadius.circular(5),
                                ),
                          ),
                        ),
                        onChanged: (FinYearModel? value) {
                          setState(() {
                            finYearOption = value!;
                            fromDateController.text = dateformat(DateTime.parse(
                                finYearOption.FROM_DATE.toString()));

                            toDateController.text = dateformat(DateTime.parse(
                                finYearOption.TO_DATE.toString()));

                            getBrand(
                                fromDateController.text, toDateController.text);

                            getCount(
                                fromDateController.text, toDateController.text);
                            getItem(
                                fromDateController.text, toDateController.text);
                            getGodown(
                                fromDateController.text, toDateController.text);

                            getPartyList(
                                fromDateController.text, toDateController.text);
                            getContact(
                                fromDateController.text, toDateController.text);
                            getCatalog(
                                fromDateController.text, toDateController.text);
                            getapprovalList(
                                fromDateController.text, toDateController.text);
                            getShade(
                                fromDateController.text, toDateController.text);
                            getMaterials(
                                fromDateController.text, toDateController.text);
                          });
                        },
                        selectedItem: finYearOption,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "Party",
                        style: headingStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                      width: 150,
                      child: DropdownSearch<GetPartyListModel>(
                        items: partyItem,
                        itemAsString: (GetPartyListModel partyItem) =>
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
                                //borderRadius: BorderRadius.circular(5),
                                ),
                          ),
                        ),
                        onChanged: (GetPartyListModel? value) {
                          setState(() {
                            partyOption = value!;
                            // accCode = value.CODE.toString();
                            // getContactList(accCode);
                          });
                        },
                        selectedItem: partyOption,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "Catalog Item",
                        style: headingStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                      width: 150,
                      child: DropdownSearch<GetPartyListModel>(
                        items: catalogItem,
                        itemAsString: (GetPartyListModel catalogItem) =>
                        catalogItem.CODE==""? "":catalogItem.CODE.toString().trim()+"-"+catalogItem.NAME.trim(),
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
                              //borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        onChanged: (GetPartyListModel? value) {
                          setState(() {
                            catalogOption = value!;
                            // accCode = value.CODE.toString();
                            // getContactList(accCode);
                          });
                        },
                        selectedItem: catalogOption,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "Material",
                        style: headingStyle,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 3, bottom: 3),
                      width: 150,
                      child: DropdownSearch<GetPartyListModel>(
                        items: materialItem,
                        itemAsString: (GetPartyListModel materialItem) =>
                            materialItem.NAME,
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                        ),
                        dropdownButtonProps: const DropdownButtonProps(
                          color: Colors.red,
                        ),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          textAlignVertical: TextAlignVertical.center,
                          dropdownSearchDecoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10, right: 5),
                            border: OutlineInputBorder(
                                //borderRadius: BorderRadius.circular(5),
                                ),
                          ),
                        ),
                        onChanged: (GetPartyListModel? value) {
                          setState(() {
                            materialOption = value!;
                            // accCode = value.CODE.toString();
                            // getContactList(accCode);
                          });
                        },
                        selectedItem: materialOption,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "Shade",
                        style: headingStyle,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 3, bottom: 3),
                      width: 150,
                      child: DropdownSearch<GetPartyListModel>(
                        items: shadeItem,
                        itemAsString: (GetPartyListModel shadeItem) =>
                            shadeItem.NAME,
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                        ),
                        dropdownButtonProps: const DropdownButtonProps(
                          color: Colors.red,
                        ),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          textAlignVertical: TextAlignVertical.center,
                          dropdownSearchDecoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10, right: 5),
                            border: OutlineInputBorder(
                                //borderRadius: BorderRadius.circular(5),
                                ),
                          ),
                        ),
                        onChanged: (GetPartyListModel? value) {
                          setState(() {
                            shadeOption = value!;
                            // accCode = value.CODE.toString();
                            // getContactList(accCode);
                          });
                        },
                        selectedItem: shadeOption,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Machine/Contact Person",
                          style: headingStyle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 3, bottom: 3),
                        width: 150,
                        child: DropdownSearch<GetPartyListModel>(
                          items: contactItem,
                          itemAsString: (GetPartyListModel contactItem) =>
                              contactItem.NAME,
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                          ),
                          dropdownButtonProps: const DropdownButtonProps(
                            color: Colors.red,
                          ),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            textAlignVertical: TextAlignVertical.center,
                            dropdownSearchDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 5),
                              border: OutlineInputBorder(
                                  //borderRadius: BorderRadius.circular(5),
                                  ),
                            ),
                          ),
                          onChanged: (GetPartyListModel? value) {
                            setState(() {
                              contactOption = value!;
                              // accCode = value.CODE.toString();
                              // getContactList(accCode);
                            });
                          },
                          selectedItem: contactOption,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Users",
                          style: headingStyle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 3, bottom: 3),
                        width: 150,
                        child: DropdownSearch<Map<String, dynamic>>(
                          itemAsString: (Map<String, dynamic> _approvalList) =>
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
                ]),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Count",
                          style: headingStyle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 3, bottom: 3),
                        width: 150,
                        child: DropdownSearch<GetPartyListModel>(
                          items: countItem,
                          itemAsString: (GetPartyListModel countItem) =>
                              countItem.NAME,
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                          ),
                          dropdownButtonProps: const DropdownButtonProps(
                            color: Colors.red,
                          ),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            textAlignVertical: TextAlignVertical.center,
                            dropdownSearchDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 5),
                              border: OutlineInputBorder(
                                  //borderRadius: BorderRadius.circular(5),
                                  ),
                            ),
                          ),
                          onChanged: (GetPartyListModel? value) {
                            setState(() {
                              countOption = value!;
                              // accCode = value.CODE.toString();
                              // getContactList(accCode);
                            });
                          },
                          selectedItem: countOption,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Item",
                          style: headingStyle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 3, bottom: 3),
                        width: 150,
                        child: DropdownSearch<GetPartyListModel>(
                          items: itemItem,
                          itemAsString: (GetPartyListModel itemItem) =>
                              itemItem.NAME,
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                          ),
                          dropdownButtonProps: const DropdownButtonProps(
                            color: Colors.red,
                          ),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            textAlignVertical: TextAlignVertical.center,
                            dropdownSearchDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 5),
                              border: OutlineInputBorder(
                                  //borderRadius: BorderRadius.circular(5),
                                  ),
                            ),
                          ),
                          onChanged: (GetPartyListModel? value) {
                            setState(() {
                              itemOption = value!;
                              // accCode = value.CODE.toString();
                              // getContactList(accCode);
                            });
                          },
                          selectedItem: itemOption,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Godown",
                          style: headingStyle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 3, bottom: 3),
                        width: 150,
                        child: DropdownSearch<GetPartyListModel>(
                          items: godownItem,
                          itemAsString: (GetPartyListModel godownItem) =>
                              godownItem.NAME,
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                          ),
                          dropdownButtonProps: const DropdownButtonProps(
                            color: Colors.red,
                          ),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            textAlignVertical: TextAlignVertical.center,
                            dropdownSearchDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, right: 5),
                              border: OutlineInputBorder(
                                  //borderRadius: BorderRadius.circular(5),
                                  ),
                            ),
                          ),
                          onChanged: (GetPartyListModel? value) {
                            setState(() {
                              godownOption = value!;
                              // accCode = value.CODE.toString();
                              // getContactList(accCode);
                            });
                          },
                          selectedItem: godownOption,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Day/Night",
                          style: headingStyle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 3, bottom: 3),
                        width: 150,
                        child: DropdownSearch<String>(
                          items: ["Both", "Day", "Night"],

                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                          ),
                          dropdownButtonProps: const DropdownButtonProps(
                            color: Colors.red,
                          ),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            textAlignVertical: TextAlignVertical.center,
                            dropdownSearchDecoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.only(left: 10, right: 5),
                              border: OutlineInputBorder(
                                //borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              day_night = value!;
                              // accCode = value.CODE.toString();
                              // getContactList(accCode);
                            });
                          },
                          selectedItem: day_night,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),

          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  setState(() {
                    // total_day = 0.0;
                    isloading = "true";
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SearchResultPr(
                          fromdate: fromDateController.text,
                          todate: toDateController.text,
                          partycode: partyOption.CODE.toString(),
                          catelogitem: catalogOption.CODE.toString(),
                          materialcode: materialOption.CODE.toString(),
                          shadecode: shadeOption.CODE.toString(),
                          compCode: widget.compCode.toString(),
                          username: _approvalList[aIndex]["USER_ID"],
                          DOC_FINYEAR: finYearOption.FINYEAR,
                          BRAND_CODE: brandOption.CODE.toString(),
                          contactOption: contactOption.CODE.toString(),
                          COUNT_CODE: countOption.CODE.toString(),
                          ITEM_CODE: itemOption.CODE.toString(),
                          GODOWN_CODE: godownOption.CODE.toString(),
                          fromto: fromDateController.text+" - "+toDateController.text,
                          comp_name: widget.comp_name,
                          day_night: day_night,
                        ),
                      ),
                    );
                  });
                },
                child: const Text('Search'),
              ),
            ],
          ),

          // isloading == "init"
          //     ? Container()
          //     : isloading == "true"
          //         ? Center(child: CircularProgressIndicator())
          //         : Expanded(
          //             child: )
        ],
      ),
    );
  }
}
