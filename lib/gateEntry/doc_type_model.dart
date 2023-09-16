import 'package:dataproject2/utils/Utils.dart';

class DocTypeModel{

  final String? id;
  final String? docType;
  final String? remarks;

  DocTypeModel({this.id, this.docType, this.remarks});

  factory DocTypeModel.fromJson(Map<String, dynamic> data) {
    return DocTypeModel(
      id: getString(data, 'code'),
      docType: getString(data, 'name'),
    );
  }

  factory DocTypeModel.parseParty(Map<String, dynamic> data) {
    return DocTypeModel(
      id: getString(data, 'acc_code'),
      docType: getString(data, 'acc_name'),
    );
  }

}