import 'package:dataproject2/utils/Utils.dart';

class EmailModel {
  final String? id;
  final String? accCode;
  final String? email;
  final String? name;
  final bool? isActive;

  EmailModel({this.id, this.accCode, this.email, this.name, this.isActive});

  factory EmailModel.fromJSON(Map<String, dynamic> data) {
    return EmailModel(
      id: getString(data, 'code').toString(),
      accCode: getString(data, 'acc_code').toString(),
      email: getString(data, 'email_id').toString(),
      name: getString(data, 'name').toString(),
      isActive: getString(data, 'active_tag') == 'Y',
    );
  }
}
