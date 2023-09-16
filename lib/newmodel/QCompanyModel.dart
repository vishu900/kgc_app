import 'package:dataproject2/utils/Utils.dart';

class QCompanyModel {
  String? id = '';
  String? name = '';
  String? address1 = '';
  String? address2 = '';
  String? logoName = '';
  String count = '';
  int? ledgerBalance = 0;

  QCompanyModel(
      {this.id,
      this.ledgerBalance,
      this.name,
      this.address1,
      this.address2,
      this.logoName,
      this.count = ''});

  factory QCompanyModel.fromJson(Map<String, dynamic> json) {
    return QCompanyModel(
      id: json['code'],
      name: getString(json, 'name') == 'BK'
          ? 'BK INTERNATIONAL(99)'
          : getString(json, 'name'),
      ledgerBalance: json['ledger_bal'],
      address1: json['add1'] == null ? '' : json['add1'],
      address2: json['add2'] == null ? '' : json['add2'],
      logoName: json['logo_name'] == null ? 'bk_intl.png' : json['logo_name'],
    );
  }

  factory QCompanyModel.parseGateEntryComp(Map<String, dynamic> json) {
    return QCompanyModel(
      id: json['code'],
      name: getString(json, 'name') == 'BK'
          ? 'BK INTERNATIONAL(99)'
          : getString(json, 'name'),
      address1: json['add1'] == null ? '' : json['add1'],
      address2: json['add2'] == null ? '' : json['add2'],
      count: getString(json, 'gate_entry'),
      logoName: json['logo_name'] == null ? 'bk_intl.png' : json['logo_name'],
    );
  }
}
