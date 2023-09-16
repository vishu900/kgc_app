import 'package:dataproject2/utils/Utils.dart';

class SmsModel {
  final String? id;
  final String? empCode;
  final String? msgId;
  final String? sentTo;
  final String? message;
  final String? sentStatus;
  final String? date;
  final String? name;

  SmsModel(
      {this.id,
      this.empCode,
      this.msgId,
      this.sentTo,
      this.message,
      this.sentStatus,
      this.name,
      this.date});

  factory SmsModel.parseSms(Map<String, dynamic> data) {
    return SmsModel(
        id: getString(data, 'message_id'),
        empCode: getString(data, 'emp_code'),
        sentTo: getString(data, 'sent_to'),
        sentStatus: getString(data, 'sent_status'),
        message: getString(data, 'message'),
        name: getString(data['employee_name'], 'emp_name'),
        date: getFormattedDate(getString(data, 'created_at'),
            outFormat: 'dd-MMM-yyyy'));
  }
}
