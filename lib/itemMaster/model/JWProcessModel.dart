import 'package:dataproject2/utils/Utils.dart';

import 'ProdOrderListModel.dart';

class JWProcessModel {
  final String? id;
  final String? name;
  final String? contCode;
  final String? contName;
  final String? procCode;
  final List<JWProcessModel>? accList;
  final List<ProdOrderListModel>? prodOrderList;

  JWProcessModel(
      {this.contCode,
      this.contName,
      this.procCode,
      this.accList,
      this.prodOrderList,
      this.id,
      this.name});

  factory JWProcessModel.fromJSON(Map<String, dynamic> data) {
    var accList = data['acc_proc'] as List;
    var prodOrderList = data['prod_order_dtl'] as List;
    List<JWProcessModel> mAccList = [];
    List<ProdOrderListModel> mProdOrderList = [];

    mProdOrderList.addAll(
        prodOrderList.map((e) => ProdOrderListModel.fromJSON(e)).toList());

    accList.forEach((element) {
      mAccList.add(JWProcessModel(
          id: element['acc_code'],
          name: element['acc_name'],
          contCode: element['cont_person_code'],
          contName: element['cont_name'],
          procCode: element['proc_code']));
    });

    return JWProcessModel(
        id: data['code'],
        name: getString(data, 'name'),
        accList: mAccList,
        prodOrderList: mProdOrderList);
  }
}
