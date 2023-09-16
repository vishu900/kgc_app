class HdrRequest {
  HdrRequest({
      this.codePk, 
      this.compCode, 
      this.docDate, 
      this.docFinyear, 
      this.docNo, 
      this.accCode, 
      this.remarks, 
      this.insDate, 
      this.insUid, 
      this.udtDate, 
      this.udtUid,});

  HdrRequest.fromJson(dynamic json) {
    codePk = json['code_pk'];
    compCode = json['comp_code'];
    docDate = json['doc_date'];
    docFinyear = json['doc_finyear'];
    docNo = json['doc_no'];
    accCode = json['acc_code'];
    remarks = json['remarks'];
    insDate = json['ins_date'];
    insUid = json['ins_uid'];
    udtDate = json['udt_date'];
    udtUid = json['udt_uid'];
  }
  int? codePk;
  int? compCode;
  String? docDate;
  int? docFinyear;
  int? docNo;
  int? accCode;
  String? remarks;
  String? insDate;
  String? insUid;
  String? udtDate;
  String? udtUid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code_pk'] = codePk;
    map['comp_code'] = compCode;
    map['doc_date'] = docDate;
    map['doc_finyear'] = docFinyear;
    map['doc_no'] = docNo;
    map['acc_code'] = accCode;
    map['remarks'] = remarks;
    map['ins_date'] = insDate;
    map['ins_uid'] = insUid;
    map['udt_date'] = udtDate;
    map['udt_uid'] = udtUid;
    return map;
  }

}