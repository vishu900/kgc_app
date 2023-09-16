import 'package:dataproject2/utils/Utils.dart';

class SaleRatePlanDetailModel {
  final String? id;
  final String? orderNo;
  final String? billNo;
  final String? date;
  final String? partyItemName;
  final String? partyPO;
  final String? bags;
  final String? qty;
  final String? qtyUom;
  final String? rate;
  final String? rateUom;
  final String? amount;
  final String? challanNo;
  final String? challanDate;
  final bool isHeader;
  bool isAscending;

  SaleRatePlanDetailModel(
      {this.id = '',
      this.orderNo = '',
      this.challanNo = '',
      this.challanDate = '',
      this.isHeader = false,
      this.isAscending = false,
      this.billNo = '',
      this.date = '',
      this.partyItemName = '',
      this.partyPO = '',
      this.bags = '',
      this.qty = '',
      this.qtyUom = '',
      this.rate = '',
      this.rateUom = '',
      this.amount = ''});

  factory SaleRatePlanDetailModel.fromJSON(
      Map<String, dynamic> data, String? orderNo, String? poNo) {
    return SaleRatePlanDetailModel(
        orderNo: orderNo,
        id: getString(data, 'code_pk'),
        qty: getString(data, 'qty'),
        bags: getString(data, 'bags'),
        rate: getString(data, 'rate'),
        amount: getString(data, 'item_amount'),
        partyItemName: getString(data, 'party_item_name'),
        billNo: getString(data['sale_hdr'], 'bill_no'),
        partyPO: poNo,
        rateUom: getString(data['rate_unit_name'], 'abv'),
        qtyUom: getString(data['qty_unit_name'], 'abv'),
        challanNo:
            getString(data['sale_challan_detail']['challan_hdr'], 'doc_no'),
        challanDate:
            getString(data['sale_challan_detail']['challan_hdr'], 'doc_date'),
        date: getString(data['sale_hdr'], 'bill_date'));
  }
}
