import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/attendance/model/DepartmentModel.dart';
import 'package:dataproject2/datamodel/UserModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/newmodel/QCompanyModel.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'ViewAttendance.dart';
import 'ViewSMS.dart';
import 'model/EmployeeAttendanceModel.dart';
import 'model/SmsModel.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> with NetworkResponse {

  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _employeeNameController = TextEditingController();
  TextEditingController _departmentController = TextEditingController(text: 'Select Section');
  TextEditingController companyController = TextEditingController(text: 'Select Company');
  List<EmployeeAttendanceModel> employeeAttendanceList = [];

  List<DepartmentModel> departmentList = [];
  List<UserModel> employeeList = [];
  List<QCompanyModel> companyList = [];
  List<SmsModel> smsList = [];
  DateTime now = DateTime.now();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String? selectedDepartmentId = '';
  String? selectedEmployeeNameId = '';

  String totalEmployee = '';
  String presentEmployee = '';
  String absentEmployee = '';
  String maleEmployee = '';
  String femaleEmployee = '';
  String imageBaseUrl = '';
  String? attendanceType = 'all';
  String? shiftType = 'all';
  String? genderType = 'all';
  String? compCode = '';
  String baseUrl = '';
  Map searchJson = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initState();
  }

  _initState() {
    _fromDateController.text = DateFormat('dd-MM-yyyy').format(now);
    _toDateController.text = _fromDateController.text;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCompanyList();
      //_getEmployeeList();
      /*_getDepartmentList();*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Attendance'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        physics: BouncingScrollPhysics(),
        child: Form(
          child: Column(
            children: [
              /// From Date
              TextFormField(
                controller: _fromDateController,
                readOnly: true,
                style: TextStyle(),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'From Date',
                    labelText: 'From Date'),
                onTap: _fromDate,
              ),
              SizedBox(
                height: 20,
              ),

              /// To Date
              TextFormField(
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
                    labelText: 'To Date'),
                onTap: _toDate,
              ),
              SizedBox(
                height: 20,
              ),

              /// Company Name
              TextFormField(
                validator: (val) =>
                    val!.trim().isEmpty ? 'Please select company' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: companyController,
                readOnly: true,
                onTap: () {
                  _companyBottomSheet(context);
                },
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    isDense: true,
                    hintText: 'Company',
                    labelText: 'Company',
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),

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

              SizedBox(
                height: 20,
              ),

              /// Employee Name
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) =>
                          _employeeNameController.text.trim().isNotEmpty
                              ? selectedEmployeeNameId!.trim().isEmpty
                                  ? 'Please select employee name'
                                  : null
                              : null,
                      controller: _employeeNameController,
                      cursorColor: Colors.black,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      onTap: () {
                        getEmployeeSheet(context);
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: 'Employee Name',
                        // labelText: 'Enter Date'
                      ),
                    ),
                  ),
                  Visibility(
                      visible: _employeeNameController.text.isNotEmpty,
                      child: SizedBox(width: 8)),
                  Visibility(
                      visible: _employeeNameController.text.isNotEmpty,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _employeeNameController.clear();
                              selectedEmployeeNameId = '';
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
              SizedBox(
                height: 12,
              ),

              Row(
                children: [
                  /// All
                  Row(
                    children: [
                      Radio(
                          value: 'all',
                          groupValue: attendanceType,
                          onChanged: (dynamic v) {
                            setState(() {
                              attendanceType = v;
                            });
                          }),
                      Text('All')
                    ],
                  ),

                  /// Present
                  Row(
                    children: [
                      Radio(
                          value: 'present',
                          groupValue: attendanceType,
                          onChanged: (dynamic v) {
                            setState(() {
                              attendanceType = v;
                            });
                          }),
                      Text('Present')
                    ],
                  ),

                  /// Absent
                  Row(
                    children: [
                      Radio(
                          value: 'absent',
                          groupValue: attendanceType,
                          onChanged: (dynamic v) {
                            setState(() {
                              attendanceType = v;
                            });
                          }),
                      Text('Absent')
                    ],
                  )
                ],
              ),

              Row(
                children: [
                  /// All
                  Row(
                    children: [
                      Radio(
                          value: 'all',
                          groupValue: shiftType,
                          onChanged: (dynamic v) {
                            setState(() {
                              shiftType = v;
                            });
                          }),
                      Text('All')
                    ],
                  ),

                  /// Day
                  Row(
                    children: [
                      Radio(
                          value: 'day',
                          groupValue: shiftType,
                          onChanged: (dynamic v) {
                            setState(() {
                              shiftType = v;
                            });
                          }),
                      Text('Day')
                    ],
                  ),

                  /// Night
                  Row(
                    children: [
                      Radio(
                          value: 'night',
                          groupValue: shiftType,
                          onChanged: (dynamic v) {
                            setState(() {
                              shiftType = v;
                            });
                          }),
                      Text('Night')
                    ],
                  ),
                ],
              ),

              Row(
                children: [
                  /// All
                  Row(
                    children: [
                      Radio(
                          value: 'all',
                          groupValue: genderType,
                          onChanged: (dynamic v) {
                            setState(() {
                              genderType = v;
                            });
                          }),
                      Text('All')
                    ],
                  ),

                  /// Male
                  Row(
                    children: [
                      Radio(
                          value: 'male',
                          groupValue: genderType,
                          onChanged: (dynamic v) {
                            setState(() {
                              genderType = v;
                            });
                          }),
                      Text('Male')
                    ],
                  ),

                  /// Female
                  Row(
                    children: [
                      Radio(
                          value: 'female',
                          groupValue: genderType,
                          onChanged: (dynamic v) {
                            setState(() {
                              genderType = v;
                            });
                          }),
                      Text('Female')
                    ],
                  )
                ],
              ),

              SizedBox(
                height: 20,
              ),

              /*   /// Employee Code
              TextFormField(
                controller: _employeeCodeController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Employee Code',
                  // labelText: 'Enter Date'
                ),
              ),
              SizedBox(
                height: 60,
              ),*/

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: ifHasPermission(
                        compCode: compCode,
                        permission: Permissions.ATTENDANCE)!,
                    child: ElevatedButton(
                      child: Text(
                        'View Attendance',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: _viewAttendance,
                    ),
                  ),
                  Visibility(
                    visible: ifHasPermission(
                        compCode: compCode,
                        permission: Permissions.ATTENDANCE)!,
                    child: ElevatedButton(
                      child: Text(
                        'View SMS',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: _viewSMS,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _viewAttendance() {
    clearFocus(context);
    if (_fromDateController.text.trim().isEmpty) {
      showAlert(context, 'Please enter from date', 'Error');
      return;
    } else if (_toDateController.text.trim().isEmpty) {
      showAlert(context, 'Please enter to date', 'Error');
      return;
    } else if (fromDate.dateOnly().isAfter(toDate.dateOnly())) {
      showAlert(context, 'Please enter valid date', 'Error');
      return;
    } else if (_employeeNameController.text.trim().isNotEmpty &&
        selectedEmployeeNameId!.isEmpty) {
      showAlert(context, 'Please select employee name', 'Error');
      return;
    } else {
      getAttendanceList();
    }
  }

  _viewSMS() {
    clearFocus(context);
    if (_fromDateController.text.trim().isEmpty) {
      showAlert(context, 'Please enter from date', 'Error');
      return;
    } else if (_toDateController.text.trim().isEmpty) {
      showAlert(context, 'Please enter to date', 'Error');
      return;
    } else {
      getSmsList();
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
      toDate = selectedDate;
      setState(() {
        _toDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    } on Exception catch (e) {
      print("an Error occurred $e");
    }
  }

  Future _fromDate() async {
    try {
      final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2001, 01, 01),
          lastDate: now);

      if (selectedDate == null) return;
      fromDate = selectedDate;
      setState(() {
        _fromDateController.text =
            DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    } catch (e, stack) {
      print("an Error occurred $e $stack");
    }
  }

  getAttendanceList() {
    Map jsonBody = {
      'user_id': getUserId(),
      'code': selectedEmployeeNameId,
      'from_date': _fromDateController.text,
      'to_date': _toDateController.text,
      'section_code': selectedDepartmentId,
      'attendance_type': attendanceType,
      'comp_code': compCode == '3' ? '99' : compCode,
      'day_type': shiftType,
      'gender': genderType
    };

    if (shiftType!.isEmpty) {
      jsonBody.remove('day_type');
    }

    logIt('getAttendanceList-> $jsonBody');

    searchJson = jsonBody;

    WebService.fromApi(AppConfig.attendanceList, this, jsonBody)
        .callPostService(context);
  }

  getSmsList() {
    Map jsonBody = {
      'user_id': getUserId(),
      'emp_code': selectedEmployeeNameId,
      'from_date': _fromDateController.text,
      'to_date': _toDateController.text
    };

    WebService.fromApi(AppConfig.smsList, this, jsonBody)
        .callPostService(context);
  }

  _getDepartmentList() {
    Map jsonBody = {
      'user_id': getUserId(),
      'table_name': 'SECTION',
      'comp_code': compCode == '3' ? '99' : compCode
    };

    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody)
        .callPostService(context);
  }

  _getEmployeeList({String? sectionCode = ''}) {
    Map jsonBody = {
      'user_id': getUserId(),
      'section_code': sectionCode,
      'comp_code': compCode == '3' ? '99' : compCode
    };

    WebService.fromApi(AppConfig.getAllEmployee, this, jsonBody)
        .callPostService(context);
  }

  _getCompanyList() {
    Map jsonBody = {
      'user_id': getUserId(),
      'tid': Permissions.ATTENDANCE,
      'mode_flag': 'S,A,I'
    };
    WebService.fromApi(AppConfig.getCompany, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) async {
    try {
      switch (requestCode) {
        case AppConfig.smsList:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              smsList.clear();
              smsList.addAll(content.map((e) => SmsModel.parseSms(e)).toList());

              Navigator.push(context,MaterialPageRoute(builder: (context) => ViewSms(smsList)));
            }
          }
          break;

        case AppConfig.attendanceList:
          {

              // var data = jsonDecode(response!);

              var data = await compute(jsonDecode, response!);

              if (data['error'] == 'false') {
                var content = data['content'] as List;

                totalEmployee = getString(data, 'total_employees');
                presentEmployee = getString(data, 'present_employees');
                absentEmployee = getString(data, 'absent_employees');
                imageBaseUrl = getString(data, 'image_png_path');

                employeeAttendanceList.clear();

                employeeAttendanceList.addAll(content.map((e) => EmployeeAttendanceModel.parseAttendance(e)).toList());

                logIt('Attendance-> ${employeeAttendanceList.length}');

                if (employeeAttendanceList.isEmpty) {
                  if (selectedEmployeeNameId!.isNotEmpty) {
                    if (attendanceType == 'present') {
                      showAlert(
                          context,
                          '${_employeeNameController.text} is not present.',
                          'Attendance');
                    } else if (attendanceType == 'absent') {
                      showAlert(
                          context,
                          '${_employeeNameController.text} is not absent.',
                          'Attendance');
                    } else {
                      showAlert(context, 'No attendance found', 'Attendance');
                    }
                  } else {
                    showAlert(context, 'No attendance found', 'Attendance');
                  }
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAttendance(
                                employeeAttendanceList,
                                totalEmployee: totalEmployee,
                                presentEmployee: presentEmployee,
                                absentEmployee: absentEmployee,
                                imageBaseUrl: imageBaseUrl,
                                jsonBody: searchJson,
                              )));
                }
              }

          }
          break;

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

        case AppConfig.getAllEmployee:
          {
            var data = jsonDecode(response!);
            imageBaseUrl = getString(data, 'image_png_path');
            employeeList.clear();
            var content = data['content'] as List;
            employeeList.addAll(
                content.map((e) => UserModel.parseEmployee(e)).toList());
            setState(() {});
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
              // companyList.removeWhere((element) => element.id == '3');
              setState(() {});
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err $stack ');
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
                      selectedEmployeeNameId = '';
                      _employeeNameController.clear();
                      if (_departmentController.text != 'Select Section')
                        _getEmployeeList(sectionCode: selectedDepartmentId);
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
                            _employeeNameController.clear();
                            employeeList.clear();
                            _getEmployeeList();
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

  void getEmployeeSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        context: _scaffoldKey.currentContext!,
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
                        value!.isEmpty ? 'Please select party name' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: itemData.image.isEmpty
                              ? Image.asset(
                                  'images/noImage.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                )
                              : FadeInImage.assetNetwork(
                                  placeholder: 'images/loading_placeholder.png',
                                  image: '$imageBaseUrl${itemData.image}.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        title: Text(itemData.name!),
                        trailing: Text(itemData.lsCode),
                        subtitle: Text('${itemData.id}'),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      Navigator.of(context).pop();
                      _employeeNameController.text = sg.name!;
                      selectedEmployeeNameId = sg.id;
                      setState(() {});
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredList(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        controller: _employeeNameController,
                        onChanged: (string) {
                          selectedEmployeeNameId = '';
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //border: OutlineInputBorder(),
                            hintText: 'Employee Name',
                            isDense: true)),
                  ),
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

  _getFilteredList(String str) {
    return employeeList
        .where((i) =>
            i.name!.toLowerCase().contains(str.toLowerCase()) ||
            i.id!.toLowerCase().contains(str.toLowerCase()))
        .toList();
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

                  _departmentController.clear();
                  _employeeNameController.clear();
                  selectedEmployeeNameId = '';
                  selectedDepartmentId = '';

                  employeeList.clear();

                  /// Clearing Defaults
                  _getDepartmentList();
                  _getEmployeeList();
                },
              ),
              itemCount: companyList.length,
            ),
          );
        });
  }
}

