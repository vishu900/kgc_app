class PendingOrder {
  PendingOrder({
    this.compCode,
    this.orderNo,
    this.orderDate,
    this.delvDate,
    this.accCode,
    this.accName,
    this.contPersonCode,
    this.contPersonName,
    this.prodOrderHdrPk,
    this.prodOrderDtlPk,
    this.saleOrderDtlPk,
    this.jwOrderDtlPk,
    this.catalogItem,
    this.catalogItemName,
    this.countCode,
    this.itemCode,
    this.materialCode,
    this.shadeCode,
    this.brandCode,
    this.iop1Code,
    this.iop1Val,
    this.iop1Uom,
    this.iop2Code,
    this.iop2Val,
    this.iop2Uom,
    this.iop3Code,
    this.iop3Val,
    this.iop3Uom,
    this.procCode,
    this.processName,
    this.rate,
    this.rateUom,
    this.rateUomName,
    this.qty,
    this.prodDay,
    this.prodNight,
    this.totProd,
    this.balQty,
    this.qtyUom,
    this.qtyUomName,
  });

  PendingOrder.fromJson(dynamic json) {
    compCode = json['comp_code'];
    orderNo = json['order_no'];
    orderDate = json['order_date'];
    delvDate = json['delv_date'];
    accCode = json['acc_code'];
    accName = json['acc_name'];
    contPersonCode = json['cont_person_code'];
    contPersonName = json['cont_person_name'];
    prodOrderHdrPk = json['prod_order_hdr_pk'];
    prodOrderDtlPk = json['prod_order_dtl_pk'];
    saleOrderDtlPk = json['sale_order_dtl_pk'];
    jwOrderDtlPk = json['jw_order_dtl_pk'];
    catalogItem = json['catalog_item'];
    catalogItemName = json['catalog_item_name'];
    countCode = json['count_code'];
    itemCode = json['item_code'];
    materialCode = json['material_code'];
    shadeCode = json['shade_code'];
    brandCode = json['brand_code'];
    iop1Code = json['iop1_code'];
    iop1Val = json['iop1_val'];
    iop1Uom = json['iop1_uom'];
    iop2Code = json['iop2_code'];
    iop2Val = json['iop2_val'];
    iop2Uom = json['iop2_uom'];
    iop3Code = json['iop3_code'];
    iop3Val = json['iop3_val'];
    iop3Uom = json['iop3_uom'];
    procCode = json['proc_code'];
    processName = json['process_name'];
    rate = json['rate'];
    rateUom = json['rate_uom'];
    rateUomName = json['rate_uom_name'];
    qty = json['qty'];
    prodDay = json['prod_day'];
    prodNight = json['prod_night'];
    totProd = json['tot_prod'];
    balQty = json['bal_qty'];
    qtyUom = json['qty_uom'];
    qtyUomName = json['qty_uom_name'];
  }
  int? compCode;
  int? orderNo;
  String? orderDate;
  String? delvDate;
  int? accCode;
  String? accName;
  int? contPersonCode;
  String? contPersonName;
  int? prodOrderHdrPk;
  int? prodOrderDtlPk;
  int? saleOrderDtlPk;
  int? jwOrderDtlPk;
  int? catalogItem;
  String? catalogItemName;
  int? countCode;
  int? itemCode;
  int? materialCode;
  int? shadeCode;
  int? brandCode;
  int? iop1Code;
  int? iop1Val;
  int? iop1Uom;
  int? iop2Code;
  int? iop2Val;
  int? iop2Uom;
  int? iop3Code;
  int? iop3Val;
  int? iop3Uom;
  int? procCode;
  String? processName;
  double? rate;
  int? rateUom;
  String? rateUomName;
  double? qty;
  double? prodDay;
  double? prodNight;
  double? totProd;
  double? balQty;
  int? qtyUom;
  int? hrs = 0;
  int? mint = 0;
  String? qtyUomName;
  bool is_selected = false;
  int? pk_code = 0;
  String? remarks = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['comp_code'] = compCode;
    map['order_no'] = orderNo;
    map['order_date'] = orderDate;
    map['delv_date'] = delvDate;
    map['acc_code'] = accCode;
    map['acc_name'] = accName;
    map['cont_person_code'] = contPersonCode;
    map['cont_person_name'] = contPersonName;
    map['prod_order_hdr_pk'] = prodOrderHdrPk;
    map['prod_order_dtl_pk'] = prodOrderDtlPk;
    map['sale_order_dtl_pk'] = saleOrderDtlPk;
    map['jw_order_dtl_pk'] = jwOrderDtlPk;
    map['catalog_item'] = catalogItem;
    map['catalog_item_name'] = catalogItemName;
    map['count_code'] = countCode;
    map['item_code'] = itemCode;
    map['material_code'] = materialCode;
    map['shade_code'] = shadeCode;
    map['brand_code'] = brandCode;
    map['iop1_code'] = iop1Code;
    map['iop1_val'] = iop1Val;
    map['iop1_uom'] = iop1Uom;
    map['iop2_code'] = iop2Code;
    map['iop2_val'] = iop2Val;
    map['iop2_uom'] = iop2Uom;
    map['iop3_code'] = iop3Code;
    map['iop3_val'] = iop3Val;
    map['iop3_uom'] = iop3Uom;
    map['proc_code'] = procCode;
    map['process_name'] = processName;
    map['rate'] = rate;
    map['rate_uom'] = rateUom;
    map['rate_uom_name'] = rateUomName;
    map['qty'] = qty;
    map['prod_day'] = prodDay;
    map['prod_night'] = prodNight;
    map['tot_prod'] = totProd;
    map['bal_qty'] = balQty;
    map['qty_uom'] = qtyUom;
    map['qty_uom_name'] = qtyUomName;
    return map;
  }

  @override
  bool operator ==(Object other) {
    return other is PendingOrder && prodOrderDtlPk == other.prodOrderDtlPk;
  }

  @override
  int get hashCode => prodOrderDtlPk.hashCode;

  @override
  String toString() => '{ id: $prodOrderDtlPk }';
}
