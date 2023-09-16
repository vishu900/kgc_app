class StockRequest {
  StockRequest({
    this.codepk,
    this.codefk,
    this.acccontpersoncode,
    this.godowncode,
    this.lotno,
    this.rollno,
    this.prodday,
    this.prodnight,
    this.qtyuom,
    this.remarks,
    this.insdate,
    this.insuid,
    this.udtdate,
    this.udtuid,
  });

  StockRequest.fromJson(dynamic json) {
    codepk = json['CODE_PK'];
    codefk = json['CODE_FK'];
    acccontpersoncode = json['ACC_CONT_PERSON_CODE'];
    godowncode = json['GODOWN_CODE'];
    lotno = json['LOT_NO'];
    rollno = json['ROLL_NO'];
    prodday = json['PROD_DAY'];
    prodnight = json['PROD_NIGHT'];
    qtyuom = json['QTY_UOM'];
    remarks = json['REMARKS'];
    insdate = json['INS_DATE'];
    insuid = json['INS_UID'];
    udtdate = json['UDT_DATE'];
    udtuid = json['UDT_UID'];
  }
  int? codepk;
  int? codefk;
  int? acccontpersoncode;
  int? godowncode;
  String? lotno;
  String? rollno;
  double? prodday;
  double? prodnight;
  int? qtyuom;
  String? remarks;
  String? insdate;
  String? insuid;
  String? udtdate;
  String? udtuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CODE_PK'] = codepk;
    map['CODE_FK'] = codefk;
    map['ACC_CONT_PERSON_CODE'] = acccontpersoncode;
    map['GODOWN_CODE'] = godowncode;
    map['LOT_NO'] = lotno;
    map['ROLL_NO'] = rollno;
    map['PROD_DAY'] = prodday;
    map['PROD_NIGHT'] = prodnight;
    map['QTY_UOM'] = qtyuom;
    map['REMARKS'] = remarks;
    map['INS_DATE'] = insdate;
    map['INS_UID'] = insuid;
    map['UDT_DATE'] = udtdate;
    map['UDT_UID'] = udtuid;
    return map;
  }
}
