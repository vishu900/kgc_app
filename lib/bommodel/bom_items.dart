class BomItems {
  String? _compCode;
  String? _compName;
  String? _orderNo;

  String? order_date,party_name,approval_uid, cont_person, approval_user_name, sod_pk;

  String? catalog_item, item_description,qty,qty_uom,net_rate, rate_uom, amount, party_order_no,delv_date,soh_fk;

  BomItems({String? compCode, String? compName, String? orderNo, String? order_date,String? party_name, String? approval_uid,  String? cont_person, String? approval_user_name, String? sod_pk,
    String? catalog_item, String? item_description,String? qty,String? qty_uom,
    String? net_rate, String? rate_uom, String? amount, String? party_order_no,String? delv_date, String? soh_fk
  }) {
    this._compCode = compCode;
    this._compName = compName;
    this._orderNo = orderNo;
    this.order_date = order_date;
    this.party_name = party_name;
    this.approval_uid = approval_uid;
    this.cont_person = cont_person;
    this.approval_user_name = approval_user_name;
    this.sod_pk = sod_pk;

    this.catalog_item = catalog_item;
    this.item_description = item_description;
    this.qty = qty;
    this.qty_uom = qty_uom;
    this.net_rate = net_rate;
    this.rate_uom = rate_uom;
    this.amount = amount;
    this.party_order_no = party_order_no;
    this.delv_date = delv_date;
    this.soh_fk = soh_fk;

  }

  String? get compCode => _compCode;
  set compCode(String? compCode) => _compCode = compCode;
  String? get compName => _compName;
  set compName(String? compName) => _compName = compName;
  String? get orderNo => _orderNo;
  set orderNo(String? orderNo) => _orderNo = orderNo;


  String? get catalogitem => catalog_item;
  set catalogitem(String? compCode) => catalogitem = compCode;
  String? get itemdescription => item_description;
  set itemdescription(String? compName) => item_description = compName;
  String? get qty1 => qty;
  set qty1(String? qty1) => qty = qty1;

  String? get qtyuom => qty_uom;
  set qtyuom(String? qtyuom) => qty_uom = qtyuom;
  String? get netrate => net_rate;
  set netrate(String? netrate) => net_rate = netrate;
  String? get rateuom => rate_uom;
  set rateuom(String? rateuom) => rate_uom = rateuom;

  String? get amount1 => amount;
  set amount1(String? amount1) => amount = amount1;
  String? get partyorderno => party_order_no;
  set partyorderno(String? partyorderno) => party_order_no = partyorderno;
  String? get delvdate => delv_date;
  set delvdate(String? delvdate) => delv_date = delvdate;

  String? get sohfk => soh_fk;
  set sohfk(String? sohfk) => soh_fk = sohfk;
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

  String? get sodpk => sod_pk;
  set sodpk(String? sodpk) => sod_pk = sodpk;

  BomItems.fromJson(Map<String, dynamic> json) {
    _compCode = json['comp_code'];
    _compName = json['comp_name'];
    _orderNo = json['order_no'];
    order_date = json['order_date'];
    party_name = json['party_name'];
    approval_uid = json['approval_uid'];
    cont_person = json['cont_person'];
    approval_user_name = json['approval_user_name'];
    sod_pk = json['sod_pk'];

    catalog_item = json['catalog_item'];
    item_description = json['item_description'];
    qty = json['qty'];
    qty_uom = json['qty_uom'];
    net_rate = json['net_rate'];

    rate_uom = json['rate_uom'];
    amount = json['amount'];
    party_order_no = json['party_order_no'];
    delv_date = json['delv_date'];
    soh_fk = json['soh_fk'];

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
    data['sod_pk'] = this.sod_pk;

    data['catalog_item'] = this.catalog_item;
    data['item_description'] = this.item_description;
    data['qty'] = this.qty;
    data['qty_uom'] = this.qty_uom;
    data['net_rate'] = this.net_rate;

    data['rate_uom'] = this.rate_uom;
    data['amount'] = this.amount;
    data['party_order_no'] = this.party_order_no;
    data['delv_date'] = this.delv_date;
    data['soh_fk'] = this.soh_fk;
    return data;
  }
}