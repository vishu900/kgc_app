import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/attendance/model/DepartmentModel.dart';
import 'package:dataproject2/digital_signature/verify_sign.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/LifecycleEventHandler.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mantra_mfs100/mantra_mfs100.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import 'dart:ui' as ui;

import '../dashboard.dart';

class EmployeeSalaryPaid extends StatefulWidget {
  final String? compId;

  const EmployeeSalaryPaid({Key? key, required this.compId}) : super(key: key);

  @override
  _EmployeeSalaryPaidState createState() => _EmployeeSalaryPaidState();
}

class _EmployeeSalaryPaidState extends State<EmployeeSalaryPaid>
    with NetworkResponse, MSF100Event {
  final vSpacer = SizedBox(height: 16);
  final hSpacer = SizedBox(width: 16);

  String _salaryEarned = '0';
  String _salaryPaid = '0';
  String _salaryTotalPaid = '0';
  String _salaryNetPayable = '0';
  String _otEarned = '0';
  String _otPaid = '0';
  String _otNetPayable = '0';
  String _voucherEarned = '0';
  String _voucherPaid = '0';
  String _voucherNetPayable = '0';
  String _bankPayable = '0';
  String _bankDeductions = '0';
  String _loanDeductions = '0';
  String _advanceDeductions = '0';
  String _esiEpfDeductions = '0';
  String _totalEarned = '0';
  String _totalPaid = '0';
  String _totalDeductions = '0';
  String _totalNetPayable = '0';
  String _empImage = '';
  String _baseUrl = '';
  String ledgerName = 'N/A';
  String ledgerValue = 'N/A';
  String _unpaidAmount = 'N/A';
  String _unpaidEmployee = 'N/A';
  String _monthlyunpaidAmount = 'N/A';
  String _monthlyunpaidEmployess = 'N/A';
  final salaryMonthController = TextEditingController();
  final empCodeController = TextEditingController();
  final empNameController = TextEditingController();
  final empAllNameController = TextEditingController();
  String selectedEmpCode = '';
  String selectedSalMonth = '';
  String? selectedDepartmentId = '';

  List<SalaryEmployeeModel> _filterEmpList = [];
  List<SalaryEmployeeModel> _allEmpList = [];
  List<DepartmentModel> departmentList = [];
  List<String?> _dateList = [];
  final GlobalKey<FormState> _validator = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _departmentController =
      TextEditingController(text: 'Select Section');

  bool _isConnected = false;
  bool _isPlatformSupported = false;
  bool _isError = false;
  bool _isCapturing = false;
  bool _isAllEmp = false;
  String _status = 'Ready';
  late MantraMfs100 _mfs;
  StreamSubscription<dynamic>? mfsStream;
  String _uploadedSign = '';

  @override
  void initState() {
    _isPlatformSupported = Platform.isAndroid;
    _isConnected = DashboardState.isConnected;
    if (_isPlatformSupported) _registerListener();
    super.initState();

    if (_isPlatformSupported) {
      _mfs = MantraMfs100.instance!;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getSalaryMonth();
    });
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(detachedCallBack: () async {
      if (_isPlatformSupported) {
        _mfs.stopAutoCapture();
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Salary Paid'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
                _isConnected ? Icons.usb_outlined : Icons.usb_off_outlined,
                size: 22),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          clearFocus(context);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Visibility(
                  visible: _isPlatformSupported,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(_isConnected ? _status : 'Device not connected!',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey)),
                      SizedBox(width: 4),
                      Container(
                        height: 10.sp,
                        width: 10.sp,
                        decoration: BoxDecoration(
                            color: _isCapturing
                                ? Colors.orange
                                : _isError || !_isConnected
                                    ? Colors.red
                                    : Colors.green,
                            shape: BoxShape.circle),
                      ),
                    ],
                  )),
              vSpacer,

              /// Salary Month
              Row(
                children: [
                  Flexible(
                    child: Form(
                      key: _validator,
                      child: Column(
                        children: [
                          /* TextFormField(
                            controller: salaryMonthController,
                            validator: (v)=> v.trim().length<6? 'Enter valid month':null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Salary Month',
                                labelText: 'Salary Month',
                                border: OutlineInputBorder()),
                          ),*/
                          vSpacer,
                          TypeAheadFormField<String?>(
                            validator: (v) => v!.trim().length < 6
                                ? 'Enter valid month'
                                : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            itemBuilder: (BuildContext context, itemData) {
                              return ListTile(
                                title: Text(itemData!),
                              );
                            },
                            onSuggestionSelected: (sg) {
                              salaryMonthController.text = sg!;
                              selectedSalMonth = salaryMonthController.text;
                              empNameController.clear();
                              selectedDepartmentId = '';
                              _departmentController.clear();
                              selectedEmpCode = '';
                              _getEmployee();
                              _getDepartmentList();
                              _resetSalaryTable();
                            },
                            suggestionsCallback: (String pattern) {
                              return _dateList;
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                                textAlign: TextAlign.start,
                                controller: salaryMonthController,
                                onChanged: (v) {},
                                decoration: InputDecoration(
                                    hintText: 'Salary Month',
                                    labelText: 'Salary Month',
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                                    isDense: true)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /* hSpacer,

                  IconButton(onPressed: (){

                    if(_validator.currentState.validate()){
                      selectedSalMonth=salaryMonthController.text;
                      _getEmployee();
                      _resetSalaryTable();
                      empNameController.clear();
                      selectedEmpCode='';
                    }

                  },icon:Icon(Icons.search)
                  )*/
                ],
              ),
              vSpacer,

              /// Section Name
              TextFormField(
                controller: _departmentController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                readOnly: true,
                onTap: () {
                  getDepartmentSheet(context);
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Section',
                  hintText: 'Section Name',
                ),
              ),
              vSpacer,

              /// Employee Name
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: TypeAheadFormField<SalaryEmployeeModel>(
                            validator: (value) => selectedEmpCode.isEmpty &&
                                    empNameController.text.isEmpty
                                ? 'Please select employee'
                                : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            itemBuilder: (BuildContext context, itemData) {
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: itemData.empImage.isEmpty
                                      ? Image.asset(
                                          'images/noImage.png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                        )
                                      : FadeInImage.assetNetwork(
                                          placeholder:
                                              'images/loading_placeholder.png',
                                          image:
                                              '$_baseUrl${itemData.empImage}.png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                                title: Text(itemData.name),
                                subtitle: Text(itemData.empCode),
                                trailing: Text(itemData.lscode),
                              );
                            },
                            onSuggestionSelected: (sg) {
                              empAllNameController.clear();
                              empNameController.text = sg.name;
                              selectedEmpCode = sg.empCode;
                              _empImage = sg.empImage;
                              departmentList.forEach((element) {
                                if (sg.sectionCode == element.id) {
                                  _departmentController.text = element.name!;
                                  selectedDepartmentId = element.id;
                                }
                              });
                              setState(() {});
                              _getSalary();
                            },
                            suggestionsCallback: (String pattern) {
                              return _getFilteredEmpList(pattern);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                                textAlign: TextAlign.start,
                                controller: empNameController,
                                onChanged: (v) {},
                                decoration: InputDecoration(
                                    hintText: 'Employee Name',
                                    labelText: 'Employee Name',
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                                    isDense: true)),
                          ),
                        ),
                        Visibility(
                            visible: _isPlatformSupported,
                            child: SizedBox(width: 8)),
                        Visibility(
                            visible: _isPlatformSupported,
                            child: GestureDetector(
                                onTap: () {
                                  _isAllEmp = false;
                                  _captureFingerPrint();
                                },
                                child: Container(
                                    height: 50,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: _isCapturing && !_isAllEmp
                                              ? Colors.red
                                              : Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(Icons.fingerprint_outlined,
                                        size: 42,
                                        color: _isCapturing && !_isAllEmp
                                            ? Colors.red
                                            : Colors.grey)))),
                        Visibility(
                            visible: empNameController.text.isNotEmpty,
                            child: SizedBox(width: 8)),
                        Visibility(
                            visible: empNameController.text.isNotEmpty,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    empNameController.clear();
                                    selectedEmpCode = '';
                                    _departmentController.clear();
                                    selectedDepartmentId = '';
                                    _resetSalaryTable();
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
                    /*  vSpacer,
                    TypeAheadFormField<SalaryEmployeeModel>(
                      validator: (value) =>
                      selectedEmpCode.isEmpty &&
                          empNameController.text.isEmpty ? 'Please select employee' : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      itemBuilder: (BuildContext context, itemData) {
                        return ListTile(
                          title: Text(itemData.name),
                          trailing: Text(itemData.empCode),
                        );
                      },
                      onSuggestionSelected: (sg) {
                        empNameController.clear();
                        empAllNameController.text=sg.name;
                        selectedEmpCode=sg.empCode;
                        _getSalary();
                      },
                      suggestionsCallback: (String pattern) {
                        return _getAllEmpList(pattern);
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                          textAlign: TextAlign.start,
                          controller: empAllNameController,
                          onChanged: (v) {},
                          decoration: InputDecoration(
                              hintText: 'All Employee Name',
                              labelText: 'All Employee Name',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              isDense: true)
                      ),
                    ),*/
                  ],
                ),
              ),

              /// Ledger Name and Value
              vSpacer,
              Table(
                border: TableBorder.all(),
                children: [
                  /// Header
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Ledger Name',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Ledger Value',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                  ]),

                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ledgerName.handleEmpty(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ledgerValue,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ]),
                ],
              ),

              /// Unpaid Amount and Employees
              vSpacer,
              Table(
                border: TableBorder.all(),
                children: [
                  /// Header
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Unpaid Amount',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Unpaid Employees',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                  ]),

                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _unpaidAmount.handleEmpty(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _unpaidEmployee,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ]),
                ],
              ),

              /// Monthly Unpaid Amount and Employees
              vSpacer,
              Table(
                border: TableBorder.all(),
                children: [
                  /// Header
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Monthly Unpaid Amount',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Monthly Unpaid Employees',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                  ]),

                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _monthlyunpaidAmount.handleEmpty(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _monthlyunpaidEmployess,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ]),
                ],
              ),

              vSpacer,
              Row(
                children: [
                  Text(
                    'Payable Rs.$_totalNetPayable',
                    style: TextStyle(fontSize: 18, letterSpacing: 0.5),
                  ),
                ],
              ),

              vSpacer,
              ElevatedButton(
                  onPressed: () {
                    _saveSalary();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Verify & Pay',
                      style: TextStyle(fontSize: 18, letterSpacing: 0.5),
                    ),
                  )),

              vSpacer,
              _empImage.isEmpty
                  ? Container(
                      child: Image.asset(
                        'images/noImage.png',
                        height: 128,
                        width: 128,
                      ),
                    )
                  : FadeInImage.assetNetwork(
                      placeholder: 'images/loading_placeholder.png',
                      image: '$_baseUrl$_empImage.png',
                      height: 128,
                      width: 128,
                    ),

              vSpacer,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _buildCells(),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: _buildHorizontalCells(),
                    ),
                  )
                ],
              ),

              vSpacer,
            ],
          ),
        ),
      ),
    );
  }

  /// Vertically
  List<Widget> _buildCells() {
    return List.generate(
      1,
      (index) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              width: 136,
              height: 48,
              color: Colors.red[500],
            ),
          ),

          /// Salary
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
                width: 136,
                height: 48,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Salary',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
          ),

          /// OT
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
                width: 136,
                height: 48,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'OT',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
          ),

          /// Voucher
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
                width: 136,
                height: 48,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Voucher',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
          ),

          /// Bank Paid
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
                width: 136,
                height: 48,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Bank Paid',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
          ),

          /// Loan Installment
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
                width: 136,
                height: 48,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Loan Installment',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
          ),

          /// Advance Paid
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
                width: 136,
                height: 48,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Advance Paid',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
          ),

          /// ESI/PF
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
                width: 136,
                height: 48,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'ESI/PF',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
          ),

          /// Total
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
                width: 136,
                height: 48,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Total',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  /// Horizontally
  Widget _buildHorizontalCells() {
    return Column(
      children: [
        /// Header
        Container(
          alignment: Alignment.topCenter,
          child: Row(children: [
            /// Salary Earned
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Salary Earned',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            /// Salary Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Salary Paid',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            ///Deductions
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Deductions',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),

            /// Total Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Total Paid',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),

            ///Net Payable
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[500],
                child: Center(
                  child: Text(
                    'Net Payable',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ]),
        ),

        Container(
          alignment: Alignment.topCenter,
          child: Row(children: [
            ///Salary Earned
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _salaryEarned,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Salary Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _salaryPaid,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Deductions
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Total Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _salaryTotalPaid,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Net Payable
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _salaryNetPayable,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
          ]),
        ),

        Container(
          alignment: Alignment.topCenter,
          child: Row(children: [
            /// OT Earned
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _otEarned,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            /// OT Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _otPaid,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Deductions
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Total Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Net Payable
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _otNetPayable,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
          ]),
        ),

        Container(
          alignment: Alignment.topCenter,
          child: Row(children: [
            /// Voucher Earned
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _voucherEarned,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Salary Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _voucherPaid,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Deductions
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Total Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Net Payable
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _voucherNetPayable,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
          ]),
        ),

        Container(
          alignment: Alignment.topCenter,
          child: Row(children: [
            ///Bank
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            ///Deductions
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _bankDeductions,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Total Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            ///Net Payable
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _bankPayable,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
          ]),
        ),

        Container(
          alignment: Alignment.topCenter,
          child: Row(children: [
            ///Loan Earned
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            ///Salary Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            ///Deductions
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _loanDeductions,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Total Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            ///Net Payable
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),
          ]),
        ),

        Container(
          alignment: Alignment.topCenter,
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            ///Deductions
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _advanceDeductions,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Total Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            ///Net Payable
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),
          ]),
        ),

        Container(
          alignment: Alignment.topCenter,
          child: Row(children: [
            /// ESI EPF Earned
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            ///Salary Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
              ),
            ),

            ///Deductions
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _esiEpfDeductions,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Total Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Net Payable
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
          ]),
        ),

        Container(
          alignment: Alignment.topCenter,
          child: Row(children: [
            ///Salary Earned
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _totalEarned,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Salary Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _totalPaid,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Deductions
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _totalDeductions,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Total Paid
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Net Payable
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: 110,
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    _totalNetPayable,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  _getEmployee() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'sal_month': selectedSalMonth,
      'filter_data': '1',
      'section_code': selectedDepartmentId
    };

    WebService.fromApi(AppConfig.salaryEmployee, this, jsonBody)
        .callPostService(context);
  }

  void getDepartmentSheet(context) {
    if (_departmentController.text == 'Select Section')
      _departmentController.clear();

    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                  child: TypeAheadFormField<DepartmentModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select section' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.name!),
                        trailing: Text(itemData.totalEmployee),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      Navigator.of(context).pop();
                      _departmentController.text = sg.name!;
                      selectedDepartmentId = sg.id;
                      empNameController.clear();
                      selectedEmpCode = '';
                      _resetSalaryTable();

                      if (_departmentController.text != 'Select Section')
                        _getEmployee();
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredSectionList(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        controller: _departmentController,
                        onChanged: (v) {
                          selectedDepartmentId = '';
                          if (v.trim().isEmpty) {
                            empNameController.clear();
                            _filterEmpList.clear();
                            _getEmployee();
                          }
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            isDense: true)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text('Total Section: ${departmentList.length}',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey)),
                ),
              ],
            ),
          );
        });
  }

  _getFilteredSectionList(String str) {
    return departmentList
        .where((i) =>
            i.name!.toLowerCase().startsWith(str.toLowerCase()) ||
            i.id!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  getAllEmployee() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'sal_month': selectedSalMonth,
      'filter_data': '0',
    };

    WebService.fromApi(AppConfig.salaryEmployee, this, jsonBody,
            reqCode: 'getAllEmployee')
        .callPostService(context);
  }

  _getSalary() {
    Map jsonBody = {
      'user_id': getUserId(),
      'emp_code': selectedEmpCode,
      'sal_month': selectedSalMonth,
      'comp_code': widget.compId,
    };

    if (selectedDepartmentId!.isNotEmpty) {
      jsonBody.addAll({'section_code': selectedDepartmentId});
    }

    WebService.fromApi(AppConfig.viewEmployeeSalary, this, jsonBody)
        .callPostService(context);
  }

  _getSalaryMonth() {
    Map jsonBody = {'user_id': getUserId(), 'comp_code': widget.compId};

    WebService.fromApi(AppConfig.getSalaryMonth, this, jsonBody)
        .callPostService(context);
  }

  _saveSalary() {
    if (!_formKey.currentState!.validate() ||
        !_validator.currentState!.validate()) {
      return;
    }

    if (int.parse(_totalNetPayable) > int.parse(ledgerValue)) {
      Commons.showToast('You do not have sufficient ledger balance!');
      return;
    }

    showAlert(
        context,
        'Are you sure you want to pay Rs.$_totalNetPayable to ${empNameController.text}',
        'Confirmation',
        ok: 'Yes',
        notOk: 'No', onNo: () {
      popIt(context);
    }, onOk: () {
      _askForSignatureAndPay();
    });
  }

  _askForSignatureAndPay() {
    showAlert(context, 'Do you want to get the signature?', 'Confirm',
        ok: 'Yes, Sign and Pay', notOk: 'No, Just Pay', onNo: () {
      popIt(context);
      _paySalary();
    }, onOk: () {
      _showSignPadAndVerifySign();
    });
  }

  _paySalary() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'emp_code': selectedEmpCode,
      'sal_month': selectedSalMonth,
      'sal_amount': _salaryEarned,
      'ot_amount': _otEarned,
      'paid_voc': _voucherNetPayable,
      'voc_amt': _voucherEarned,
      'paid_rf': _bankPayable,
      'bank_salary': _bankDeductions,
      'act_advance_paid': _advanceDeductions,
      'act_loan_paid': _loanDeductions,
      'act_esi_paid': _esiEpfDeductions,
      'act_sal_amt_paid': _salaryNetPayable,
      'act_gw_amt_paid': _otNetPayable
    };

    WebService.fromApi(AppConfig.saveEmployeeSalary, this, jsonBody)
        .callPostService(context);
  }

  _getDepartmentList() {
    Map jsonBody = {
      'user_id': getUserId(),
      'table_name': 'SECTION',
      'comp_code': widget.compId,
      'sal_month': salaryMonthController.text.trim()
    };

    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody)
        .callPostService(context);
  }

  _findEmployee(String filePath) {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'sal_month': salaryMonthController.text.trim(),
      'type': 'salary'
    };

    WebService.multipartApi(
            AppConfig.findEmployeeByFingerprint, this, jsonBody, filePath)
        .callMultipartPostService(context, fileName: 'fingerprint_image');
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.searchItemParameters:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              departmentList.clear();
              var content = data['content'] as List;
              departmentList
                  .add(DepartmentModel(id: '', name: 'Select Section'));
              departmentList.addAll(
                  content.map((e) => DepartmentModel.parse(e)).toList());
              setState(() {});
            }

            logIt('DepartmentData-> $data');
          }
          break;

        case AppConfig.getSalaryMonth:
          {
            var data = jsonDecode(response!);
            logIt('onResponse-> $data');

            if (data['error'] == 'false') {
              var content = data['content'] as List?;
              _dateList.clear();

              if (content != null) {
                content.forEach((element) {
                  _dateList.add(element['sal_yyyymm']);
                });
              }

              ledgerName = getString(data, 'ladger_name');
              ledgerValue = getString(data, 'ladger_bal');

              if (_dateList.isNotEmpty) {
                salaryMonthController.text = _dateList[0]!;
                selectedSalMonth = salaryMonthController.text;
                _getDepartmentList();
                _getEmployee();
              }

              setState(() {});
            }
          }
          break;

        case AppConfig.salaryEmployee:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              logIt('Salary Employee -> $content');

              _filterEmpList.clear();
              _filterEmpList.addAll(
                  content.map((e) => SalaryEmployeeModel.fromJson(e)).toList());

              _baseUrl = getString(data, 'image_png_path');
              _unpaidEmployee = _filterEmpList.length.toString();
              _monthlyunpaidEmployess = _filterEmpList.length.toString();
              _monthlyunpaidAmount = getString(data, 'monthlyunpaidamount');
              _monthlyunpaidEmployess =
                  getString(data, 'monthlyunpaidemployees');

              setState(() {});
            }
          }
          break;

        case 'getAllEmployee':
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              _allEmpList.clear();
              _allEmpList.addAll(
                  content.map((e) => SalaryEmployeeModel.fromJson(e)).toList());

              setState(() {});
            }
          }
          break;

        case AppConfig.saveEmployeeSalary:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                _resetSalaryTable();
                selectedEmpCode = '';
                empNameController.clear();
                empAllNameController.clear();
                _departmentController.clear();
                selectedDepartmentId = '';
                _getEmployee();
              });

              setState(() {});
            } else {
              showAlert(context, data['message'], 'Error');
            }
          }
          break;

        case AppConfig.viewEmployeeSalary:
          {
            _getSignature();
            var res = jsonDecode(response!);
            if (res['error'] == 'false') {
              var data = res['content'];

              _salaryEarned = getString(data, 'sal_amt');
              _otEarned = getString(data, 'ot_amt');
              _voucherEarned = getString(data, 'voc_amt');

              _otPaid = getString(data, 'paid_ot');
              _voucherPaid = getString(data, 'paid_voc');

              _otNetPayable =
                  (int.parse(_otEarned) - int.parse(_otPaid)).toString();
              _voucherNetPayable =
                  (int.parse(_voucherEarned) - int.parse(_voucherPaid))
                      .toString();

              _advanceDeductions = getString(res['advance'], 'amt_paid');
              _bankDeductions = getString(data, 'bank_pay_amt');
              _esiEpfDeductions = getString(data, 'pf_esi_amt');
              _loanDeductions = getString(data, 'loan_amt');

              ledgerName = getString(res, 'ledger_name');
              ledgerValue = getString(res, 'ledger_balance');
              _bankPayable = getString(data, 'rf_amt');

              _totalEarned =
                  _getTotal([_salaryEarned, _otEarned, _voucherEarned]);
              _totalDeductions = _getTotal([
                _bankDeductions,
                _loanDeductions,
                _advanceDeductions,
                _esiEpfDeductions
              ]);
              _salaryPaid = (int.parse(getString(data, 'sal_paid')) +
                      int.parse(_totalDeductions))
                  .toString();
              _salaryNetPayable =
                  (int.parse(_salaryEarned) - int.parse(_salaryPaid))
                      .toString();
              _totalPaid = _getTotal([_salaryPaid, _otPaid, _voucherPaid]);
              _totalNetPayable =
                  (int.parse(_totalEarned) - int.parse(_totalDeductions))
                      .toString();
              _salaryTotalPaid = _totalPaid;
              _totalNetPayable = _getRoundOff(_totalNetPayable).toString();

              _unpaidAmount = getString(res, 'pending_salary_amount');

              logIt('Total UnPaid Amount-> $_unpaidAmount');

              setState(() {});
            }
          }
          break;

        case AppConfig.findEmployeeByFingerprint:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              if (data['content'] != null) {
                empNameController.text =
                    '${getStringValue(data['content'], 'first_name')} ${getStringValue(data['content'], 'middle_name')} ${getStringValue(data['content'], 'last_name')}';
                selectedEmpCode = getString(data['content'], 'code');
                String secCode = getString(data['content'], 'section_code');
                var imagesList = data['images'] as List;
                String image = '';

                if (imagesList.isNotEmpty) {
                  image = imagesList[0];
                  _empImage = '${image.split('.').first}';
                }

                departmentList.forEach((element) {
                  logIt('Found Employee -> $secCode ${element.id}');
                  if (secCode == element.id) {
                    _departmentController.text = element.name!;
                    selectedDepartmentId = element.id;
                  }
                });

                setState(() {});
                _getSalary();
              }
            } else {
              showAlert(context, getString(data, 'message'), 'Oops');
            }

            logIt('Found Employee -> $data');
          }

          break;

        case AppConfig.getEmpSign:
          {
            var data = jsonDecode(response!);

            logIt("EmpSign-> $data");

            if (data['error'] == 'false') {
              if (getString(data, 'content').isNotEmpty) {
                _uploadedSign =
                    '${getString(data, 'image_png_path')}${getString(data, 'content')}';
              }

              setState(() {});
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err $stack');
    }
  }

  _showSignPadAndVerifySign() async {
    final res = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VerifySign(uploadedSign: _uploadedSign)));

    if (res == null) return;

    if (res['status']) {
      File file = await createFileFromUint8List(res['data'] as Uint8List);

      Map jsonBody = {
        'user_id': getUserId(),
        'comp_code': widget.compId,
        'emp_code': selectedEmpCode,
        'sal_month': selectedSalMonth,
        'sal_amount': _salaryEarned,
        'ot_amount': _otEarned,
        'paid_voc': _voucherNetPayable,
        'voc_amt': _voucherEarned,
        'paid_rf': _bankPayable,
        'bank_salary': _bankDeductions,
        'act_advance_paid': _advanceDeductions,
        'act_loan_paid': _loanDeductions,
        'act_esi_paid': _esiEpfDeductions,
        'act_sal_amt_paid': _salaryNetPayable,
        'act_gw_amt_paid': _otNetPayable
      };

      WebService.multipartApi(
              AppConfig.saveEmployeeSalary, this, jsonBody, file.absolute.path)
          .callMultipartPostService(context, fileName: 'employee_sign');
    }
  }

  _getRoundOff(String str) {
    if (str == '0') return str;
    if (str.isNotEmpty) {
      var last = str.substring(str.length - 1, str.length);
      var res = 0;
      var result = 0;
      if (int.parse(last) < 5) {
        res = int.parse(last);
        result = int.parse(str) - res;
      } else {
        res = 10 - int.parse(last);
        result = int.parse(str) + res;
      }
      return result;
    } else {
      return 0;
    }
  }

  _getFilteredEmpList(String str) {
    return _filterEmpList
        .where((i) =>
            i.name.toLowerCase().contains(str.toLowerCase()) ||
            i.empCode.toLowerCase().contains(str.toLowerCase()))
        .toList();
  }

  getAllEmpList(String str) {
    return _allEmpList
        .where((i) =>
            i.name.toLowerCase().contains(str.toLowerCase()) ||
            i.empCode.toLowerCase().contains(str.toLowerCase()))
        .toList();
  }

  String _getTotal(List<String> args) {
    var item = 0;

    args.forEach((element) {
      if (element.isEmpty) {
        item += 0;
      } else {
        item += int.parse(element);
      }
    });

    return item.toString();
  }

  /*  String getValue(data, String key) {
    if (data == null) return '0';
    if (data[key] != null) {
      return data[key].toString();
    } else {
      return '0';
    }
  }*/

  String getString(data, String key) {
    if (data == null) return '0';
    if (data[key] != null) {
      return data[key].toString();
    } else {
      return '0';
    }
  }

  getAmount(AmountType type, Map<String, dynamic> res) {
    var _allowances = ['A150', 'A170', 'A140', 'A130', 'A120'];

    var content = res['other'] as List?;

    int val = 0;

    switch (type) {
      case AmountType.Voucher:
        content!.forEach((element) {
          if (_allowances.contains(element['tran_code'])) {
            val += int.parse(getString(element, 'amount'));
          }
        });

        return val.toString();
      //   break;

      case AmountType.BankPaid:
        var content = res['varded'] as List;

        content.forEach((element) {
          if (element['tran_code'] == 'D180') {
            val += int.parse(getString(element, 'ded_amount'));
          }
        });

        return val.toString();
      //  break;

      case AmountType.LoanInstallment:
        var content = res['varded'] as List;
        content.forEach((element) {
          if (element['tran_code'] == 'D110') {
            val += int.parse(getString(element, 'ded_amount'));
          }
        });

        return val.toString();
      // break;

      case AmountType.AdvancePaid:
        break;

      case AmountType.EsiEpf:
        var content = res['varded'] as List;

        content.forEach((element) {
          if (element['tran_code'] == 'D190') {
            val += int.parse(getString(element, 'ded_amount'));
          }
        });

        return val.toString();
      //break;
    }
  }

  _resetSalaryTable() {
    _salaryEarned = '0';
    _salaryPaid = '0';
    _salaryTotalPaid = '0';
    _salaryNetPayable = '0';
    _otEarned = '0';
    _otPaid = '0';
    _otNetPayable = '0';
    _voucherEarned = '0';
    _voucherPaid = '0';
    _voucherNetPayable = '0';
    _bankPayable = '0';
    _bankDeductions = '0';
    _loanDeductions = '0';
    _advanceDeductions = '0';
    _esiEpfDeductions = '0';
    _totalEarned = '0';
    _totalPaid = '0';
    _totalDeductions = '0';
    _totalNetPayable = '0';
    _empImage = '';
    _uploadedSign = '';
    // _unpaidAmount = 'N/A';
    //_unpaidEmployee = 'N/A';
  }

  @override
  void onDeviceAttached(bool hasPermission) {
    _isConnected = true;
    _setCaptureSuccess('Ready');
    logIt('onDevAttached-> $_isConnected, $hasPermission');
  }

  @override
  void onDeviceDetached() {
    _mfs.unInit();
    setState(() {
      _isConnected = false;
      _resetCapturing();
    });
    logIt('onDeviceDetached-> $_isConnected');
  }

  @override
  void onHostCheckFailed(String var1) {}

  _setCaptureError(String errorMsg) {
    setState(() {
      _isError = true;
      _status = errorMsg;
    });
  }

  _setCaptureSuccess(String successMsg) {
    setState(() {
      _isError = false;
      _status = successMsg;
    });
  }

  _resetCapturing() {
    _isError = false;
    _status = 'Ready';
    // _fingerImageBytes = null;
  }

  _registerListener() {
    mfsStream = DashboardState.mfsController.stream.listen((event) {
      if (event['event'] == 'connected') {
        _isConnected = true;
        _setCaptureSuccess('Ready');
        logIt('onDevAttached-> $_isConnected');
      } else if (event['event'] == 'disConnected') {
        setState(() {
          _isConnected = false;
          _resetCapturing();
        });
        logIt('onDeviceDetached-> $_isConnected');
      }
    });
  }

  _captureFingerPrint() async {
    try {
      if (_isCapturing) return;
      _isCapturing = true;
      _resetCapturing();
      _setCaptureSuccess('Trying to capture...');
      await Future.delayed(Duration(milliseconds: 250));
      FingerData res = await _mfs.startAutoCapture(6000, true);
      _isCapturing = false;
      _setCaptureSuccess('Captured with ${res.quality}% quality');
      final file = await _createFileFromUint8List(
          await _getPngUint8List(res.fingerImage), 'probeFinger');
      _findEmployee(file.absolute.path);
    } catch (err) {
      if (err is PlatformException) {
        _setCaptureError(err.message.toString());
      }
    } finally {
      _isCapturing = false;
    }
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<Uint8List> _getPngUint8List(List<int> fingerImage) async {
    final img = await loadImage(Uint8List.fromList(fingerImage));
    final byteImg = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteImg!.buffer.asUint8List();
  }

  Future<File> _createFileFromUint8List(
      Uint8List imageBytes, String fileName) async {
    logIt('filename-> $fileName');
    final tempDir = await getTemporaryDirectory();
    final kFile = await File('${tempDir.path}/$fileName.png').create();
    if (kFile.existsSync()) {
      kFile.deleteSync();
    }
    kFile.writeAsBytesSync(imageBytes);
    return Future.value(kFile);
  }

  _getSignature() {
    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'emp_code': selectedEmpCode,
    };

    WebService.fromApi(AppConfig.getEmpSign, this, jsonBody)
        .callPostService(context);
  }
}

