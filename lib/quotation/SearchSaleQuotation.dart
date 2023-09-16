import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/quotation/QuotationForm.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../newmodel/QCompanyModel.dart';
import '../newmodel/SearchResultModel.dart';
import 'AddressModel.dart';
import 'PartyModel.dart';
import 'SendEmail.dart';
import 'ViewPdf.dart';

class SearchSaleQuotation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchSaleQuotation();
}

class _SearchSaleQuotation extends State<SearchSaleQuotation> {
  /// Controllers
  TextEditingController _companyController =
      TextEditingController(text: 'Select Company');
  TextEditingController _partyController = TextEditingController();
  TextEditingController _entryDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _finYearController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();

  /// List
  List<QCompanyModel> companyList = [];
  List<PartyModel> partyList = [];
  List<PartyModel> mainPartyList = [];
  List<AddressModel> addressList = [];
  List<SearchResultModel> searchResultList = [];

  String? companyCode = '';
  String addressCode = '';
  String? partyCode = '';
  String? rankCode = '';

  DateTime now = DateTime.now();
  PageController? _pageController;

  int position = 0;
  double progress = 0.0;
  bool isDownloading = false;
  double? height;

  String? id;
  String? mPartyCode;
  String? partyName;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      _getCompanyList();
    });
    _pageController = PageController(initialPage: 0);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (position == 0) {
          return true;
        } else {
          _pageController!.previousPage(
              duration: Duration(milliseconds: 600),
              curve: Curves.fastLinearToSlowEaseIn);
          return false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            position == 0
                ? 'Search Sale Quotation'
                : 'Sale Quotation (${searchResultList.length})',
          ),
          centerTitle: false,
          backgroundColor: Color(0xFFFF0000),
          actions: [
            /*position == 0
                ? Tooltip(
                    message: 'Add Sale Quotation',
                    child: IconButton(
                        icon: Icon(
                          Icons.playlist_add,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuotationForm()));
                        }),
                  )
                : Tooltip(
                    message: 'Search Sale Quotation',
                    child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          _pageController.previousPage(
                              duration: Duration(milliseconds: 600),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }),
                  )*/
          ],
        ),
        body: PageView.builder(
          /// 0 => Search Screen, 1=> Result Screen
          itemBuilder: (context, index) => _getMainWidget(index),
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: 2,
          onPageChanged: (pos) {
            setState(() {
              position = pos;
            });
            debugPrint("OnPageChanged => $pos");
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => QuotationForm()));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  _getMainWidget(int index) {
    if (index == 0) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),

              /// From Date
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter To Date' : null,
                controller: _entryDateController,
                readOnly: true,
                style: TextStyle(),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'From Date',
                  // labelText: 'Enter Date'
                ),
                onTap: _selectDate,
              ),
              SizedBox(
                height: 20,
              ),

              /// To Date
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter To Date' : null,
                controller: _toDateController,
                readOnly: true,
                style: TextStyle(),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'To Date',
                  // labelText: 'Enter Date'
                ),
                onTap: _toDate,
              ),
              SizedBox(
                height: 20,
              ),

              /// Financial Year
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter financial year' : null,
                controller: _finYearController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                style: TextStyle(),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Financial Year e.g. 20202021',
                    labelText: 'Financial Year'),
              ),

              SizedBox(
                height: 20,
              ),

              /// Number
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter number' : null,
                controller: _numberController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                style: TextStyle(),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Number',
                    labelText: 'Number'),
              ),

              SizedBox(
                height: 20,
              ),

              /// Company Name
              TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Please select company name' : null,
                  onTap: () {
                    debugPrint('Company List Size is ${companyList.length}');
                    _companyBottomSheet(context);
                  },
                  controller: _companyController,
                  readOnly: true,
                  style: TextStyle(),
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                      border: OutlineInputBorder(),
                      hintText: 'Company Name',
                      isDense: true)),

              SizedBox(
                height: 20,
              ),

              /// Party Name
              TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Please select party name' : null,
                  onTap: () {
                    if (partyList.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Please select a company first.',
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red);
                    } else {
                      _partyBottomSheet(context);
                    }
                  },
                  controller: _partyController,
                  readOnly: true,
                  style: TextStyle(),
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                      border: OutlineInputBorder(),
                      hintText: 'Party Name',
                      isDense: true)),

              SizedBox(
                height: 20,
              ),

              /// Address
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter address' : null,
                controller: _addressController,
                readOnly: true,
                style: TextStyle(),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Address',
                  // labelText: 'Address'
                ),
                onTap: () {
                  addressList.isEmpty
                      ? Commons.showToast('Please select a party first.')
                      : _partyAddressSheet(context);
                },
              ),

              SizedBox(
                height: 20,
              ),

              /// Remarks
              TextFormField(
                style: TextStyle(),
                controller: _remarksController,
                keyboardType: TextInputType.multiline,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.newline,
                maxLines: 5,
                minLines: 3,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Remarks',
                    hintStyle: TextStyle(),
                    labelText: 'Remarks'),
              ),

              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 30,
              ),

              /// Search Button
              ElevatedButton(
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Text(
                  'Search',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                // color: Colors.red,
                onPressed: () {
                  if (_validated()) {
                    _search();
                  }
                },
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.grey[200],
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(10.0),
            itemCount: searchResultList.length,
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    _viewQuotation(index);
                  },
                  child: Container(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Table(
                              children: [
                                /// Quotation No.
                                TableRow(children: [
                                  Text('Quotation No'),
                                  Text(searchResultList[index].qtnNo!)
                                ]),

                                /// Quotation Date
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text('Quotation Date'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child:
                                        Text(searchResultList[index].qtnDate!),
                                  )
                                ]),

                                /// Quotation FinYear
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text('Quotation FinYear'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                        searchResultList[index].qtnFinYear!),
                                  )
                                ]),

                                /// Party Name
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text('Party Name'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                        searchResultList[index].partyName!),
                                  )
                                ]),

                                /// Company Name
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text('Company Name'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(9.0),
                                          child: Image.network(
                                            AppConfig.small_image +
                                                searchResultList[index]
                                                    .compLogo!,
                                            height: 18,
                                            width: 18,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(searchResultList[index].compName!),
                                      ],
                                    ),
                                  )
                                ])
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    icon: SvgPicture.asset(
                                      'images/mail_icon.svg',
                                      width: 28,
                                      height: 28,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SendEmail(
                                                    codePk:
                                                        searchResultList[index]
                                                            .id,
                                                    partyCode:
                                                        searchResultList[index]
                                                            .partyCode,
                                                    companyName:
                                                        searchResultList[index]
                                                            .partyName,
                                                    type: Qtn,
                                                  )));
                                    }),
                                IconButton(
                                    icon: SvgPicture.asset(
                                      'images/pdf.svg',
                                      width: 28,
                                      height: 28,
                                    ),
                                    onPressed: () {
                                      _downloadPdf(searchResultList[index].id);
                                      id = searchResultList[index].id;
                                      mPartyCode =
                                          searchResultList[index].partyCode;
                                      partyName =
                                          searchResultList[index].partyName;
                                    }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
      );
    }
  }

  _getCompanyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    WebService()
        .post(
            this.context,
            AppConfig.getCompany,
            jsonEncode(<String, dynamic>{
              'user_id': user_id,
              'tid': Permissions.SALE_QTN,
              'mode_flag': 'S,A,I'
            }))
        .then((value) => {
              Navigator.of(this.context).pop(),
              debugPrint('getCompanyList ${value!.body}'),
              _parseCompanyList(value)
            });
  }

  _parseCompanyList(Response value) {
    if (value.statusCode == 200) {
      var res = jsonDecode(value.body);
      if (res['error'] == 'false') {
        var content = res['content'] as List;
        companyList.clear();
        companyList.add(QCompanyModel(
            id: '',
            address1: '',
            address2: '',
            logoName: '',
            name: 'Select Company'));
        companyList
            .addAll(content.map((e) => QCompanyModel.fromJson(e)).toList());
        setState(() {});
      }
    }
  }

  void showAlert(BuildContext context, String msg, String title) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        ElevatedButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    );

    showGeneralDialog(
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: alert,
          ),
        );
      },

      barrierColor: Colors.white.withOpacity(0),
      context: context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      // ignore: missing_return
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          SizedBox(),
    );
  }

  void _companyBottomSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: companyList[index].logoName!.isNotEmpty
                      ? Image.network(
                          AppConfig.small_image + companyList[index].logoName!,
                          width: 32.0,
                          height: 32.0,
                        )
                      : Icon(Icons.done_sharp, color: Colors.black),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(companyList[index].name!),
                ),
                onTap: () {
                  _companyController.text = companyList[index].name!;
                  companyCode = companyList[index].id;
                  Navigator.of(context).pop();
                  partyCode = '';
                  _partyController.clear();
                  _addressController.clear();
                  rankCode = '';
                  partyList.clear();
                  mainPartyList.clear();
                  if (companyCode!.isNotEmpty) _getPartyList();
                },
              ),
              itemCount: companyList.length,
            ),
          );
        });
  }

  void _partyBottomSheet(context) {
    partyList.clear();
    partyList.addAll(mainPartyList);
    setState(() {});

    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20.0, 18, 0),
                  child: TypeAheadFormField<PartyModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select party name' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.name!),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      _partyController.text = sg.name!;
                      partyCode = sg.id;
                      Navigator.of(context).pop();
                      _getAddress();
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredList(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        controller: _partyController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //border: OutlineInputBorder(),
                            hintText: 'Party Name',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _init() {
    _entryDateController.text = '${now.month}/${now.day}/${now.year}';
    _toDateController.text = '${now.month}/${now.day}/${now.year}';
  }

  _getFilteredList(String str) {
    // return clientList.sort((str, b) => str.clientName.compareTo(b.clientName));
    return partyList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getPartyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    WebService()
        .post(
            this.context,
            AppConfig.getParty,
            jsonEncode(<String, dynamic>{
              'user_id': user_id,
              'comp_code': companyCode
            }))
        .then((value) => {
              Navigator.of(this.context).pop(),
              debugPrint('getPartyList ${value!.body}'),
              _parsePartyList(value)
            });
  }

  _parsePartyList(Response value) {
    if (value.statusCode == 200) {
      var res = jsonDecode(value.body);

      if (res['error'] == 'false') {
        var content = res['content'] as List;
        partyList.clear();
        mainPartyList.clear();
        partyList.addAll(content.map((e) => PartyModel.fromJson(e)).toList());
        mainPartyList
            .addAll(content.map((e) => PartyModel.fromJson(e)).toList());
        setState(() {});
        debugPrint('PartyListSize ${partyList.length}');
      }
    }
  } //,file_path=quotations,filename

  _getAddress() async {
    _addressController.clear();
    rankCode = '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    WebService()
        .post(
            this.context,
            AppConfig.getAddressList,
            jsonEncode(
                <String, dynamic>{'user_id': user_id, 'acc_code': partyCode}))
        .then((value) => {
              Navigator.of(this.context).pop(),
              //  debugPrint('_getAddress ${value.body}'),
              _parseAddress(value!)
            });
  }

  _parseAddress(Response res) {
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;
        addressList.clear();
        addressList
            .addAll(contentList.map((e) => AddressModel.fromJson(e)).toList());
      }
    }
  }

  Future _selectDate() async {
    try {
      final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2001, 01, 01),
          lastDate: now);

      if (selectedDate == null) return;

      debugPrint("SelectedDate $selectedDate ");

      setState(() {
        _entryDateController.text =
            "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
      });
    } on Exception catch (e) {
      print("an Error occurred $e");
    }
  }

  Future _toDate() async {
    try {
      final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2001, 01, 01),
          lastDate: now);

      if (selectedDate == null) return;

      debugPrint("SelectedDate $selectedDate ");

      setState(() {
        _toDateController.text =
            "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
      });
    } on Exception catch (e) {
      print("an Error occurred $e");
    }
  }

  void _partyAddressSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => ListTile(
                title: Row(
                  //      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}.'),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(addressList[index].add0! +
                            addressList[index].add1! +
                            addressList[index].add2! +
                            addressList[index].city!),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _addressController.text = addressList[index].add0! +
                      ' ' +
                      addressList[index].add1! +
                      ' ' +
                      addressList[index].add2! +
                      addressList[index].city!;
                  rankCode = addressList[index].id;
                  Navigator.of(context).pop();
                },
              ),
              itemCount: addressList.length,
            ),
          );
        });
  }

  bool _validated() {
    if (companyCode!.isEmpty &&
        rankCode!.trim().isEmpty &&
        _remarksController.text.trim().isEmpty &&
        _finYearController.text.trim().isEmpty &&
        _toDateController.text.trim().isEmpty &&
        _entryDateController.text.trim().isEmpty &&
        partyCode!.isEmpty &&
        _numberController.text.trim().isEmpty) {
      Commons().showAlert(
          context, 'Please enter or select at least one field', 'Error');

      return false;
    } else {
      return true;
    }
  }

  /// Search Api
  _search() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    var json = jsonEncode(<String, dynamic>{
      'user_id': userId,
      'comp_code': companyCode,
      'acc_code': partyCode,
      'qtn_no': _numberController.text.trim(),
      'from_date': _entryDateController.text.trim(),
      'to_date': _toDateController.text.trim(),
      //'qtn_date': _entryDateController.text.trim(),
      'qtn_finyear': _finYearController.text.trim(),
      'remarks': _remarksController.text.trim(),
      'add_rank': rankCode
    });

    debugPrint('SearchParam =>  $json');

    WebService().post(this.context, AppConfig.searchQuotation, json).then(
        (value) => {Navigator.of(this.context).pop(), _parseSearch(value!)});
  }

  _parseSearch(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;
        searchResultList.clear();
        searchResultList.addAll(
            contentList.map((e) => SearchResultModel.fromJSON(e)).toList());

        if (searchResultList.isNotEmpty) {
          _pageController!.nextPage(
              duration: Duration(milliseconds: 600),
              curve: Curves.fastLinearToSlowEaseIn);
        } else {
          Commons().showAlert(context, 'No quotation found', 'Result');
        }
      }
    }
  }

  /// After Search On Click Of Result  item
  _viewQuotation(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                QuotationForm(qtnId: searchResultList[index].id)));
  }

  _downloadPdf(String? docCode) async {
    List<int> bytes = [];

    var url = '${AppConfig.downloadSaleQtn}$docCode';

    var documentDirectory = await getTemporaryDirectory();
    var firstPath = documentDirectory.path + "/doc";
    var filePathAndName = documentDirectory.path + '/doc/$docCode.pdf';
    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);

    if (file2.existsSync()) {
      logIt('File does EXIST -> $file2');
      _viewPdf(file2);
    } else {
      Commons().showProgressbar(context);
      logIt('File does not exist -> $file2');

      final request = Request('GET', Uri.parse(url));
      final StreamedResponse res = await Client().send(request);

      res.stream.listen(
        (List<int> newBytes) {
          bytes.addAll(newBytes);
          //final downloadedLength = bytes.length;
          //_progress = downloadedLength / contentLength;
          setState(() {});
        },
        onDone: () async {
          await file2.writeAsBytes(bytes);
          popIt(context);

          _viewPdf(file2);
        },
        onError: (e) {
          popIt(context);
          showAlert(context, 'Error occurred while downloading', 'Error!');
          print(e);
        },
        cancelOnError: true,
      );

      setState(() {
        isDownloading = false;
      });
    }
  }

  _viewPdf(File data) async {
    FocusScope.of(context).unfocus();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ViewPdf(
              type: Qtn,
              data: data,
              id: id,
              partyCode: partyCode,
              partyName: partyName,
            )));
  }
}
