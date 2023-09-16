import 'package:dataproject2/utils/Utils.dart';

import 'JobWorkModel.dart';

class SaleOrderDetailModel {
  final String id;
  final String? orderNo;
  final String? orderDate;
  final String? partyName;
  final String? partyItemName;
  final String? partyOrderNo;
  final String? qty;
  final String? rate;
  final bool isHeader;
  bool isAscending;
  bool isViewing;
  final List<JobWorkModel>? jobWorkList;

  SaleOrderDetailModel(
      {this.id = '',
      this.orderNo = '',
      this.orderDate = '',
      this.partyName = '',
      this.partyItemName = '',
      this.isHeader = false,
      this.isAscending = false,
      this.isViewing = false,
      this.partyOrderNo = '',
      this.qty = '',
      this.jobWorkList,
      this.rate = ''});

  factory SaleOrderDetailModel.fromJSON(
      Map<String, dynamic> data, String? proCode) {
    List<JobWorkModel> mJobWorkList = [];

    var purBill = data['pull_bills'] as List;

    mJobWorkList.addAll(purBill.map((e) => JobWorkModel.fromJSON(e)).toList());

    return SaleOrderDetailModel(
        qty: getString(data, 'qty'),
        rate: getString(data, 'rate'),
        partyItemName: getString(data, 'party_item_name'),
        partyOrderNo: data['prod_sale_order'] != null
            ? getString(data['prod_sale_order']['order_header'], 'order_no')
            : '',
        partyName: data['prod_sale_order'] != null
            ? getString(
                data['prod_sale_order']['order_header']['acc_party_detail'],
                'name')
            : '',
        orderDate: data['prod_sale_order'] != null
            ? getString(data['prod_sale_order']['order_header'], 'order_date')
            : '',
        orderNo: data['prod_sale_order'] != null
            ? getString(data['prod_sale_order']['order_header'], 'order_no')
            : '',
        jobWorkList: mJobWorkList);
  }
}
