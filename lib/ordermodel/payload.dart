import 'dart:convert';

import 'ordercontent.dart';

Payload payloadFromJson(String str) => Payload.fromJson(json.decode(str));

String payloadToJson(Payload data) => json.encode(data.toJson());

class Payload {
  Payload({
    this.error,
    this.content,
  });

  String? error;
  Map<String, List<List<OrderContent>>>? content;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        error: json["error"],
        content: Map.from(json["content"]).map((k, v) =>
            MapEntry<String, List<List<OrderContent>>>(
                k,
                List<List<OrderContent>>.from(v.map((x) =>
                    List<OrderContent>.from(
                        x.map((x) => OrderContent.fromJson(x))))))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "content": Map.from(content!).map((k, v) => MapEntry<String, dynamic>(
            k,
            List<dynamic>.from(
                v.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))))),
      };
}
