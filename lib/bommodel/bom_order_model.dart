import 'bom_content.dart';

class BomOrderModel {
  String? _error;
  List<BomContent>? _content;

  BomOrderModel({String? error, List<BomContent>? content}) {
    this._error = error;
    this._content = content;
  }

  String? get error => _error;
  set error(String? error) => _error = error;
  List<BomContent>? get content => _content;
  set content(List<BomContent>? content) => _content = content;

  BomOrderModel.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    if (json['content'] != null) {
      _content = <BomContent>[];
      json['content'].forEach((v) {
        _content!.add(new BomContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    if (this._content != null) {
      data['content'] = this._content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
