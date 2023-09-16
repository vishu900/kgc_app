import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/attendance/model/WorkMachineCodeModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeMachineMapping extends StatefulWidget {

  final String? date;
  final String? employeeCode;
  final String? compCode;
  final String? empName;
  final String? fatherName;

  const EmployeeMachineMapping(
      {Key? key, this.date,
        this.employeeCode,
        this.compCode,
        this.empName='',
        this.fatherName='',
      })
      : super(key: key);

  @override
  _EmployeeMachineMappingState createState() => _EmployeeMachineMappingState();

}

class _EmployeeMachineMappingState extends State<EmployeeMachineMapping>
    with NetworkResponse {

  TextEditingController dateController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  TextEditingController empCodeController = TextEditingController();
  TextEditingController empNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController workSecCodeController = TextEditingController();
  TextEditingController workMachineCodeController = TextEditingController();
  DateTime now = DateTime.now();
  String? selectedWorkSecCode = '';
  String? selectedWorkMacCode = '';
  String selectedSectionCode = '';

  List<WorkMachineCodeModel> workMachineCodeList = [];
  List<WorkMachineCodeModel> workSecCodeList = [];
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      empNameController.text=widget.empName!;
      fatherNameController.text=widget.fatherName!;
      dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
      empCodeController.text = widget.employeeCode!;
      _getWorkMachineCode();
      _getWorkMachineSecCode();
      _getPreFilled();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Employee Machine Mapping'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Doc Date
              TextFormField(
                controller: dateController,
                readOnly: true,
                style: TextStyle(),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Date',
                  // labelText: 'Enter Date'
                ),
                //  onTap: _fromDate,
              ),
              SizedBox(
                height: 20,
              ),

              /// Shift
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Please select shift' : null,
                controller: shiftController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                readOnly: true,
                onTap: () {
                  shiftSheet(context);
                },
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'e.g. Day',
                    labelText: 'Shift'),
              ),
              SizedBox(
                height: 20,
              ),

              /// Emp Code
              TextFormField(
                controller: empCodeController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    //hintText: 'e.g. Day',
                    labelText: 'Employee Code'),
              ),
              SizedBox(
                height: 20,
              ),

              /// Employee Name
              TextFormField(
                controller: empNameController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Employee Name'),
              ),
              SizedBox(
                height: 20,
              ),

              /// Father Name
              TextFormField(
                controller: fatherNameController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    //hintText: 'e.g. Day',
                    labelText: 'Father Name'),
              ),
              SizedBox(
                height: 20,
              ),

              /// Section
              TextFormField(
                controller: sectionController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Section'),
              ),
              SizedBox(
                height: 20,
              ),

              /// Work Sec Code
              TextFormField(
                validator: (val) =>
                    val!.isEmpty ? 'Please select work sec code' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: workSecCodeController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                readOnly: true,
                onTap: () {
                  workMachineSecSheet(context);
                },
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Work Sec Code'),
              ),
              SizedBox(
                height: 20,
              ),

              /// Work Machine Code
              TextFormField(
                validator: (val) =>
                    val!.isEmpty ? 'Please select work machine code' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: workMachineCodeController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                readOnly: true,
                onTap: () {
                  workMachineSheet(context);
                },
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Work Machine Code'),
              ),
              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _mapMacToEmployee();
                    }
                  },
                  child: Text(
                    'Assign',
                    style: TextStyle(fontSize: 16, letterSpacing: 0.8),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _getPreFilled() {
    Map jsonBody = {
      'user_id': getUserId(),
      'emp_code': empCodeController.text,
    };

    WebService.fromApi(AppConfig.getDailyProd, this, jsonBody)
        .callPostService(context);
  } //

  _getWorkMachineSecCode() {
    Map jsonBody = {
      'user_id': getUserId(),
      'table_name': 'SECTION',
      'dept_code': '1'
    };

    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody)
        .callPostService(context);
  }

  _getWorkMachineCode() {
    Map jsonBody = {'user_id': getUserId()};

    WebService.fromApi(AppConfig.workMachine, this, jsonBody)
        .callPostService(context);
  }

  _mapMacToEmployee() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compCode,
      'emp_code': widget.employeeCode,
      'work_sec_code': selectedWorkSecCode,
      'work_machine_code': selectedWorkMacCode,
      'day_night': shiftController.text == 'Day' ? 'D' : 'N'
    }; //updateProdMpPlan
    logIt('mapMaxToEmployee-> $jsonBody');
    WebService.fromApi(AppConfig.updateProdMpPlan, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.workMachine:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              workMachineCodeList.clear();

              var content = data['content'] as List;
              workMachineCodeList.addAll(
                  content.map((e) => WorkMachineCodeModel.parse(e)).toList());

              setState(() {});
            }

          }
          break;
        case AppConfig.searchItemParameters:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              workSecCodeList.clear();

              var content = data['content'] as List;
              workSecCodeList.addAll(content
                  .map((e) => WorkMachineCodeModel.parseCode(e))
                  .toList());

              setState(() {});
            }

          }
          break;

        case AppConfig.getDailyProd:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              logIt('getDailyProd-> $data');

              if (data['content'] == null) return;

              shiftController.text =
                  getString(data['content'], 'day_night') == 'D'
                      ? 'Day'
                      : 'Night';
              empNameController.text =
                  '${getString(data['content']['employee_name'], 'first_name')} ${getString(data['content']['employee_name'], 'middle_name')} ${getString(data['content']['employee_name'], 'last_name')}';

              fatherNameController.text = getString(
                  data['content']['employee_name']['emp_info'], 'father_name');
              sectionController.text = getString(
                  data['content']['employee_name']['emp_section_name'], 'name');
              selectedSectionCode = getString(
                  data['content']['employee_name']['emp_section_name'], 'code');
              workSecCodeController.text =
                  getString(data['content']['work_section_name'], 'name');
              selectedWorkSecCode =
                  getString(data['content']['work_section_name'], 'code');
              workMachineCodeController.text =
                  getString(data['content']['work_machine_name'], 'name');
              selectedWorkMacCode =
                  getString(data['content']['work_machine_name'], 'code');
            }
          }
          break;

        case AppConfig.updateProdMpPlan:
          {
            var data = jsonDecode(response!);
            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                popIt(context);
              });
            } else {
              showAlert(context, data['message'], 'Failed');
            }
          }

      }
    } catch (err, stack) {
      logIt('onResponse-> $err $stack');
    }
  }

  void shiftSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Day'),
                  ),
                  onTap: () {
                    popIt(context);
                    shiftController.text = 'Day';
                  },
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Night'),
                  ),
                  onTap: () {
                    popIt(context);
                    shiftController.text = 'Night';
                  },
                ),
              ],
            ),
          );
        });
  }

  void workMachineSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
                itemCount: workMachineCodeList.length,
                itemBuilder: (context, index) => ListTile(
                      leading: Text(workMachineCodeList[index].id!),
                      title: Text(workMachineCodeList[index].name!),
                      subtitle: Text(workMachineCodeList[index].name!),
                      onTap: () {
                        popIt(context);
                        workMachineCodeController.text =
                            workMachineCodeList[index].name!;
                        selectedWorkMacCode = workMachineCodeList[index].id;
                      },
                    )),
          );
        });
  }

  void workMachineSecSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
                itemCount: workSecCodeList.length,
                itemBuilder: (context, index) => ListTile(
                      leading: Text(workSecCodeList[index].id!),
                      title: Text(workSecCodeList[index].name!),
                      onTap: () {
                        popIt(context);
                        workSecCodeController.text =
                            workSecCodeList[index].name!;
                        selectedWorkSecCode = workSecCodeList[index].id;
                      },
                    )),
          );
        });
  }

}
