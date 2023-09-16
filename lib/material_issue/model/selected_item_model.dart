class SelectedItemModel {
  var RollNo;
  var Qty;
  var UOM;
  var Rate;
  var Amount;
  var index;
  var hsnCode;
  var prdOrderNo;
  var catalogCode;
  var orderDate;
  var PROD_ORDER_BOM_FK;
  var godowncode;
  var godownName;
  var lotNo;
  var countCode;
  var brandCode;
  var materialCode;
  var ITEM_CODE;
  var shade_code;
  var iop1_code;
  var iop1_val;
  var iop1_uom;
  var iop2_code;
  var iop2_val;
  var iop2_uom;
  var iop3_code;
  var iop3_val;
  var iop3_uom;
  var QTY_UOM_NUM;
  var pro_odr_name;
  var SALE_ORDER_DTL_PK;

  String name;

  SelectedItemModel({
    required this.RollNo,
    required this.Qty,
    required this.UOM,
    required this.Rate,
    required this.Amount,
    required this.index,
    required this.name,
    required this.hsnCode,
    required this.catalogCode,
    required this.prdOrderNo,
    required this.orderDate,
    required this.PROD_ORDER_BOM_FK,
    required this.godowncode,
    required this.lotNo,
    required this.countCode,
    required this.brandCode,
    required this.materialCode,
    required this.ITEM_CODE,
    required this.shade_code,
    required this.iop1_code,
    required this.iop1_val,
    required this.iop1_uom,
    required this.iop2_code,
    required this.iop2_val,
    required this.iop2_uom,
    required this.iop3_code,
    required this.iop3_val,
    required this.iop3_uom,
    required this.QTY_UOM_NUM,
    required this.godownName,
    required this.pro_odr_name,
    required this.SALE_ORDER_DTL_PK,
  });

  split(String s) {}
}
