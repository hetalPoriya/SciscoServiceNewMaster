class ServicePending {
  List<ServiceRequest> serviceRequest;
  String status;
  int error;

  ServicePending({this.serviceRequest, this.status, this.error});

  ServicePending.fromJson(Map<String, dynamic> json) {
    if (json['service_request'] != null) {
      serviceRequest = <ServiceRequest>[];
      json['service_request'].forEach((v) {
        serviceRequest.add(new ServiceRequest.fromJson(v));
      });
    }
    status = json['status'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.serviceRequest != null) {
      data['service_request'] =
          this.serviceRequest.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['error'] = this.error;
    return data;
  }
}

class ServiceRequest {
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
  String assignedProductId;

  ServiceRequest(
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
      this.serviceRequestId,
      this.assignedProductId});

  ServiceRequest.fromJson(Map<String, dynamic> json) {
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
    assignedProductId = json['assigned_product_id'];
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
    data['assigned_product_id'] = this.assignedProductId;
    return data;
  }
}
