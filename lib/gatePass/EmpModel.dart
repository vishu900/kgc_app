import 'package:dataproject2/utils/Utils.dart';

class EmpModel{

  final String? id;
  final String? employeeCode;
  final String? employeeName;
  final String? department;
  final String? designation;
  final String? image;

  EmpModel(
      {this.id,
      this.employeeCode,
      this.employeeName,
      this.department,
      this.designation,
      this.image});

  factory EmpModel.fromJson(Map<String,dynamic> data){

    return EmpModel(
      employeeName: '${getString(data['employee_name'], 'first_name')} ${getString(data['employee_name'], 'last_name')}',
      employeeCode: getString(data, 'emp_code'),
      department: getString(data['employee_name']['emp_section_name'], 'name'),
      designation: getString(data['employee_name']['emp_designation_code'], 'designation'),
      image: getString(data['emp_profile_pic'], 'code_pk')
    );

  }

}