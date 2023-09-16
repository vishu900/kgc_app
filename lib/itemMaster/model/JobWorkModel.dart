import 'package:dataproject2/utils/Utils.dart';

class JobWorkModel {
  final String? id;
  final String? docNo;
  final String? docDate;
  final String? billNo;
  final String? billDate;
  final String? catalogItem;
  final String? stockQty;
  final String? stockQtyUom;
  final String? finQty;
  final String? finQtyUom;
  final String? rate;
  final String? rateUom;
  final bool isHeader;
  bool isAscending;
  bool isViewing;

  JobWorkModel(
      {this.id,
      this.docNo,
      this.stockQtyUom,
      this.finQtyUom,
      this.rateUom,
      this.docDate,
      this.billNo,
      this.billDate,
      this.catalogItem,
      this.stockQty,
      this.finQty,
      this.isHeader = false,
      this.isAscending = false,
      this.isViewing = false,
      this.rate});

  factory JobWorkModel.fromJSON(Map<String, dynamic> data) {
    return JobWorkModel(
      id: data['code_pk'],
      docDate: getString(data['bill_hdr'], 'doc_date'),
      docNo: getString(data['bill_hdr'], 'doc_no'),
      billNo: getString(data['bill_hdr'], 'bill_no'),
      billDate: getString(data['bill_hdr'], 'bill_date'),
      catalogItem: getString(data, 'catalog_item'),
      stockQty: getString(data, 'stock_qty'),
      finQty: getString(data, 'fin_qty'),
      rate: getString(data, 'rate'),
      rateUom: getString(data['rate_unit_name'], 'abv'),
      stockQtyUom: getString(data['stock_unit_name'], 'abv'),
      finQtyUom: getString(data['finqty_unit_name'], 'abv'),
    );
  }
}
