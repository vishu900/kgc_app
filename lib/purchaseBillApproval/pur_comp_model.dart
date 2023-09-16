import 'package:dataproject2/utils/Utils.dart';

class PurCompModel {
  final String? id;
  final String? name;
  final String? abv;
  final String? logo;
  final String? orderCount;

  PurCompModel({this.id, this.name, this.abv, this.logo, this.orderCount});

  factory PurCompModel.fromJson(Map<String, dynamic> data) {
    return PurCompModel(
        id: getString(data, 'code'),
        name: getString(data, 'name'),
        abv: getString(data, 'abv'),
        logo: getString(data, 'logo_name'),
        orderCount: getString(data, 'pending_bill_count'));
  }

}
