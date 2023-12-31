import 'package:http/http.dart';

class InsertModel {
  String PROD_ORDER_BOM_FK;
  String godownCode;
  String lotNo,
      ROLL_NO,
      QTY,
      INQTY,
      OUTQTY,
      QTY_UOM,
      HSN_CODE,
      RATE,
      AMOUNT,
      CATALOG_ITEM,
      COUNT_CODE,
      ITEM_CODE,
      material_code,
      brand_code,
      shade_code,
      iop1_code,
      iop1_val,
      iop1_uom,
      iop2_code,
      iop2_val,
      iop2_uom,
      iop3_code,
      iop3_val,
      iop3_uom,
      QTY_UOM_NUM;

  InsertModel({
    required this.PROD_ORDER_BOM_FK,
    required this.godownCode,
    required this.lotNo,
    required this.ROLL_NO,
    required this.QTY,
    required this.INQTY,
    required this.OUTQTY,
    required this.QTY_UOM,
    required this.HSN_CODE,
    required this.RATE,
    required this.AMOUNT,
    required this.CATALOG_ITEM,
    required this.COUNT_CODE,
    required this.ITEM_CODE,
    required this.material_code,
    required this.brand_code,
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
  });
}
