class ItemAttributeModel {
  String? name;
  String? attrCode;
  bool isHeader;
  String? at1;
  String? at2;
  String? at3;
  String? at4;
  String? at5;
  String? at6;
  String? at7;
  String? at8;
  String? at9;
  String? at10;
  String? at11;
  String? at12;
  String? at13;
  String? at14;
  String? at15;
  String? at16;
  String? at17;
  String? at18;
  String? at19;
  String? at20;
  String? at21;
  String? at22;
  String? at23;
  String? at24;
  String? at25;

  ItemAttributeModel(
      {this.name = '',
      this.attrCode = '',
      this.isHeader = false,
      this.at1 = '',
      this.at2 = '',
      this.at3 = '',
      this.at4 = '',
      this.at5 = '',
      this.at6 = '',
      this.at7 = '',
      this.at8 = '',
      this.at9 = '',
      this.at10 = '',
      this.at11 = '',
      this.at12 = '',
      this.at13 = '',
      this.at14 = '',
      this.at15 = '',
      this.at16 = '',
      this.at17 = '',
      this.at18 = '',
      this.at19 = '',
      this.at20 = '',
      this.at21 = '',
      this.at22 = '',
      this.at23 = '',
      this.at24 = '',
      this.at25 = ''});

  factory ItemAttributeModel.fromJSON(Map<String, dynamic> json) {
    return ItemAttributeModel(
      attrCode: json['attr_code'],
      at1: json['at1'] == null ? '' : json['at1'],
      at2: json['at2'] == null ? '' : json['at2'],
      at3: json['at3'] == null ? '' : json['at3'],
      at4: json['at4'] == null ? '' : json['at4'],
      at5: json['at5'] == null ? '' : json['at5'],
      at6: json['at6'] == null ? '' : json['at6'],
      at7: json['at7'] == null ? '' : json['at7'],
      at8: json['at8'] == null ? '' : json['at8'],
      at9: json['at9'] == null ? '' : json['at9'],
      at10: json['at10'] == null ? '' : json['at10'],
      at11: json['at11'] == null ? '' : json['at11'],
      at12: json['at12'] == null ? '' : json['at12'],
      at13: json['at13'] == null ? '' : json['at13'],
      at14: json['at14'] == null ? '' : json['at14'],
      at15: json['at15'] == null ? '' : json['at15'],
      at16: json['at16'] == null ? '' : json['at16'],
      at17: json['at17'] == null ? '' : json['at17'],
      at18: json['at18'] == null ? '' : json['at18'],
      at19: json['at19'] == null ? '' : json['at19'],
      at20: json['at20'] == null ? '' : json['at20'],
      at21: json['at21'] == null ? '' : json['at21'],
      at22: json['at22'] == null ? '' : json['at22'],
      at23: json['at23'] == null ? '' : json['at23'],
      at24: json['at24'] == null ? '' : json['at24'],
      at25: json['at25'] == null ? '' : json['at25'],
      name: json['attr_name']['name'] == null ? '' : json['attr_name']['name'],
    );
  }


}
