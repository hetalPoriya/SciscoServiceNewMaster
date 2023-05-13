import 'package:scisco_service/models/InstallationList.dart';

class InstallationModel {
  List<InstallationList> installations;
  String status;
  String error;

  InstallationModel.dart(this.installations, this.error, this.status);

  factory InstallationModel.fromJson(Map<String, dynamic> json) {
    return InstallationModel.dart(
      json['installations'] != null
          ? json['installations']
          .map<InstallationList>(
              (json) => InstallationList.fromJson(json))
          .toList()
          : null,
      json['status'],
      json['error'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "installations": List<dynamic>.from(installations.map((x) => x.toJson())),
    "status": status,
    "error": error,
  };
}
