class PendingOrderRequest {
  PendingOrderRequest({
    this.codePk,
    this.codeFk,
    this.prodOrderDtlFk,
    this.gateentrydtlfk,
    this.catalogitem,
    this.countcode,
    this.itemcode,
    this.materialcode,
    this.shadecode,
    this.brandcode,
    this.iop1code,
    this.iop1val,
    this.iop1uom,
    this.iop2code,
    this.iop2val,
    this.iop2uom,
    this.iop3code,
    this.iop3val,
    this.iop3uom,
    this.prodqty,
    this.qtyuom,
    this.proctimehrs,
    this.proctimemints,
    this.remarks,
    this.insDate,
    this.insUid,
    this.udtDate,
    this.udtUid,
    this.qualitystatus,
  });

  PendingOrderRequest.fromJson(dynamic json) {
    codePk = json['code_pk'];
    codeFk = json['code_fk'];
    prodOrderDtlFk = json['prod_order_dtl_fk'];
    gateentrydtlfk = json['GATE_ENTRY_DTL_FK'];
    catalogitem = json['CATALOG_ITEM'];
    countcode = json['COUNT_CODE'];
    itemcode = json['ITEM_CODE'];
    materialcode = json['MATERIAL_CODE'];
    shadecode = json['SHADE_CODE'];
    brandcode = json['BRAND_CODE'];
    iop1code = json['IOP1_CODE'];
    iop1val = json['IOP1_VAL'];
    iop1uom = json['IOP1_UOM'];
    iop2code = json['IOP2_CODE'];
    iop2val = json['IOP2_VAL'];
    iop2uom = json['IOP2_UOM'];
    iop3code = json['IOP3_CODE'];
    iop3val = json['IOP3_VAL'];
    iop3uom = json['IOP3_UOM'];
    prodqty = json['PROD_QTY'];
    qtyuom = json['QTY_UOM'];
    proctimehrs = json['PROC_TIME_HRS'];
    proctimemints = json['PROC_TIME_MINTS'];
    remarks = json['REMARKS'];
    insDate = json['ins_date'];
    insUid = json['ins_uid'];
    udtDate = json['udt_date'];
    udtUid = json['udt_uid'];
    qualitystatus = json['QUALITY_STATUS'];
  }
  int? codePk;
  int? codeFk;
  int? prodOrderDtlFk;
  int? gateentrydtlfk;
  int? catalogitem;
  int? countcode;
  int? itemcode;
  int? materialcode;
  int? shadecode;
  int? brandcode;
  int? iop1code;
  int? iop1val;
  int? iop1uom;
  int? iop2code;
  int? iop2val;
  int? iop2uom;
  int? iop3code;
  int? iop3val;
  int? iop3uom;
  double? prodqty;
  int? qtyuom;
  int? proctimehrs;
  int? proctimemints;
  String? remarks;
  String? insDate;
  String? insUid;
  String? udtDate;
  String? udtUid;
  String? qualitystatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code_pk'] = codePk;
    map['code_fk'] = codeFk;
    map['prod_order_dtl_fk'] = prodOrderDtlFk;
    map['GATE_ENTRY_DTL_FK'] = gateentrydtlfk;
    map['CATALOG_ITEM'] = catalogitem;
    map['COUNT_CODE'] = countcode;
    map['ITEM_CODE'] = itemcode;
    map['MATERIAL_CODE'] = materialcode;
    map['SHADE_CODE'] = shadecode;
    map['BRAND_CODE'] = brandcode;
    map['IOP1_CODE'] = iop1code;
    map['IOP1_VAL'] = iop1val;
    map['IOP1_UOM'] = iop1uom;
    map['IOP2_CODE'] = iop2code;
    map['IOP2_VAL'] = iop2val;
    map['IOP2_UOM'] = iop2uom;
    map['IOP3_CODE'] = iop3code;
    map['IOP3_VAL'] = iop3val;
    map['IOP3_UOM'] = iop3uom;
    map['PROD_QTY'] = prodqty;
    map['QTY_UOM'] = qtyuom;
    map['PROC_TIME_HRS'] = proctimehrs;
    map['PROC_TIME_MINTS'] = proctimemints;
    map['REMARKS'] = remarks;
    map['ins_date'] = insDate;
    map['ins_uid'] = insUid;
    map['udt_date'] = udtDate;
    map['udt_uid'] = udtUid;
    map['QUALITY_STATUS'] = qualitystatus;
    return map;
  }
}
