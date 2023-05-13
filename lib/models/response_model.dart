import 'dart:convert';

ResponseData responseDataFromMap(String str) =>
    ResponseData.fromMap(json.decode(str));

String responseDataToMap(ResponseData data) => json.encode(data.toMap());

class ResponseData {
  ResponseData({
    this.status,
    this.error,
  });

  String status;
  int error;

  factory ResponseData.fromMap(Map<String, dynamic> json) => ResponseData(
        status: json["status"] == null ? null : json["status"],
        error: json["error"] == null ? null : json["error"],
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "error": error == null ? null : error,
      };
}
