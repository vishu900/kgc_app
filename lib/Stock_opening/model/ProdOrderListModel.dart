import 'package:dataproject2/utils/Utils.dart';

import 'SaleOrderDetailModel.dart';

class ProdOrderListModel {
  final String? id;
  final String? prodOrderNo;
  final String? prodOrderDate;
  final String? procCode;
  final bool isHeader;
  bool isAscending;
  bool isViewing;

  final List<SaleOrderDetailModel>? saleOrderList;

  ProdOrderListModel({
    this.id,
    this.isHeader = false,
    this.isAscending = false,
    this.isViewing = false,
    this.procCode,
    this.prodOrderNo,
    this.prodOrderDate,
    this.saleOrderList,
  });

  factory ProdOrderListModel.fromJSON(Map<String, dynamic> data) {
    var saleOrderList = data['prod_hdr']['prod_items_list'] as List;

    List<SaleOrderDetailModel> mSaleOrderList = [];

    saleOrderList.forEach((element) {
      if (data['proc_code'] == element['proc_code']) {
        mSaleOrderList
            .add(SaleOrderDetailModel.fromJSON(element, data['proc_code']));
      }
    });

    return ProdOrderListModel(
        id: data['prod_hdr']['comp_code'],
        procCode: data['proc_code'],
        prodOrderDate: getString(data['prod_hdr'], 'order_date'),
        prodOrderNo: getString(data['prod_hdr'], 'order_no'),
        saleOrderList: mSaleOrderList);
  }
}
