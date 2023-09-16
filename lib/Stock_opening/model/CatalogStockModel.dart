class CatalogStockModel {
  String? id;
  String? catalogCode;
  String? godown;
  String? lotNo;
  String? rollNo;
  String? stockQty;
  bool isHeader;
  bool isAscending;

  CatalogStockModel(
      {this.id,
      this.godown,
      this.lotNo,
      this.rollNo,
      this.stockQty,
      this.isHeader = false,
      this.isAscending = false,
      });

  factory CatalogStockModel.fromJSON(Map<String, dynamic> data) {
    return CatalogStockModel(
        id: data['comp_code'],
        godown: data['godown_name']['name'],
        lotNo: data['lot_no'],
        rollNo: data['roll_no'],
        stockQty: data['stock_qty']);
  }
}
