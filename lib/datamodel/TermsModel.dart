import 'package:dataproject2/utils/Utils.dart';

class TermsModel {
  final String? id;
  String? name;
  String remarks;
  bool isAdded;
  bool isDefault;

  TermsModel(
      {this.id,
      this.name,
      this.remarks = '',
      this.isAdded = false,
      this.isDefault = false});

  factory TermsModel.fromJOSN(Map<String, dynamic> data) {
    return TermsModel(
        id: getString(data, 'code').toString(),
        name: getString(data, 'name'),
        isAdded: getString(data, 'sqtn') == 'Y',
        isDefault: getString(data, 'sqtn') == 'Y');
  }

  factory TermsModel.parseEdit(Map<String, dynamic> data) {
    return TermsModel(
        id: getString(data, 'terms_code').toString(),
        name: getString(data, 'name'),
        remarks: getString(data, 'remarks'),
        isAdded: true,
        isDefault: true);
  }
}
