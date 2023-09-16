import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
//import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/datamodel/AddressModel.dart';
import 'package:dataproject2/datamodel/ContactUserModel.dart';
import 'package:dataproject2/datamodel/DataModel.dart';
import 'package:dataproject2/datamodel/EmployeeModel.dart';
import 'package:dataproject2/datamodel/UserModel.dart';
import 'package:dataproject2/gatePass/GatePass.dart';
import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/newmodel/QCompanyModel.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:dataproject2/utils/uppercase_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

class CreateGatePass extends StatefulWidget {
  final PassType? passType;
  final bool isEditMode;
  final String? id;

  /// [passType], [id] and [isEditMode] params are required for edit mode
  const CreateGatePass(
      {Key? key, this.passType, this.id, this.isEditMode = false})
      : super(key: key);

  @override
  _CreateGatePassState createState() => _CreateGatePassState();
}

class _CreateGatePassState extends State<CreateGatePass> with NetworkResponse {
  PassType? _passType = PassType.Employee;

  /// Controllers
  final serialNoController = TextEditingController();
  final dateController = TextEditingController();
  final outDateController = TextEditingController();
  final companyController = TextEditingController(text: 'Select Company');
  final employeeController = TextEditingController();
  final purposeController = TextEditingController();
  final otherPurposeController = TextEditingController();
  final placeToVisitController = TextEditingController();
  final approvalUserController = TextEditingController();

  final timeController = TextEditingController();
  final nameController = TextEditingController();
  final personToMeetController = TextEditingController();
  final contactController = TextEditingController();
  final totalPersonController = TextEditingController(text: '1');
  final remarksController = TextEditingController();
  final addressController = TextEditingController();
  final visitorCompController = TextEditingController();

  String? compCode = '';
  String empCode = '';
  String addressCode = '';
  String address = '';
  String srNo = '';
  String? selectedApprovalUser = '';
  final _now = DateTime.now();

  List<AddressModel> contactAddressPartyList = [];
  List<ContactUserModel> contactUserList = [];
  List<AddressModel> addressPartyList = [];
  List<EmployeeModel> employeeList = [];
  List<QCompanyModel> companyList = [];
  List<String> placeToVisitList = [];
  List<UserModel> usersList = [];
  List<String> personToMeet = [];
  List<String> purposeList = [
    'Interview',
    'Official',
    'Personal',
    'Meeting',
    'Other'
  ];

  GlobalKey<FormState> _employeeFormKey = GlobalKey();
  GlobalKey<FormState> _visitorFormKey = GlobalKey();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  FocusNode _otpFocusKey = FocusNode();
  bool isOtpSent = false;
  File? imageFile;
  String? _cityCode = '';
  String receivedOtp = '';
  String visitorImageCode = '';
  String imageBaseUrl = '';
  String empBaseUrl = '';
  List<DataModel> _cityList = [];
  List<EmployeeModel> _selectedEmpList = [];

