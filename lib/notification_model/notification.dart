


class Notification {
  String? code;
  String? name;

  Notification({this.code, this.name});

  Notification.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.code;
    data['name'] = this.name;
    return data;
  }
}