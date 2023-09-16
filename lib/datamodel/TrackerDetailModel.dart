class TrackerDetailModel {
  String? id;
  String? docNo;
  String? docDate;
  String? catalogNo;
  String? catalogName;
  String? quantity;
  String? balanceQuantity;
  String? completeQuantity;
  String? client;
  String? companyName;

  TrackerDetailModel(
      {this.id,
      this.docNo,
      this.docDate,
      this.catalogNo,
      this.balanceQuantity,
      this.completeQuantity,
      this.catalogName,
      this.quantity,
      this.client,
      this.companyName});

  factory TrackerDetailModel.fromJSON(Map<String, dynamic> json) {
    return TrackerDetailModel(
      docNo: json['doc_no'] == null ? '' : json['doc_no'].toString().trim(),
      docDate:
          json['doc_date'] == null ? '' : json['doc_date'].toString().trim(),
      catalogNo: json['catalog_item'] == null
          ? ''
          : json['catalog_item'].toString().trim(),
      catalogName: json['catalog_item_name'] == null
          ? ''
          : json['catalog_item_name'].toString().trim(),
      quantity:
          json['order_qty'] == null ? '' : json['order_qty'].toString().trim(),
      companyName:
          json['comp_abv'] == null ? '' : json['comp_abv'].toString().trim(),
      client: json['acc_name'] == null ? 'N.A' : json['acc_name'].toString().trim(),
      completeQuantity: json['complete_qty'] == null
          ? 'N.A' : json['complete_qty'].toString().trim(),
      balanceQuantity: json['balance_qty'] == null ? 'N.A' : json['balance_qty'].toString().trim(),
    );
  }
}
