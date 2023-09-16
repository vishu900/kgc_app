class OrderHeader {
  OrderHeader({
    this.sohPk,
    this.orderNo,
  });

  String? sohPk;
  String? orderNo;

  factory OrderHeader.fromJson(Map<String, dynamic> json) => OrderHeader(
    sohPk: json["soh_pk"],
    orderNo: json["order_no"],
  );

  Map<String, dynamic> toJson() => {
    "soh_pk": sohPk,
    "order_no": orderNo,
  };
}
