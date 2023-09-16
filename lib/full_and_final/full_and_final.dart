import 'dart:convert';
import 'dart:core';

import 'package:dataproject2/salary/employee_salary_paid.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import '../network/NetworkResponse.dart';
import '../network/WebService.dart';

class FullAndFinal extends StatefulWidget {
  final String? compId;

  const FullAndFinal({Key? key, required this.compId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FullAndFinal();
}

class _FullAndFinal extends State<FullAndFinal> with NetworkResponse {
  final _formKey = GlobalKey<FormState>();
  final hspacer = SizedBox(
    width: 16,
  );
  final vspacer = SizedBox(
    height: 16,
  );

  String empName = '';
  String? _baseUrl = '';
  String empCode = '';
  String actualdata = 'Yes';
  String simulation = 'No';
  String _empcode = '0';
  String _salary = '0';
  String _payableSalary = '0';
  String _earned = '0';
  String _d = '0';
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

  List<SalaryEmployeeModel> _filterEmpList = [];
  TextEditingController _yearmonthController = TextEditingController();
  TextEditingController _empNameController = TextEditingController();
  TextEditingController _empTypeController = TextEditingController();
  TextEditingController _payBasisController = TextEditingController();

  //TextEditingController nameController = TextEditingController();
  String selectedEmpTypeid = '';
  DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
  _yearmonthController.text = DateFormat('yyyyMM').format(now);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getEmploy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Full And Final"),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ///Emp code
                        Row(
                          children: [
                            Flexible(
                              child: TypeAheadFormField<SalaryEmployeeModel>(
                                validator: (value) =>
                                empCode.isEmpty && empName.isEmpty
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
                                  _empTypeController.text = sg.empTypeName;
                                  _empNameController.text = sg.name;
                                  empCode = sg.empCode;
                                  selectedEmpTypeid = sg.empTypeId;
                                  setState(() {});
                                },
                                suggestionsCallback: (String pattern) {
                                  return _getFilteredEmpList(pattern);
                                },
                                textFieldConfiguration: TextFieldConfiguration(
                                    controller: _empNameController,
                                    textAlign: TextAlign.start,
                                    decoration: InputDecoration(
                                        labelText: 'Emp Code',
                                        hintText: ' Emp Code',
                                        border: OutlineInputBorder(),
                                        suffixIcon:
                                        Icon(Icons.keyboard_arrow_down),
                                        isDense: true)),
                              ),
                            ),
                            Visibility(
                                visible: _empNameController.text.isNotEmpty,
                                child: SizedBox(width: 8)),
                            Visibility(
                                visible: _empNameController.text.isNotEmpty,
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                         _empNameController.clear();
                                         _empTypeController.clear();
                                         _payBasisController.clear();
                                        _cleardetails();
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
                        vspacer,
                        /// Yyyymm
                        TextFormField(
                          readOnly: true,
                            maxLength: 6,
                            controller: _yearmonthController,
                            validator: (v) => v!.trim().length < 6
                                ? 'Enter valid Yyyymm'
                                : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.date_range),
                              border: OutlineInputBorder(),
                              labelText: "Yyyymm",
                              counterText: "",
                              isDense: true,
                            ),
                          onTap: () {
                            _selectYearMonth(BuildContext);
                          },
                        ),
                        vspacer,
                        Row(
                          children: [
                            Column(
                              //Actual Data
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Actual Data'),
                                  Row(
                                    children: [
                                      Text('Yes'),
                                      Radio(
                                          value: 'Yes',
                                          groupValue: actualdata,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              actualdata = 'Yes';
                                            });
                                          }),
                                      Text('No'),
                                      Radio(
                                          value: 'No',
                                          groupValue: actualdata,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              actualdata = 'No';
                                            });
                                          })
                                    ],
                                  ),
                                ]),
                            hspacer,
                            Column(
                              //Simulation
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Simulation'),
                                  Row(
                                    children: [
                                      Text('Yes'),
                                      Radio(
                                          value: 'Yes',
                                          groupValue: simulation,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              simulation = 'Yes';
                                            });
                                          }),
                                      Text('No'),
                                      Radio(
                                          value: 'No',
                                          groupValue: simulation,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              simulation = 'No';
                                            });
                                          })
                                    ],
                                  ),
                                ]),
                          ],
                        ),
                        vspacer,
                        ///Emp Type
                        TextFormField(
                            controller: _empTypeController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Emp Type",
                              isDense: true,
                            )),
                        vspacer,
                        ///Calculate
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()){
                                _getCalculate();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Calculate',
                                style: TextStyle(fontSize: 16),
                              ),
                            )),
                        vspacer,
                        ///image
                        Container(
                          child: Image.asset(
                            'images/noImage.png',
                            height: 128,
                            width: 128,
                          ),
                        ),
                        vspacer,
                        Table(
                          border: TableBorder.all(),
                          children: [

                            /// Employee Code
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Employee Code',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_empcode,
                                    style: TextStyle(fontSize: 15)),
                              )
                            ]),

                            /// Salary
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Salary',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_salary,
                                    style: TextStyle(fontSize: 15)),
                              )
                            ]),

                            /// Earned
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Earned',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                            //D
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'D',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _d,
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
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

                            /// Payable Salary
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Payable Salary',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _payableSalary,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )
                            ]),
                          ],
                        ),
                        vspacer,
                        /// Pay Basis
                        TextFormField(
                          controller: _payBasisController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Pay Basis',
                          ),
                        ),
                        vspacer,
                        /// Emp name
                        TextFormField(
                          controller: _empNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Emp Name',
                          ),
                        )
                      ],
                    )
                )
            )
        )
    );
  }

  _selectYearMonth(buildContext) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      DateFormat formatter = DateFormat('yyyyMM');
      _yearmonthController.text = formatter.format(selected);
    }
  }
  _getFilteredEmpList(String str) {
    return _filterEmpList
        .where((i) =>
    i.name.toLowerCase().contains(str.toLowerCase()) ||
        i.empCode.toLowerCase().contains(str.toLowerCase()))
        .toList();
  }

  _getEmploy() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      // 'section_code': selectedDepartmentId,
      // 'sal_month': _salaryMonthController.text.trim()
    };

    WebService.fromApi(AppConfig.fullAndFinalEmployees, this, jsonBody)
        .callPostService(context);
  }

  _getCalculate(){
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'sal_month': _yearmonthController.text,
      'emp_code': empCode,
      'emp_type': selectedEmpTypeid,
      'simulation_value': simulation,
      'actual_tag': actualdata == 'Yes' ? 'Y' : 'N'
    };
    WebService.fromApi(AppConfig.calculateSalary, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    switch (requestCode) {
      case AppConfig.fullAndFinalEmployees:
        {
          var data = jsonDecode(response!);

          if (data['error'] == 'false') {
            var content = data['content'] as List;
            _baseUrl = data['image_png_path'];
            _filterEmpList.clear();
            _filterEmpList.addAll(
                content.map((e) => SalaryEmployeeModel.fromEmp(e)).toList());

            setState(() {});
          }
        }
        break;
      case AppConfig.calculateSalary:
         {
          var data = jsonDecode(response!);
          if (data['error'] == 'false'){
            var salary = data['salary'];
            _payBasisController.text = getString(data['salary_month'], 'pay_basis');
            _empcode = getString(salary,'emp_code');
            _d = getString(data['salary_month'], 'pdays');
            _ot = getString(data, 'overtime_factor');
            _amount = getString(salary, 'ot_amt');
            _advance = getString(salary, 'adv_amt');
            _loan = getString(salary, 'loan_amt');
            _pfEsi = getString(salary, 'pf_esi_amt');
            _bankPaid = getString(salary, 'bank_pay_amt');
            _totalDeductions = getString(salary, 'tot_ded');
            _rfAmount = getString(salary, 'rf_amt');
            int basic = int.parse(getString(data['basic_salary'], 'amount'));
            int basicPercent = ((basic * 40) ~/ 100).toInt();
            _salary = (basic + basicPercent).toString();
            _getEarnedSalary(data);
            _getVoucher(data);
            _getMeal(data);
             print('_earned $_earned _amount $_amount _meal $_meal _voucher $_voucher');
            _totalEarn = (int.parse(_earned) + int.parse(_amount) + int.parse(_meal) + int.parse(_voucher)).toString();
            _payableSalary = (int.parse(_totalEarn) - int.parse(_totalDeductions)).toString();
            _payableSalary = _getRoundOff(_payableSalary).toString();
            setState((){});
          }
        }
        break;
    }
  }

  _getEarnedSalary(Map<String, dynamic> data) {
    try {
      var salaryTransList = data['salary_trans'] as List;
      int hra = 0;
      int basic = int.parse(getString(data['basic_salary'], 'amount'));
      salaryTransList.forEach((element)
      {
        //HRA
        if (getString(element,'tran_code') == 'A110')
        {
          hra = int.parse(getString(element, 'amount'));
        }
      }
      );
      _earned = (hra + basic).toString();
     } catch (err, stack){
      logIt('getEarnedSalary-> $err,$stack');
    }
   }

  _getVoucher(Map<String, dynamic> data) {
    var voucher = ['A130', 'A120', 'A150', 'A170'];
    var content = data['salary_trans'] as List;
    int val = 0;
    content.forEach((element) {
      if (voucher.contains(element['tran_code'])) {
        val += int.parse(getString(element, 'amount'));
      }
    });
    _voucher = val.toString();
  }

  _getMeal(Map<String, dynamic> data) {
    var content = data['salary_trans'] as List;
    int meal = 0;
    content.forEach((element) {
      if (getString(element, 'tran_code') == 'A140') {
        meal = int.parse(getString(element, 'amount'));
      }
    });
    _meal = meal.toString();
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


  _cleardetails() {
     _empcode = '';
     _salary = '0';
     _payableSalary = '0';
     _earned = '0';
     _d = '0';
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
     selectedEmpTypeid = '';
     actualdata='';
     simulation='';
  }
}