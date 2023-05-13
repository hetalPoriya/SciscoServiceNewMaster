import 'package:scisco_service/models/ServiceReqList.dart';

class ServiceReqModel {
  List<ServiceReqList> service_request;
  String status;
  String error;

  ServiceReqModel.dart(this.service_request, this.error, this.status);

  factory ServiceReqModel.fromJson(Map<String, dynamic> json) {
    return ServiceReqModel.dart(
      json['service_request'] != null
          ? json['service_request']
              .map<ServiceReqList>((json) => ServiceReqList.fromJson(json))
              .toList()
          : null,
      json['status'],
      json['error'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "service_request":
            List<dynamic>.from(service_request.map((x) => x.toJson())),
        "status": status,
        "error": error,
      };
}
