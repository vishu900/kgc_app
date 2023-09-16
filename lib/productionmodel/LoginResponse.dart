class LoginResponse{
  LoginResponse({
    this.responseCode,
    this.Status,
    this.Message,
    this.data,
  });

  int? responseCode;
  bool? Status;
  String? data;
  String? Message;

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
      responseCode: json["responseCode"],
      Status: json["Status"],
      data: json['data'],
      Message: json['Message']
  );

  Map<String, dynamic> toMap() => {
    "responseCode": responseCode,
    "Status": Status,
    "data": data,
    "Message":Message
  };
}