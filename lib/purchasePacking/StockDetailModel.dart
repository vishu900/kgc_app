import 'package:dataproject2/utils/Utils.dart';

class StockDetailModel{

  final String? id;
  final String? lotNo;
  final String? rollNo;
  final String? stockQty;
  final String? stockQtyUom;
  final String? billQty;
  final String? billQtyUom;

  StockDetailModel(
      {this.id,
      this.lotNo,
      this.rollNo,
      this.stockQty,
      this.stockQtyUom,
      this.billQty,
      this.billQtyUom});

  factory StockDetailModel.fromJson(Map<String,dynamic> data){

    return StockDetailModel(
      id: getString(data, 'code_pk'),
      lotNo: getString(data, 'lot_no'),
      rollNo: getString(data, 'roll_no'),
      stockQty: getString(data, 'stk_qty'),
      stockQtyUom: getString(data['stock_unit_name'], 'abv'),
      billQty: getString(data, 'fin_qty'),
      billQtyUom: getString(data['fin_unit_name'], 'abv')
    );

  }


}