import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:intl/intl.dart';
import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:path_provider/path_provider.dart';

class AccountMasterApproval extends StatefulWidget {
  final String? id;

  const AccountMasterApproval({Key? key, this.id, code, String? codeController})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AccountMasterApproval();
}

class _AccountMasterApproval extends State<AccountMasterApproval>
    with NetworkResponse {
  final _mainKey = GlobalKey<FormState>();
  final _addressKey = GlobalKey<FormState>();
  final _bankKey = GlobalKey<FormState>();
  final _communicationKey = GlobalKey<FormState>();
  final _taxKey = GlobalKey<FormState>();
  final _accCompanyKey = GlobalKey<FormState>();
  final _saleTypeKey = GlobalKey<FormState>();
  final _purTypeKey = GlobalKey<FormState>();
  final _contactPersonKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool type = true;
  File? mFile;
  RegExp emailValidator = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  List<BankModel> bankModelList = [];
  List<CommunicationModel> communicationlist = [];
  List<CommunicationModel> communication = [];
  List<AccCompanyModel> accCompanylist = [];
  List<AddressModel> addressList = [];
  List<BankModel> banknameList = [];
  List<TaxModel> taxList = [];
  List<PersonModel> personList = [];
  List<SaleTypeModel> saleTypeList = [];
  List<SaleTypeModel> saleTypeList2 = [];
  List<PurchaseModel> purchaseList = [];
  List<PurchaseModel> purchaseList2 = [];
  List<PurchaseModel> tdslist = [];
  List<PlaceModel> _placeList = [];
  List<TitleModel> titleList = [];
  List<BsGroupModel> bsGroupList = [];
  List<AccCompanyModel> companylist = [];
  List<TaxModel> taxlist2 = [];
  String debitCredit = '';
  String active = '';
  String? bsGroupCode = '';
  String? titleCode = '';
  String spCommissionTag = 'N';
  DateTime now = new DateTime.now();
  String contactImageBaseUrl = '';
  final hspacer = SizedBox(
    width: 16,
  );
  final vspacer = SizedBox(
    height: 16,
  );

  /// For Account Master
  TextEditingController codeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bsController = TextEditingController();
  TextEditingController printController = TextEditingController();
  TextEditingController openingController = TextEditingController();
  TextEditingController drcrController = TextEditingController();
  TextEditingController creditlimitController = TextEditingController();
  TextEditingController creditdaysController = TextEditingController();
  TextEditingController accounttypeController = TextEditingController();
  TextEditingController activeController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController approvaluserController = TextEditingController();
  TextEditingController approvaldataController = TextEditingController();

  /// For Address
  TextEditingController rankController = TextEditingController();
  TextEditingController accnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  //For Bank
  /* TextEditingController rnController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController bankAccnumController = TextEditingController();
  TextEditingController bankbranchController = TextEditingController();
  TextEditingController ifscController = TextEditingController();*/
  /// For Contact Person
  TextEditingController _titleController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _phnoController = TextEditingController();
  TextEditingController _faxController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _activeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    _getPartiesDetail();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 9,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Account Master Approval"),
            actions: [
              Visibility(
                visible: true,
                child: Visibility(
                  visible: !isEdit,
                  child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _getOptionList();
                        _getPlace();
                        setState(() {
                          isEdit = true;
                        });
                      }),
                ),
              ),
            ],
            bottom: TabBar(
                isScrollable: true,
                unselectedLabelStyle:
                    TextStyle(fontSize: 18, color: Colors.white70),
                labelStyle: TextStyle(fontSize: 18, color: Colors.white),
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                labelPadding: EdgeInsets.all(8),
                tabs: [
                  Text("Account Master"),
                  Text("Address"),
                  Text("Bank"),
                  Text("Communication"),
                  Text("Tax Detail"),
                  Text("Account Company"),
                  Text("Sale Type"),
                  Text("Purchase Type"),
                  Text("Contact Person"),
                ]),
          ),
          body: TabBarView(
            children: [
              getWidgets(
                WidgetType.AccountMaster,
              ),
              getWidgets(
                WidgetType.Address,
              ),
              getWidgets(
                WidgetType.Bank,
              ),
              getWidgets(
                WidgetType.Communication,
              ),
              getWidgets(
                WidgetType.TaxDetail,
              ),
              getWidgets(
                WidgetType.AccountCompany,
              ),
              getWidgets(
                WidgetType.SaleType,
              ),
              getWidgets(
                WidgetType.PurchaseType,
              ),
              getWidgets(
                WidgetType.ContactPerson,
              ),
            ],
          ),
        ));
  }

  getWidgets(WidgetType type) {
    switch (type) {
      /// Account Master
      case WidgetType.AccountMaster:
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _mainKey,
            child: Column(
              children: [
                /// Code
                TextFormField(
                  controller: codeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: "Code",
                  ),
                ),
                vspacer,

                /// Title
                TypeAheadFormField<TitleModel>(
                  validator: (value) =>
                      value!.isEmpty ? 'Please select a Title' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  suggestionsCallback: (String pattern) {
                    return _getTitle(pattern);
                  },
                  itemBuilder: (BuildContext context, itemData) {
                    return ListTile(title: Text(itemData.title!));
                  },
                  onSuggestionSelected: (sg) {
                    setState(
                      () {
                        titleController.text = sg.title!;
                        titleCode = sg.code;
                      },
                    );
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: titleController,
                      onChanged: (v) {
                        titleController.clear();
                        titleCode = '';
                      },
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      enabled: isEdit,
                      decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Title',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          isDense: true)),
                ),
                vspacer,

                /// Name
                TextFormField(
                  readOnly: !isEdit,
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: "Name",
                  ),
                ),
                vspacer,

                /// Bs Group
                TypeAheadFormField<BsGroupModel>(
                  validator: (value) =>
                      value!.isEmpty ? 'Please select a Title' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  suggestionsCallback: (String pattern) {
                    return _getBsGroup(pattern);
                  },
                  itemBuilder: (BuildContext context, itemData) {
                    return ListTile(title: Text(itemData.name!));
                  },
                  onSuggestionSelected: (sg) {
                    setState(
                      () {
                        bsController.text = sg.name!;
                        bsGroupCode = sg.code;
                      },
                    );
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: bsController,
                      onChanged: (v) {
                        bsController.clear();
                        bsGroupCode = '';
                      },
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      enabled: isEdit,
                      decoration: InputDecoration(
                          labelText: 'Bs Group',
                          hintText: 'Bs Group',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          isDense: true)),
                ),
                vspacer,

                /// Print On Ch
                TextFormField(
                  controller: printController,
                  readOnly: !isEdit,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: "Print ON CH",
                  ),
                ),
                vspacer,

                /// opBalance And Dr/Cr
                Row(
                  children: [
                    /// Opening Balance
                    Flexible(
                        child: TextFormField(
                            controller: openingController,
                            readOnly: !isEdit,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Opening Balance",
                            ))),
                    hspacer,

                    /// Dr/Cr
                    Flexible(
                      child: Center(
                        child: !isEdit
                            ? TextFormField(
                                controller: drcrController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Dr/Cr",
                                ))
                            : Row(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Dr/Cr'),
                                        Row(
                                          children: [
                                            Text('Debit'),
                                            Radio(
                                                value: 'D',
                                                groupValue: debitCredit,
                                                onChanged: (dynamic value) {
                                                  setState(() {
                                                    debitCredit = 'D';
                                                  });
                                                }),
                                            Text('Credit'),
                                            Radio(
                                                value: 'C',
                                                groupValue: debitCredit,
                                                onChanged: (dynamic value) {
                                                  setState(() {
                                                    debitCredit = 'C';
                                                  });
                                                })
                                          ],
                                        ),
                                      ]),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                vspacer,

                /// Credit Limit And Days
                Row(
                  children: [
                    /// Credit Limit
                    Flexible(
                        child: TextFormField(
                            controller: creditlimitController,
                            readOnly: !isEdit,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Credit Limit",
                              isDense: true,
                            ))),
                    hspacer,

                    /// Credit Days
                    Flexible(
                        child: TextFormField(
                            controller: creditdaysController,
                            readOnly: !isEdit,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Credit Days",
                              isDense: true,
                            ))),
                  ],
                ),
                vspacer,

                /// Account Type And Active
                Row(
                  children: [
                    /// Account Type
                    Flexible(
                      child: TypeAheadFormField<String>(
                        validator: (value) => value!.isEmpty
                            ? 'Please select a Account Type'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        suggestionsCallback: (String type) {
                          return ['Debit', 'Credit', 'Both', 'General'];
                        },
                        itemBuilder: (BuildContext context, itemData) {
                          return ListTile(title: Text(itemData));
                        },
                        onSuggestionSelected: (sg) {
                          setState(
                            () {
                              accounttypeController.text = sg;
                            },
                          );
                        },
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: accounttypeController,
                            onChanged: (v) {
                              accounttypeController.clear();
                            },
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.start,
                            enabled: isEdit,
                            decoration: InputDecoration(
                                labelText: 'Account Type',
                                hintText: 'Account Type',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.keyboard_arrow_down),
                                isDense: true)),
                      ),
                    ),
                    hspacer,

                    /// Active
                    Flexible(
                      child: Center(
                        child: !isEdit
                            ? TextFormField(
                                controller: activeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Active",
                                ))
                            : Row(
                                children: [
                                  Column(
                                      //Actual Data
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Active'),
                                        Row(
                                          children: [
                                            Text('Yes'),
                                            Radio(
                                                value: 'Y',
                                                groupValue: active,
                                                onChanged: (dynamic value) {
                                                  setState(() {
                                                    active = 'Y';
                                                  });
                                                }),
                                            Text('No'),
                                            Radio(
                                                value: 'N',
                                                groupValue: active,
                                                onChanged: (dynamic value) {
                                                  setState(() {
                                                    active = 'N';
                                                  });
                                                })
                                          ],
                                        ),
                                      ]),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                vspacer,

                /// Remarks
                TextFormField(
                    controller: remarksController,
                    readOnly: !isEdit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Remarks",
                      isDense: true,
                    )),
                vspacer,

                /// Save
                Visibility(
                  visible: isEdit,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              if (_mainKey.currentState!.validate()) {
                                _updateMain();
                              }
                            },
                            child: Text('Save')),
                      ),
                    ],
                  ),
                ),

                /*TextFormField(
                    controller: approvaluserController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Approval User",
                      isDense: true,
                    )),
                vspacer,
                TextFormField(
                    controller: approvaldataController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Approval Data",
                      isDense: true,
                    )),*/

                /// Buttons
                Visibility(
                  visible: !isEdit,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            showAlert(
                                context,
                                'Are You sure You Want to Approve this Account?',
                                'Confirmation',
                                ok: 'Ok',
                                onOk: () {
                                  _approve();
                                },
                                notOk: 'Cancel',
                                onNo: () {
                                  popIt(context);
                                });
                          },
                          child: Text('Approve')),
                      ElevatedButton(
                          onPressed: () {
                            showAlert(
                                context,
                                'Are You sure You Want to Reject this Account?',
                                'Confirmation',
                                ok: 'Ok',
                                onOk: () {
                                  _reject();
                                },
                                notOk: 'Cancel',
                                onNo: () {
                                  popIt(context);
                                });
                          },
                          child: Text('Reject')),
                    ],
                  ),
                ),
                vspacer,
              ],
            ),
          ),
        );

      ///Address
      case WidgetType.Address:
        return Stack(
          children: [
            addressList.isEmpty
                ? Center(
                    child: Text('No Data Found',
                        style: TextStyle(
                          fontSize: 16,
                        )))
                : Form(
                    key: _addressKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          /// Save
                          Visibility(
                            visible: addressList.isNotEmpty && isEdit,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_addressKey.currentState!
                                            .validate()) {
                                          _updateAddress();
                                        }
                                      },
                                      child: Text('Save')),
                                ),
                              ],
                            ),
                          ),
                          /*ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.all(12),
                            itemCount: addressList.length,
                            itemBuilder: (context, index) => Card(
                              child: Column(children: [
                                /// Delete
                                Visibility(
                                  visible: addressList.isNotEmpty && isEdit,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                if(addressList[index].isLocal){
                                                  setState(() {
                                                    addressList.removeAt(index);
                                                  });
                                                }else{
                                                  _deleteAddress(index);
                                                }
                                                },
                                              child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      color: AppColor.appRed,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Icon(Icons.delete,
                                                      size: 14,
                                                      color: Colors.white))),
                                        )
                                      ]),
                                ),

                                /// Rank
                                TextFormField(
                                    onChanged: (v) {
                                      addressList[index].rank = v;
                                    },
                                    validator: (value) => value.isEmpty
                                        ? 'Rank is required'
                                        : null,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: TextEditingController(
                                        text: addressList[index].rank),
                                    readOnly: !isEdit,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Rank",
                                      isDense: true,
                                    )),
                                vspacer,

                                /// Account Name
                                TextFormField(
                                    onChanged: (v) {
                                      addressList[index].add0 = v;
                                    },
                                    validator: (value) => value.isEmpty
                                        ? 'Address is required'
                                        : null,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: TextEditingController(
                                        text: addressList[index].add0),
                                    readOnly: !isEdit,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Account Name",
                                      isDense: true,
                                    )),
                                vspacer,

                                /// Address1
                                TextFormField(
                                    onChanged: (v) {
                                      addressList[index].add1 = v;
                                    },
                                    validator: (value) => value.isEmpty
                                        ? 'Address is required'
                                        : null,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: TextEditingController(
                                        text: addressList[index].add1),
                                    readOnly: !isEdit,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Address",
                                      isDense: true,
                                    )),
                                vspacer,

                                /// Address2
                                TextFormField(
                                    onChanged: (v) {
                                      addressList[index].add2 = v;
                                    },
                                    validator: (value) => value.isEmpty
                                        ? 'Address is required'
                                        : null,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: TextEditingController(
                                        text: addressList[index].add2),
                                    readOnly: !isEdit,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Address",
                                      isDense: true,
                                    )),
                                vspacer,

                                /// City And State
                                Row(
                                  children: [
                                    /// City
                                    Flexible(
                                        child: TypeAheadFormField<PlaceModel>(
                                      validator: (value) => addressList[index]
                                                  .cityCode
                                                  .isEmpty &&
                                              addressList[index].city.isEmpty
                                          ? 'Please select a City'
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      suggestionsCallback: (String pattern) {
                                        return _getCity(pattern.trim());
                                      },
                                      itemBuilder: (BuildContext context, itemData) {
                                        return ListTile(
                                            title: Text(itemData.city));
                                      },
                                          hideKeyboard: false,
                                          hideOnEmpty: false,
                                          hideOnLoading: false,
                                          hideSuggestionsOnKeyboardHide: false,
                                      onSuggestionSelected: (sg) {
                                        setState(
                                          () {
                                            addressList[index].city = sg.city;
                                            addressList[index].cityCode =
                                                sg.cityCode;
                                            addressList[index].state = sg.state;
                                            addressList[index].stateCode =
                                                sg.stateCode;
                                            addressList[index].country =
                                                sg.country;
                                            addressList[index].countryCode =
                                                sg.countryCode;
                                          },
                                        );
                                      },
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                              controller: TextEditingController(
                                                  text:
                                                      addressList[index].city),
                                              onChanged: (v) {
                                                addressList[index].cityCode = '';

                                                // addressList[index].city = '';
                                                //
                                                // addressList[index].state='';
                                                // addressList[index].country='';

                                                 //setState(() {});
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              textAlign: TextAlign.start,
                                              enabled: isEdit,
                                              decoration: InputDecoration(
                                                  labelText: 'City',
                                                  hintText: 'City',
                                                  border: OutlineInputBorder(),
                                                  suffixIcon: Icon(Icons
                                                      .keyboard_arrow_down),
                                                  isDense: true)),
                                    )),
                                    hspacer,

                                    /// State
                                    Flexible(
                                      child: TextFormField(
                                          validator: (value) => value.isEmpty
                                              ? 'State is required'
                                              : null,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: TextEditingController(
                                              text: addressList[index].state),
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "State",
                                          )),
                                    ),
                                  ],
                                ),
                                vspacer,

                                /// Country And Pincode
                                Row(
                                  children: [
                                    /// Country
                                    Flexible(
                                      child: TextFormField(
                                          validator: (value) => value.isEmpty
                                              ? 'Country is required'
                                              : null,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: TextEditingController(
                                              text: addressList[index].country),
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Country",
                                          )),
                                    ),

                                    hspacer,

                                    /// Pincode
                                    Flexible(
                                      child: TextFormField(
                                          onChanged: (v) {
                                            addressList[index].pincode = v;
                                          },
                                          validator: (value) => value.isEmpty
                                              ? 'PinCode is required'
                                              : value.length < 6
                                                  ? 'Pincode Should be of 6 digits'
                                                  : null,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          controller: TextEditingController(
                                              text: addressList[index].pincode),
                                          readOnly: !isEdit,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "PinCode",
                                          )),
                                    ),
                                  ],
                                ),
                                vspacer,
                              ]),
                            ),
                          ),*/
                          Column(
                            children: List.generate(
                                addressList.length,
                                (index) => Card(
                                      child: Column(children: [
                                        /// Delete
                                        Visibility(
                                          visible:
                                              addressList.isNotEmpty && isEdit,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        if (addressList[index]
                                                            .isLocal) {
                                                          setState(() {
                                                            addressList
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        } else {
                                                          _deleteAddress(index);
                                                        }
                                                      },
                                                      child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              color: AppColor
                                                                  .appRed,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Icon(
                                                              Icons.delete,
                                                              size: 14,
                                                              color: Colors
                                                                  .white))),
                                                )
                                              ]),
                                        ),

                                        /// Rank
                                        TextFormField(
                                            onChanged: (v) {
                                              addressList[index].rank = v;
                                            },
                                            validator: (value) => value!.isEmpty
                                                ? 'Rank is required'
                                                : null,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: TextEditingController(
                                                text: addressList[index].rank),
                                            readOnly: !isEdit,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Rank",
                                              isDense: true,
                                            )),
                                        vspacer,

                                        /// Account Name
                                        TextFormField(
                                            onChanged: (v) {
                                              addressList[index].add0 = v;
                                            },
                                            // validator: (value) => value.isEmpty
                                            //     ? 'Address is required'
                                            //     : null,
                                            // autovalidateMode:
                                            // AutovalidateMode.onUserInteraction,
                                            controller: TextEditingController(
                                                text: addressList[index].add0),
                                            readOnly: !isEdit,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Account Name",
                                              isDense: true,
                                            )),
                                        vspacer,

                                        /// Address1
                                        TextFormField(
                                            onChanged: (v) {
                                              addressList[index].add1 = v;
                                            },
                                            validator: (value) => value!.isEmpty
                                                ? 'Address is required'
                                                : null,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: TextEditingController(
                                                text: addressList[index].add1),
                                            readOnly: !isEdit,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Address",
                                              isDense: true,
                                            )),
                                        vspacer,

                                        /// Address2
                                        TextFormField(
                                            onChanged: (v) {
                                              addressList[index].add2 = v;
                                            },
                                            // validator: (value) => value.isEmpty
                                            //     ? 'Address is required'
                                            //     : null,
                                            // autovalidateMode:
                                            // AutovalidateMode.onUserInteraction,
                                            controller: TextEditingController(
                                                text: addressList[index].add2),
                                            readOnly: !isEdit,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Address",
                                              isDense: true,
                                            )),
                                        vspacer,

                                        /// City And State
                                        Row(
                                          children: [
                                            /// City
                                            Flexible(
                                                child: TypeAheadFormField<
                                                    PlaceModel>(
                                              validator: (value) =>
                                                  addressList[index]
                                                              .cityCode!
                                                              .isEmpty &&
                                                          addressList[index]
                                                              .city!
                                                              .isEmpty
                                                      ? 'Please select a City'
                                                      : null,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              suggestionsCallback:
                                                  (String pattern) {
                                                return _getCity(pattern.trim());
                                              },
                                              itemBuilder:
                                                  (BuildContext context,
                                                      itemData) {
                                                return ListTile(
                                                    title:
                                                        Text(itemData.city!));
                                              },
                                              hideKeyboard: false,
                                              hideOnEmpty: false,
                                              hideOnLoading: false,
                                              hideSuggestionsOnKeyboardHide:
                                                  false,
                                              onSuggestionSelected: (sg) {
                                                setState(
                                                  () {
                                                    addressList[index].city =
                                                        sg.city;
                                                    addressList[index]
                                                        .cityCode = sg.cityCode;
                                                    addressList[index].state =
                                                        sg.state;
                                                    addressList[index]
                                                            .stateCode =
                                                        sg.stateCode;
                                                    addressList[index].country =
                                                        sg.country;
                                                    addressList[index]
                                                            .countryCode =
                                                        sg.countryCode;
                                                  },
                                                );
                                              },
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                      controller:
                                                          TextEditingController(
                                                              text: addressList[
                                                                      index]
                                                                  .city),
                                                      onChanged: (v) {
                                                        addressList[index]
                                                            .cityCode = '';

                                                        // addressList[index].city = '';
                                                        //
                                                        // addressList[index].state='';
                                                        // addressList[index].country='';

                                                        //setState(() {});
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      textAlign:
                                                          TextAlign.start,
                                                      enabled: isEdit,
                                                      decoration: InputDecoration(
                                                          labelText: 'City',
                                                          hintText: 'City',
                                                          border:
                                                              OutlineInputBorder(),
                                                          suffixIcon: Icon(Icons
                                                              .keyboard_arrow_down),
                                                          isDense: true)),
                                            )),
                                            hspacer,

                                            /// State
                                            Flexible(
                                              child: TextFormField(
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? 'State is required'
                                                      : null,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  controller:
                                                      TextEditingController(
                                                          text:
                                                              addressList[index]
                                                                  .state),
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: "State",
                                                  )),
                                            ),
                                          ],
                                        ),
                                        vspacer,

                                        /// Country And Pincode
                                        Row(
                                          children: [
                                            /// Country
                                            Flexible(
                                              child: TextFormField(
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? 'Country is required'
                                                      : null,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  controller:
                                                      TextEditingController(
                                                          text:
                                                              addressList[index]
                                                                  .country),
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: "Country",
                                                  )),
                                            ),

                                            hspacer,

                                            /// Pincode
                                            Flexible(
                                              child: TextFormField(
                                                  onChanged: (v) {
                                                    addressList[index].pincode =
                                                        v;
                                                  },
                                                  // validator: (value) => value.isEmpty
                                                  //     ? 'PinCode is required'
                                                  //     : value.length < 6
                                                  //     ? 'Pincode Should be of 6 digits'
                                                  //     : null,
                                                  // autovalidateMode: AutovalidateMode
                                                  //     .onUserInteraction,
                                                  keyboardType: TextInputType
                                                      .number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        6),
                                                  ],
                                                  controller:
                                                      TextEditingController(
                                                          text:
                                                              addressList[index]
                                                                  .pincode),
                                                  readOnly: !isEdit,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: "PinCode",
                                                  )),
                                            ),
                                          ],
                                        ),
                                        vspacer,
                                      ]),
                                    )),
                          ),
                        ],
                      ),
                    ),
                  ),

            /// Add
            Visibility(
              visible: isEdit,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      addressList.add(AddressModel());
                      setState(() {});
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

      /// Bank
      case WidgetType.Bank:
        return Stack(
          children: [
            bankModelList.isEmpty
                ? Center(
                    child: Text('No Data Found',
                        style: TextStyle(
                          fontSize: 16,
                        )))
                : Form(
                    key: _bankKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// Save
                          Visibility(
                            visible: bankModelList.isNotEmpty && isEdit,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_bankKey.currentState!.validate()) {
                                          _updateBank();
                                        }
                                      },
                                      child: Text('Save')),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(8),
                            itemCount: bankModelList.length,
                            itemBuilder: (context, index) => Card(
                                child: Column(children: [
                              /// Delete
                              Visibility(
                                visible: bankModelList.isNotEmpty && isEdit,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            if (bankModelList[index].isLocal) {
                                              setState(() {
                                                bankModelList.removeAt(index);
                                              });
                                            } else {
                                              _deleteBank(index);
                                            }
                                          },
                                          child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: AppColor.appRed,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Icon(Icons.delete,
                                                  size: 14,
                                                  color: Colors.white))),
                                    ),
                                  ],
                                ),
                              ),

                              /// Rank
                              TextFormField(
                                  onChanged: (v) {
                                    bankModelList[index].rank = v;
                                  },
                                  validator: (value) => value!.isEmpty
                                      ? 'Rank is required'
                                      : null,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  readOnly: !isEdit,
                                  controller: TextEditingController(
                                      text: bankModelList[index].rank),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Rank",
                                    isDense: true,
                                  )),
                              vspacer,

                              /// Bank
                              TypeAheadFormField<BankModel>(
                                validator: (value) => value!.isEmpty
                                    ? 'Please select a Bank'
                                    : null,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                suggestionsCallback: (String pattern) {
                                  return _getBank(pattern);
                                },
                                itemBuilder: (BuildContext context, itemData) {
                                  return ListTile(title: Text(itemData.bank));
                                },
                                onSuggestionSelected: (sg) {
                                  setState(
                                    () {
                                      bankModelList[index].bank = sg.bank;
                                      bankModelList[index].bankCode =
                                          sg.bankCode;
                                    },
                                  );
                                },
                                textFieldConfiguration: TextFieldConfiguration(
                                    controller: TextEditingController(
                                        text: bankModelList[index].bank),
                                    onChanged: (v) {
                                      bankModelList[index].bank = '';
                                      bankModelList[index].bankCode = '';
                                      // bankModelList[index].accno = '';
                                      // bankModelList[index].branch = '';
                                      // bankModelList[index].ifsc = '';
                                    },
                                    textInputAction: TextInputAction.next,
                                    textAlign: TextAlign.start,
                                    enabled: isEdit,
                                    decoration: InputDecoration(
                                        labelText: 'Bank',
                                        hintText: 'Bank',
                                        border: OutlineInputBorder(),
                                        suffixIcon:
                                            Icon(Icons.keyboard_arrow_down),
                                        isDense: true)),
                              ),
                              vspacer,

                              /// Account No.
                              TextFormField(
                                  onChanged: (v) {
                                    setState(() {
                                      bankModelList[index].accno = v;
                                    });
                                  },
                                  // validator: (value) => value.isEmpty
                                  //     ? 'Enter Bank Account No.'
                                  //     : null,
                                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  // controller: TextEditingController(text: bankModelList[index].accno),
                                  readOnly: !isEdit,
                                  initialValue: bankModelList[index].accno,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Bank Acc. Number",
                                    isDense: true,
                                  )),
                              vspacer,

                              /// Branch
                              TextFormField(
                                  onChanged: (v) {
                                    bankModelList[index].branch = v;
                                  },
                                  // validator: (value) => value.isEmpty
                                  //     ? 'Enter Bank Branch'
                                  //     : null,
                                  // autovalidateMode:
                                  //     AutovalidateMode.onUserInteraction,
                                  //keyboardType:TextInputType.name,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-z A-Z]')),
                                  ],
                                  controller: TextEditingController(
                                      text: bankModelList[index].branch),
                                  readOnly: !isEdit,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Bank Branch",
                                    isDense: true,
                                  )),
                              vspacer,

                              /// IFSC
                              TextFormField(
                                  onChanged: (v) {
                                    bankModelList[index].ifsc = v;
                                  },
                                  // validator: (value) => value.isEmpty
                                  //     ? 'Enter Bank Ifsc Code'
                                  //     : value.length < 11
                                  //         ? 'Pincode Should be of 11 digits'
                                  //         : null,
                                  // autovalidateMode:
                                  //     AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.text,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[a-zA-Z0-9]')),
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  controller: TextEditingController(
                                      text: bankModelList[index].ifsc),
                                  readOnly: !isEdit,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "IFSC Code",
                                    hintText: 'eg: SBIN0125620',
                                    isDense: true,
                                  )),
                              vspacer,
                            ])),
                          ),
                        ],
                      ),
                    ),
                  ),

            /// Add
            Visibility(
              visible: isEdit,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      bankModelList.add(BankModel());
                      setState(() {});
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

      ///Communication
      case WidgetType.Communication:
        return Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _communicationKey,
              child: Column(
                children: [
                  if (communicationlist.isEmpty)
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No Data Found',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// Save
                            Visibility(
                              visible: communicationlist.isNotEmpty && isEdit,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          for (int i = 0;
                                              i < communicationlist.length;
                                              i++) {
                                            if (communicationlist[i]
                                                    .type
                                                    .isEmpty ||
                                                communicationlist[i]
                                                    .description
                                                    .isEmpty) {
                                              showAlert(
                                                  context,
                                                  'All fields are required',
                                                  'Error');
                                              return;
                                            }
                                          }
                                          _updateCommunication();
                                        },
                                        child: Text('Save'),
                                      )),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: communicationlist.length,
                              itemBuilder: (context, index) => Card(
                                elevation: 5,
                                child: Column(
                                  children: [
                                    /// Delete
                                    Visibility(
                                      visible: communicationlist.isNotEmpty &&
                                          isEdit,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  if (communicationlist[index]
                                                      .isLocal) {
                                                    setState(() {
                                                      communicationlist
                                                          .removeAt(index);
                                                    });
                                                  } else {
                                                    _deleteCommunication(index);
                                                  }
                                                },
                                                child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                        color: AppColor.appRed,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Icon(Icons.delete,
                                                        size: 14,
                                                        color: Colors.white))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Table(children: [
                                      /// Type
                                      TableRow(children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Communication Type',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Center(
                                          child: !isEdit
                                              ? Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    communicationlist[index]
                                                        .type,
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              : Container(
                                                  width: double.infinity,
                                                  height: 36,
                                                  color: Colors.transparent,
                                                  child: PopupMenuButton(
                                                      // offset: Offset(0, 0),
                                                      child: Column(
                                                        children: [
                                                          Center(
                                                            child:
                                                                communicationlist[
                                                                            index]
                                                                        .type
                                                                        .isEmpty
                                                                    ? Text(
                                                                        'Please Select a type',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )
                                                                    : Text(
                                                                        communicationlist[index]
                                                                            .type,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                          ),
                                                        ],
                                                      ),
                                                      itemBuilder: (context) =>
                                                          List.generate(
                                                            communication
                                                                .length,
                                                            (subIndex) =>
                                                                PopupMenuItem(
                                                              onTap: () {
                                                                setState(() {
                                                                  communicationlist[
                                                                          index]
                                                                      .type = communication[
                                                                          subIndex]
                                                                      .type;
                                                                  communicationlist[
                                                                          index]
                                                                      .commTypeCode = communication[
                                                                          subIndex]
                                                                      .commTypeCode;
                                                                });
                                                              },
                                                              child: Text(
                                                                communication[
                                                                        subIndex]
                                                                    .type,
                                                              ),
                                                            ),
                                                          )),
                                                ),
                                        ),
                                      ]),

                                      /// Description
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'Communication Description',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          Center(
                                            child: !isEdit
                                                ? Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      communicationlist[index]
                                                          .description,
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                : TextFormField(
                                                    onChanged: (v) {
                                                      communicationlist[index]
                                                              .description =
                                                          v.trim();
                                                    },
                                                    validator: (value) => value!
                                                            .isEmpty
                                                        ? 'Description is required'
                                                        : null,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    initialValue:
                                                        communicationlist[index]
                                                            .description,
                                                    textAlign: TextAlign.center,
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true)),
                                          ),
                                        ],
                                      ),

                                      /// Print Tag
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'Print Tag',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          Center(
                                            child: !isEdit
                                                ? Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      communicationlist[index]
                                                          .tag,
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                : Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7),
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                      Radio(
                                                          value: 'Yes',
                                                          groupValue:
                                                              communicationlist[
                                                                      index]
                                                                  .tag,
                                                          onChanged:
                                                              (dynamic value) {
                                                            setState(() {
                                                              communicationlist[
                                                                      index]
                                                                  .tag = 'Yes';
                                                            });
                                                          }),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7),
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                      Radio(
                                                          value: 'No',
                                                          groupValue:
                                                              communicationlist[
                                                                      index]
                                                                  .tag,
                                                          onChanged:
                                                              (dynamic value) {
                                                            setState(() {
                                                              communicationlist[
                                                                      index]
                                                                  .tag = 'No';
                                                            });
                                                          })
                                                    ],
                                                  ),
                                          )
                                        ],
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  /// Add
                  Visibility(
                    visible: isEdit,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            communicationlist.add(CommunicationModel());
                            setState(() {});
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));

      ///Tax Detail
      case WidgetType.TaxDetail:
        return Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _taxKey,
              child: Column(
                children: [
                  taxList.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No Data Found',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                /// Save
                                Visibility(
                                  visible: taxList.isNotEmpty && isEdit,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              for (int i = 0;
                                                  i < taxList.length;
                                                  i++) {
                                                logIt('${taxList[i].number}');
                                                if (taxList[i].type.isEmpty ||
                                                    taxList[i].number.isEmpty) {
                                                  showAlert(
                                                      context,
                                                      'All fields are required',
                                                      'Error');
                                                  return;
                                                }
                                              }
                                              _updateTax();
                                            },
                                            child: Text('Save')),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: taxList.length,
                                  itemBuilder: (context, index) => Card(
                                    elevation: 4,
                                    child: Column(
                                      children: [
                                        /// Delete
                                        Visibility(
                                          visible: taxList.isNotEmpty && isEdit,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      _deleteTax(index);
                                                    },
                                                    child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                AppColor.appRed,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Icon(
                                                            Icons.delete,
                                                            size: 14,
                                                            color:
                                                                Colors.white))),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Table(children: [
                                          /// Type
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Tax Registration Type',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              Center(
                                                child: !isEdit
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          taxList[index].type,
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: double.infinity,
                                                        height: 36,
                                                        color:
                                                            Colors.transparent,
                                                        child: PopupMenuButton(
                                                            // offset: Offset(0, 0),
                                                            child: Center(
                                                                child: taxList[
                                                                            index]
                                                                        .type
                                                                        .isEmpty
                                                                    ? Text(
                                                                        'Please Select a type',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )
                                                                    : Text(
                                                                        taxList[index]
                                                                            .type,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      )),
                                                            itemBuilder:
                                                                (context) =>
                                                                    List.generate(
                                                                      taxlist2
                                                                          .length,
                                                                      (subIndex) => PopupMenuItem(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              taxList[index].type = taxlist2[subIndex].type;
                                                                              taxList[index].code = taxlist2[subIndex].code;
                                                                            });
                                                                          },
                                                                          child: Text(
                                                                            taxlist2[subIndex].type,
                                                                          )),
                                                                    )),
                                                      ),
                                              ),
                                            ],
                                          ),

                                          /// Number
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Tax Registration Number',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              Center(
                                                child: !isEdit
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          taxList[index].number,
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : TextFormField(
                                                        validator: (value) => value!
                                                                .isEmpty
                                                            ? 'Number is required'
                                                            : null,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        onChanged: (v) {
                                                          taxList[index]
                                                                  .number =
                                                              v.trim();
                                                        },
                                                        initialValue:
                                                            taxList[index]
                                                                .number,
                                                        textAlign:
                                                            TextAlign.center,
                                                        decoration:
                                                            InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                isDense: true)),
                                              ),
                                            ],
                                          ),

                                          /// Print Tag
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Print Tag',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              Center(
                                                child: !isEdit
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          taxList[index].tag,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(7),
                                                            child: Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                          Radio(
                                                              value: 'Yes',
                                                              groupValue:
                                                                  taxList[index]
                                                                      .tag,
                                                              onChanged:
                                                                  (dynamic
                                                                      value) {
                                                                setState(() {
                                                                  taxList[index]
                                                                          .tag =
                                                                      'Yes';
                                                                });
                                                              }),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(7),
                                                            child: Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                          Radio(
                                                              value: 'No',
                                                              groupValue:
                                                                  taxList[index]
                                                                      .tag,
                                                              onChanged:
                                                                  (dynamic
                                                                      value) {
                                                                setState(() {
                                                                  taxList[index]
                                                                          .tag =
                                                                      'No';
                                                                });
                                                              })
                                                        ],
                                                      ),
                                              )
                                            ],
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                  /// Add
                  Visibility(
                    visible: isEdit,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            taxList.add(TaxModel());
                            setState(() {});
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));

      ///Account Company
      case WidgetType.AccountCompany:
        return Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _accCompanyKey,
              child: Column(
                children: [
                  accCompanylist.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No Data Found',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                /// Save
                                Visibility(
                                  visible: accCompanylist.isNotEmpty && isEdit,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              for (int i = 0;
                                                  i < accCompanylist.length;
                                                  i++) {
                                                if (accCompanylist[i]
                                                    .company
                                                    .isEmpty) {
                                                  showAlert(
                                                      context,
                                                      'Please Select A Company',
                                                      'Error');
                                                  return;
                                                }
                                              }
                                              _updateAccCompany();
                                            },
                                            child: Text('Save')),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: accCompanylist.length,
                                  itemBuilder: (context, index) => Card(
                                    elevation: 4,
                                    child: Column(
                                      children: [
                                        /// Delete
                                        Visibility(
                                          visible: accCompanylist.isNotEmpty &&
                                              isEdit,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      _deleteAccCompany(index);
                                                    },
                                                    child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                AppColor.appRed,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Icon(
                                                            Icons.delete,
                                                            size: 14,
                                                            color:
                                                                Colors.white))),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Table(children: [
                                          /// Code
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Code',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  accCompanylist[index]
                                                      .compCode,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),

                                          /// Company
                                          TableRow(children: [
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                'Company',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                            Center(
                                              child: !isEdit
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text(
                                                        accCompanylist[index]
                                                            .company,
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  : Container(
                                                      width: double.infinity,
                                                      height: 36,
                                                      color: Colors.transparent,
                                                      child: PopupMenuButton(
                                                          // offset: Offset(10, 10),
                                                          child: Center(
                                                              child: accCompanylist[
                                                                          index]
                                                                      .company
                                                                      .isEmpty
                                                                  ? Text(
                                                                      'Please Select a Company',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    )
                                                                  : Text(
                                                                      accCompanylist[
                                                                              index]
                                                                          .company,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )),
                                                          itemBuilder:
                                                              (context) =>
                                                                  List.generate(
                                                                    companylist
                                                                        .length,
                                                                    (subIndex) =>
                                                                        PopupMenuItem(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                accCompanylist[index].company = companylist[subIndex].company;
                                                                                accCompanylist[index].compCode = companylist[subIndex].compCode;
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              companylist[subIndex].company,
                                                                            )),
                                                                  )),
                                                    ),
                                            ),
                                          ]),

                                          /// Remarks
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Remarks',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              Center(
                                                child: !isEdit
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          accCompanylist[index]
                                                              .remarks,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : TextFormField(
                                                        // validator: (value) => value
                                                        //         .isEmpty
                                                        //     ? 'Remarks IS required'
                                                        //     : null,
                                                        // autovalidateMode:
                                                        //     AutovalidateMode
                                                        //         .onUserInteraction,
                                                        readOnly: !isEdit,
                                                        onChanged: (v) {
                                                          accCompanylist[index]
                                                              .remarks = v;
                                                        },
                                                        initialValue:
                                                            accCompanylist[
                                                                    index]
                                                                .remarks,
                                                        decoration:
                                                            InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                isDense: true)),
                                              )
                                            ],
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                  /// Add
                  Visibility(
                    visible: isEdit,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            accCompanylist.add(AccCompanyModel());
                            setState(() {});
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));

      ///Sale Type
      case WidgetType.SaleType:
        return Stack(
          children: [
            saleTypeList.isEmpty
                ? Center(
                    child:
                        Text('No Data Found', style: TextStyle(fontSize: 16)))
                : Form(
                    key: _saleTypeKey,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(children: [
                                  _buildHorizontalcells(),
                                  Column(
                                    children: List.generate(
                                      saleTypeList.length,
                                      (index) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          /// Code
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, top: 2),
                                            child: Container(
                                              height: 60,
                                              width: 150,
                                              padding: EdgeInsets.all(8),
                                              color: Colors.red[100],
                                              child: Center(
                                                child: Text(
                                                  saleTypeList[index].code,
                                                ),
                                              ),
                                            ),
                                          ),

                                          /// Description
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, top: 2),
                                            child: Container(
                                              height: 60,
                                              width: 210,
                                              padding: EdgeInsets.all(8),
                                              color: Colors.red[100],
                                              child: Center(
                                                child: !isEdit
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          saleTypeList[index]
                                                              .description,
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: double.infinity,
                                                        height: 36,
                                                        color:
                                                            Colors.transparent,
                                                        child: PopupMenuButton(
                                                            //offset: Offset(0, 0),
                                                            child: Center(
                                                                child: saleTypeList[
                                                                            index]
                                                                        .description
                                                                        .isEmpty
                                                                    ? Text(
                                                                        'Please Select a description',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )
                                                                    : Text(
                                                                        saleTypeList[index]
                                                                            .description,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      )),
                                                            itemBuilder:
                                                                (context) =>
                                                                    List.generate(
                                                                      saleTypeList2
                                                                          .length,
                                                                      (subIndex) => PopupMenuItem(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              saleTypeList[index].description = saleTypeList2[subIndex].description;
                                                                              saleTypeList[index].code = saleTypeList2[subIndex].code;
                                                                            });
                                                                          },
                                                                          child: Text(
                                                                            saleTypeList2[subIndex].description,
                                                                          )),
                                                                    )),
                                                      ),
                                              ),
                                            ),
                                          ),

                                          /// Company
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, top: 2),
                                            child: Container(
                                              height: 60,
                                              width: 210,
                                              padding: EdgeInsets.all(8),
                                              color: Colors.red[100],
                                              child: Center(
                                                child: !isEdit
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          saleTypeList[index]
                                                              .company,
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: double.infinity,
                                                        height: 36,
                                                        color:
                                                            Colors.transparent,
                                                        child: PopupMenuButton(
                                                            // offset: Offset(10, 10),
                                                            child: Center(
                                                                child: saleTypeList[
                                                                            index]
                                                                        .company
                                                                        .isEmpty
                                                                    ? Text(
                                                                        'Please Select a company',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )
                                                                    : Text(
                                                                        saleTypeList[index]
                                                                            .company,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      )),
                                                            itemBuilder:
                                                                (context) =>
                                                                    List.generate(
                                                                      companylist
                                                                          .length,
                                                                      (subIndex) => PopupMenuItem(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              saleTypeList[index].company = companylist[subIndex].company;
                                                                              saleTypeList[index].compCode = companylist[subIndex].compCode;
                                                                            });
                                                                          },
                                                                          child: Text(
                                                                            companylist[subIndex].company,
                                                                          )),
                                                                    )),
                                                      ),
                                              ),
                                            ),
                                          ),

                                          /// From Date
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, top: 2),
                                            child: Container(
                                              height: 60,
                                              width: 170,
                                              color: Colors.red[100],
                                              //  padding: EdgeInsets.all(8),
                                              child: Center(
                                                child: !isEdit
                                                    ? Text(saleTypeList[index]
                                                        .fromdate)
                                                    : TextFormField(
                                                        validator: (value) =>
                                                            value!.isEmpty
                                                                ? 'Please Enter From Date'
                                                                : null,
                                                        readOnly: true,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .always,
                                                        onTap: () {
                                                          _saleFromDate(
                                                              BuildContext,
                                                              index);
                                                        },
                                                        controller:
                                                            TextEditingController(
                                                          text: saleTypeList[
                                                                  index]
                                                              .fromdate,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none),
                                                          suffixIcon: Icon(
                                                              Icons.date_range),
                                                          isDense: true,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),

                                          /// To Date
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, top: 2),
                                            child: Container(
                                              height: 60,
                                              width: 170,
                                              color: Colors.red[100],
                                              //  padding: EdgeInsets.all(8),
                                              child: Center(
                                                child: !isEdit
                                                    ? Text(saleTypeList[index]
                                                        .todate)
                                                    : TextFormField(
                                                        readOnly: true,
                                                        validator: (value) =>
                                                            value!.isEmpty
                                                                ? 'Please Enter To Date'
                                                                : null,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .always,
                                                        onTap: () {
                                                          _saleToDate(
                                                              BuildContext,
                                                              index);
                                                        },
                                                        controller:
                                                            TextEditingController(
                                                                text: saleTypeList[
                                                                        index]
                                                                    .todate),
                                                        textAlign:
                                                            TextAlign.center,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none),
                                                          suffixIcon: Icon(
                                                              Icons.date_range),
                                                          isDense: true,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),

                                          /// Delete
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, top: 2),
                                            child: Container(
                                              height: 60,
                                              width: 70,
                                              color: Colors.red[100],
                                              child: Visibility(
                                                  visible:
                                                      saleTypeList.isNotEmpty &&
                                                          isEdit,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        _deleteSaleType(index);
                                                      },
                                                      child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .red[100],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Icon(
                                                              Icons.delete,
                                                              size: 24,
                                                              color: Colors
                                                                  .red[500])))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ])),

                            /// Save
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: saleTypeList.isNotEmpty && isEdit,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            for (int i = 0;
                                                i < saleTypeList.length;
                                                i++) {
                                              if (saleTypeList[i]
                                                      .description
                                                      .isEmpty ||
                                                  saleTypeList[i]
                                                      .company
                                                      .isEmpty ||
                                                  saleTypeList[i]
                                                      .fromdate
                                                      .isEmpty ||
                                                  saleTypeList[i]
                                                      .todate
                                                      .isEmpty) {
                                                showAlert(
                                                    context,
                                                    'All Fields are required ',
                                                    'Error');
                                                return;
                                              }
                                            }
                                            _updateSaleType();
                                          },
                                          child: Text('Save')),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),

            /// Add
            Visibility(
              visible: isEdit,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      saleTypeList.add(SaleTypeModel());
                      setState(() {});
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

      ///Purchase Type
      case WidgetType.PurchaseType:
        return Stack(
          children: [
            purchaseList.isEmpty
                ? Center(
                    child:
                        Text('No Data Found', style: TextStyle(fontSize: 16)))
                : Form(
                    key: _purTypeKey,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  _buildcell(),
                                  Column(
                                      children: List.generate(
                                    purchaseList.length,
                                    (index) => Row(
                                      children: [
                                        /// Description
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 4, top: 2),
                                          child: Container(
                                            height: 60,
                                            width: 210,
                                            padding: EdgeInsets.all(8),
                                            color: Colors.red[100],
                                            child: Center(
                                              child: !isEdit
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text(
                                                        purchaseList[index]
                                                            .description,
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  : Container(
                                                      width: double.infinity,
                                                      height: 36,
                                                      color: Colors.transparent,
                                                      child: PopupMenuButton(
                                                          // offset: Offset(0, 0),
                                                          child: Center(
                                                              child: purchaseList[
                                                                          index]
                                                                      .description
                                                                      .isEmpty
                                                                  ? Text(
                                                                      'Please Select a description',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    )
                                                                  : Text(
                                                                      purchaseList[
                                                                              index]
                                                                          .description,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )),
                                                          itemBuilder:
                                                              (context) =>
                                                                  List.generate(
                                                                    purchaseList2
                                                                        .length,
                                                                    (subIndex) =>
                                                                        PopupMenuItem(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                purchaseList[index].description = purchaseList2[subIndex].description;
                                                                                purchaseList[index].code = purchaseList2[subIndex].code;
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              purchaseList2[subIndex].description,
                                                                            )),
                                                                  )),
                                                    ),
                                            ),
                                          ),
                                        ),

                                        /// Company
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 4, top: 2),
                                          child: Container(
                                            height: 60,
                                            width: 210,
                                            padding: EdgeInsets.all(8),
                                            color: Colors.red[100],
                                            child: Center(
                                              child: !isEdit
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text(
                                                        purchaseList[index]
                                                            .company,
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  : Container(
                                                      width: double.infinity,
                                                      height: 36,
                                                      color: Colors.transparent,
                                                      child: PopupMenuButton(
                                                          // offset: Offset(0, 0),
                                                          child: Center(
                                                              child: purchaseList[
                                                                          index]
                                                                      .company
                                                                      .isEmpty
                                                                  ? Text(
                                                                      'Please Select a company',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    )
                                                                  : Text(
                                                                      purchaseList[
                                                                              index]
                                                                          .company,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )),
                                                          itemBuilder:
                                                              (context) =>
                                                                  List.generate(
                                                                    companylist
                                                                        .length,
                                                                    (subIndex) =>
                                                                        PopupMenuItem(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                purchaseList[index].company = companylist[subIndex].company;
                                                                                purchaseList[index].compCode = companylist[subIndex].compCode;
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              companylist[subIndex].company,
                                                                            )),
                                                                  )),
                                                    ),
                                            ),
                                          ),
                                        ),

                                        /// Tds
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 4, top: 2),
                                          child: Container(
                                            height: 60,
                                            width: 100,
                                            padding: EdgeInsets.all(8),
                                            color: Colors.red[100],
                                            child: Center(
                                              child: !isEdit
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text(
                                                        purchaseList[index]
                                                            .tdstype,
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  : Container(
                                                      width: double.infinity,
                                                      height: 36,
                                                      color: Colors.transparent,
                                                      child: PopupMenuButton(
                                                          // offset: Offset(0, 0),
                                                          child: Center(
                                                              child: purchaseList[
                                                                          index]
                                                                      .tdstype
                                                                      .isEmpty
                                                                  ? Text(
                                                                      'Please Select a Tds',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    )
                                                                  : Text(
                                                                      purchaseList[index]
                                                                              .tdstype +
                                                                          '%',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )),
                                                          itemBuilder:
                                                              (context) =>
                                                                  List.generate(
                                                                    tdslist
                                                                        .length,
                                                                    (sub1Index) =>
                                                                        PopupMenuItem(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                purchaseList[index].tdsname = tdslist[sub1Index].tdsname;
                                                                                purchaseList[index].tdscode = tdslist[sub1Index].tdscode;
                                                                                purchaseList[index].tdstype = tdslist[sub1Index].tdstype;
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              tdslist[sub1Index].tdsname + '  ' + tdslist[sub1Index].tdstype + '%',
                                                                            )),
                                                                  )),
                                                    ),
                                            ),
                                          ),
                                        ),

                                        /// From Date
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 4, top: 2),
                                          child: Container(
                                            height: 60,
                                            width: 170,
                                            color: Colors.red[100],
                                            //padding: EdgeInsets.all(8),
                                            child: Center(
                                              child: !isEdit
                                                  ? Text(purchaseList[index]
                                                      .fromdate)
                                                  : TextFormField(
                                                      validator: (value) => value!
                                                              .isEmpty
                                                          ? 'Please Enter From Date'
                                                          : null,
                                                      readOnly: true,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .always,
                                                      onTap: () {
                                                        _purchaseFromDate(
                                                            BuildContext,
                                                            index);
                                                      },
                                                      controller:
                                                          TextEditingController(
                                                              text: purchaseList[
                                                                      index]
                                                                  .fromdate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        suffixIcon: Icon(
                                                            Icons.date_range),
                                                        isDense: true,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),

                                        /// To Date
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 4, top: 2),
                                          child: Container(
                                            height: 60,
                                            width: 170,
                                            color: Colors.red[100],
                                            //  padding: EdgeInsets.all(8),
                                            child: Center(
                                              child: !isEdit
                                                  ? Text(purchaseList[index]
                                                      .todate)
                                                  : TextFormField(
                                                      validator: (value) => value!
                                                              .isEmpty
                                                          ? 'Please Enter To Date'
                                                          : null,
                                                      readOnly: true,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .always,
                                                      onTap: () {
                                                        _purchaseToDate(
                                                            BuildContext,
                                                            index);
                                                      },
                                                      controller:
                                                          TextEditingController(
                                                              text:
                                                                  purchaseList[
                                                                          index]
                                                                      .todate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        suffixIcon: Icon(
                                                            Icons.date_range),
                                                        isDense: true,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),

                                        /// Delete
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, top: 2),
                                          child: Container(
                                            height: 60,
                                            width: 70,
                                            color: Colors.red[100],
                                            child: Visibility(
                                                visible:
                                                    purchaseList.isNotEmpty &&
                                                        isEdit,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      _deletePurType(index);
                                                    },
                                                    child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.red[100],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Icon(
                                                            Icons.delete,
                                                            size: 24,
                                                            color: Colors
                                                                .red[500])))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),

                            /// Save
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: purchaseList.isNotEmpty && isEdit,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            for (int i = 0;
                                                i < purchaseList.length;
                                                i++) {
                                              if (purchaseList[i]
                                                      .description
                                                      .isEmpty ||
                                                  purchaseList[i]
                                                      .company
                                                      .isEmpty ||
                                                  purchaseList[i]
                                                      .tdstype
                                                      .isEmpty ||
                                                  purchaseList[i]
                                                      .fromdate
                                                      .isEmpty ||
                                                  purchaseList[i]
                                                      .todate
                                                      .isEmpty) {
                                                showAlert(
                                                    context,
                                                    'All Fields are required ',
                                                    'Error');
                                                return;
                                              }
                                            }
                                            _updatePurType();
                                          },
                                          child: Text('Save')),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),

            /// Add
            Visibility(
              visible: isEdit,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      purchaseList.add(PurchaseModel());
                      setState(() {});
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

      ///Contact Person
      case WidgetType.ContactPerson:
        return Stack(
          children: [
            personList.isEmpty
                ? Center(
                    child: Text('No Data Found',
                        style: TextStyle(
                          fontSize: 16,
                        )))
                : Form(
                    key: _contactPersonKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          /// Save
                          Visibility(
                            visible: personList.isNotEmpty && isEdit,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_contactPersonKey.currentState!
                                            .validate()) {
                                          _updateContactPerson();
                                        }
                                      },
                                      child: Text('Save')),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: List.generate(
                                personList.length,
                                (index) => Card(
                                      child: Column(
                                        children: [
                                          /// Delete
                                          Visibility(
                                            visible:
                                                personList.isNotEmpty && isEdit,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        _deleteContactPerson(
                                                            index);
                                                      },
                                                      child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              color: AppColor
                                                                  .appRed,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Icon(
                                                              Icons.delete,
                                                              size: 14,
                                                              color: Colors
                                                                  .white))),
                                                ),
                                              ],
                                            ),
                                          ),

                                          /// Image
                                          GestureDetector(
                                            onTap: isEdit
                                                ? () {
                                                    _filePickerBottomSheet(
                                                        context, index);
                                                  }
                                                : null,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(64),
                                                child: _getContactImage(
                                                    personList[index])),
                                          ),
                                          vspacer,
                                          // SizedBox(height: 16),
                                          /// Title
                                          TypeAheadFormField<TitleModel>(
                                            validator: (value) => value!.isEmpty
                                                ? 'Please select a Title'
                                                : null,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            suggestionsCallback:
                                                (String pattern) {
                                              return _getTitle(pattern);
                                            },
                                            itemBuilder: (BuildContext context,
                                                itemData) {
                                              return ListTile(
                                                  title: Text(itemData.title!));
                                            },
                                            onSuggestionSelected: (sg) {
                                              setState(
                                                () {
                                                  personList[index].title =
                                                      sg.title;
                                                  personList[index].titleCode =
                                                      sg.code;
                                                },
                                              );
                                            },
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                                    controller:
                                                        TextEditingController(
                                                            text: personList[
                                                                    index]
                                                                .title),
                                                    onChanged: (v) {
                                                      personList[index].title =
                                                          '';
                                                    },
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    textAlign: TextAlign.start,
                                                    enabled: isEdit,
                                                    decoration: InputDecoration(
                                                        labelText: 'Title',
                                                        hintText: 'Title',
                                                        border:
                                                            OutlineInputBorder(),
                                                        suffixIcon: Icon(Icons
                                                            .keyboard_arrow_down),
                                                        isDense: true)),
                                          ),
                                          vspacer,

                                          /// Name
                                          TextFormField(
                                              onChanged: (v) {
                                                personList[index].name = v;
                                              },
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? 'Please Enter Name'
                                                      : null,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: TextEditingController(
                                                  text: personList[index].name),
                                              readOnly: !isEdit,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Name",
                                                isDense: true,
                                              )),
                                          vspacer,

                                          /// Address1
                                          TextFormField(
                                              onChanged: (v) {
                                                personList[index].add1 = v;
                                              },
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? 'Address is required'
                                                      : null,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: TextEditingController(
                                                  text: personList[index].add1),
                                              readOnly: !isEdit,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Address",
                                                isDense: true,
                                              )),
                                          vspacer,

                                          /// Address2
                                          TextFormField(
                                              onChanged: (v) {
                                                personList[index].add2 = v;
                                              },
                                              // validator: (value) => value.isEmpty
                                              //     ? 'Address is required'
                                              //     : null,
                                              // autovalidateMode:
                                              // AutovalidateMode.onUserInteraction,
                                              controller: TextEditingController(
                                                  text: personList[index].add2),
                                              readOnly: !isEdit,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Address",
                                                isDense: true,
                                              )),
                                          vspacer,

                                          /// City And State
                                          Row(
                                            children: [
                                              /// City
                                              Flexible(
                                                  child: TypeAheadFormField<
                                                      PlaceModel>(
                                                validator: (value) =>
                                                    value!.isEmpty
                                                        ? 'Please select a City'
                                                        : null,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                suggestionsCallback:
                                                    (String pattern) {
                                                  return _city(pattern);
                                                },
                                                itemBuilder:
                                                    (BuildContext context,
                                                        itemData) {
                                                  return ListTile(
                                                      title:
                                                          Text(itemData.city!));
                                                },
                                                onSuggestionSelected: (sg) {
                                                  setState(
                                                    () {
                                                      personList[index].city =
                                                          sg.city;
                                                      personList[index].state =
                                                          sg.state;
                                                      personList[index]
                                                          .country = sg.country;
                                                      personList[index]
                                                              .cityCode =
                                                          sg.cityCode;
                                                      personList[index]
                                                              .stateCode =
                                                          sg.stateCode;
                                                      personList[index]
                                                              .countryCode =
                                                          sg.countryCode;
                                                    },
                                                  );
                                                },
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                        controller:
                                                            TextEditingController(
                                                                text: personList[
                                                                        index]
                                                                    .city),
                                                        onChanged: (v) {
                                                          personList[index]
                                                              .cityCode = '';
                                                          // personList[index].city = '';
                                                          // personList[index].state='';
                                                          // personList[index].country='';
                                                          // setState(() {});
                                                        },
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        textAlign:
                                                            TextAlign.start,
                                                        enabled: isEdit,
                                                        decoration: InputDecoration(
                                                            labelText: 'City',
                                                            hintText: 'City',
                                                            border:
                                                                OutlineInputBorder(),
                                                            suffixIcon: Icon(Icons
                                                                .keyboard_arrow_down),
                                                            isDense: true)),
                                              )),
                                              hspacer,

                                              /// State
                                              Flexible(
                                                child: TextFormField(
                                                    validator: (value) => value!
                                                            .isEmpty
                                                        ? 'State is required'
                                                        : null,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    controller:
                                                        TextEditingController(
                                                            text: personList[
                                                                    index]
                                                                .state),
                                                    readOnly: !isEdit,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "State",
                                                    )),
                                              ),
                                            ],
                                          ),
                                          vspacer,

                                          /// Country And Pin
                                          Row(
                                            children: [
                                              /// Country
                                              Flexible(
                                                child: TextFormField(
                                                    validator: (value) => value!
                                                            .isEmpty
                                                        ? 'Country is required'
                                                        : null,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    controller:
                                                        TextEditingController(
                                                            text: personList[
                                                                    index]
                                                                .country),
                                                    readOnly: !isEdit,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Country",
                                                    )),
                                              ),

                                              hspacer,

                                              /// Pin
                                              Flexible(
                                                child: TextFormField(
                                                    onChanged: (v) {
                                                      personList[index].pin = v;
                                                    },
                                                    // validator: (value) => value.isEmpty
                                                    //     ? 'PinCode is required'
                                                    //     : value.length < 6
                                                    //     ? 'Pincode Should be of 6 digits'
                                                    //     : null,
                                                    // autovalidateMode: AutovalidateMode
                                                    //     .onUserInteraction,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          6),
                                                    ],
                                                    controller:
                                                        TextEditingController(
                                                            text: personList[
                                                                    index]
                                                                .pin),
                                                    readOnly: !isEdit,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "PinCode",
                                                    )),
                                              ),
                                              vspacer,
                                            ],
                                          ),
                                          vspacer,

                                          /// Mobile1 And Mobile2
                                          Row(
                                            children: [
                                              /// Mobile1
                                              Flexible(
                                                  child: TextFormField(
                                                      onChanged: (v) {
                                                        personList[index].mob1 =
                                                            v;
                                                      },
                                                      // validator: (value) => value
                                                      //     .isEmpty
                                                      //     ? 'Enter Mobile No.'
                                                      //     : value.length < 10
                                                      //     ? 'Mobile No. must contain 10 digits'
                                                      //     : null,
                                                      // autovalidateMode: AutovalidateMode
                                                      //     .onUserInteraction,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            10),
                                                      ],
                                                      controller:
                                                          TextEditingController(
                                                              text: personList[
                                                                      index]
                                                                  .mob1),
                                                      readOnly: !isEdit,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: "Mobile",
                                                        isDense: true,
                                                      ))),
                                              hspacer,

                                              /// Mobile2
                                              Flexible(
                                                  child: TextFormField(
                                                      onChanged: (v) {
                                                        personList[index].mob2 =
                                                            v;
                                                      },
                                                      // validator: (value) => value
                                                      //     .isEmpty
                                                      //     ? 'Enter Mobile No.'
                                                      //     : value.length < 10
                                                      //     ? 'Mobile No. must contain 10 digits'
                                                      //     : null,
                                                      // autovalidateMode: AutovalidateMode
                                                      //     .onUserInteraction,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            10),
                                                      ],
                                                      controller:
                                                          TextEditingController(
                                                              text: personList[
                                                                      index]
                                                                  .mob2),
                                                      readOnly: !isEdit,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: "Mobile",
                                                        isDense: true,
                                                      ))),
                                            ],
                                          ),
                                          vspacer,

                                          /// Phone And Fax No.
                                          Row(
                                            children: [
                                              /// Phone no.
                                              Flexible(
                                                  child: TextFormField(
                                                      onChanged: (v) {
                                                        personList[index].ph =
                                                            v;
                                                      },
                                                      // validator: (value) => value
                                                      //     .isEmpty
                                                      //     ? 'Phone No.is Required'
                                                      //     : value.length < 11
                                                      //     ? 'Phone No. must contain 10 digits'
                                                      //     : null,
                                                      // autovalidateMode: AutovalidateMode
                                                      //     .onUserInteraction,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            11),
                                                      ],
                                                      controller:
                                                          TextEditingController(
                                                              text: personList[
                                                                      index]
                                                                  .ph),
                                                      readOnly: !isEdit,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: "Phone no.",
                                                        isDense: true,
                                                      ))),
                                              hspacer,

                                              /// Fax no.
                                              Flexible(
                                                  child: TextFormField(
                                                      onChanged: (v) {
                                                        personList[index].fax =
                                                            v;
                                                      },
                                                      // validator: (value) => value
                                                      //     .isEmpty
                                                      //     ? 'Fax No.is Required'
                                                      //     : value.length < 11
                                                      //     ? 'Phone No. must contain 10 digits'
                                                      //     : null,
                                                      // autovalidateMode: AutovalidateMode
                                                      //     .onUserInteraction,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            11),
                                                      ],
                                                      controller:
                                                          TextEditingController(
                                                              text: personList[
                                                                      index]
                                                                  .fax),
                                                      readOnly: !isEdit,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: "Fax no.",
                                                        isDense: true,
                                                      ))),
                                            ],
                                          ),
                                          vspacer,

                                          /// Email And Url Id
                                          Row(
                                            children: [
                                              /// Email Id
                                              Flexible(
                                                  child: TextFormField(
                                                      onChanged: (v) {
                                                        personList[index]
                                                            .email = v;
                                                      },
                                                      // validator: (value) => value
                                                      //     .isEmpty
                                                      //     ? 'url is required'
                                                      //     : value.isNotEmpty
                                                      //     ? (!emailValidator
                                                      //     .hasMatch(value)
                                                      //     ? 'Enter valid email'
                                                      //     : null)
                                                      //     : null,
                                                      // autovalidateMode: AutovalidateMode
                                                      //     .onUserInteraction,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      controller:
                                                          TextEditingController(
                                                              text: personList[
                                                                      index]
                                                                  .email),
                                                      readOnly: !isEdit,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: "Email id",
                                                        hintText:
                                                            'e.g:abc@gmail.com',
                                                        isDense: true,
                                                      ))),
                                              hspacer,

                                              /// Url Id
                                              Flexible(
                                                  child: TextFormField(
                                                      onChanged: (v) {
                                                        personList[index].url =
                                                            v;
                                                      },
                                                      // validator: (value) =>
                                                      // value.isEmpty
                                                      //     ? 'url is required'
                                                      //     : null,
                                                      // autovalidateMode: AutovalidateMode
                                                      //     .onUserInteraction,
                                                      keyboardType:
                                                          TextInputType.url,
                                                      controller:
                                                          TextEditingController(
                                                              text: personList[
                                                                      index]
                                                                  .url),
                                                      readOnly: !isEdit,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: "Url id",
                                                        hintText:
                                                            'e.g:https://www.abc.org/',
                                                        isDense: true,
                                                      ))),
                                            ],
                                          ),
                                          vspacer,

                                          /// Active Tag
                                          Center(
                                            child: !isEdit
                                                ? TextFormField(
                                                    controller:
                                                        TextEditingController(
                                                            text: personList[
                                                                    index]
                                                                .active),
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: "Active",
                                                      isDense: true,
                                                    ))
                                                : Row(
                                                    children: [
                                                      Column(
                                                          //Actual Data
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('Active'),
                                                            Row(
                                                              children: [
                                                                Text('Yes'),
                                                                Radio(
                                                                    value:
                                                                        'Yes',
                                                                    groupValue:
                                                                        personList[index]
                                                                            .active,
                                                                    onChanged:
                                                                        (dynamic
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        personList[index].active =
                                                                            'Yes';
                                                                      });
                                                                    }),
                                                                Text('No'),
                                                                Radio(
                                                                    value: 'No',
                                                                    groupValue:
                                                                        personList[index]
                                                                            .active,
                                                                    onChanged:
                                                                        (dynamic
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        personList[index].active =
                                                                            'No';
                                                                      });
                                                                    })
                                                              ],
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                          )
                                        ],
                                      ),
                                    )),
                          ),

                          /* ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(16),
                            itemCount: personList.length,
                            itemBuilder: (context, index) => Card(
                              child: Column(
                                children: [
                                  /// Delete
                                  Visibility(
                                    visible: personList.isNotEmpty && isEdit,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                _deleteContactPerson(index);
                                                },
                                              child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      color: AppColor.appRed,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Icon(Icons.delete,
                                                      size: 14,
                                                      color: Colors.white))),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// Image
                                  GestureDetector(
                                    onTap: isEdit
                                        ? () {
                                            _filePickerBottomSheet(context,index);
                                          }
                                        : null,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(64),
                                        child: _getContactImage(personList[index])
                                    ),
                                  ),

                                  /// Title
                                  TypeAheadFormField<TitleModel>(
                                    validator: (value) => value.isEmpty
                                        ? 'Please select a Title'
                                        : null,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    suggestionsCallback: (String pattern) {
                                      return _getTitle(pattern);
                                    },
                                    itemBuilder:
                                        (BuildContext context, itemData) {
                                      return ListTile(
                                          title: Text(itemData.title));
                                    },
                                    onSuggestionSelected: (sg) {
                                      setState(
                                        () {
                                          personList[index].title = sg.title;
                                          personList[index].titleCode = sg.code;
                                        },
                                      );
                                    },
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            controller: TextEditingController(
                                                text: personList[index].title),
                                            onChanged: (v) {
                                              personList[index].title = '';
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            textAlign: TextAlign.start,
                                            enabled: isEdit,
                                            decoration: InputDecoration(
                                                labelText: 'Title',
                                                hintText: 'Title',
                                                border: OutlineInputBorder(),
                                                suffixIcon: Icon(
                                                    Icons.keyboard_arrow_down),
                                                isDense: true)),
                                  ),
                                  vspacer,

                                  /// Name
                                  TextFormField(
                                      onChanged: (v) {
                                        personList[index].name = v;
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'Please Enter Name'
                                          : null,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: TextEditingController(
                                          text: personList[index].name),
                                      readOnly: !isEdit,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Name",
                                        isDense: true,
                                      )),
                                  vspacer,

                                  /// Address1
                                  TextFormField(
                                      onChanged: (v) {
                                        personList[index].add1 = v;
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'Address is required'
                                          : null,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: TextEditingController(
                                          text: personList[index].add1),
                                      readOnly: !isEdit,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Address",
                                        isDense: true,
                                      )),
                                  vspacer,

                                  /// Address2
                                  TextFormField(
                                      onChanged: (v) {
                                        personList[index].add2 = v;
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'Address is required'
                                          : null,
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      controller: TextEditingController(
                                          text: personList[index].add2),
                                      readOnly: !isEdit,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Address",
                                        isDense: true,
                                      )),
                                  vspacer,

                                  /// City And State
                                  Row(
                                    children: [
                                      /// City
                                      Flexible(
                                          child: TypeAheadFormField<PlaceModel>(
                                        validator: (value) => value.isEmpty
                                            ? 'Please select a City'
                                            : null,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        suggestionsCallback: (String pattern) {
                                          return _city(pattern);
                                        },
                                        itemBuilder:
                                            (BuildContext context, itemData) {
                                          return ListTile(
                                              title: Text(itemData.city));
                                        },
                                        onSuggestionSelected: (sg) {
                                          setState(
                                            () {
                                              personList[index].city = sg.city;
                                              personList[index].state =
                                                  sg.state;
                                              personList[index].country =
                                                  sg.country;
                                              personList[index].cityCode =
                                                  sg.cityCode;
                                              personList[index].stateCode =
                                                  sg.stateCode;
                                              personList[index].countryCode =
                                                  sg.countryCode;
                                            },
                                          );
                                        },
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                                controller:
                                                    TextEditingController(
                                                        text: personList[index]
                                                            .city),
                                                onChanged: (v) {
                                                  personList[index].cityCode =
                                                      '';
                                                  // personList[index].city = '';
                                                  // personList[index].state='';
                                                  // personList[index].country='';
                                                  // setState(() {});
                                                },
                                                textInputAction:
                                                    TextInputAction.next,
                                                textAlign: TextAlign.start,
                                                enabled: isEdit,
                                                decoration: InputDecoration(
                                                    labelText: 'City',
                                                    hintText: 'City',
                                                    border:
                                                        OutlineInputBorder(),
                                                    suffixIcon: Icon(Icons
                                                        .keyboard_arrow_down),
                                                    isDense: true)),
                                      )),
                                      hspacer,

                                      /// State
                                      Flexible(
                                        child: TextFormField(
                                            validator: (value) => value.isEmpty
                                                ? 'State is required'
                                                : null,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: TextEditingController(
                                                text: personList[index].state),
                                            readOnly: !isEdit,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "State",
                                            )),
                                      ),
                                    ],
                                  ),
                                  vspacer,

                                  /// Country And Pin
                                  Row(
                                    children: [
                                      /// Country
                                      Flexible(
                                        child: TextFormField(
                                            validator: (value) => value.isEmpty
                                                ? 'Country is required'
                                                : null,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: TextEditingController(
                                                text:
                                                    personList[index].country),
                                            readOnly: !isEdit,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Country",
                                            )),
                                      ),

                                      hspacer,

                                      /// Pin
                                      Flexible(
                                        child: TextFormField(
                                            onChanged: (v) {
                                              personList[index].pin = v;
                                            },
                                            validator: (value) => value.isEmpty
                                                ? 'PinCode is required'
                                                : value.length < 6
                                                    ? 'Pincode Should be of 6 digits'
                                                    : null,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  6),
                                            ],
                                            controller: TextEditingController(
                                                text: personList[index].pin),
                                            readOnly: !isEdit,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "PinCode",
                                            )),
                                      ),
                                      vspacer,
                                    ],
                                  ),
                                  vspacer,

                                  /// Mobile1 And Mobile2
                                  Row(
                                    children: [
                                      /// Mobile1
                                      Flexible(
                                          child: TextFormField(
                                              onChanged: (v) {
                                                personList[index].mob1 = v;
                                              },
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? 'Enter Mobile No.'
                                                  : value.length < 10
                                                      ? 'Mobile No. must contain 10 digits'
                                                      : null,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                              ],
                                              controller: TextEditingController(
                                                  text: personList[index].mob1),
                                              readOnly: !isEdit,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Mobile",
                                                isDense: true,
                                              ))),
                                      hspacer,

                                      /// Mobile2
                                      Flexible(
                                          child: TextFormField(
                                              onChanged: (v) {
                                                personList[index].mob2 = v;
                                              },
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? 'Enter Mobile No.'
                                                  : value.length < 10
                                                      ? 'Mobile No. must contain 10 digits'
                                                      : null,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                              ],
                                              controller: TextEditingController(
                                                  text: personList[index].mob2),
                                              readOnly: !isEdit,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Mobile",
                                                isDense: true,
                                              ))),
                                    ],
                                  ),
                                  vspacer,

                                  /// Phone And Fax No.
                                  Row(
                                    children: [
                                      /// Phone no.
                                      Flexible(
                                          child: TextFormField(
                                              onChanged: (v) {
                                                personList[index].ph = v;
                                              },
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? 'Phone No.is Required'
                                                  : value.length < 11
                                                      ? 'Phone No. must contain 10 digits'
                                                      : null,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    11),
                                              ],
                                              controller: TextEditingController(
                                                  text: personList[index].ph),
                                              readOnly: !isEdit,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Phone no.",
                                                isDense: true,
                                              ))),
                                      hspacer,

                                      /// Fax no.
                                      Flexible(
                                          child: TextFormField(
                                              onChanged: (v) {
                                                personList[index].fax = v;
                                              },
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? 'Fax No.is Required'
                                                  : value.length < 11
                                                      ? 'Phone No. must contain 10 digits'
                                                      : null,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    11),
                                              ],
                                              controller: TextEditingController(
                                                  text: personList[index].fax),
                                              readOnly: !isEdit,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Fax no.",
                                                isDense: true,
                                              ))),
                                    ],
                                  ),
                                  vspacer,

                                  /// Email And Url Id
                                  Row(
                                    children: [
                                      /// Email Id
                                      Flexible(
                                          child: TextFormField(
                                              onChanged: (v) {
                                                personList[index].email = v;
                                              },
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? 'url is required'
                                                  : value.isNotEmpty
                                                      ? (!emailValidator
                                                              .hasMatch(value)
                                                          ? 'Enter valid email'
                                                          : null)
                                                      : null,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              controller: TextEditingController(
                                                  text:
                                                      personList[index].email),
                                              readOnly: !isEdit,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Email id",
                                                hintText: 'e.g:abc@gmail.com',
                                                isDense: true,
                                              ))),
                                      hspacer,

                                      /// Url Id
                                      Flexible(
                                          child: TextFormField(
                                              onChanged: (v) {
                                                personList[index].url = v;
                                              },
                                              validator: (value) =>
                                                  value.isEmpty
                                                      ? 'url is required'
                                                      : null,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType: TextInputType.url,
                                              controller: TextEditingController(
                                                  text: personList[index].url),
                                              readOnly: !isEdit,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Url id",
                                                hintText:
                                                    'e.g:https://www.abc.org/',
                                                isDense: true,
                                              ))),
                                    ],
                                  ),
                                  vspacer,

                                  /// Active Tag
                                  Center(
                                    child: !isEdit
                                        ? TextFormField(
                                            controller: TextEditingController(
                                                text: personList[index].active),
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Active",
                                              isDense: true,
                                            ))
                                        : Row(
                                            children: [
                                              Column(
                                                  //Actual Data
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Active'),
                                                    Row(
                                                      children: [
                                                        Text('Yes'),
                                                        Radio(
                                                            value: 'Yes',
                                                            groupValue:
                                                                personList[
                                                                        index]
                                                                    .active,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                personList[index]
                                                                        .active =
                                                                    'Yes';
                                                              });
                                                            }),
                                                        Text('No'),
                                                        Radio(
                                                            value: 'No',
                                                            groupValue:
                                                                personList[
                                                                        index]
                                                                    .active,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                personList[index]
                                                                        .active =
                                                                    'No';
                                                              });
                                                            })
                                                      ],
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),

            /// Add
            Visibility(
              visible: isEdit,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      personList.add(PersonModel());
                      setState(() {});
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _getContactImage(PersonModel model) {
    if (model.imageUrl!.isEmpty) {
      if (model.imagePath != null) {
        return Image.file(model.imagePath!, height: 128, width: 128);
      } else {
        return Image.asset('images/noImage.png', height: 128, width: 128);
      }
    } else {
      return Image.network('$contactImageBaseUrl${model.imageUrl}.png',
          height: 128, width: 128);
    }
  }

  Widget _buildHorizontalcells() {
    return Column(children: [
      Container(
        alignment: Alignment.topCenter,
        child: Row(
          children: [
            ///  Sale Type Code
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 40,
                width: 150,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Sale Type Code',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            /// Sale Type Description
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 40,
                width: 210,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    "Sale Type Description",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            /// Company
            Padding(
                padding: EdgeInsets.only(left: 4, top: 2),
                child: Container(
                  height: 40,
                  width: 210,
                  color: Colors.red[500],
                  child: Center(
                      child: Text(
                    "Company",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
                )),

            /// From Date
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 40,
                width: 170,
                color: Colors.red[500],
                child: Center(
                  child: Text("From Date",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),

            /// To Date
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 40,
                width: 170,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'To Date',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            /// Actions
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 40,
                width: 70,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Actions',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildcell() {
    return Column(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              /// Purchase type Description
              Padding(
                padding: EdgeInsets.only(left: 4, top: 2),
                child: Container(
                  height: 40,
                  width: 210,
                  color: Colors.red[500],
                  child: Center(
                    child: Text(
                      'Purchase type Description',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),

              /// Company
              Padding(
                padding: EdgeInsets.only(left: 4, top: 2),
                child: Container(
                  height: 40,
                  width: 210,
                  color: Colors.red[500],
                  child: Center(
                    child: Text(
                      'Company',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),

              /// Tds
              Padding(
                padding: EdgeInsets.only(left: 4, top: 2),
                child: Container(
                  height: 40,
                  width: 100,
                  color: Colors.red[500],
                  child: Center(
                    child: Text(
                      'Tds',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),

              /// From Date
              Padding(
                padding: EdgeInsets.only(left: 4, top: 2),
                child: Container(
                  height: 40,
                  width: 170,
                  color: Colors.red[500],
                  child: Center(
                    child: Text(
                      'From Date',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),

              /// To Date
              Padding(
                padding: EdgeInsets.only(left: 4, top: 2),
                child: Container(
                  height: 40,
                  width: 170,
                  color: Colors.red[500],
                  child: Center(
                      child: Text(
                    'To Date',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
                ),
              ),

              /// Action
              Padding(
                padding: EdgeInsets.only(left: 4, top: 2),
                child: Container(
                  height: 40,
                  width: 70,
                  color: Colors.red[500],
                  child: Center(
                      child: Text(
                    'Action',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  /// Image Editor
  void _filePickerBottomSheet(context, int index) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(blurRadius: 10.9, color: Colors.grey[400]!)
            ]),
            height: 170,
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Text("Select File Options"),
                ),
                Divider(
                  height: 1,
                ),
                new Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.photo_library),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      var mFile = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageEditor()));
                                      if (mFile == null) return;
                                      // this.mFile = mFile['file'];
                                      personList[index].imageUrl = '';
                                      personList[index].imagePath =
                                          mFile['file'];
                                      setState(() {});
                                    }),
                                SizedBox(width: 10),
                                Text("Upload Image")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  /// Date Picker
  _saleFromDate(BuildContext, int index) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      DateFormat formatter = DateFormat('dd MMM yyyy');
      saleTypeList[index].fromdate = formatter.format(selected);
    }
    setState(() {});
  }

  _saleToDate(BuildContext, int index) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      DateFormat formatter = DateFormat('dd MMM yyyy');
      saleTypeList[index].todate = formatter.format(selected);
    }
    setState(() {});
  }

  _purchaseFromDate(BuildContext, int index) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      DateFormat formatter = DateFormat('dd MMM yyyy');
      purchaseList[index].fromdate = formatter.format(selected);
    }
    setState(() {});
  }

  _purchaseToDate(BuildContext, int index) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      DateFormat formatter = DateFormat('dd MMM yyyy');
      purchaseList[index].todate = formatter.format(selected);
    }
    setState(() {});
  }

  /// Drop Down
  _getTitle(String str) {
    return titleList
        .where((i) => i.title!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getBsGroup(String str) {
    return bsGroupList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getBank(String str) {
    return banknameList
        .where((i) => i.bank.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getCity(String str) {
    return _placeList
        .where((i) => i.city!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _city(String str) {
    return _placeList
        .where((i) => i.city!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  /// Save Update
  _updateMain() {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'main',
      'title_code': titleCode,
      'name': nameController.text,
      'bs_group_code': bsGroupCode,
      'print_on_ch': printController.text,
      'cr_limit': creditlimitController.text,
      'active_tag': active,
      'sp_commission_tag': spCommissionTag,
      'op_bal_tag': debitCredit,
      'acc_type': getAccountType(accounttypeController.text),
      'op_bal': openingController.text.trim(),
      'cr_days': creditdaysController.text.trim(),
      'remarks': remarksController.text,
    };
    logIt('_updateMain -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartySave, this, jsonBody)
        .callPostService(context);
  }

  _updateAddress() {
    String? codePk = '';
    String? rank = '';
    String? add1 = '';
    String? cityCode = '';
    String? add0 = '';
    String? add2 = '';
    String? pinCode = '';
    addressList.forEach((element) {
      logIt('address isLocal ${element.isLocal}');
      if (codePk!.isEmpty) {
        if (element.isLocal) {
          codePk = '0';
        } else {
          codePk = element.codePk;
        }
      } else {
        if (element.isLocal) {
          codePk = '$codePk,${'0'}';
        } else {
          codePk = '$codePk,${element.codePk}';
        }
      }
      if (rank!.isEmpty) {
        rank = element.rank;
      } else {
        rank = '$rank,${element.rank}';
      }
      if (add1!.isEmpty) {
        add1 = element.add1;
      } else {
        add1 = '$add1,${element.add1}';
      }
      if (cityCode!.isEmpty) {
        cityCode = element.cityCode;
      } else {
        cityCode = '$cityCode,${element.cityCode}';
      }
      if (add0!.isEmpty) {
        add0 = element.add0;
      } else {
        add0 = '$add0,${element.add0}';
      }
      if (add2!.isEmpty) {
        add2 = element.add2;
      } else {
        add2 = '$add2,${element.add2}';
      }
      if (pinCode!.isEmpty) {
        pinCode = element.pincode;
      } else {
        pinCode = '$pinCode,${element.pincode}';
      }
    });
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'address',
      'code_pk': codePk,
      'rank': rank,
      'add1': add1,
      'city_code': cityCode,
      'add0': add0,
      'add2': add2,
      'pin_code': pinCode,
      'op_bal': '',
      'op_bal_tag': '',
    };
    logIt('_updateAddress -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartySave, this, jsonBody)
        .callPostService(context);
  }

  _updateBank() {
    String codePk = '';
    String rank = '';
    String bankCode = '';
    String accno = '';
    String branch = '';
    String ifsc = '';
    bankModelList.forEach((element) {
      if (codePk.isEmpty) {
        if (element.isLocal) {
          codePk = '0';
        } else {
          codePk = element.codePk;
        }
      } else {
        if (element.isLocal) {
          codePk = '$codePk,${'0'}';
        } else {
          codePk = '$codePk,${element.codePk}';
        }
      }
      if (rank.isEmpty) {
        rank = element.rank;
      } else {
        rank = '$rank,${element.rank}';
      }
      if (bankCode.isEmpty) {
        bankCode = element.bankCode;
      } else {
        bankCode = '$bankCode,${element.bankCode}';
      }
      if (accno.isEmpty) {
        accno = element.accno;
      } else {
        accno = '$accno,${element.accno}';
      }
      if (branch.isEmpty) {
        branch = element.branch;
      } else {
        branch = '$branch,${element.branch}';
      }
      if (ifsc.isEmpty) {
        ifsc = element.ifsc;
      } else {
        ifsc = '$ifsc,${element.ifsc}';
      }
    });
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'bank',
      'code_pk': codePk,
      'rank': rank,
      'bank_code': bankCode,
      'bank_acc_no': accno,
      'bank_branch': branch,
      'ifsc_code': ifsc,
    };
    logIt('_updateBank -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartySave, this, jsonBody)
        .callPostService(context);
  }

  _updateCommunication() {
    String commTypeCode = '';
    String description = '';
    String oldNAme = '';
    String tag = '';
    communicationlist.forEach((element) {
      if (commTypeCode.isEmpty) {
        commTypeCode = element.commTypeCode;
      } else {
        commTypeCode = '$commTypeCode,${element.commTypeCode}';
      }
      if (description.isEmpty) {
        description = element.description;
      } else {
        description = '$description,${element.description}';
      }
      if (oldNAme.isEmpty) {
        oldNAme = element.oldName;
      } else {
        oldNAme = '$oldNAme,${element.oldName}';
      }
      if (tag.isEmpty) {
        tag = element.tag == 'Yes' ? 'Y' : 'N';
      } else {
        tag = '$tag,${element.tag == 'Yes' ? 'Y' : 'N'}';
      }
    });
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'comm',
      'commtype_code': commTypeCode,
      'name': description,
      'old_name': oldNAme,
      'print_tag': tag,
    };
    logIt('_updateCommunication -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartySave, this, jsonBody)
        .callPostService(context);
  }

  _updateTax() {
    String taxRegCode = '';
    String number = '';
    String oldName = '';
    String tag = '';
    taxList.forEach((element) {
      if (taxRegCode.isEmpty) {
        taxRegCode = element.code;
      } else {
        taxRegCode = '$taxRegCode,${element.code}';
      }
      if (number.isEmpty) {
        number = element.number;
      } else {
        number = '$number,${element.number}';
      }
      if (oldName.isEmpty) {
        oldName = element.oldName;
      } else {
        oldName = '$oldName,${element.oldName}';
      }
      if (tag.isEmpty) {
        tag = element.tag == 'Yes' ? 'Y' : 'N';
      } else {
        tag = '$tag,${element.tag == 'Yes' ? 'Y' : 'N'}';
      }
    });
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'tax',
      'taxreg_code': taxRegCode,
      'name': number,
      'print_tag': tag,
      'old_name': oldName,
    };
    logIt('_updateTax -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartySave, this, jsonBody)
        .callPostService(context);
  }

  _updateAccCompany() {
    String compCode = '';
    String remarks = '';
    accCompanylist.forEach((element) {
      if (compCode.isEmpty) {
        compCode = element.compCode;
      } else {
        compCode = '$compCode,${element.compCode}';
      }

      if (remarks.isEmpty) {
        remarks = element.remarks;
      } else {
        remarks = '$remarks,${element.remarks}';
      }
    });
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'company',
      'comp_code': compCode,
      'remarks': remarks
    };
    logIt('_updateAccCompany -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartySave, this, jsonBody)
        .callPostService(context);
  }

  _updateSaleType() {
    String compCode = '';
    String saleType = '';
    String fromDate = '';
    String toDate = '';
    saleTypeList.forEach((element) {
      if (compCode.isEmpty) {
        compCode = element.compCode;
      } else {
        compCode = '$compCode,${element.compCode}';
      }
      if (saleType.isEmpty) {
        saleType = element.code;
      } else {
        saleType = '$saleType,${element.code}';
      }
      if (fromDate.isEmpty) {
        fromDate = getFormattedDate(element.fromdate,
            inFormat: 'dd MMM yyyy', outFormat: 'yyyy-MM-dd');
      } else {
        fromDate =
            '$fromDate,${getFormattedDate(element.fromdate, inFormat: 'dd MMM yyyy', outFormat: 'yyyy-MM-dd')}';
      }
      if (toDate.isEmpty) {
        toDate = getFormattedDate(element.todate,
            inFormat: 'dd MMM yyyy', outFormat: 'yyyy-MM-dd');
      } else {
        toDate =
            '$toDate,${getFormattedDate(element.todate, inFormat: 'dd MMM yyyy', outFormat: 'yyyy-MM-dd')}';
      }
    });
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'sale',
      'comp_code': compCode,
      'sale_type': saleType,
      'from_date': fromDate,
      'to_date': toDate,
    };
    logIt('_updateSaleType -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartySave, this, jsonBody)
        .callPostService(context);
  }

  _updatePurType() {
    String compCode = '';
    String purType = '';
    String tdsCode = '';
    String tdsType = '';
    String fromDate = '';
    String toDate = '';
    purchaseList.forEach((element) {
      if (compCode.isEmpty) {
        compCode = element.compCode;
      } else {
        compCode = '$compCode,${element.compCode}';
      }
      if (purType.isEmpty) {
        purType = element.code;
      } else {
        purType = '$purType,${element.code}';
      }
      if (tdsCode.isEmpty) {
        tdsCode = element.tdscode;
      } else {
        tdsCode = '$tdsCode,${element.tdscode}';
      }
      if (tdsType.isEmpty) {
        tdsType = element.tdstype;
      } else {
        tdsType = '$tdsType,${element.tdstype}';
      }
      if (fromDate.isEmpty) {
        fromDate = getFormattedDate(element.fromdate,
            inFormat: 'dd MMM yyyy', outFormat: 'yyyy-MM-dd');
      } else {
        fromDate =
            '$fromDate,${getFormattedDate(element.fromdate, inFormat: 'dd MMM yyyy', outFormat: 'yyyy-MM-dd')}';
      }
      if (toDate.isEmpty) {
        toDate = getFormattedDate(element.todate,
            inFormat: 'dd MMM yyyy', outFormat: 'yyyy-MM-dd');
      } else {
        toDate =
            '$toDate,${getFormattedDate(element.todate, inFormat: 'dd MMM yyyy', outFormat: 'yyyy-MM-dd')}';
      }
    });
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'purchase',
      'comp_code': compCode,
      'pur_type': purType,
      'tds_code': tdsCode,
      'tds_type': tdsType,
      'from_date': fromDate,
      'to_date': toDate,
    };
    logIt('_updatePurType -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartySave, this, jsonBody)
        .callPostService(context);
  }

  _updateContactPerson() async {
    String? codePk = '';
    String? title = '';
    String? name = '';
    String? cityCode = '';
    String? add1 = '';
    String? add2 = '';
    String? pinCode = '';
    String? mob1 = '';
    String? mob2 = '';
    String? phNO = '';
    String? faxNo = '';
    String? emailId = '';
    String? urlId = '';
    String tag = '';
    String dsgCode = '';
    String fileNameId = '';
    List<dynamic> imageList = [];
    var dmFile = await _createDummyImageFile();
    personList.forEach((element) {
      if (codePk!.isEmpty) {
        if (element.isLocal) {
          codePk = '0';
        } else {
          codePk = element.codePk;
        }
      } else {
        if (element.isLocal) {
          codePk = '$codePk,${'0'}';
        } else {
          codePk = '$codePk,${element.codePk}';
        }
      }
      if (title!.isEmpty) {
        title = element.titleCode;
      } else {
        title = '$title,${element.titleCode}';
      }
      if (name!.isEmpty) {
        name = element.name;
      } else {
        name = '$name,${element.name}';
      }
      if (cityCode!.isEmpty) {
        cityCode = element.cityCode;
      } else {
        cityCode = '$cityCode,${element.cityCode}';
      }
      if (add1!.isEmpty) {
        add1 = element.add1;
      } else {
        add1 = '$add1,${element.add1}';
      }
      // if (dsgCode.isEmpty) {
      //   dsgCode = element.dsgCode;
      // }
      // else {
      dsgCode = '$dsgCode,${element.dsgCode}';
      // }
      if (add2!.isEmpty) {
        add2 = element.add2;
      } else {
        add2 = '$add2,${element.add2}';
      }
      if (pinCode!.isEmpty) {
        pinCode = element.pin;
      } else {
        pinCode = '$pinCode,${element.pin}';
      }
      if (mob1!.isEmpty) {
        mob1 = element.mob1;
      } else {
        mob1 = '$mob1,${element.mob1}';
      }
      if (mob2!.isEmpty) {
        mob2 = element.mob2;
      } else {
        mob2 = '$mob2,${element.mob2}';
      }
      if (phNO!.isEmpty) {
        phNO = element.ph;
      } else {
        phNO = '$phNO,${element.ph}';
      }
      if (faxNo!.isEmpty) {
        faxNo = element.fax;
      } else {
        faxNo = '$faxNo,${element.fax}';
      }
      if (emailId!.isEmpty) {
        emailId = element.email;
      } else {
        emailId = '$emailId,${element.email}';
      }
      if (urlId!.isEmpty) {
        urlId = element.url;
      } else {
        urlId = '$urlId,${element.url}';
      }
      if (tag.isEmpty) {
        tag = element.active == 'Yes' ? 'Y' : 'N';
      } else {
        tag = '$tag,${element.active == 'Yes' ? 'Y' : 'N'}';
      }

      if (fileNameId.isEmpty) {
        if (element.imageUrl!.isEmpty) {
          if (element.imagePath == null)
            fileNameId = ',';
          else
            fileNameId = '0';
        } else {
          // if(element.imagePath==null) fileNameId='$fileNameId,';
          // else
          fileNameId = '${element.imageUrl}';
        }
      } else {
        if (element.imageUrl!.isEmpty) {
          if (element.imagePath == null)
            fileNameId = ',';
          else
            fileNameId = '$fileNameId,0';
        } else {
          // if(element.imagePath==null) fileNameId='$fileNameId,';
          // else fileNameId='$fileNameId,${element.imageUrl}';
          fileNameId = '$fileNameId,${element.imageUrl}';
        }
      }

      if (element.imageUrl!.isEmpty && element.imagePath == null) {
        logIt('Image is Empty and Null');
        imageList.add(dmFile);
      } else {
        if (element.imagePath != null) {
          imageList.add(element.imagePath!.absolute.path);
        } else {
          imageList.add(dmFile);
        }
      }
    });

    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'contact',
      'code_pk': codePk,
      'title_code': title,
      'name': name,
      'add1': add1,
      'city_code': cityCode,
      'pin_code': pinCode,
      'dsg_code': dsgCode,
      'add2': add2,
      'mobile_no1': mob1,
      'mobile_no2': mob2,
      'ph_no': phNO,
      'fax_no': faxNo,
      'email_id': emailId,
      'url_id': urlId,
      'active_tag': tag,
      'filename_id': fileNameId,
    };
    logIt('_updateContactPerson -> $jsonBody ');
    WebService.multipartGalleryImagesApi(
            AppConfig.accountPartySave, this, jsonBody, imageList)
        .callMultipartCreateGalleryService(context, fileName: 'filename[]');
    //WebService.fromApi(AppConfig.accountPartySave, this, jsonBody).callPostService(context);
  }

  Future<String> _createDummyImageFile() async {
    var documentDirectory = await getTemporaryDirectory();
    var imagePath = documentDirectory.path + "/image";
    var dummyImagePath = documentDirectory.path + '/image/dummyImage.jpg';
    await Directory(imagePath).create(recursive: true);
    await File(dummyImagePath).create(recursive: true);
    return Future.value(dummyImagePath);
  }

  /// Delete
  _deleteAddress(int index) {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'address',
      'code_pk': addressList[index].codePk,
    };
    logIt('_deleteAddress -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartyDelete, this, jsonBody)
        .callPostService(context, onResult: () {
      setState(() {
        addressList.removeAt(index);
      });
    });
  }

  _deleteBank(int index) {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'bank',
      'code_pk': bankModelList[index].codePk,
    };
    logIt('_deleteBank -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartyDelete, this, jsonBody)
        .callPostService(context, onResult: () {
      setState(() {
        bankModelList.removeAt(index);
      });
    });
  }

  _deleteCommunication(int index) {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'comm',
      'commtype_code': communicationlist[index].commTypeCode,
    };
    logIt('_deleteCommunication -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartyDelete, this, jsonBody)
        .callPostService(context, onResult: () {
      setState(() {
        communicationlist.removeAt(index);
      });
    });
  }

  _deleteTax(int index) {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'tax',
      'taxreg_code': taxList[index].code,
    };
    logIt('_deleteTax -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartyDelete, this, jsonBody)
        .callPostService(context, onResult: () {
      setState(() {
        taxList.removeAt(index);
      });
    });
  }

  _deleteAccCompany(int index) {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'company',
      'comp_code': accCompanylist[index].compCode,
    };
    logIt('_deleteAccCompany -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartyDelete, this, jsonBody)
        .callPostService(context, onResult: () {
      setState(() {
        accCompanylist.removeAt(index);
      });
    });
  }

  _deleteSaleType(int index) {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'sale',
      'sale_type': saleTypeList[index].code,
    };
    logIt('_deleteSaleType -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartyDelete, this, jsonBody)
        .callPostService(context, onResult: () {
      setState(() {
        saleTypeList.removeAt(index);
      });
    });
  }

  _deletePurType(int index) {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'purchase',
      'pur_type': purchaseList[index].code,
    };
    logIt('_deletePurType -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartyDelete, this, jsonBody)
        .callPostService(context, onResult: () {
      setState(() {
        purchaseList.removeAt(index);
      });
    });
  }

  _deleteContactPerson(int index) {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': codeController.text,
      'save_type': 'contact',
      'code_pk': personList[index].codePk,
    };
    logIt('_deleteContactPerson -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartyDelete, this, jsonBody)
        .callPostService(context, onResult: () {
      setState(() {
        personList.removeAt(index);
      });
    });
  }

  ///Services
  _getPartiesDetail() {
    Map jsonBody = {'user_id': getUserId(), 'code': widget.id};
    logIt('_getParties -> $jsonBody ');
    WebService.fromApi(AppConfig.accountPartyDetail, this, jsonBody)
        .callPostService(context);
  }

  _getOptionList() {
    Map jsonBody = {
      'user_id': getUserId(),
    };
    logIt('_getOptionList -> $jsonBody ');
    WebService.fromApi(AppConfig.partyOptionList, this, jsonBody)
        .callPostService(context);
  }

  _approve() {
    Map jsonBody = {'user_id': getUserId(), 'code': widget.id};

    WebService.fromApi(AppConfig.approveParty, this, jsonBody)
        .callPostService(context);
  }

  _reject() {
    Map jsonBody = {
      'user_id': getUserId(),
      'code': widget.id,
      'type': 'reject'
    };

    WebService.fromApi(AppConfig.approveParty, this, jsonBody)
        .callPostService(context);
  }

  _getPlace() {
    Map jsonBody = {
      'user_id': getUserId(),
      'table_name': 'CITY_MASTER',
    };
    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody,
            reqCode: 'CITY_MASTER')
        .callPostService(context);
  }

  String getAccountType(String type) {
    switch (type) {
      case 'Debit':
        return 'D';
      case 'Credit':
        return 'C';
      case 'Both':
        return 'B';
      case 'General':
        return 'G';
      default:
        return '';
    }
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    switch (requestCode) {
      case AppConfig.accountPartyDetail:
        {
          var res = jsonDecode(response!);

          if (res['error'] == 'false') {
            var data = res['content'];

            var bankcontent = data['bank_lists'] as List;
            var communicationcontent = data['comm_lists'] as List;
            var companycontent = data['company_master'] as List;
            var addresscontent = data['party_address_with_city'] as List;
            var taxcontent = data['tax_reg_lists'] as List;
            var personcontent = data['all_contact_persons'] as List;
            var salecontent = data['sale_type_lists'] as List;
            var purchasecontent = data['pur_type_lists'] as List;

            titleController.text = getString(data['title_name'], 'name');
            titleCode = getString(data['title_name'], 'code');
            codeController.text = getString(data, 'code');
            nameController.text = getString(data, 'name');
            bsController.text = getString(data['bs_group_name'], 'name');
            bsGroupCode = getString(data, 'bs_group_code');
            spCommissionTag = getString(data, 'sp_commission_tag');
            printController.text = getString(data, 'print_on_ch');
            openingController.text = getString(data, 'op_bal');
            drcrController.text =
                getString(data, 'op_bal_tag') == 'D' ? 'Debit' : 'Credit';
            debitCredit = getString(data, 'op_bal_tag');
            creditlimitController.text = getString(data, 'cr_limit');
            creditdaysController.text = getString(data, 'cr_days');
            accounttypeController.text =
                getAccType(getString(data, 'acc_type'));
            activeController.text =
                getString(data, 'active_tag') == 'Y' ? 'Yes' : 'No';
            active = getString(data, 'active_tag');
            remarksController.text = getString(data, 'remarks');
            //approvaluserController.text = getString(data, 'approval_uid');
            //approvaldataController.text = getString(data, 'approval_date');
            bankModelList.clear();
            bankModelList.addAll(
                bankcontent.map((e) => BankModel.parsejson(e)).toList());
            communicationlist.clear();
            communicationlist.addAll(communicationcontent
                .map((e) => CommunicationModel.parsejson(e))
                .toList());
            accCompanylist.clear();
            accCompanylist.addAll(companycontent
                .map((e) => AccCompanyModel.parsejson(e))
                .toList());
            addressList.clear();
            addressList.addAll(
                addresscontent.map((e) => AddressModel.parsejson(e)).toList());
            taxList.clear();
            taxList
                .addAll(taxcontent.map((e) => TaxModel.parsejson(e)).toList());
            personList.clear();
            personList.addAll(
                personcontent.map((e) => PersonModel.parsejson(e)).toList());
            saleTypeList.clear();
            saleTypeList.addAll(
                salecontent.map((e) => SaleTypeModel.parsejson(e)).toList());
            purchaseList.clear();
            purchaseList.addAll(purchasecontent
                .map((e) => PurchaseModel.parsejson(e))
                .toList());

            contactImageBaseUrl = getString(res, 'image_png_path');

            setState(() {});
          }
        }
        break;
      case AppConfig.approveParty:
        {
          var res = jsonDecode(response!);
          if (res['error'] == 'false') {
            showAlert(context, res['message'], 'Success', onOk: () {
              popIt(context);
            });
          } else {
            showAlert(context, res['message'], 'Error');
          }
        }
        break;
      case 'CITY_MASTER':
        {
          var data = jsonDecode(response!);

          if (data['error'] == 'false') {
            var content = data['content'] as List;
            _placeList.clear();
            _placeList.addAll(content.map((e) => PlaceModel.parsejson(e)));
            setState(() {});
          }
        }
        break;
      case AppConfig.partyOptionList:
        {
          var res = jsonDecode(response!);
          if (res['error'] == 'false') {
            var bankcontent = res['bank_master'] as List;
            banknameList.clear();
            banknameList.addAll(
                bankcontent.map((e) => BankModel.parseItems(e)).toList());
            var titlecontent = res['titles'] as List;
            titleList.clear();
            titleList.addAll(
                titlecontent.map((e) => TitleModel.parsejson(e)).toList());
            var groupcontent = res['bs_groups'] as List;
            bsGroupList.clear();
            bsGroupList.addAll(
                groupcontent.map((e) => BsGroupModel.parsejson(e)).toList());
            var company = res['companies'] as List;
            companylist.clear();
            companylist.addAll(
                company.map((e) => AccCompanyModel.parseItems(e)).toList());
            var communicationcntnt = res['comm_type_master'] as List;
            communication.clear();
            communication.addAll(communicationcntnt
                .map((e) => CommunicationModel.parseItems(e))
                .toList());
            var taxc = res['tax_reg_master'] as List;
            taxlist2.clear();
            taxlist2.addAll(taxc.map((e) => TaxModel.parseItems(e)).toList());
            var salecontent = res['sale_type_master'] as List;
            saleTypeList2.clear();
            saleTypeList2.addAll(
                salecontent.map((e) => SaleTypeModel.parseItems(e)).toList());
            var purcontent = res['pur_type_master'] as List;
            purchaseList2.clear();
            purchaseList2.addAll(
                purcontent.map((e) => PurchaseModel.parseItems(e)).toList());
            var tdscontent = res['tds_master'] as List;
            tdslist.clear();
            tdslist.addAll(
                tdscontent.map((e) => PurchaseModel.parsejsonBody(e)).toList());
          }
        }
        break;
      case AppConfig.accountPartySave:
        {
          var res = jsonDecode(response!);
          if (res['error'] == 'false') {
            showAlert(context, res['message'], 'Success', onOk: () {
              _getPartiesDetail();
            });
          } else {
            showAlert(context, res['message'], 'Error');
          }
        }
        break;
      case AppConfig.accountPartyDelete:
        {
          var res = jsonDecode(response!);
          if (res['error'] == 'false') {
            showAlert(context, res['message'], 'Success', onOk: () {});
          } else {
            showAlert(context, res['message'], 'Error');
          }
        }
        break;
    }
  }

  String getAccType(String type) {
    switch (type) {
      case 'D':
        return 'Debit';
      case 'C':
        return 'Credit';
      case 'B':
        return 'Both';
      case 'G':
        return 'General';
      default:
        return '';
    }
  }
}

class BankModel {
  String rank = '',
      bank = '',
      bankCode = '',
      accno = '',
      branch = '',
      ifsc = '',
      codePk = '';
  bool isLocal;

  BankModel(
      {this.rank = '',
      this.codePk = '',
      this.bank = '',
      this.bankCode = '',
      this.accno = '',
      this.branch = '',
      this.ifsc = '',
      this.isLocal = true});
  factory BankModel.parsejson(Map<String, dynamic> data) {
    return BankModel(
        rank: getString(data, 'rank'),
        codePk: getString(data, 'code'),
        bankCode: getString(data['bank_code_name'], 'code'),
        bank: getString(data['bank_code_name'], 'name'),
        accno: getString(data, 'bank_acc_no'),
        branch: getString(data, 'bank_branch'),
        ifsc: getString(data, 'ifsc_code'),
        isLocal: false);
  }
  factory BankModel.parseItems(Map<String, dynamic> data) {
    return BankModel(
      rank: getString(data, 'rank'),
      bank: getString(data, 'name'),
      bankCode: getString(data, 'code'),
      accno: getString(data, 'bank_acc_no'),
      branch: getString(data, 'bank_branch'),
      ifsc: getString(data, 'ifsc_code'),
    );
  }
}

class CommunicationModel {
  String type = '',
      commTypeCode = '',
      description = '',
      oldName = '',
      tag = 'No';
  bool isLocal;
  CommunicationModel(
      {this.type = '',
      this.commTypeCode = '',
      this.description = '',
      this.oldName = '',
      this.tag = 'No',
      this.isLocal = true});
  factory CommunicationModel.parsejson(Map<String, dynamic> data) {
    return CommunicationModel(
        type: getString(data['communication_name'], 'name'),
        commTypeCode: getString(data, 'commtype_code'),
        description: getString(data, 'name'),
        oldName: getString(data, 'name'),
        isLocal: false,
        tag: getString(data, 'print_tag') == 'Y' ? 'Yes' : 'No');
  }
  factory CommunicationModel.parseItems(Map<String, dynamic> data) {
    return CommunicationModel(
        commTypeCode: getString(data, 'code'), type: getString(data, 'name'));
  }
}

class AccCompanyModel {
  String compCode = '', company = '', remarks = '';
  AccCompanyModel({this.compCode = '', this.company = '', this.remarks = ''});

  factory AccCompanyModel.parsejson(Map<String, dynamic> data) {
    return AccCompanyModel(
      compCode: getString(data['company_name'], 'code'),
      company: getString(data['company_name'], 'name'),
      remarks: getString(data['company_name'], 'remarks'),
    );
  }
  factory AccCompanyModel.parseItems(Map<String, dynamic> data) {
    return AccCompanyModel(
      compCode: getString(data, 'code'),
      company: getString(data, 'name'),
      remarks: getString(data, 'remarks'),
    );
  }
}

class AddressModel {
  String? rank = '',
      accountname = '',
      add0 = '',
      add1 = '',
      add2 = '',
      city = '',
      cityCode = '',
      state = '',
      stateCode = '',
      country = '',
      countryCode = '',
      pincode = '',
      codePk = '';
  bool isLocal;

  AddressModel({
    this.rank = '',
    this.add0 = '',
    this.add1 = '',
    this.add2 = '',
    this.city = '',
    this.cityCode = '',
    this.state = '',
    this.stateCode = '',
    this.country = '',
    this.countryCode = '',
    this.pincode = '',
    this.codePk = '',
    this.isLocal = true,
  });

  factory AddressModel.parsejson(Map<String, dynamic> data) {
    return AddressModel(
        codePk: getString(data, 'code'),
        rank: getString(data, 'rank'),
        add0: getString(data, 'add0'),
        add1: getString(data, 'add1'),
        add2: getString(data, 'add2'),
        cityCode: getString(data['city_name'], 'code'),
        city: getString(data['city_name'], 'name'),
        state: getString(data['city_name']['state_name'], 'name'),
        country:
            getString(data['city_name']['state_name']['country_name'], 'name'),
        pincode: getString(data, 'pin_code'),
        isLocal: false);
  }
  factory AddressModel.parseItems(Map<String, dynamic> data) {
    return AddressModel(
      cityCode: getString(data, 'code'),
      city: getString(data, 'name'),
      state: getString(data['state_name'], 'name'),
      stateCode: getString(data['state_name'], 'code'),
      country: getString(data['state_name']['country_name'], 'name'),
      countryCode: getString(data['state_name']['country_name'], 'code'),
    );
  }
}

class TaxModel {
  String type = '', code = '', number = '', oldName = '', tag = 'NO';

  TaxModel(
      {this.type = '',
      this.code = '',
      this.oldName = '',
      this.number = '',
      this.tag = 'No'});

  factory TaxModel.parsejson(Map<String, dynamic> data) {
    return TaxModel(
      type: getString(data['tax_name'], 'name'),
      number: getString(data, 'name'),
      oldName: getString(data, 'name'),
      tag: getString(data, 'print_tag') == 'Y' ? 'Yes' : 'No',
      code: getString(data['tax_name'], 'code'),
    );
  }
  factory TaxModel.parseItems(Map<String, dynamic> data) {
    return TaxModel(
      type: getString(data, 'name'),
      code: getString(data, 'code'),
    );
  }
}

class PersonModel {
  String? title = '',
      titleCode = '',
      name = '',
      codePk = '',
      dsgCode = '',
      add1 = '',
      add2 = '',
      city = '',
      cityCode = '',
      state = '',
      stateCode = '',
      country = '',
      countryCode = '',
      pin = '',
      mob1 = '',
      mob2 = '',
      ph = '',
      fax = '',
      email = '',
      url = '',
      active = 'No',
      imageUrl = '';
  bool isLocal;
  File? imagePath;

  PersonModel(
      {this.title = '',
      this.titleCode = '',
      this.name = '',
      this.codePk = '',
      this.dsgCode = '',
      this.add1 = '',
      this.add2 = '',
      this.city = '',
      this.cityCode = '',
      this.state = '',
      this.stateCode = '',
      this.country = '',
      this.countryCode = '',
      this.pin = '',
      this.mob1 = '',
      this.mob2 = '',
      this.ph = '',
      this.fax = '',
      this.email = '',
      this.url = '',
      this.imageUrl = '',
      this.active = 'No',
      this.isLocal = true,
      this.imagePath});

  factory PersonModel.parsejson(Map<String, dynamic> data) {
    return PersonModel(
        title: getString(data['title_name'], 'name'),
        titleCode: getString(data['title_name'], 'code'),
        name: getString(data, 'name'),
        codePk: getString(data, 'code'),
        dsgCode: getString(data, 'dsg_code'),
        add1: getString(data, 'add1'),
        add2: getString(data, 'add2'),
        city: getString(data['city_name'], 'name'),
        cityCode: getString(data['city_name'], 'code'),
        state: getString(data['city_name']['state_name'], 'name'),
        country:
            getString(data['city_name']['state_name']['country_name'], 'name'),
        pin: getString(data, 'pin_code'),
        mob1: getString(data, 'mobile_no1'),
        mob2: getString(data, 'mobile_no2'),
        ph: getString(data, 'ph_no'),
        fax: getString(data, 'fax_no'),
        email: getString(data, 'email_id'),
        url: getString(data, 'url_id'),
        active: getString(data, 'active_tag') == 'Y' ? 'Yes' : 'No',
        imageUrl: getString(data['person_images_single'], 'code'),
        isLocal: false);
  }
}

class SaleTypeModel {
  String compCode = '',
      code = '',
      description = '',
      company = '',
      fromdate = '',
      todate = '';

  SaleTypeModel(
      {this.compCode = '',
      this.code = '',
      this.description = '',
      this.company = '',
      this.fromdate = '',
      this.todate = ''});

  factory SaleTypeModel.parsejson(Map<String, dynamic> data) {
    return SaleTypeModel(
      code: getString(data['sale_name'], 'code'),
      description: getString(data['sale_name'], 'name'),
      compCode: getString(data['company_name'], 'code'),
      company: getString(data['company_name'], 'name'),
      fromdate: getFormattedDate(getString(data, 'from_date'),
          inFormat: 'yyyy-MM-dd hh:mm:ss', outFormat: 'dd MMM yyyy'),
      //fromdate: getString(data, 'from_date'),
      todate: getFormattedDate(getString(data, 'to_date'),
          inFormat: 'yyyy-MM-dd hh:mm:ss', outFormat: 'dd MMM yyyy'),
      // todate: getString(data, 'to_date'),
    );
  }
  factory SaleTypeModel.parseItems(Map<String, dynamic> data) {
    return SaleTypeModel(
      code: getString(data, 'code'),
      description: getString(data, 'name'),
    );
  }
}

class PurchaseModel {
  String code = '',
      description = '',
      tdscode = '',
      purType = '',
      compCode = '',
      company = '',
      tdsname = '',
      tdstype = '',
      fromdate = '',
      todate = '';
  PurchaseModel(
      {this.code = '',
      this.description = '',
      this.tdscode = '',
      this.compCode = '',
      this.tdstype = '',
      this.company = '',
      this.tdsname = '',
      this.purType = '',
      this.fromdate = '',
      this.todate = ''});
  factory PurchaseModel.parsejson(Map<String, dynamic> data) {
    return PurchaseModel(
      code: getString(data['pur_name'], 'code'),
      description: getString(data['pur_name'], 'name'),
      company: getString(data['company_name'], 'name'),
      compCode: getString(data['company_name'], 'code'),
      tdsname: getString(data['tds_detail_single'], 'name'),
      tdscode: getString(data, 'tds_code'),
      tdstype: getString(data, 'tds_type'),
      fromdate: getFormattedDate(getString(data, 'from_date'),
          inFormat: 'yyyy-MM-dd hh:mm:ss', outFormat: 'dd MMM yyyy'),
      todate: getFormattedDate(getString(data, 'to_date'),
          inFormat: 'yyyy-MM-dd hh:mm:ss', outFormat: 'dd MMM yyyy'),
    );
  }
  factory PurchaseModel.parseItems(Map<String, dynamic> data) {
    return PurchaseModel(
      description: getString(data, 'name'),
      code: getString(data, 'code'),
    );
  }
  factory PurchaseModel.parsejsonBody(Map<String, dynamic> data) {
    return PurchaseModel(
        tdsname: getString(data['tds_type_detail'], 'name'),
        tdscode: getString(data, 'code'),
        tdstype: getString(data, 'tax_per'));
  }
}

class PlaceModel {
  String? cityCode;
  String? city;
  String? state;
  String? stateCode;
  String? country;
  String? countryCode;
  PlaceModel({
    this.cityCode,
    this.city,
    this.state,
    this.stateCode,
    this.country,
    this.countryCode,
  });
  factory PlaceModel.parsejson(Map<String, dynamic> data) {
    return PlaceModel(
      cityCode: getString(data, 'code'),
      city: getString(data, 'name'),
      state: getString(data['state_name'], 'name'),
      stateCode: getString(data['state_name'], 'code'),
      country: getString(data['state_name']['country_name'], 'name'),
      countryCode: getString(data['state_name']['country_name'], 'code'),
    );
  }
}

class TitleModel {
  String? code;
  String? title;

  TitleModel({this.code, this.title});
  factory TitleModel.parsejson(Map<String, dynamic> data) {
    return TitleModel(
        code: getString(data, 'code'), title: getString(data, 'name'));
  }
}

class BsGroupModel {
  String? code;
  String? name;

  BsGroupModel({this.code, this.name});
  factory BsGroupModel.parsejson(Map<String, dynamic> data) {
    return BsGroupModel(
        code: getString(data, 'code'), name: getString(data, 'name'));
  }
}

enum WidgetType {
  AccountMaster,
  Address,
  Bank,
  Communication,
  TaxDetail,
  AccountCompany,
  SaleType,
  PurchaseType,
  ContactPerson,
}
