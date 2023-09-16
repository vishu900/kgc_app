class AddressModel {
  String? id = '';
  String? add1 = '';
  String? add2 = '';
  String? add0 = '';
  String? city = '';

  AddressModel({this.id, this.add1, this.add2, this.add0, this.city});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['rank'],
      add1: json['add1'] == null ? '' : json['add1'].toString(),
      add2: json['add2'] == null ? '' : json['add2'].toString(),
      add0: json['add0'] == null ? '' : json['add0'].toString(),
      city: json['city_detail']['name'] == null
          ? ''
          : json['city_detail']['name'].toString(),
    );
  }

}
