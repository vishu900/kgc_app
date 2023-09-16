import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/attendance/model/DepartmentModel.dart';
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

import '../dashboard.dart';
import '../digital_signature/verify_sign.dart';
import 'employee_salary_paid.dart';
import 'dart:ui' as ui;

class SalaryAdvancePaid extends StatefulWidget {
  final String? compId;

  const SalaryAdvancePaid({Key? key, required this.compId}) : super(key: key);

  @override
  _SalaryAdvancePaidState createState() => _SalaryAdvancePaidState();
}

class _SalaryAdvancePaidState extends State<SalaryAdvancePaid>
    with NetworkResponse {
  final vSpacer = SizedBox(height: 16);
  final hSpacer = SizedBox(width: 16);
  final hSpacer2 = SizedBox(width: 8);

  String _empImage = '';
  String _salary = '0';
  String _days = '0';
  String _earned = '0';
  String _ot = '0';
  String _amount = '0';
  String _meal = '0';
  String _voucher = '0';
  String _totalEarn = '0';
  String _advance = '0';
  String _loan = '0';
  String _pfEsi = '0';
  String _bankPaid = '0';
  String _totalDeductions = '0';
  String _rfAmount = '0';
  String _netSalary = '0';
  String _totalAdvToBePaid = '0';
  String _totalAdvAlreadyBePaid = '0';
  String _totalAdvLeftToBePaid = '0';
  String _totalEmpToBePaid = '0';
  String _totalEmpAlreadyTaken = '0';
  String _totalEmpLeft = '0';
  TextEditingController _docDate = TextEditingController();
  TextEditingController _salaryMonthController = TextEditingController();
  TextEditingController _amountPaidController = TextEditingController();
  TextEditingController _amountAlreadyPaidController = TextEditingController();
  TextEditingController allempController = TextEditingController();
  DateTime _docDateDT = DateTime.now();
  DateTime now = DateTime.now();
  final empNameController = TextEditingController();
  String selectedEmpCode = '';
  String? selectedDepartmentId = '';
  String _baseUrl = '';
  String ledgerName = 'N/A';
  String ledgerValue = 'N/A';

  List<SalaryEmployeeModel> _filterEmpList = [];
  List<AdvanceHistoryModel> advanceHistoryList = [];
  List<DepartmentModel> departmentList = [];
  List<SalaryEmployeeModel> _filterallEmpList = [];
  TextEditingController _departmentController =
      TextEditingController(text: 'Select Section');

  bool _isPlatformSupported = false;
  bool _isConnected = false;
  bool _isError = false;
  bool _isCapturing = false;
  bool _isAllEmp = false;
  String _status = 'Ready';
  late MantraMfs100 _mfs;
  String _uploadedSign = '';
  StreamSubscription<dynamic>? mfsStream;

  @override
  void initState() {
    _isPlatformSupported = Platform.isAndroid;
    _isConnected = DashboardState.isConnected;
    if (_isPlatformSupported) _registerListener();
    super.initState();
    if (_isPlatformSupported) {
      _mfs = MantraMfs100.instance!;
    }
    _init();
  }

  _init() {
    _docDate.text = _docDateDT.format('dd-MM-yyyy');
    _salaryMonthController.text = _docDateDT.format('yyyyMM');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
      _getEmployee();
      _getAllEmployee();
      _getDepartmentList();
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
    return GestureDetector(
      onTap: () => clearFocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Advance Entry'),
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
        body: SingleChildScrollView(
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

              /// Salary
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _salaryMonthController,
                      textAlignVertical: TextAlignVertical.top,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (v) =>
                          v!.trim().length < 6 ? 'Enter valid date' : null,
                      onChanged: (v) {
                        if (v.trim().length > 5) {
                          //  if (!isOldDate()) {
                          _getEmployee();
                          _getDepartmentList();
                          //  }
                        }
                      },
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Salary Month',
                          labelText: 'Salary Month',
                          //  suffix: Icon(Icons.keyboard_arrow_down, size: 14),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  hSpacer2,
                  Flexible(
                    child: TextFormField(
                      controller: _docDate,
                      readOnly: true,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Doc Date',
                          labelText: 'Doc Date',
                          border: OutlineInputBorder()),
                    ),
                  ),
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
              Row(
                children: [
                  Flexible(
                    child: TypeAheadFormField<SalaryEmployeeModel>(
                      validator: (value) => selectedEmpCode.isEmpty
                          ? 'Please select employee'
                          : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    image: '$_baseUrl${itemData.empImage}.png',
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
                        empNameController.text = sg.name;
                        selectedEmpCode = sg.empCode;
                        _empImage = sg.empImage;
                        departmentList.forEach((element) {
                          if (sg.sectionCode == element.id) {
                            logIt('Bingo-> ${element.name} ');
                            _departmentController.text = element.name!;
                            selectedDepartmentId = element.id;
                          }
                        });
                        allempController.clear();
                        setState(() {});
                        _getAdvDetail();
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
                      visible: _isPlatformSupported, child: SizedBox(width: 8)),
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
                              _amountPaidController.clear();
                              _amountAlreadyPaidController.clear();
                              empNameController.clear();
                              selectedEmpCode = '';
                              _departmentController.clear();
                              selectedDepartmentId = '';
                              _resetDetail();
                            });
                          },
                          child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: AppColor.appRed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.clear,
                                  size: 14, color: Colors.white)))),
                ],
              ),
              vSpacer,

              /// All Employee
              Row(
                children: [
                  Flexible(
                    child: TypeAheadFormField<SalaryEmployeeModel>(
                      validator: (value) => selectedEmpCode.isEmpty
                          ? 'Please select employee'
                          : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    image: '$_baseUrl${itemData.empImage}.png',
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
                        allempController.text = sg.name;
                        selectedEmpCode = sg.empCode;
                        _empImage = sg.empImage;
                        departmentList.forEach((element) {
                          if (sg.sectionCode == element.id) {
                            logIt('Bingo-> ${element.name} ');
                            _departmentController.text = element.name!;
                            selectedDepartmentId = element.id;
                          }
                        });
                        empNameController.clear();
                        setState(() {});
                        _getAdvDetail();
                      },
                      suggestionsCallback: (String pattern) {
                        return _getFilteredAllEmpList(pattern);
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                          textAlign: TextAlign.start,
                          controller: allempController,
                          onChanged: (v) {},
                          decoration: InputDecoration(
                              hintText: 'All Employee ',
                              labelText: 'All Employee ',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              isDense: true)),
                    ),
                  ),
                  Visibility(
                      visible: _isPlatformSupported, child: SizedBox(width: 8)),
                  Visibility(
                      visible: _isPlatformSupported,
                      child: GestureDetector(
                          onTap: () {
                            _isAllEmp = true;
                            _captureFingerPrint();
                          },
                          child: Container(
                              height: 50,
                              width: 48,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _isCapturing && _isAllEmp
                                        ? Colors.red
                                        : Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(Icons.fingerprint_outlined,
                                  size: 42,
                                  color: _isCapturing && _isAllEmp
                                      ? Colors.red
                                      : Colors.grey)))),
                  Visibility(
                      visible: allempController.text.isNotEmpty,
                      child: SizedBox(width: 8)),
                  Visibility(
                      visible: allempController.text.isNotEmpty,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              allempController.clear();
                              _amountPaidController.clear();
                              _amountAlreadyPaidController.clear();
                              allempController.clear();
                              selectedEmpCode = '';
                              _departmentController.clear();
                              selectedDepartmentId = '';
                              _resetDetail();
                            });
                          },
                          child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: AppColor.appRed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.clear,
                                  size: 14, color: Colors.white)))),
                ],
              ),
              vSpacer,

              /// Amount Paid
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _amountPaidController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(color: Colors.red),
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Amount Paid',
                          labelText: 'Amount Paid',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  hSpacer2,
                  Flexible(
                    child: TextFormField(
                      readOnly: true,
                      controller: _amountAlreadyPaidController,
                      style: TextStyle(color: Colors.blue[900]),
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Amount Already Paid',
                          labelText: 'Amount Already Paid',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
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
              vSpacer,

              ElevatedButton(
                  onPressed: () {
                    clearFocus(context);
                    if (_salaryMonthController.text.isEmpty) {
                      showAlert(context, 'Please enter salary month', 'Error');
                    } else if (_salaryMonthController.text.length < 6) {
                      showAlert(
                          context, 'Please enter valid salary month', 'Error');
                    }
                    // else if (isOldDate()) {
                    //   showAlert(
                    //       context, 'Please enter valid salary month', 'Error');
                    // }
                    else if (selectedEmpCode.isEmpty) {
                      showAlert(context, 'Please select employee', 'Error');
                    } else if (_amountPaidController.text.isEmpty) {
                      showAlert(context, 'Please enter amount', 'Error');
                    } else if (_amountPaidController.text.trim() == '0') {
                      showAlert(context, 'Please enter amount', 'Error');
                    } else if (_amountPaidController.text
                        .trim()
                        .contains('-')) {
                      showAlert(context, 'Please enter valid amount', 'Error');
                    }
                    // else if(int.parse(_netSalary)<int.parse(_amountPaidController.text.trim())){

                    // }
                    else {
                      int payableSal =
                          int.parse(_amountPaidController.text.trim());
                      int paidSal =
                          int.parse(_amountAlreadyPaidController.text.trim());
                      int netSal = int.parse(_netSalary);
                      if (payableSal + paidSal >= netSal) {
                        showAlert(
                            context,
                            'This employee\'s advance is greater than calculated, do you want to pay extra advance?',
                            'Confirm',
                            ok: 'Pay',
                            notOk: 'Cancel', onNo: () {
                          popIt(context);
                        }, onOk: () {
                          _askForSignatureAndPay();
                        });
                      } else if (int.parse(_amountPaidController.text.trim()) <=
                          int.parse(ledgerValue)) {
                        _askForSignatureAndPay();
                      } else {
                        Commons.showToast(
                            'You do not have sufficient ledger balance!');
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Pay',
                      style: TextStyle(fontSize: 16, letterSpacing: 0.5),
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

              Table(
                border: TableBorder.all(),
                children: [
                  /// Salary
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Salary',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_salary, style: TextStyle(fontSize: 15)),
                    )
                  ]),

                  /// Days
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Days',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_days, style: TextStyle(fontSize: 15)),
                    )
                  ]),

                  /// Earned
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Earned',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _earned,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// OT
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Ot',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _ot,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Amount
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Amount',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _amount,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Meal
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Meal',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _meal,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Voucher
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Voucher',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _voucher,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Total Earn
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Earn',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _totalEarn,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Advance
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Advance',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _advance,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Loan
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Loan',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _loan,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Pf/Esi
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Pf/Esi',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _pfEsi,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Bank Paid
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Bank Paid',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _bankPaid,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Total Deductions
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Deductions',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _totalDeductions,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Rf Amount
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Rf Amount',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _rfAmount,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),

                  /// Net Salary
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Net Salary',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _netSalary,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ]),
                ],
              ),
              vSpacer,

              Table(
                border: TableBorder.all(),
                children: [
                  /// Header
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total advance to be paid',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total advance already paid',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total advance left to be pay',
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
                        _totalAdvToBePaid,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _totalAdvAlreadyBePaid,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _totalAdvLeftToBePaid,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ]),
                ],
              ),
              vSpacer,

              Table(
                border: TableBorder.all(),
                children: [
                  /// Header
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total employees to be paid',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total employees already taken',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total employees left',
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
                        _totalEmpToBePaid,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _totalEmpAlreadyTaken,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _totalEmpLeft,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ]),
                ],
              ),
              vSpacer,

              Visibility(
                visible: advanceHistoryList.isNotEmpty,
                child: Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Date',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'User',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Amount',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ])
                  ],
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: advanceHistoryList.length,
                  itemBuilder: (ctx, index) => Table(
                        border: TableBorder(
                            bottom: BorderSide(),
                            left: BorderSide(),
                            right: BorderSide(),
                            verticalInside: BorderSide()),
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                advanceHistoryList[index].date!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                advanceHistoryList[index].userName!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showAdvanceUpdateAlert(
                                    advanceHistoryList[index].amount,
                                    advanceHistoryList[index].id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      advanceHistoryList[index].amount!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.edit, size: 20)
                                  ],
                                ),
                              ),
                            ),
                          ])
                        ],
                      )),

              vSpacer,
              vSpacer,
            ],
          ),
        ),
      ),
    );
  }

  bool isOldDate() {
    DateTime _now = DateTime(now.year, now.month);
    String year = _salaryMonthController.text.trim().substring(0, 4);
    String month = _salaryMonthController.text.trim().substring(4, 6);
    DateTime enteredDate = DateTime(int.parse(year), int.parse(month));
    return enteredDate.isBefore(_now);
  }

  _getDepartmentList() {
    Map jsonBody = {
      'user_id': getUserId(),
      'table_name': 'SECTION',
      'comp_code': widget.compId,
      //'sal_month': _salaryMonthController.text.trim()
    };

    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody)
        .callPostService(context);
  }

  _getEmployee() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'section_code': selectedDepartmentId,
      'sal_month': _salaryMonthController.text.trim()
    };

    WebService.fromApi(AppConfig.salaryAdvEmployee, this, jsonBody)
        .callPostService(context);
  }

  _getAllEmployee() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'section_code': selectedDepartmentId,
      'sal_month': _salaryMonthController.text.trim(),
      'ignore_advance': '1'
    };

    WebService.fromApi(AppConfig.salaryAdvEmployee, this, jsonBody,
            reqCode: 'getAllEmployee')
        .callPostService(context);
  }

  _getAdvDetail() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'emp_code': selectedEmpCode,
      'sal_month': _salaryMonthController.text
    };

    WebService.fromApi(AppConfig.salaryViewAdvEmployee, this, jsonBody)
        .callPostService(context);
  }

  _getSignature() {
    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'emp_code': selectedEmpCode,
    };

    WebService.fromApi(AppConfig.getEmpSign, this, jsonBody)
        .callPostService(context);
  }

  Future getSalaryMonth() async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Year"),
            content: Container(
              // Need to use container to add size constraint.
              width: 300,
              height: 300,
              child: CalendarDatePicker(
                  firstDate: DateTime(DateTime.now().year - 100, 1),
                  lastDate: DateTime(DateTime.now().year + 100, 1),
                  initialDate: now,
                  initialCalendarMode: DatePickerMode.day,
                  onDateChanged: (selectedDate) {
                    popIt(context);
                    // ignore: unnecessary_null_comparison
                    if (selectedDate == null) return;
                    setState(() {
                      _salaryMonthController.text =
                          selectedDate.format('yyyyMM');
                    });
                  }),
            ),
          );
        },
      );
    } catch (e, stack) {
      print("an Error occurred $e $stack");
    }
  }

  _getFilteredEmpList(String str) {
    return _filterEmpList
        .where((i) =>
            i.name.toLowerCase().contains(str.toLowerCase()) ||
            i.empCode.toLowerCase().contains(str.toLowerCase()))
        .toList();
  }

  _getFilteredAllEmpList(String str) {
    return _filterallEmpList
        .where((i) =>
            i.name.toLowerCase().contains(str.toLowerCase()) ||
            i.empCode.toLowerCase().contains(str.toLowerCase()))
        .toList();
  }

  _askForSignatureAndPay() {
    showAlert(context, 'Do you want to get the signature?', 'Confirm',
        ok: 'Yes, Sign and Pay', notOk: 'No, Just Pay', onNo: () {
      popIt(context);
      _submitAdvance();
    }, onOk: () {
      _showSignPadAndVerifySign();
    });
  }

  _showSignPadAndVerifySign() async {
    final res = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VerifySign(uploadedSign: _uploadedSign)));

    if (res == null) return;

    if (res['status']) {
      File file = await createFileFromUint8List(res['data'] as Uint8List);
      _submitAdvance(file: file);
    }
  }

  _submitAdvance({File? file}) {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'emp_code': selectedEmpCode,
      'doc_date': _docDate.text,
      'sal_month': _salaryMonthController.text,
      'amt_paid': _amountPaidController.text,
    };

    if (file != null) {
      // logIt('Submit Advance : With Sign');
      WebService.multipartApi(
              AppConfig.saveAdvanceSalary, this, jsonBody, file.absolute.path)
          .callMultipartPostService(context, fileName: 'employee_sign');
    } else {
      //logIt('Submit Advance : Without Sign');
      WebService.fromApi(AppConfig.saveAdvanceSalary, this, jsonBody)
          .callPostService(context);
    }
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
                      selectedEmpCode = '';
                      _amountPaidController.clear();
                      _amountAlreadyPaidController.clear();
                      empNameController.clear();
                      _resetDetail();

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

        case AppConfig.saveAdvanceSalary:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                _resetDetail();
                empNameController.clear();
                _amountPaidController.clear();
                _amountAlreadyPaidController.clear();
                empNameController.clear();
                selectedEmpCode = '';
                _departmentController.clear();
                selectedDepartmentId = '';
                advanceHistoryList.clear();
                _getEmployee();
              });
            } else {
              showAlert(context, data['message'], 'Success');
            }
          }
          break;

        case AppConfig.salaryAdvEmployee:
          {
            var data = jsonDecode(response!);
            logIt('onResponseEmployee-> $data');
            if (data['error'] == 'false') {
              var content = data['content'] as List;

              _filterEmpList.clear();
              _filterEmpList.addAll(
                  content.map((e) => SalaryEmployeeModel.fromJson(e)).toList());

              logIt('EmpLIstLength-> ${_filterEmpList.length}');
              _baseUrl = getString(data, 'image_png_path');
              ledgerName = getString(data, 'ladger_name');
              ledgerValue = getString(data, 'ladger_bal');

              setState(() {});
            }
          }
          break;

        case 'getAllEmployee':
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;
              _filterallEmpList.clear();
              _filterallEmpList.addAll(
                  content.map((e) => SalaryEmployeeModel.fromJson(e)).toList());
              logIt('EmpAllListLength-> ${_filterallEmpList.length}');
              _baseUrl = getString(data, 'image_png_path');
              ledgerName = getString(data, 'ladger_name');
              ledgerValue = getString(data, 'ladger_bal');
              setState(() {});
            }
          }
          break;

        case AppConfig.editAdvanceSalary:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                _getAdvDetail();
              });
            } else {
              showAlert(context, data['message'], 'Error');
            }
          }
          break;

        case AppConfig.salaryViewAdvEmployee:
          {
            _getSignature();
            var resp = jsonDecode(response!);

            if (resp['error'] == 'false') {
              var data = resp['content'];

              _salary = getString(data, 'salary');
              _days = getString(data, 'days');
              _earned = getString(data, 'earned');
              _ot = getString(data, 'ot');
              _amount = getString(data, 'amt');
              _meal = getString(data, 'meal');
              _voucher = getString(data, 'voucher');
              _totalEarn = getString(data, 'tot_earn');
              _advance = getString(data, 'adv');
              _loan = getString(data, 'loan');
              _pfEsi = getString(data, 'pf_esi');
              _bankPaid = getString(data, 'bank_paid');
              _totalDeductions = getString(data, 'tot_ded');
              _rfAmount = getString(data, 'rf_amt');
              _amountAlreadyPaidController.text =
                  getString(resp, 'total_advance');
              _netSalary = getString(data, 'net_sal');
              _amountPaidController.text = (int.parse(_netSalary) -
                      int.parse(_amountAlreadyPaidController.text))
                  .toString();

              if (_amountPaidController.text.contains('-') ||
                  _netSalary == '0') {
                _amountPaidController.text = '0';
              }

              _totalAdvToBePaid = getString(resp, 'total_advance_to_be_paid');
              _totalAdvAlreadyBePaid = getString(resp, 'total_advance_paid');
              _totalAdvLeftToBePaid = (int.parse(_totalAdvToBePaid) -
                      int.parse(_totalAdvAlreadyBePaid))
                  .toString();
              _totalEmpToBePaid = getString(resp, 'total_employees_to_be_paid');
              _totalEmpAlreadyTaken = getString(resp, 'total_employees_paid');
              _totalEmpLeft = (int.parse(_totalEmpToBePaid) -
                      int.parse(_totalEmpAlreadyTaken))
                  .toString();

              ledgerName = getString(resp, 'ledger_name');
              ledgerValue = getString(resp, 'ledger_balance');

              advanceHistoryList.clear();

              var history = resp['advance_lists'] as List;

              advanceHistoryList.addAll(
                  history.map((e) => AdvanceHistoryModel.parse(e)).toList());

              setState(() {});
            }
          }
          break;

        case AppConfig.findEmployeeByFingerprint:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              if (data['content'] != null) {
                if (_isAllEmp) {
                  allempController.text =
                      '${getStringValue(data['content'], 'first_name')} ${getStringValue(data['content'], 'middle_name')} ${getStringValue(data['content'], 'last_name')}';
                } else {
                  empNameController.text =
                      '${getStringValue(data['content'], 'first_name')} ${getStringValue(data['content'], 'middle_name')} ${getStringValue(data['content'], 'last_name')}';
                }

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
                _getAdvDetail();
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
    } catch (err) {
      logIt('onResponse-> $err');
    }
  }

  String getString(data, String key) {
    if (data == null) return '0';
    if (data[key] != null) {
      return data[key].toString();
    } else {
      return '0';
    }
  }

  _showAdvanceUpdateAlert(String? prevAmt, String? id) {
    final TextEditingController advance = TextEditingController(text: prevAmt);
    final GlobalKey<FormState> formKey = GlobalKey();

    AlertDialog alert = AlertDialog(
      title: Text('Update Advance'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: advance,
          autofocus: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) => v!.trim().isEmpty ? 'Required' : null,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(labelText: 'Advance'),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Update', style: TextStyle(color: Colors.red)),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              popIt(context);
              _updateAdvance(prevAmt, advance.text.trim(), id);
            }
          },
        ),
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Colors.red)),
          onPressed: () {
            popIt(context);
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
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      // ignore: missing_return
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          SizedBox(),
    );
  }

  _updateAdvance(String? prevAmt, String newAmt, String? id) {
    Map jsonBody = {
      'code_pk': id,
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'emp_code': selectedEmpCode,
      'sal_month': _salaryMonthController.text,
      'amt_paid': prevAmt,
      'new_amt_paid': newAmt
    };

    WebService.fromApi(AppConfig.editAdvanceSalary, this, jsonBody)
        .callPostService(context);
  }

  _resetDetail() {
    _salary = '0';
    _days = '0';
    _earned = '0';
    _ot = '0';
    _amount = '0';
    _meal = '0';
    _voucher = '0';
    _totalEarn = '0';
    _advance = '0';
    _loan = '0';
    _pfEsi = '0';
    _bankPaid = '0';
    _totalDeductions = '0';
    _rfAmount = '0';
    _netSalary = '0';
    _totalAdvToBePaid = '0';
    _totalAdvAlreadyBePaid = '0';
    _totalAdvLeftToBePaid = '0';
    _totalEmpToBePaid = '0';
    _totalEmpAlreadyTaken = '0';
    _totalEmpLeft = '0';
    _empImage = '';
  }

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
      _findEmployee(file.absolute.path, ignore: _isAllEmp);
    } catch (err) {
      if (err is PlatformException) {
        _setCaptureError(err.message.toString());
      }
    } finally {
      _isCapturing = false;
    }
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

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  _findEmployee(String filePath, {bool ignore = false}) {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'sal_month': _salaryMonthController.text.trim(),
      'type': 'advance',
    };

    if (ignore) jsonBody.addAll({'ignore_advance': '1'});

    WebService.multipartApi(
            AppConfig.findEmployeeByFingerprint, this, jsonBody, filePath)
        .callMultipartPostService(context, fileName: 'fingerprint_image');
  }

  @override
  void dispose() {
    if (_isPlatformSupported) {
      // _mfs.unInit();
      mfsStream?.cancel();
    }
    super.dispose();
  }
}

class AdvanceHistoryModel {
  final String? id;
  final String? userName;
  final String? amount;
  final String? date;

  AdvanceHistoryModel({this.id, this.userName, this.amount, this.date});

  factory AdvanceHistoryModel.parse(Map<String, dynamic> data) {
    return AdvanceHistoryModel(
      id: getString(data, 'code_pk'),
      date: getString(data, 'doc_date'),
      amount: getString(data, 'amt_paid'),
      userName: getString(data['ins_user_name'], 'name'),
    );
  }
}
