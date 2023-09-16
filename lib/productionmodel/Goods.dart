import 'package:dataproject2/productionmodel/ListItem.dart';

class Goods {
  Goods(
      {this.pmName,
      this.godown,
      this.lotNo,
      this.rollBagDesign,
      this.prodDay,
      this.prodNight,
      this.remarks});

  Goods.fromJson(dynamic json) {
    pmName = json['pm_name'];
    godown = json['godown'];
    lotNo = json['lot_no'];
    rollBagDesign = json['roll_bag_design'];
    prodDay = json['prod_day'];
    prodNight = json['prod_night'];
    remarks = json['remarks'];
  }
  String? pmName = "";
  String? godown = "";
  String? lotNo = "";
  String? rollBagDesign = "0";
  double? prodDay = 0.0;
  double? prodNight = 0.0;
  String? remarks = "";
  int? prodOrderDtlPk = 0;
  bool isEmpty = true;
  ListItem? selectedGodown;
  ListItem? selectedpmName;
  bool is_edit = false;
  int? pk_code = 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pm_name'] = pmName;
    map['godown'] = godown;
    map['lot_no'] = lotNo;
    map['roll_bag_design'] = rollBagDesign;
    map['prod_day'] = prodDay;
    map['prod_night'] = prodNight;
    map['remarks'] = remarks;
    return map;
  }
}