enum AmountType {
  Voucher,
  BankPaid,
  LoanInstallment,
  AdvancePaid,
  EsiEpf,
}

class SalaryEmployeeModel {
  final String name;
  final String empCode;
  final String empImage;
  final String sectionCode;
  final String lscode;
  final String empTypeName;
  final String empTypeId;

  SalaryEmployeeModel({
    this.name = '',
    this.sectionCode = '',
    this.empCode = '',
    this.empImage = '',
    this.lscode = '',
    this.empTypeName = '',
    this.empTypeId = '',
  });

  factory SalaryEmployeeModel.fromJson(Map<String, dynamic> data) {
    return SalaryEmployeeModel(
      empCode: getString(data, 'code'),
      sectionCode: getString(data, 'section_code'),
      empImage: getString(data['emp_profile_pic'], 'code_pk'),
      name:
          '${getString(data, 'first_name')} ${getString(data, 'middle_name')} ${getString(data, 'last_name')}',
      lscode: getString(data, 'ls_code'),
    );
  }
  //For Full And Final
  factory SalaryEmployeeModel.fromEmp(Map<String, dynamic> data) {
    return SalaryEmployeeModel(
      empCode: getString(data, 'code'),
      sectionCode: getString(data, 'section_code'),
      empImage: getString(data['emp_profile_pic'], 'code_pk'),
      name:
          '${getString(data, 'first_name')} ${getString(data, 'middle_name')} ${getString(data, 'last_name')}',
      lscode: getString(data, 'ls_code'),
      empTypeId: getString(data['emp_type_name'], 'type'),
      empTypeName: getString(data['emp_type_name'], 'name'),
    );
  }
}

/// Todo : Modification in form
