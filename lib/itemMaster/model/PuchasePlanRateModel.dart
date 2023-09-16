import 'package:dataproject2/itemMaster/model/PuchasePlanRateDetailModel.dart';
import 'package:dataproject2/utils/Utils.dart';

class PurchasePlanRateModel {
  final String? id;
  final String? orderDate;
  final String? orderNo;
  final String? partyName;
  final String? qty;
  final String? basicRate;
  final String? descPercent;
  final String? discRate;
  final String? netRate;
  final bool isHeader;
  bool isAscending;
  bool isViewing;
  final List<PurchasePlanRateDetailModel>? detailList;

  PurchasePlanRateModel(
      {this.id,
      this.detailList,
      this.isHeader = false,
      this.isAscending = false,
      this.isViewing = false,
      this.orderDate,
      this.orderNo,
      this.partyName,
      this.qty,
      this.basicRate,
      this.descPercent,
      this.discRate,
      this.netRate});

  factory PurchasePlanRateModel.fromJSON(Map<String, dynamic> data) {
    var billDetailList = data['bill_details'] as List;
    String? orderNo = getString(data, 'order_no');
    List<PurchasePlanRateDetailModel> mBillDetailList = [];

    mBillDetailList.add(PurchasePlanRateDetailModel(
        isHeader: true,
        orderNo: 'Order No',
        docNo: 'Doc No',
        docDate: 'Doc Date',
        rate: 'Rate',
        finQty: 'Fin Qty',
        stockQty: 'Stock Qty',
        billDate: 'Bill Date',
        billNo: 'Bill No'));

    mBillDetailList.addAll(billDetailList
        .map((e) => PurchasePlanRateDetailModel.fromJSON(e, orderNo))
        .toList());

    if (mBillDetailList.length == 1) mBillDetailList.clear();

    return PurchasePlanRateModel(
        id: data['comp_code'],
        qty: getString(data, 'qty'),
        partyName: getString(data['party_name'], 'name'),
        netRate: getString(data, 'net_rate'),
        basicRate: getString(data, 'rate'),
        descPercent: getString(data, 'disc_per'),
        discRate: getString(data, 'disc_rate'),
        orderDate: getString(data, 'order_date'),
        orderNo: getString(data, 'order_no'),
        detailList: mBillDetailList);
  }

  static String getTotalQty(
      List<PurchasePlanRateDetailModel> mBillDetailList, String type) {
    double qty = 0.0;

    try {
      mBillDetailList.forEach((element) {
        if (element.isHeader) return;
        if (type == 'Stock') {
          if (element.stockQty!.isEmpty) return;
          qty += double.parse(element.stockQty!);
        } else if (type == 'Fin') {
          if (element.finQty!.isEmpty) return;
          qty += double.parse(element.finQty!);
        }
      });

      return qty.toStringAsFixed(2);
    } catch (err) {
      logIt('getTotalQty-> $err');
      return qty.toStringAsFixed(2);
    }
  }
}