  bool? hasPerm = false;
  bool? hasEditPerm = false;
  bool? hasEmpPerm = false;
  bool? hasEmpEditPerm = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    _passType = widget.passType;
    dateController.text = _now.format('dd/MM/yyyy');
    outDateController.text = dateController.text;
    timeController.text = DateFormat('hh:mm a').format(_now);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.isEditMode) {
        if (widget.passType == PassType.Visitor) {
          _getPassDetails();
        } else {
          _getEmpPassDetails();
        }
      }
      _getCity();
      _getUsersList();
      _getCompanyList();
      _getPlaceToVisit();
      _getPersonToMeet();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clearFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(widget.passType == PassType.Visitor
              ? widget.isEditMode
                  ? 'Edit Gate Pass'
                  : 'Create Visitor Gate Pass'
              : widget.isEditMode
                  ? 'Edit Employee Gate Pass'
                  : 'Create Employee Gate Pass'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              if (_passType == PassType.Employee)
                Form(
                  /// Employee Gate Pass
                  key: _employeeFormKey,
                  child: Column(
                    children: [
                      /// Serial No.
                      TextFormField(
                        validator: (val) => val!.trim().isEmpty
                            ? 'Serial No. cannot be empty'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: serialNoController,
                        readOnly: true,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Auto Generated Serial No.',
                            labelText: 'Serial No.',
                            border: OutlineInputBorder()),
                      ),

                      SizedBox(height: 16),

                      /// Date
                      TextFormField(
                        validator: (val) =>
                            val!.trim().isEmpty ? 'Date cannot be empty' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Date',
                            labelText: 'Date',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 16),

                      /// Out Date
                      TextFormField(
                        validator: (val) => val!.trim().isEmpty
                            ? 'Out date cannot be empty'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: outDateController,
                        readOnly: true,
                        onTap: _outDate,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.date_range),
                            isDense: true,
                            hintText: 'Out Date',
                            labelText: 'Out Date',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 16),

                      /// Company Code
                      TextFormField(
                        validator: (val) => val!.trim().isEmpty
                            ? 'Please select company'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: companyController,
                        readOnly: true,
                        onTap: () {
                          if (!widget.isEditMode) _companyBottomSheet(context);
                        },
                        decoration: InputDecoration(
                            suffixIcon: !widget.isEditMode
                                ? Icon(Icons.arrow_drop_down)
                                : null,
                            isDense: true,
                            hintText: 'Company',
                            labelText: 'Company',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 16),

                      TypeAheadFormField<EmployeeModel>(
                        validator: (val) => _selectedEmpList.isEmpty
                            ? 'Please select employee'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        itemBuilder: (BuildContext context, itemData) {
                          return ListTile(
                            trailing: Text(itemData.lscode!),
                            leading: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: itemData.image!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: FadeInImage.assetNetwork(
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                          placeholder:
                                              'images/loading_placeholder.png',
                                          image:
                                              '$empBaseUrl${itemData.image}.png'),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        'images/noImage.png',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                            ),
                            title: Text(itemData.name!,
                                style: TextStyle(
                                    color: itemData.isSelected
                                        ? Colors.grey
                                        : Colors.black)),
                            subtitle: Text(
                                '${itemData.deptName} (${itemData.desgName})\n${itemData.id}'),
                          );
                        },
                        onSuggestionSelected: (sg) {
                          if (sg.isSelected) return;
                          setState(() {
                            sg.isSelected = true;
                            _selectedEmpList.insert(0, sg);
                          });
                        },
                        suggestionsCallback: (String pattern) {
                          return _getFilteredEmployee(pattern);
                        },
                        textFieldConfiguration: TextFieldConfiguration(
                            textAlign: TextAlign.start,
                            controller: employeeController,
                            autofocus: false,
                            onChanged: (string) {
                              empCode = '';
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                hintText: 'Employee',
                                labelText: 'Employee',
                                isDense: true)),
                      ),

                      SizedBox(height: 16),

                      Visibility(
                        visible: _selectedEmpList.isNotEmpty,
                        child: Container(
                          width: 100.0.w,
                          height: 200,
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _selectedEmpList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8, top: 8),
                                        child: Container(
                                            width: 200,
                                            padding: EdgeInsets.only(
                                                left: 6, right: 4),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Card(
                                              elevation: 2,
                                              child: Column(children: [
                                                SizedBox(height: 7),
                                                _selectedEmpList[index]
                                                        .image!
                                                        .isNotEmpty
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        child: FadeInImage.assetNetwork(
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.fill,
                                                            placeholder:
                                                                'images/loading_placeholder.png',
                                                            image:
                                                                '$empBaseUrl${_selectedEmpList[index].image}.png'),
                                                      )
                                                    : Image.asset(
                                                        'images/noImage.png',
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.fill,
                                                      ),
                                                SizedBox(height: 7),
                                                Table(
                                                  children: [
                                                    TableRow(children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 8, 1, 4),
                                                        child: Text(
                                                            'Employee Code:'),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                1, 8, 8, 4),
                                                        child: Text(
                                                            _selectedEmpList[
                                                                    index]
                                                                .id!,
                                                            maxLines: 2),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 0, 1, 4),
                                                        child: Text('Name:'),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                1, 0, 8, 4),
                                                        child: Text(
                                                            _selectedEmpList[
                                                                    index]
                                                                .name!,
                                                            maxLines: 2),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 0, 1, 8),
                                                        child: Text('Dept:'),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                1, 0, 8, 8),
                                                        child: Text(
                                                            _selectedEmpList[
                                                                    index]
                                                                .deptName!,
                                                            maxLines: 2),
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              ]),
                                            )),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 4,
                                        child: InkWell(
                                          onTap: () {
                                            var empId =
                                                _selectedEmpList[index].id;
                                            employeeList.forEach((element) {
                                              if (element.id == empId)
                                                element.isSelected = false;
                                            });
                                            setState(() {
                                              _selectedEmpList.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColor.appRed,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(Icons.clear,
                                                  size: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                        ),
                      ),

                      Visibility(
                          visible: _selectedEmpList.isNotEmpty,
                          child: SizedBox(height: 16)),

                      /// Purpose
                      TextFormField(
                        validator: (val) =>
                            val!.trim().isEmpty ? 'Please enter Purpose' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: purposeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Purpose',
                            labelText: 'Purpose',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 16),

                      /// Place To Visit
                      TextFormField(
                        validator: (val) => val!.trim().isEmpty
                            ? 'Please enter Place to visit'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: placeToVisitController,
                        keyboardType: TextInputType.streetAddress,
                        readOnly: true,
                        onTap: () {
                          _placeToVisitSheet(context);
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            isDense: true,
                            hintText: 'Place To Visit',
                            labelText: 'Place To Visit',
                            border: OutlineInputBorder()),
                      ),

                      SizedBox(height: 16),

                      /// Approval User
                      TextFormField(
                        validator: (val) => val!.trim().isEmpty
                            ? 'Please select Approval User'
                            : null,
                        controller: approvalUserController,
                        readOnly: true,
                        onTap: () {
                          _approvalUserBottomSheet(context);
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            isDense: true,
                            hintText: 'Approval User',
                            labelText: 'Approval User',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),

                      Visibility(
                        visible: widget.isEditMode,
                        child: Visibility(
                          visible: hasEmpEditPerm!,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_employeeFormKey.currentState!.validate()) {
                                  _updateEmployeePass();
                                }
                              },
                              child: Text('Update')),
                        ),
                      ),

                      Visibility(
                        visible: !widget.isEditMode,
                        child: Visibility(
                          visible: hasEmpPerm!,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_employeeFormKey.currentState!.validate()) {
                                  _submitEmployeePass();
                                }
                              },
                              child: Text('Submit')),
                        ),
                      )
                    ],
                  ),
                )
              else
                Form(
                  /// Visitor Gate Pass
                  key: _visitorFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(64),
                                child: _getImageWidget(),
                              ),
                              Visibility(
                                visible: hasPerm! || hasEditPerm!,
                                child: Positioned(
                                    top: 0,
                                    right: 5,
                                    child: InkWell(
                                      onTap: () {
                                        _selectVisitorImage();
                                      },
                                      child: Container(
                                          height: 28,
                                          width: 28,
                                          decoration: BoxDecoration(
                                              color: AppColor.appRed,
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          child: Icon(Icons.edit,
                                              color: Colors.white, size: 16)),
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      /// Slip No.
                      TextFormField(
                        validator: (val) => val!.trim().isEmpty
                            ? 'Slip no cannot be empty'
                            : null,
                        controller: serialNoController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Auto Generated Slip No.',
                            labelText: 'Slip No.',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 16),

                      /// Company Code
                      TextFormField(
                        validator: (val) => compCode!.trim().isEmpty
                            ? 'Please select company'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: companyController,
                        readOnly: true,
                        onTap: () {
                          if (!widget.isEditMode) _companyBottomSheet(context);
                        },
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Company',
                            labelText: 'Company',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 16),

                      /// Date
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: dateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Date',
                                  labelText: 'Date',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: timeController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Time',
                                  labelText: 'Time',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      /// Contact No
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) => val!.trim().isEmpty
                                  ? 'Please enter contact no'
                                  : (val.length < 10
                                      ? 'Please enter valid contact no.'
                                      : null),
                              controller: contactController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              maxLines: 1,
                              onChanged: (v) {
                                if (v.length == 10) {
                                  _searchUserByContact(v, 'mobile');
                                } else {
                                  contactUserList.clear();
                                  setState(() {});
                                }
                              },
                              textInputAction: TextInputAction.search,
                              onFieldSubmitted: (v) {
                                _searchUserByContact(v, 'mobile');
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  prefixText: '+91',
                                  isDense: true,
                                  hintText: 'Contact No',
                                  labelText: 'Contact No',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      Visibility(
                        visible: contactUserList.isNotEmpty,
                        child: LimitedBox(
                          maxWidth: MediaQuery.of(context).size.width,
                          maxHeight: 296,
                          child: ListView.builder(
                              itemCount: contactUserList.length,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: (MediaQuery.of(context).size.width /
                                          100) *
                                      55,
                                  height:
                                      MediaQuery.of(context).size.height * 25,
                                  child: InkWell(
                                    onTap: () {
                                      contactUserList.forEach((element) {
                                        if (element.isSelected)
                                          element.isSelected = false;
                                      });

                                      setState(() {
                                        imageFile = null;
                                        contactUserList[index].isSelected =
                                            true;
                                        visitorImageCode =
                                            contactUserList[index].image;
                                        nameController.text =
                                            contactUserList[index]
                                                .name
                                                .toUpperCase();
                                        purposeController.text =
                                            contactUserList[index]
                                                .purpose
                                                .toUpperCase();
                                        otherPurposeController.text =
                                            contactUserList[index]
                                                .otherPurpose
                                                .toUpperCase();
                                        personToMeetController.text =
                                            contactUserList[index]
                                                .personToMeet
                                                .toUpperCase();
                                        totalPersonController.text =
                                            contactUserList[index].totalPerson;
                                        contactController.text =
                                            contactUserList[index].contact;
                                        visitorCompController.text =
                                            contactUserList[index]
                                                .company!
                                                .toUpperCase();
                                        addressController.text =
                                            contactUserList[index]
                                                .address
                                                .toUpperCase();
                                        addressCode =
                                            contactUserList[index].addressCode;
                                        var cityCode =
                                            contactUserList[index].cityCode;

                                        _cityList.forEach((element) {
                                          if (element.id == cityCode) {
                                            _cityCode = cityCode;
                                            _cityController.text =
                                                element.name!;
                                            _stateController.text = element
                                                .stateName!
                                                .toUpperCase();
                                          }
                                        });
                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      color: contactUserList[index].isSelected
                                          ? Colors.red[50]
                                          : Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              child: FadeInImage.assetNetwork(
                                                  width: 90,
                                                  height: 90,
                                                  fit: BoxFit.fill,
                                                  placeholder:
                                                      'images/loading_placeholder.png',
                                                  image:
                                                      '$imageBaseUrl${contactUserList[index].image}.png'),
                                            ),
                                            Table(
                                              children: [
                                                /// Name
                                                TableRow(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text('Name'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text(
                                                      contactUserList[index]
                                                          .name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ]),

                                                /// In Date
                                                TableRow(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text('In Date'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text(
                                                      contactUserList[index]
                                                          .inDate,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ]),

                                                /// Purpose
                                                TableRow(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text('Purpose'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text(
                                                      contactUserList[index]
                                                          .purpose,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ]),

                                                /// Person To Meet
                                                TableRow(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child:
                                                        Text('Person To Meet'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text(
                                                      contactUserList[index]
                                                          .personToMeet,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ]),

                                                /// Total Person
                                                TableRow(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text('Total Person'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text(
                                                      contactUserList[index]
                                                          .totalPerson,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ]),

                                                /// Address
                                                TableRow(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text('Address'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 2),
                                                    child: Text(
                                                      '${contactUserList[index].company} ${contactUserList[index].address}',
                                                      maxLines: 4,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ])
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),

                      Visibility(
                          visible: contactUserList.isNotEmpty,
                          child: SizedBox(height: 4)),

                      Visibility(
                          visible: contactUserList.isNotEmpty,
                          child: Text(
                            '${contactUserList.length} Results',
                            style: TextStyle(
                              color: CupertinoColors.secondaryLabel,
                              fontSize: 15,
                            ),
                          )),

                      Visibility(
                          visible: contactUserList.isNotEmpty,
                          child: SizedBox(height: 8)),

                      /// Name
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) => val!.trim().isEmpty
                                  ? 'Please enter name'
                                  : null,
                              controller: nameController,
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                              ],
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Name',
                                  labelText: 'Name',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Visibility(
                              visible: !widget.isEditMode,
                              child: SizedBox(width: 6)),
                          Visibility(
                            visible: !widget.isEditMode,
                            child: InkWell(
                              onTap: () {
                                _searchUserByContact(
                                    nameController.text, 'name');
                              },
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[400]!, width: 1.5),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(Icons.search, color: Colors.grey),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16),

                      /// Visitor's Company
                      Row(
                        children: [
                          Flexible(
                            child: TypeAheadFormField<AddressModel>(
                              itemBuilder: (BuildContext context, itemData) {
                                return itemData.isVisitor
                                    ? ListTile(
                                        title: Text(itemData.address),
                                      )
                                    : ListTile(
                                        title: Text(itemData.name),
                                        subtitle: Text('${itemData.address}'),
                                      );
                              },
                              onSuggestionSelected: (sg) {
                                setState(() {
                                  visitorCompController.text = sg.name;
                                  addressController.text = sg.address;
                                  addressCode = sg.id;
                                  _cityCode = sg.cityCode;
                                  _cityController.text = sg.city;
                                  _stateController.text = sg.state;
                                });
                              },
                              suggestionsCallback: (String pattern) {
                                return _getFilteredAddress(pattern);
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                  textAlign: TextAlign.start,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  controller: visitorCompController,
                                  autofocus: false,
                                  onChanged: (string) {
                                    address = string;
                                    setState(() {
                                      addressCode = '';
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      hintText: 'Visitor\'s Company',
                                      labelText: 'Visitor\'s Company',
                                      isDense: true)),
                            ),
                          ),
                          Visibility(
                              visible: visitorCompController.text.isNotEmpty,
                              child: SizedBox(width: 8)),
                          Visibility(
                              visible: visitorCompController.text.isNotEmpty,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      visitorCompController.clear();
                                    });
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: AppColor.appRed,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(Icons.clear,
                                          size: 14, color: Colors.white)))),
                        ],
                      ),
                      SizedBox(height: 16),

                      /// Address Controller
                      Row(
                        children: [
                          Flexible(
                            child: TypeAheadFormField<AddressModel>(
                              validator: (val) =>
                                  val!.isEmpty ? 'Please select address' : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              itemBuilder: (BuildContext context, itemData) {
                                return itemData.isVisitor
                                    ? ListTile(
                                        title: Text(itemData.address),
                                      )
                                    : ListTile(
                                        title: Text(itemData.name),
                                        subtitle: Text('${itemData.address}'),
                                      );
                              },
                              onSuggestionSelected: (sg) {
                                setState(() {
                                  visitorCompController.text = sg.name;
                                  addressController.text = sg.address;
                                  addressCode = sg.id;
                                  _cityCode = sg.cityCode;
                                  _cityController.text = sg.city;
                                  _stateController.text = sg.state;
                                });
                              },
                              suggestionsCallback: (String pattern) {
                                return _getFilteredAddress(pattern);
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                  textAlign: TextAlign.start,
                                  controller: addressController,
                                  autofocus: false,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  onChanged: (string) {
                                    address = string;
                                    logIt('AddressCont-> $address');
                                    logIt('addressCode-> $addressCode');
                                    setState(() {
                                      addressCode = '';
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      hintText: 'Address',
                                      labelText: 'Address',
                                      isDense: true)),
                            ),
                          ),
                          Visibility(
                              visible: addressController.text.isNotEmpty,
                              child: SizedBox(width: 8)),
                          Visibility(
                              visible: addressController.text.isNotEmpty,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      addressController.clear();
                                    });
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: AppColor.appRed,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(Icons.clear,
                                          size: 14, color: Colors.white)))),
                        ],
                      ),
                      SizedBox(height: 16),

                      /// City
                      TextFormField(
                        controller: _cityController,
                        readOnly: true,
                        onTap: () {
                          _showCitySheet();
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            value!.trim().isEmpty ? 'City is required' : null,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            labelText: 'City',
                            labelStyle: TextStyle(fontSize: 18),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(),
                            isDense: true),
                      ),
                      SizedBox(height: 12),

                      /// State
                      TextFormField(
                        controller: _stateController,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            value!.trim().isEmpty ? 'State is required' : null,
                        decoration: InputDecoration(
                            //suffixIcon: Icon(Icons.arrow_drop_down),
                            labelText: 'State',
                            labelStyle: TextStyle(fontSize: 18),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(),
                            isDense: true),
                      ),
                      SizedBox(height: 12),

                      /// Purpose
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) => val!.trim().isEmpty
                                  ? 'Please enter purpose'
                                  : null,
                              controller: purposeController,
                              readOnly: true,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                              ],
                              onTap: () {
                                _purposeBottomSheet(context);
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  isDense: true,
                                  hintText: 'Purpose',
                                  labelText: 'Purpose',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Visibility(
                              visible: purposeController.text.isNotEmpty,
                              child: SizedBox(width: 8)),
                          Visibility(
                              visible: purposeController.text.isNotEmpty,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      purposeController.clear();
                                    });
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: AppColor.appRed,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(Icons.clear,
                                          size: 14, color: Colors.white)))),
                        ],
                      ),
                      SizedBox(height: 16),

                      /// Other Purpose
                      Visibility(
                        visible: purposeController.text == 'Other',
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) => val!.trim().isEmpty
                              ? 'Please enter other  purpose'
                              : null,
                          controller: otherPurposeController,
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                          ],
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Other Purpose',
                              labelText: 'Other Purpose',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Visibility(
                          visible: purposeController.text == 'Other',
                          child: SizedBox(height: 16)),

                      /// Person To Meet
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) => val!.trim().isEmpty
                                  ? 'This field cannot be empty'
                                  : null,
                              controller: personToMeetController,
                              readOnly: true,
                              textCapitalization: TextCapitalization.characters,
                              onTap: () {
                                _personToMeetSheet(context);
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  isDense: true,
                                  hintText: 'Person To Meet',
                                  labelText: 'Person To Meet',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Visibility(
                              visible: personToMeetController.text.isNotEmpty,
                              child: SizedBox(width: 8)),
                          Visibility(
                              visible: personToMeetController.text.isNotEmpty,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      personToMeetController.clear();
                                    });
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: AppColor.appRed,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(Icons.clear,
                                          size: 14, color: Colors.white)))),
                        ],
                      ),
                      SizedBox(height: 16),

                      /// Total Person
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) => val!.trim().isEmpty
                            ? 'Please enter total person'
                            : null,
                        controller: totalPersonController,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (v) {
                          if (v.trim().length > 0) {
                            clearFocus(context);
                          }
                        },
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Total Person',
                            labelText: 'Total Person',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 16),

                      /// Remarks
                      TextFormField(
                        controller: remarksController,
                        keyboardType: TextInputType.streetAddress,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Remarks',
                            labelText: 'Remarks',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 16),

                      /// Submit Button
                      widget.isEditMode
                          ? Visibility(
                              visible: hasEditPerm!,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_visitorFormKey.currentState!
                                            .validate()) {
                                          _updateVisitorPass();
                                        }
                                      },
                                      child: Text('Update')),
                                ],
                              ),
                            )
                          : Visibility(
                              visible: hasPerm!,
                              child: AnimatedSwitcher(
                                duration: Duration(seconds: 1),
                                child: !isOtpSent
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                if (_visitorFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  _sendVisitorOtp();
                                                }
                                              },
                                              child: Text('Submit')),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Text('Enter OTP',
                                              style: TextStyle(fontSize: 18)),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: PinCodeTextField(
                                                    focusNode: _otpFocusKey,
                                                    appContext: context,
                                                    length: 5,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    pinTheme: PinTheme.defaults(
                                                        selectedColor:
                                                            AppColor.appRed,
                                                        activeColor:
                                                            Colors.black26),
                                                    onChanged: (value) {},
                                                    onCompleted: (v) {
                                                      logIt('onComp-> $v');
                                                      if (v.trim() ==
                                                          receivedOtp)
                                                        _submitVisitorPass();
                                                      else
                                                        showAlert(
                                                            context,
                                                            'Otp is incorrect',
                                                            'Error');
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                      SizedBox(height: 20),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future _outDate() async {
    try {
      final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: _now,
          firstDate: _now,
          lastDate: _now.add(Duration(days: 30)));

      if (selectedDate == null) return;
      setState(() {
        outDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    } catch (e, stack) {
      print("an Error occurred $e $stack");
    }
  }

  _getImageWidget() {
    if (imageFile == null && visitorImageCode.isEmpty) {
      return Image.asset('images/noImage.png', height: 128, width: 128);
    } else if (imageFile != null) {
      return Image.file(
        imageFile!,
        height: 128,
        width: 128,
        fit: BoxFit.fill,
      );
    } else if (visitorImageCode.isNotEmpty) {
      return Image.network(
        '$imageBaseUrl$visitorImageCode.png',
        height: 128,
        width: 128,
        fit: BoxFit.fill,
      );
    }
  }

  _getCompanyList() {
    Map jsonBody = {
      'user_id': getUserId(),
      'tid': widget.passType == PassType.Employee
          ? Permissions.EMP_GATEPASS
          : Permissions.VISITOR_GATE_ENTRY,
      'mode_flag': 'A,I,M'
    };
    WebService.fromApi(AppConfig.getCompany, this, jsonBody)
        .callPostService(context);
  }

  _getUsersList() {
    Map jsonBody = {'user_id': getUserId()};
    WebService.fromApi(AppConfig.getApprovalUsers, this, jsonBody)
        .callPostService(context);
  }

  _getEmployeeCode() {
    if (_passType == PassType.Employee) {
      Map data = {
        'user_id': getUserId(),
        'comp_code': compCode == '3' ? '99' : compCode,
      };
      WebService.fromApi(AppConfig.getEmployeeList, this, data)
          .callPostService(context);
    } else {
      Map data = {
        'user_id': getUserId(),
        'comp_code': compCode, //== '3' ? '99' : compCode,
      };
      WebService.fromApi(AppConfig.getPartyList, this, data)
          .callPostService(context);
    }
  }

  _submitEmployeePass() {
    Map jsonBody = {
      'user_id': getUserId(),
      'sno': serialNoController.text,
      'srl': srNo,
      'emp_code': _getEmpIds(),
      'place_to_visit': placeToVisitController.text,
      'purpose': purposeController.text,
      'comp_code': compCode == '3' ? '99' : compCode, //,
      'approved_user': selectedApprovalUser,
      'out_date': outDateController.text
          .toDateTime(format: 'dd/MM/yyyy')
          .format('yyyy-MM-dd')
    };

    logIt('submitEmpGatePass-> $jsonBody');

    WebService.fromApi(AppConfig.submitEmpPass, this, jsonBody)
        .callPostService(context);
  }

  /// Todo Change url
  _updateEmployeePass() {
    Map jsonBody = {
      'user_id': getUserId(),
      'sno': serialNoController.text,
      'srl': srNo,
      'emp_code': _getEmpIds(),
      'place_to_visit': placeToVisitController.text,
      'purpose': purposeController.text,
      'comp_code': compCode == '3' ? '99' : compCode, //,
      'approved_user': selectedApprovalUser,
      'code_pk': widget.id,
      'out_date': outDateController.text
          .toDateTime(format: 'dd/MM/yyyy')
          .format('yyyy-MM-dd')
    };

    WebService.fromApi(AppConfig.editEmpPass, this, jsonBody)
        .callPostService(context);
  }

  String _getEmpIds() {
    String data = '';

    _selectedEmpList.forEach((element) {
      if (data.isEmpty) {
        data = '${element.id}';
      } else {
        data = '$data,${element.id}';
      }
    });

    return data;
  }

  _sendVisitorOtp() {
    if (imageFile == null && visitorImageCode.isEmpty) {
      showAlert(context, 'Please select visitor image', 'Error');
      return;
    }

    Map jsonBody = {'user_id': getUserId(), 'contact': contactController.text};

    WebService.fromApi(AppConfig.sendVisitorOtp, this, jsonBody)
        .callPostService(context);
  }

  _getCity() {
    Map jsonBody = {
      'user_id': getUserId(),
      'table_name': 'CITY_MASTER',
      //'state_code': _stateCode
    };
    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody,
            reqCode: 'CITY_MASTER')
        .callPostService(context);
  }

  _submitVisitorPass() {
    try {
      Map jsonBody = {
        'user_id': getUserId(),
        'slipno': serialNoController.text,
        'sno': srNo,
        'name': nameController.text.trim(),
        'contact': contactController.text,
        'comp_code': compCode, //== '3' ? '99' : compCode,
        'company_name': visitorCompController.text,
        // 'address_type': addressCode.isEmpty ? 'N' : 'Y',
        'address_type': 'N',
        'remarks': remarksController.text,
        'total_person': totalPersonController.text,
        'person_to_meet': personToMeetController.text,
        'purpose': purposeController.text,
        'other_purpose': otherPurposeController.text,
        'indate': _now.format('yyyy-MM-dd'),
        'intime': timeController.text,
        'otp': receivedOtp,
        'city_code': _cityCode,
        'visitor_images_code_pk': visitorImageCode,
        'address': addressController.text,
        //'address': addressCode.isEmpty ? addressController.text : addressCode,
      };

      logIt('Params -> $jsonBody ');

      if (visitorImageCode.trim().isNotEmpty) {
        WebService.fromApi(AppConfig.submitVisitorPass, this, jsonBody)
            .callPostService(context);
      } else {
        WebService.multipartApi(AppConfig.submitVisitorPass, this, jsonBody,
                imageFile!.absolute.path)
            .callMultipartPostService(context, fileName: 'filename');
      }
    } catch (err, stack) {
      logIt('submitVisitorPass-> $err $stack');
    }
  }

  _updateVisitorPass() {
    if (imageFile == null && visitorImageCode.isEmpty) {
      showAlert(context, 'Please select visitor image', 'Error');
    }
    try {
      Map jsonBody = {
        'user_id': getUserId(),
        'slipno': serialNoController.text,
        'sno': srNo,
        'name': nameController.text.trim(),
        'contact': contactController.text,
        'comp_code': compCode,
        'company_name': visitorCompController.text,
        //'address_type': addressCode.isEmpty ? 'N' : 'Y',
        'address_type': 'N',
        'remarks': remarksController.text,
        'total_person': totalPersonController.text,
        'person_to_meet': personToMeetController.text,
        'purpose': purposeController.text,
        'other_purpose': otherPurposeController.text,
        'city_code': _cityCode,
        'visitor_images_code_pk': visitorImageCode,
        'address': addressController.text,
        // 'address': addressCode.isEmpty ? addressController.text : addressCode,
      };

      logIt('Params -> $jsonBody ');

      if (visitorImageCode.trim().isNotEmpty) {
        WebService.fromApi(AppConfig.editVisitorPass, this, jsonBody)
            .callPostService(context);
      } else {
        WebService.multipartApi(AppConfig.editVisitorPass, this, jsonBody,
                imageFile!.absolute.path)
            .callMultipartPostService(context, fileName: 'filename');
      }
    } catch (err, stack) {
      logIt('submitVisitorPass-> $err $stack');
    }
  }

  _getPlaceToVisit() {
    Map data = {
      'user_id': getUserId(),
    };
    WebService.fromApi(AppConfig.placeToVisit, this, data)
        .callPostService(context);
  }

  _getPersonToMeet() {
    Map data = {
      'user_id': getUserId(),
    };
    WebService.fromApi(AppConfig.personToMeet, this, data)
        .callPostService(context);
  }

  _searchUserByContact(String contact, String type) {
    if (contact.trim().isEmpty) return;

    Map data = {'user_id': getUserId(), 'contact': contact, 'type': type};

    WebService.fromApi(AppConfig.contactVisitorSearch, this, data)
        .callPostService(context);

    clearFocus(context);
  }

  _getPassDetails() {
    Map jsonBody = {'user_id': getUserId(), 'slipno': widget.id};

    WebService.fromApi(AppConfig.getVisitorPassDetail, this, jsonBody)
        .callPostService(context);
  }

  _getEmpPassDetails() {
    Map jsonBody = {'user_id': getUserId(), 'code_pk': widget.id};

    WebService.fromApi(AppConfig.getEmployeePassDetail, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.submitVisitorPass:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GatePass(
                            passType: PassType.Visitor,
                            compId: compCode,
                            entryby: getUserId(),
                            isDirectView: true)));
              });
            } else {
              showAlert(context, data['message'], 'Error!');
            }
          }
          break;

        case AppConfig.submitEmpPass:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GatePass(
                            passType: PassType.Employee,
                            compId: compCode == '3' ? '99' : compCode,
                            entryby: getUserId(),
                            isDirectView: true)));
              });
            } else {
              showAlert(context, data['message'], 'Error!');
            }
          }
          break;

        case AppConfig.getPartyList:
          {
            var data = jsonDecode(response!);

            logIt('onResponse getPartyList-> $data ');

            if (data['error'] == 'false') {
              if (!widget.isEditMode)
                srNo = getString(data, 'visitor_sno').toString();
              if (!widget.isEditMode)
                serialNoController.text =
                    getString(data, 'visitor_slip').toString();

              var content = data['content'] as List;
              var visitor = data['visitors'] as List;
              addressPartyList.clear();

              addressPartyList.addAll(
                  content.map((e) => AddressModel.parseAddress(e)).toList());

              addressPartyList.addAll(visitor
                  .map((e) => AddressModel.parseVisitorAddress(e))
                  .toList());

              setState(() {});
            }
          }
          break;

        case AppConfig.getEmployeeList:
          {
            var data = jsonDecode(response!);

            logIt('onResponse Pass-> $data ');

            if (data['error'] == 'false') {
              empBaseUrl = getString(data, 'image_png_path');

              srNo = getString(data, 'emp_srl').toString();
              serialNoController.text = getString(data, 'emp_slip').toString();

              var content = data['content'] as List;
              employeeList.clear();

              employeeList.addAll(
                  content.map((e) => EmployeeModel.fromJSON(e)).toList());

              setState(() {});
            }
          }
          break;

        case AppConfig.getCompany:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              companyList.clear();

              companyList.add(QCompanyModel(
                  id: '',
                  address1: '',
                  address2: '',
                  logoName: '',
                  name: 'Select Company'));

              companyList.addAll(
                  content.map((e) => QCompanyModel.fromJson(e)).toList());

              if (widget.passType == PassType.Employee)
                companyList.removeWhere((element) => element.id == '3');
              setState(() {});
            }
          }
          break;

        case AppConfig.getApprovalUsers:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              usersList.clear();

              usersList
                  .addAll(content.map((e) => UserModel.parseUser(e)).toList());

              setState(() {});
            }
          }
          break;

        case AppConfig.placeToVisit:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              content.forEach((element) {
                placeToVisitList.add(element);
              });
            }
          }
          break;

        case AppConfig.personToMeet:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              content.forEach((element) {
                personToMeet.add(element);
              });
            }
          }
          break;

        case AppConfig.contactVisitorSearch:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              contactUserList.clear();

              contactUserList.addAll(
                  content.map((e) => ContactUserModel.parse(e)).toList());

              imageBaseUrl = getString(data, 'image_tiff_path');
              // contactAddressPartyList.clear();

              /// Adding Address of Searched Visitor.

              contactUserList.sort((a, b) => b.inDate
                  .toDateTime(format: 'dd MMM yyyy hh:mm a')
                  .compareTo(
                      a.inDate.toDateTime(format: 'dd MMM yyyy hh:mm a')));

              logIt('VisitorNoAddressCount-> ${contactUserList.length}');

              setState(() {});
            }
          }
          break;

        case AppConfig.sendVisitorOtp:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              receivedOtp = getString(data, 'otp_code');
              setState(() {
                isOtpSent = true;
              });
            }

            logIt('AppConfig.sendVisitorOtp-> $data');
          }
          break;

        case 'CITY_MASTER':
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;
              _cityList.clear();
              _cityList.addAll(content.map((e) => DataModel.fromJSONCity(e)));
              setState(() {});
            }
          }
          break;

        case AppConfig.getVisitorPassDetail:
          {
            logIt('AppConfig.getVisitorPassDetail-> $response');

            var content = jsonDecode(response!);

            if (content['error'] == 'false') {
              var data = content['content'];

              imageBaseUrl = getString(content, 'image_tiff_path');

              serialNoController.text = widget.id!;
              srNo = getString(data, 'sno');
              nameController.text = getString(data, 'name');
              dateController.text =
                  getString(data, 'indate').toDateTime().format('dd/MM/yyyy');
              contactController.text = getString(data, 'contact');
              timeController.text = getString(data, 'intime');
              totalPersonController.text = getString(data, 'total_person');
              personToMeetController.text = getString(data, 'person_to_meet');
              remarksController.text = getString(data, 'remarks');
              purposeController.text = getString(data, 'purpose');
              otherPurposeController.text = getString(data, 'other_purpose');

              _cityCode = getString(data['city_name'], 'code');
              _cityController.text = getString(data['city_name'], 'name');
              _stateController.text =
                  getString(data['city_name']['state_name'], 'name');

              addressCode = getString(data, 'address_type').toString() == 'Y'
                  ? getString(data, 'address')
                  : '';

              visitorCompController.text =
                  getString(data, 'address_type').toString() == 'Y'
                      ? '${getString(data['visitor_address'], 'name')}'
                      : getString(data, 'company_name');

              addressController.text = getString(data, 'address_type')
                          .toString() ==
                      'Y'
                  ? '${getString(data['visitor_address']['party_address'], 'acc_address')} '
                  : getString(data, 'address');

              companyController.text =
                  getString(data['company_detail'], 'name');
              compCode = getString(data['company_detail'], 'code');

              visitorImageCode =
                  getString(data, 'visitor_images_code_pk').isEmpty
                      ? getString(data['visitor_image'], 'code_pk')
                      : getString(data, 'visitor_images_code_pk');

              hasEditPerm = ifHasPermission(
                  compCode: compCode,
                  permission: Permissions.VISITOR_GATE_ENTRY,
                  permType: PermType.MODIFIED);

              hasEmpEditPerm = ifHasPermission(
                  compCode: compCode,
                  permission: Permissions.EMP_GATEPASS,
                  permType: PermType.MODIFIED);

              setState(() {});

              _getEmployeeCode();
            }
          }
          break;

        case AppConfig.getEmployeePassDetail:
          {
            var content = jsonDecode(response!);

            empBaseUrl = getString(content, 'image_tiff_path');

            logIt('TheImagePathis-> $imageBaseUrl');

            if (content['error'] == 'false') {
              var data = content['content'];

              srNo = getString(data, 'srl');
              serialNoController.text = getString(data, 'sno');
              dateController.text = getString(data, 'ins_date')
                  .toDateTime(format: 'yyyy-MM-dd hh:mm:ss')
                  .format('dd/MM/yyyy');
              outDateController.text = getString(data, 'out_date').isNotEmpty
                  ? getString(data, 'out_date')
                      .toDateTime()
                      .format('dd/MM/yyyy')
                  : '';
              purposeController.text = getString(data, 'purpose');
              placeToVisitController.text = getString(data, 'place_to_visit');
              approvalUserController.text =
                  getString(data['approver_name'], 'name');
              selectedApprovalUser =
                  getString(data['approver_name'], 'user_id');
              companyController.text =
                  getString(data['company_detail'], 'name');
              compCode = getString(data, 'comp_code');

              if (companyController.text.isEmpty)
                companyController.text = 'Select Company';

              var empList = data['emp_lists'] as List;

              _selectedEmpList.clear();

              _selectedEmpList.addAll(
                  empList.map((e) => EmployeeModel.parseGatePass(e)).toList());

              setState(() {});

              hasEmpEditPerm = ifHasPermission(
                  compCode: compCode,
                  permission: Permissions.EMP_GATEPASS,
                  permType: PermType.MODIFIED);

              _getEmployeeCode();
            }
          }
          break;

        case AppConfig.editVisitorPass:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, getString(data, 'message'), 'Success',
                  onOk: () {
                popIt(context);
              });
            } else {
              showAlert(context, getString(data, 'message'), 'Error');
            }
          }
          break;

        case AppConfig.editEmpPass:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, getString(data, 'message'), 'Success',
                  onOk: () {
                popIt(context);
              });
            } else {
              showAlert(context, getString(data, 'message'), 'Error');
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err here-> $stack');
    }
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
                  popIt(context);
                  companyController.text = companyList[index].name!;
                  compCode = companyList[index].id;

                  /// Clearing Defaults
                  employeeController.clear();
                  empCode = '';
                  _getEmployeeCode();

                  hasPerm = ifHasPermission(
                      compCode: compCode,
                      permission: Permissions.VISITOR_GATE_ENTRY,
                      permType: PermType.INSERT);

                  hasEmpPerm = ifHasPermission(
                      compCode: compCode,
                      permission: Permissions.EMP_GATEPASS,
                      permType: PermType.INSERT);
                },
              ),
              itemCount: companyList.length,
            ),
          );
        });
  }

  void userBottomSheet(context) {
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
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${index + 1}. ${usersList[index].name}'),
                ),
                onTap: () {
                  popIt(context);
                  approvalUserController.text = usersList[index].name!;
                  selectedApprovalUser = usersList[index].id;
                },
              ),
              itemCount: usersList.length,
            ),
          );
        });
  }

  void _purposeBottomSheet(context) {
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
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${index + 1}. ${purposeList[index]}'),
                ),
                onTap: () {
                  popIt(context);
                  purposeController.text = purposeList[index].toUpperCase();
                  setState(() {});
                },
              ),
              itemCount: purposeList.length,
            ),
          );
        });
  }

  void _approvalUserBottomSheet(context) {
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
                  child: TypeAheadFormField<UserModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select approval user' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.name!),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      popIt(context);
                      approvalUserController.text = sg.name!;
                      selectedApprovalUser = sg.id;
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredApprovalUser(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        controller: approvalUserController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            hintText: 'Approval User',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _placeToVisitSheet(context) {
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
                  child: TypeAheadFormField<String>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select place to visit' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      popIt(context);
                      placeToVisitController.text = sg;
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredPlace(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        controller: placeToVisitController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            hintText: 'Place to visit',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _personToMeetSheet(context) {
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
                  child: TypeAheadFormField<String>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select person to meet' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      popIt(context);
                      personToMeetController.text = sg.toUpperCase();
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredPerson(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        keyboardType: TextInputType.name,
                        controller: personToMeetController,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        onSubmitted: (v) {
                          popIt(context);
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            hintText: 'Person to meet',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _getFilteredEmployee(String str) {
    return employeeList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getFilteredAddress(String str) {
    //if (contactUserList.isEmpty) {
    return addressPartyList
        .where((i) => (i.name.toLowerCase().startsWith(str.toLowerCase()) ||
            i.address.toLowerCase().contains(str.toLowerCase())))
        .toList();
    /* } else {
      return contactAddressPartyList
          .where((i) => (i.name.toLowerCase().startsWith(str.toLowerCase()) ||
              i.address.toLowerCase().contains(str.toLowerCase())))
          .toList();
    }*/
  }

  _getFilteredApprovalUser(String str) {
    return usersList
        .where((i) => (i.name!.toLowerCase().startsWith(str.toLowerCase())))
        .toList();
  }

  _getFilteredPlace(String str) {
    return placeToVisitList
        .where((i) => (i.toLowerCase().startsWith(str.toLowerCase())))
        .toList();
  }

  _getFilteredPerson(String str) {
    return personToMeet
        .where((i) => (i.toLowerCase().startsWith(str.toLowerCase())))
        .toList();
  }

  void _selectVisitorImage() async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageEditor(
                  title: '',
                )));

    if (res != null) {
      visitorImageCode = '';
      setState(() {
        imageFile = res['file'];
      });
    }
  }

  _showCitySheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              margin: EdgeInsets.fromLTRB(8, 24, 8, 8),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  TypeAheadFormField<DataModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select city' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${itemData.name}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${itemData.stateName}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        enabled: !itemData.isSelected,
                      );
                    },
                    onSuggestionSelected: (sg) {
                      if (sg.isSelected) return;
                      Navigator.of(context).pop();
                      _cityController.text = sg.name!;
                      _stateController.text = sg.stateName!;
                      _cityCode = sg.id;
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredCities(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        onChanged: (string) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.search),
                            hintText: 'Search City',
                            isDense: true)),
                  ),
                ],
              ));
        });
  }

  _getFilteredCities(String char) {
    return _cityList
        .where((i) => (i.name!.toLowerCase().startsWith(char.toLowerCase()) ||
            i.stateName!.toLowerCase().startsWith(char.toLowerCase())))
        .toList();
  }

  void upperCaseText(String value, TextEditingController textController) {
    if (textController.text != value.toUpperCase())
      textController.value =
          textController.value.copyWith(text: value.toUpperCase());
  }
}

enum PassType { Employee, Visitor }
