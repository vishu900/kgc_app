import 'package:dataproject2/utils/Utils.dart';

class PurBillAppSelectionModel {

  final String? id;
  final String? partyName;
  final String? docNo;
  final String? docDate;
  final String? billNo;
  final String? billDate;
  final String? billAmount;

  PurBillAppSelectionModel(
      {this.id,
      this.partyName,
      this.docNo,
      this.docDate,
      this.billNo,
      this.billDate,
      this.billAmount});

  factory PurBillAppSelectionModel.fromJson(Map<String,dynamic> data){

    return PurBillAppSelectionModel(
      id: getString(data, 'code_pk'),
      partyName: getString(data['party_detail'], 'name'),
      docNo: getString(data, 'doc_no'),
      docDate: getString(data, 'doc_date'),
      billNo: getString(data, 'bill_no'),
      billDate: getString(data, 'bill_date'),
      billAmount: getString(data, 'net_amount')
    );

  }

}
