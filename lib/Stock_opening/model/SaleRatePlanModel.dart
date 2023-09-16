import 'package:dataproject2/utils/Utils.dart';

import 'SaleRatePlanDetailModel.dart';

class SaleRatePlanModel {
  final String? id;
  final String? orderDate;
  final String? orderNo;
  final String? partyOrderNo;
  final String? partyName;
  final String stock;
  final String? qty;
  final String? uom;
  final bool isHeader;
  bool isViewing;
  bool isAscending;
  final String? netRate;
  final List<SaleRatePlanDetailModel>? saleDetailList;

  SaleRatePlanModel(
      {this.id,
      this.isHeader = false,
      this.isAscending = false,
      this.isViewing = false,
      this.orderDate = '',
      this.uom = '',
      this.orderNo = '',
      this.partyOrderNo = '',
      this.partyName = '',
      this.stock = '',
      this.qty = '',
      this.saleDetailList,
      this.netRate = ''});

  factory SaleRatePlanModel.fromJSON(Map<String, dynamic> data) {
    var detailList = data['bill_details'] as List;
    List<SaleRatePlanDetailModel> mDetailList = [];

    mDetailList.add(SaleRatePlanDetailModel(
        isHeader: true,
        orderNo: 'Order No',
        billNo: 'Bill No',
        date: 'Date',
        partyItemName: 'Party Item Name',
        partyPO: 'Party PO',
        bags: 'Bags',
        qty: 'Qty',
        qtyUom: 'Uom',
        rate: 'Rate',
        rateUom: 'Uom',
        amount: 'Item Amount'));

    mDetailList.addAll(detailList
        .map((e) => SaleRatePlanDetailModel.fromJSON(
            e, getString(data, 'order_no'), getString(data, 'party_order_no')))
        .toList());

    mDetailList.add(SaleRatePlanDetailModel(
        billNo: 'Challan No',
        date: '${mDetailList.length > 1 ? mDetailList[1].challanNo : ''}',
        partyItemName: 'Challan Date',
        partyPO: '${mDetailList.length > 1 ? mDetailList[1].challanDate : ''}',
        bags: getTotals('Bags', mDetailList),
        qty: getTotals('Qty', mDetailList),
        amount: getTotals('Amount', mDetailList)));

    if (mDetailList.length == 2) mDetailList.clear();

    return SaleRatePlanModel(
        id: data['comp_code'],
        qty: getString(data, 'qty'),
        uom: getString(data['qty_unit_name'], 'abv'),
        stock: getStockType(getString(data['order_details'], 'order_type')),
        partyName: getString(data['party_name'], 'name'),
        netRate: getString(data, 'net_rate'),
        orderDate: getString(data, 'order_date'),
        orderNo: getString(data, 'order_no'),
        partyOrderNo: getString(data, 'party_order_no'),
        saleDetailList: mDetailList);
  }

  static String getTotals(
      String type, List<SaleRatePlanDetailModel> mDetailList) {
    double qty = 0.0;

    try {
      if (type == 'Bags') {
        mDetailList.forEach((element) {
          if (element.isHeader) return;
          if (element.bags!.isEmpty) return;
          qty += double.parse(element.bags!);
        });
        return qty.toStringAsFixed(0);
      } else if (type == 'Qty') {
        mDetailList.forEach((element) {
          if (element.isHeader) return;
          if (element.qty!.isEmpty) return;
          qty += double.parse(element.qty!);
        });
      } else if (type == 'Amount') {
        mDetailList.forEach((element) {
          if (element.isHeader) return;
          if (element.amount!.isEmpty) return;
          qty += double.parse(element.amount!);
        });
      } else {
        return '';
      }

      return qty.toStringAsFixed(2);
    } catch (err) {
      logIt('getTotalQty-> $err');
      return qty.toStringAsFixed(2);
    }
  }

  static String getStockType(String? type) {
    switch (type) {
      case 'S':
        return 'Stock';
      //break;

      case 'M':
        return 'Manufacturing';
      // break;

      case 'T':
        return 'Trading';
      // break;

      case 'B':
        return 'Both';
      // break;

      case 'N':
        return 'N/A';
      // break;

      default:
        return '';
      //break;
    }
  }
}
