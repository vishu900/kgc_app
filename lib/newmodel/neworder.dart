import 'content.dart';

class NewOrder {

  String? _error;
  List<Content>? _content;

  NewOrder({String? error, List<Content>? content}) {
    this._error = error;
    this._content = content;
  }

  String? get error => _error;
  set error(String? error) => _error = error;
  List<Content>? get content => _content;
  set content(List<Content>? content) => _content = content;

  NewOrder.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    if (json['content'] != null) {
      _content = <Content>[];
      json['content'].forEach((v) {
        _content!.add(new Content.fromJson(v));
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
