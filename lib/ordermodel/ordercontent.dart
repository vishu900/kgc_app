import 'orderheader.dart';

class OrderContent {
  OrderContent({
    this.sodPk,
    this.sohFk,
    this.sqdFk,
    this.orderHeader,
  });

  String? sodPk;
  String? sohFk;
  String? sqdFk;
  OrderHeader? orderHeader;

  factory OrderContent.fromJson(Map<String, dynamic> json) => OrderContent(
    sodPk: json["sod_pk"],
    sohFk: json["soh_fk"],
    sqdFk: json["sqd_fk"],
    orderHeader: OrderHeader.fromJson(json["order_header"]),
  );

  Map<String, dynamic> toJson() => {
    "sod_pk": sodPk,
    "soh_fk": sohFk,
    "sqd_fk": sqdFk,
    "order_header": orderHeader!.toJson(),
  };
}
