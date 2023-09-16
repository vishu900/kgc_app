class SelectedItemModelPP {
  var CATALOG_ITEM;
  String CATALOG_NAME;
  var COUNT_CODE;
  String COUNT_NAME;
  var ITEM_CODE;
  String ITEM_NAME;
  var MATERIAL_CODE;
  String MATERIAL_NAME;
  var SHADE_CODE;
  String SHADE_NAME;
  var BRAND_CODE;
  String BRAND_NAME;
  var PROC_CODE;
  String PROC_NAME;
  var PLAN_QTY;
  String UOM_ABV;
  String SALE_ORDER_DTL_PK, PROD_ORDER_HDR_FK;

  SelectedItemModelPP(
      {required this.CATALOG_ITEM,
      required this.CATALOG_NAME,
      required this.COUNT_CODE,
      required this.COUNT_NAME,
      required this.ITEM_CODE,
      required this.ITEM_NAME,
      required this.MATERIAL_CODE,
      required this.MATERIAL_NAME,
      required this.SHADE_CODE,
      required this.SHADE_NAME,
      required this.BRAND_CODE,
      required this.BRAND_NAME,
      required this.PROC_CODE,
      required this.PROC_NAME,
      required this.PLAN_QTY,
      required this.UOM_ABV, required this.SALE_ORDER_DTL_PK, required this.PROD_ORDER_HDR_FK});

  split(String s) {}
}
