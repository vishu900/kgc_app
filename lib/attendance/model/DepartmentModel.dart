import 'package:dataproject2/utils/Utils.dart';

class DepartmentModel {
  final String? id;
  final String? name;
  final String totalEmployee;

  DepartmentModel({this.id, this.name,this.totalEmployee=''});

  factory DepartmentModel.parse(Map<String, dynamic> data) {
    return DepartmentModel(
        id: getString(data, 'code'),
        name: getString(data, 'name'),
        totalEmployee: getString(data,'section_emp_count')
    );
  }

}
