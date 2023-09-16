class PartyModel {
  String? id = '';
  String? title_code = '';
  String?  name = '';
  String? print_on_ch = '';
  String? active_tag = '';

  PartyModel(
      {this.id, this.title_code, this.name, this.print_on_ch, this.active_tag});

  factory PartyModel.fromJson(Map<String, dynamic> json) {
    return PartyModel(
      id: json['code'],
      title_code: json['title_code'],
      name: json['name'] as String?,
      print_on_ch: json['print_on_ch'] == null ? '' : json['print_on_ch'],
      active_tag: json['active_tag'] == null ? '' : json['active_tag'],
    );
  }
}
