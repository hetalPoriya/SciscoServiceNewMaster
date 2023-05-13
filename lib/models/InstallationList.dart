class InstallationList {
  String customer_id;
  String customer_name;
  String customer_mobile;
  String customer_email;
  String customer_whatsapp;
  String product_id;
  String product_name;
  String product_image;
  String product_brand;
  String model_no;
  String assigned_on;
  String qr_image;
  String status;
  String pre_installation;
  String installed_at;

  InstallationList(
      this.customer_id,
      this.customer_name,
      this.customer_mobile,
      this.customer_email,
      this.customer_whatsapp,
      this.product_id,
      this.product_name,
      this.product_image,
      this.product_brand,
      this.model_no,
      this.assigned_on,
      this.qr_image,
      this.status,
      this.pre_installation,
      this.installed_at);

  factory InstallationList.fromJson(Map<String, dynamic> json) =>
      InstallationList(
          json["customer_id"],
          json["customer_name"],
          json["customer_mobile"],
          json["customer_email"],
          json["customer_whatsapp"],
          json["product_id"],
          json["product_name"],
          json["product_image"],
          json["product_brand"],
          json["model_no"],
          json["assigned_on"],
          json["qr_image"],
          json["status"],
          json["pre_installation"],
          json["installed_at"]);

  Map<String, dynamic> toJson() => {
    "customer_id": customer_id,
    "customer_name": customer_name,
    "customer_mobile": customer_mobile,
    "customer_email": customer_email,
    "customer_whatsapp": customer_whatsapp,
    "product_id": product_id,
    "product_name": product_name,
    "product_image":product_image,
    "product_brand": product_brand,
    "model_no": model_no,
    "assigned_on":assigned_on,
    "qr_image":qr_image,
    "status": status,
    "pre_installation": pre_installation,
    "installed_at": installed_at
  };
}
