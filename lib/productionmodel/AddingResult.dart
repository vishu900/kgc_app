class AddingResult {
  AddingResult({
      this.responseCode, 
      this.status, 
      this.message, 
      });

  AddingResult.fromJson(dynamic json) {
    responseCode = json['responseCode'];
    status = json['Status'];
    message = json['Message'];

  }
  int? responseCode;
  bool? status;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['responseCode'] = responseCode;
    map['Status'] = status;
    map['Message'] = message;
    return map;
  }

}