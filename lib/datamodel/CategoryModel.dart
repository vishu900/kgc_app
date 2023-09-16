class CategoryModel {
  String? id;
  String? categoryName;
  String? type;
  bool isSelected;
  String? selectedId;

  CategoryModel(
      {this.id,
      this.categoryName,
      this.type,
      this.isSelected = false,
      this.selectedId});

  factory CategoryModel.fromJSON(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['code'] == null ? '' : json['code'],
      categoryName: json['name'] == null ? '' : json['name'],
      type: json.containsKey('remarks') ? 'Attr' : 'Para',
    );
  }
}
