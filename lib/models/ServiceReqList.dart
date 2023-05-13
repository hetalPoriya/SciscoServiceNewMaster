class ServiceReqList {
  String product_id;
  String product_name;
  String product_image;
  String model_no;
  String brand;
  String customer_id;
  String customer_name;
  String customer_mobile;
  String customer_whatsapp;
  String service_status;
  String service_request_id;
  String response;

  ServiceReqList(
      this.product_id,
      this.product_name,
      this.product_image,
      this.model_no,
      this.brand,
      this.customer_id,
      this.customer_name,
      this.customer_mobile,
      this.customer_whatsapp,
      this.service_status,
      this.service_request_id,
      this.response);

  factory ServiceReqList.fromJson(Map<String, dynamic> json) => ServiceReqList(
      json["product_id"],
      json["product_name"],
      json["product_image"],
      json["model_no"],
      json["brand"],
      json["customer_id"],
      json["customer_name"],
      json["customer_mobile"],
      json["customer_whatsapp"],
      json["service_status"],
      json["service_request_id"],
      json["response"]);

  Map<String, dynamic> toJson() => {
        "product_id": product_id,
        "product_name": product_name,
        "product_image":product_image,
        "model_no": model_no,
        "brand": brand,
        "customer_id": customer_id,
        "customer_name": customer_name,
        "customer_mobile": customer_mobile,
        "customer_whatsapp": customer_whatsapp,
        "service_status": service_status,
        "service_request_id": service_request_id,
        "response": response
      };
}
