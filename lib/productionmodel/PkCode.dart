class PkCode {
  PkCode({
      this.code,});

  PkCode.fromJson(dynamic json) {
    code = json['Code'];
  }
  int? code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = code;
    return map;
  }

}