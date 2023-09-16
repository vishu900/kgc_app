class ProcessOrderModel {
  String CATALOG_ITEM_NAME;
  var prdOrderNo;
  var catalogCode;
  var orderDate;
  var pro_odr_name;
  ProcessOrderModel({
    required this.CATALOG_ITEM_NAME,
    required this.prdOrderNo,
    required this.catalogCode,
    required this.orderDate,
    required this.pro_odr_name,
  });
}
