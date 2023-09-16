import 'notification.dart';

class NotificationModel {
  String? error;
  List<Notification>? content;

  NotificationModel({this.error, this.content});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['notification'] != null) {
      content = <Notification>[];
      json['notification'].forEach((v) {
        content!.add(new Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.content != null) {
      data['notification'] = this.content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}