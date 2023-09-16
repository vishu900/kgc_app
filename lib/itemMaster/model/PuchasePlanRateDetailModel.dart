import 'package:dataproject2/utils/Utils.dart';

class PurchasePlanRateDetailModel {
  final String? id;
  final String? orderNo;
  final String? docNo;
  final String? docDate;
  final String? billNo;
  final String? billDate;
  final String? stockQty;
  final String? finQty;
  final String? rate;
  final bool isHeader;
  bool isViewing;
  bool isAscending;

  PurchasePlanRateDetailModel({
    this.docNo,
    this.orderNo = '',
    this.docDate,
    this.billNo,
    this.billDate,
    this.stockQty,
    this.finQty,
    this.rate,
    this.id,
    this.isHeader = false,
    this.isViewing = false,
    this.isAscending = false,
  });

  factory PurchasePlanRateDetailModel.fromJSON(Map<String, dynamic> data,
      [String? orderNo = '']) {
    return PurchasePlanRateDetailModel(
        id: data['code_pk'],
        orderNo: orderNo,
        docNo: getString(data['bill_hdr'], 'doc_no'),
        docDate: getString(data['bill_hdr'], 'doc_date'),
        billNo: getString(data['bill_hdr'], 'bill_no'),
        billDate: getString(data['bill_hdr'], 'bill_date'),
        stockQty: getString(data, 'stock_qty'),
        finQty: getString(data, 'fin_qty'),
        rate: getString(data, 'rate'));
  }
}
