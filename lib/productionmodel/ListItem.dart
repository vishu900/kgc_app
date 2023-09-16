class ListItem {
  ListItem({
      this.code, 
      this.name,});

  ListItem.fromJson(dynamic json) {
    code = json['Code'];
    name = json['name'];
  }
  int? code;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = code;
    map['name'] = name;
    return map;
  }

}