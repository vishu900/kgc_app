import 'process_items.dart';

class BomContent {
  String? _compCode;
  String? _compName;
  String? _orderNo;
  String? order_date,party_name,approval_uid, cont_person, approval_user_name, soh_pk;
  List<ProcessItems>? _orderItems;

  BomContent(
      {String? compCode,
        String? compName,
        String? orderNo,
        String? order_date,String? party_name, String? approval_uid,  String? cont_person, String? approval_user_name, String? soh_pk,
        List<ProcessItems>? orderItems}) {
    this._compCode = compCode;
    this._compName = compName;
    this._orderNo = orderNo;
    this._orderItems = orderItems;
    this.order_date = order_date;
    this.party_name = party_name;
    this.approval_uid = approval_uid;
    this.cont_person = cont_person;
    this.approval_user_name = approval_user_name;
    this.soh_pk = soh_pk;
  }

  String? get compCode => _compCode;
  set compCode(String? compCode) => _compCode = compCode;
  String? get compName => _compName;
  set compName(String? compName) => _compName = compName;
  String? get orderNo => _orderNo;
  set orderNo(String? orderNo) => _orderNo = orderNo;

  String? get orderdate => order_date;
  set orderdate(String? orderdate) => order_date = orderdate;

  String? get partyname => party_name;
  set partyname(String? partyname) => party_name = partyname;

  String? get approvaluid => approval_uid;
  set approvaluid(String? approvaluid) => approval_uid = approvaluid;

  String? get contperson => cont_person;
  set contperson(String? contperson) => cont_person = contperson;

  String? get approvalusername => approval_user_name;
  set approvalusername(String? approvalusername) => approval_user_name = approvalusername;

  String? get sohpk => soh_pk;
  set sohpk(String? sohpk) => soh_pk = sohpk;



  List<ProcessItems>? get orderItems => _orderItems;
  set orderItems(List<ProcessItems>? orderItems) => _orderItems = orderItems;

  BomContent.fromJson(Map<String, dynamic> json) {
    _compCode = json['comp_code'];
    _compName = json['comp_name'];
    _orderNo = json['order_no'];
    order_date = json['order_date'];
    party_name = json['party_name'];
    approval_uid = json['approval_uid'];
    cont_person = json['cont_person'];
    approval_user_name = json['approval_user_name'];
    soh_pk = json['soh_pk'];


    if (json['order_items'] != null) {
      _orderItems = <ProcessItems>[];
      json['order_items'].forEach((v) {
        _orderItems!.add(new ProcessItems.fromJson(v));
      });
    }

  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comp_code'] = this._compCode;
    data['comp_name'] = this._compName;
    data['order_no'] = this._orderNo;
    data['order_date'] = this.order_date;
    data['party_name'] = this.party_name;
    data['approval_uid'] = this.approval_uid;
    data['cont_person'] = this.cont_person;
    data['approval_user_name'] = this.approval_user_name;
    data['soh_pk'] = this.soh_pk;
    if (this._orderItems != null) {
      data['order_items'] = this._orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
