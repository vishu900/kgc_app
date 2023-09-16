class ItemResultModel {
  String? id;
  String? itemName;
  String? itemCode;
  String? itemImage;
  String? itemType;
  bool? isSelected;
  bool isEnabled;

  ItemResultModel(
      {this.id,
        this.itemCode,
        this.itemName,
        this.itemImage,
        this.itemType,
        this.isSelected,
        this.isEnabled = true});

  factory ItemResultModel.fromJSON(Map<String, dynamic> json) {
    return ItemResultModel(
        id: json['code'],
        itemName: json['name'] == null ? 'N.A' : json['name'],
        itemType: '1',
        itemImage: json['item_single_image'] == null
            ? ''
            : json['item_single_image']['code_pk'],
        isSelected: false);
  }

  factory ItemResultModel.fromJSONParse2(Map<String, dynamic> json) {
    return ItemResultModel(
        id: json['code'],
        itemCode: json['item_code'],
        itemType: '2',
        itemName: getItemName(json),
        itemImage: json['item_single_image'] == null
            ? ''
            : json['item_single_image']['code_pk'],
        isSelected: false);
  }

  static String getItemName(Map<String, dynamic> json) {
    String name = json['item_name'] == null
        ? ''
        : json['item_name']['name'].toString().trim();
    String? count =
    json['item_count'] == null ? '' : getUnDottedValue(json, 'item_count');
    String? material = json['item_material'] == null
        ? ''
        : getUnDottedValue(json, 'item_material');
    String? brand =
    json['item_brand'] == null ? '' : getUnDottedValue(json, 'item_brand');
    String? shade =
    json['item_shade'] == null ? '' : getUnDottedValue(json, 'item_shade');
    String? value1 =
    json['iop1_code'] == '0' ? '' : json['item_code_1']['name'];
    String? value2 =
    json['iop2_code'] == '0' ? '' : json['item_code_2']['name'];
    String? value3 =
    json['iop3_code'] == '0' ? '' : json['item_code_3']['name'];
    return '$count $name $material $brand $shade $value1 $value2 $value3'
        .trim();
  }

  static String getItemNameEdit(Map<String, dynamic> json) {
    print('getItemName-> $json');
    String name = json['item_detail'] == null
        ? ''
        : json['item_detail']['name'].toString().trim();
    return name;
  }

  static String? getUnDottedValue(json, String param) {
    if (json[param]['code'] == '0') {
      return '';
    } else {
      return json[param]['name'];
    }
  }
}
