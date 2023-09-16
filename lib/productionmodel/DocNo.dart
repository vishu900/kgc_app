class DocNo {
  DocNo({
      this.docNo,});

  DocNo.fromJson(dynamic json) {
    docNo = json['DocNo'];
  }
  int? docNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DocNo'] = docNo;
    return map;
  }

}