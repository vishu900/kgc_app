import 'package:dataproject2/utils/Utils.dart';

class EmployeeModel {
  final String? id;
  final String? name;
  final String? deptName;
  final String? desgName;
  final String? image;
  final String? lscode;
  bool isSelected;

  EmployeeModel(
      {this.id,
      this.name,
      this.deptName,
      this.desgName,
      this.image,
      this.lscode,
      this.isSelected = false});

  factory EmployeeModel.fromJSON(Map<String, dynamic> data) {
    return EmployeeModel(
        id: getString(data, 'code'),
        name:
            '${getString(data, 'first_name')} ${getString(data, 'middle_name')} ${getString(data, 'last_name')}',
        deptName: getString(data['emp_department_name'], 'name'),
        desgName: getString(data['emp_designation_name'], 'name'),
        image: getString(data['emp_profile_pic'], 'code_pk'),
        lscode: getString(data, 'ls_code'));
  }

  factory EmployeeModel.parseGatePass(Map<String, dynamic> data) {
    return EmployeeModel(
        id: getString(data, 'emp_code'),
        name:
            '${getString(data['employee_name'], 'first_name')} ${getString(data['employee_name'], 'last_name')}',
        deptName:
            getString(data['employee_name']['emp_department_name'], 'name'),
        desgName:
            getString(data['employee_name']['emp_designation_name'], 'name'),
        image: getString(data['employee_name']['emp_profile_pic'], 'code_pk'));
  }
}
