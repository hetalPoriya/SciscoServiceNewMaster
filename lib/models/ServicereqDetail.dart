class SerReqDetail {
  ServiceProduct serviceProduct;
  String status;
  int error;

  SerReqDetail({this.serviceProduct, this.status, this.error});

  SerReqDetail.fromJson(Map<String, dynamic> json) {
    serviceProduct = json['service_product'] != null
        ? new ServiceProduct.fromJson(json['service_product'])
        : null;
    status = json['status'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.serviceProduct != null) {
      data['service_product'] = this.serviceProduct.toJson();
    }
    data['status'] = this.status;
    data['error'] = this.error;
    return data;
  }
}

class ServiceProduct {
  String productId;
  String productName;
  String productImage;
  String modelNo;
  String brand;
  String customerId;
  String customerName;
  String customerMobile;
  String customerWhatsapp;
  String qrImage;
  String serviceStatus;
  String response;
  String serviceRequestId;

  ServiceProduct(
      {this.productId,
        this.productName,
        this.productImage,
        this.modelNo,
        this.brand,
        this.customerId,
        this.customerName,
        this.customerMobile,
        this.customerWhatsapp,
        this.qrImage,
        this.serviceStatus,
        this.response,
        this.serviceRequestId});

  ServiceProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    modelNo = json['model_no'];
    brand = json['brand'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerMobile = json['customer_mobile'];
    customerWhatsapp = json['customer_whatsapp'];
    qrImage = json['qr_image'];
    serviceStatus = json['service_status'];
    response = json['response'];
    serviceRequestId = json['service_request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['model_no'] = this.modelNo;
    data['brand'] = this.brand;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_mobile'] = this.customerMobile;
    data['customer_whatsapp'] = this.customerWhatsapp;
    data['qr_image'] = this.qrImage;
    data['service_status'] = this.serviceStatus;
    data['response'] = this.response;
    data['service_request_id'] = this.serviceRequestId;
    return data;
  }
}