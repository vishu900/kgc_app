import 'package:dataproject2/utils/Utils.dart';

class MachineTypeModel {
  final String? id;
  final String? name;
  final String? remarks;

  MachineTypeModel({this.id, this.name, this.remarks});

  factory MachineTypeModel.fromJSON(Map<String, dynamic> data) {
    return MachineTypeModel(
      id: data['code'],
      name: getString(data, 'name'),
      remarks:
          getString(data, 'remarks') == '' ? 'N/A' : getString(data, 'remarks'),
    );
  }
}
