import 'package:dataproject2/utils/Utils.dart';

class MachineModel {
  final String? id;
  final String? machineName;
  final String? remarks;

  MachineModel({this.id, this.machineName, this.remarks = 'N/A'});

  factory MachineModel.fromJSON(Map<String, dynamic> data) {
    return MachineModel(
        id: data['code'],
        machineName: getString(data, 'name'),
        remarks: getString(data, 'remarks') == ''
            ? 'N/A'
            : getString(data, 'remarks'));
  }
}
