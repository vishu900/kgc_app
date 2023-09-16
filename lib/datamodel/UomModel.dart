class UomModel {
  String? id;
  String? abbreviation;
  String? name;

  UomModel({this.id, this.abbreviation='', this.name=''});

  factory UomModel.fromJSON(Map<String, dynamic> json) {
    return UomModel(
        id: json['code'] == null ? '' : json['code'],
        abbreviation: json['abv'] == null ? '' : json['abv'],
        name: json['name'] == null ? '' : json['name']);
  }

  factory UomModel.fromJSON2(Map<String, dynamic> json) {
    return UomModel(
        id: json['para_code_name'] == null ? '' : json['para_code_name']['code'],
        name: json['para_code_name'] == null ? '' : json['para_code_name']['name']);
  }

}
