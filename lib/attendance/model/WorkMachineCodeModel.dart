import 'package:dataproject2/utils/Utils.dart';

class WorkMachineCodeModel {
  final String? id;
  final String? name;
  final String? address;

  WorkMachineCodeModel({this.id, this.name, this.address});

  factory WorkMachineCodeModel.parse(Map<String, dynamic> data) {
    return WorkMachineCodeModel(
      id: getString(data, 'code'),
      name: getString(data, 'name'),
      address: getString(data, 'add1'),
    );
  }

  factory WorkMachineCodeModel.parseCode(Map<String, dynamic> data) {
    return WorkMachineCodeModel(
      id: getString(data, 'code'),
      name: getString(data, 'name'),
    );
  }

}
