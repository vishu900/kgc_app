import 'ordercontent.dart';
import 'package:json_annotation/json_annotation.dart';

// ignore: deprecated_member_use
@JsonSerializable(nullable: false)
class OrderModel {
  String? error;
  List<OrderContent>? content;

  OrderModel({this.error, this.content});

//  factory OrderModel.fromJson(Map<String, dynamic> json) {
//
//     OrderContent(order_header: json['order_header'],
//     qty: json['qty']
//     );
//
//
//  }
//
//  => _$OrderFromJson(json);
//  Map<String, dynamic> toJson() => _$PersonToJson(this);

//  OrderModel.fromJson(Map<String, dynamic> json) {
//    error = json['error'];
//    if (json['content'] != null) {
//      content = new List<OrderContent>();
//      json['content'].forEach((v) {
//
//        content.add(new OrderContent.fromJson(v));
//      });
//    }
//  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
