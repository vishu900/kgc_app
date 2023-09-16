class Partnameresp {
  int? code;
  String? name;

  Partnameresp({this.code, this.name});

  Partnameresp.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}