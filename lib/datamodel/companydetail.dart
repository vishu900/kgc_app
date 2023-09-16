import 'content.dart';

class CompanyDetail {
  String? error;
  List<Content>? content;

  CompanyDetail({this.error, this.content});

  CompanyDetail.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}