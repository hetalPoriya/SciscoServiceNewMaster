class AllocatedProdList {
  String product_id;
  String product_name;
  String product_image;
  String model_no;
  String brand;
  String reagents_based;
  String assigned_date;
  String warranty;
  String amc_cost;
  String amc_duration;
  String cmc_cost;
  String cmc_duration;
  String installation_status;
  String installed_at;
  String service_status;
  String assigned_product_id;

  AllocatedProdList(
      this.product_id,
      this.product_name,
      this.product_image,
      this.model_no,
      this.brand,
      this.reagents_based,
      this.assigned_date,
      this.warranty,
      this.amc_cost,
      this.amc_duration,
      this.cmc_cost,
      this.cmc_duration,
      this.installation_status,
      this.installed_at,
      this.service_status,
      this.assigned_product_id);

  factory AllocatedProdList.fromJson(Map<String, dynamic> json) =>
      AllocatedProdList(
        json["product_id"],
        json["product_name"],
        json["product_image"],
        json["model_no"],
        json["brand"],
        json["reagents_based"],
        json["assigned_date"],
        json["warranty"],
        json["amc_cost"],
        json["amc_duration"],
        json["cmc_cost"],
        json["cmc_duration"],
        json["installation_status"],
        json["installed_at"],
        json["service_status"],
        json["assigned_product_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": product_id,
        "product_name": product_name,
        "product_image": product_image,
        "model_no": model_no,
        "brand": brand,
        "reagents_based": reagents_based,
        "assigned_date": assigned_date,
        "warranty": warranty,
        "amc_cost": amc_cost,
        "amc_duration": amc_duration,
        "cmc_cost": cmc_cost,
        "cmc_duration": cmc_duration,
        "installation_status": installation_status,
        "installed_at": installed_at,
        "service_status": service_status,
        "assigned_product_id": assigned_product_id
      };
}
