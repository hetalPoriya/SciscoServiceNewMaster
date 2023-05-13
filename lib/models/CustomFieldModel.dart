import 'package:scisco_service/models/CustomFieldList.dart';

class CustomFieldModel {
  List<CustomFieldList> custom_fields;
  String error;
  String service_request_id;

// print(CustomFieldList);
  CustomFieldModel.dart(this.custom_fields, this.error, this.service_request_id);

  factory CustomFieldModel.fromJson(Map<String, dynamic> json) {
    return CustomFieldModel.dart(
      json['custom_fields'] != null
          ? json['custom_fields']
          .map<CustomFieldList>(
              (json) => CustomFieldList.fromJson(json))
          .toList()
          : null,
      json['error'].toString(),
      json['service_request_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    "custom_fields": List<dynamic>.from(custom_fields.map((x) => x.toJson())),
    "error": error,
    "service_request_id": service_request_id,
  };
}
