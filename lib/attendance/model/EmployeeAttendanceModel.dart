import 'package:dataproject2/attendance/model/InOutModel.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:intl/intl.dart';

class EmployeeAttendanceModel {
  final String? id;
  final String? date;
  final String? employeeCode;
  final String? compCode;
  final String? employeeName;
  final String? inTime;
  String? outTime;
  final String? sectionName;
  final String? empCode;
  final String? fatherName;
  final String workSecCode;
  final String workMacCode;
  final String? image;
  final String? gender;
  List<InOutModel>? inOutList;

  EmployeeAttendanceModel(
      {this.id,
      this.date,
      this.compCode,
      this.employeeCode,
      this.employeeName,
      this.inTime,
      this.outTime,
      this.gender,
      this.sectionName,
      this.empCode,
      this.inOutList,
      this.workSecCode='N/A',
      this.workMacCode='N/A',
      this.image,
      this.fatherName});

  factory EmployeeAttendanceModel.parseSms(Map<String, dynamic> data) {
    return EmployeeAttendanceModel(
        sectionName: getString(data, 'section_name'),
        employeeCode: getString(data, 'emp_code'),
        employeeName: getString(data, 'emp_name'),
        date: getFormattedDate(getString(data, 'logdate'),
            outFormat: 'dd-MMM-yyyy'));
  }

  factory EmployeeAttendanceModel.parseAttendance(Map<String, dynamic> data) {
    var attnList = data['attendance'] as List?;
    var prodData=data['prod_plan'];
    if(prodData==null)prodData={};
    List<InOutModel> _inOutList = [];

    if(attnList!=null) _inOutList.addAll(attnList.map((e) => InOutModel.parse(e)));

    if (_inOutList.isNotEmpty) {
      _inOutList.add(InOutModel(punchTime: getTotalWorkingHour(_inOutList)));
    }

    return EmployeeAttendanceModel(
        compCode: getString(data, 'comp_code'),
        sectionName: getString(data, 'section_name'),
        employeeCode: getString(data, 'code'),
        empCode: getString(data, 'emp_type'),
        fatherName: getString(data['emp_info'], 'father_name'),
        gender: getString(data['emp_info'], 'sex'),
        image: getString(data['emp_profile_pic'], 'code_pk'),
        employeeName: '${getString(data, 'first_name')} ${getString(data, 'middle_name')} ${getString(data, 'last_name')}',
        workSecCode: getString(prodData['work_section_name'], 'name').toString(),
        workMacCode: getString(prodData['work_machine_name'], 'name').toString(),
        inOutList: _inOutList);

  }

  static String getTotalWorkingHour(List<InOutModel> inOutList) {
    int twHrs = 0;

    String? prevTime = '';
    inOutList.forEach((element) {
      if (prevTime!.trim().isEmpty) {
        prevTime = element.punchTime;
      } else {
        DateTime outTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(element.punchTime!);
        DateTime inTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(prevTime!);
        prevTime = '';
        twHrs += outTime.difference(inTime).inMilliseconds;
      }
    });

    return twHrs == 0 ? 'N/A' : getDuration(Duration(milliseconds: twHrs));
  }

 static String getDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

}
