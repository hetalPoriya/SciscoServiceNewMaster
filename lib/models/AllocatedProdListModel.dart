import 'package:scisco_service/models/AllocatedProdList.dart';

class AllocatedProdListModel {
  List<AllocatedProdList> assigned_products;
  String error;
  String status;

  AllocatedProdListModel.dart(this.assigned_products, this.error, this.status);

  factory AllocatedProdListModel.fromJson(Map<String, dynamic> json) {
    return AllocatedProdListModel.dart(
      json['assigned_products'] != null
          ? json['assigned_products']
              .map<AllocatedProdList>(
                  (json) => AllocatedProdList.fromJson(json))
              .toList()
          : null,
      json['error'].toString(),
      json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        "assigned_products": List<dynamic>.from(assigned_products.map((x) => x.toJson())),
        "error": error,
        "status": status,
      };
}
