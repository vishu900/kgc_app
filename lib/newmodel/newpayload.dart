import 'package:dataproject2/newmodel/neworder.dart';


class NewPayLoad {
  String? error;
  List<NewOrder>? content;

  NewPayLoad({this.error, this.content});

  NewPayLoad.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['content'] != null) {
      content = <NewOrder>[];
      json['content'].forEach((v) {
        content!.add(new NewOrder.fromJson(v));
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