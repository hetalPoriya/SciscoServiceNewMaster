class AllocatedProdDetail {
  ProductDetails productDetails;
  int error;
  String status;

  AllocatedProdDetail({this.productDetails, this.error, this.status});

  AllocatedProdDetail.fromJson(Map<String, dynamic> json) {
    productDetails = json['product_details'] != null
        ? new ProductDetails.fromJson(json['product_details'])
        : null;
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productDetails != null) {
      data['product_details'] = this.productDetails.toJson();
    }
    data['error'] = this.error;
    data['status'] = this.status;
    return data;
  }
}

class ProductDetails {
  String productId;
  String assignedProductId;
  String productName;
  String productImage;
  String modelNo;
  String brand;
  String qrImage;
  String reagentsBased;
  String assignedDate;
  String warranty;
  String amcCost;
  String amcDuration;
  String cmcCost;
  String cmcDuration;
  String installationStatus;
  String serviceStatus;
  String installedAt;
  String serviceRequestid;
  var serviceYet;
  List service_logs;

  ProductDetails({
    this.productId,
    this.assignedProductId,
    this.productName,
    this.productImage,
    this.modelNo,
    this.brand,
    this.qrImage,
    this.reagentsBased,
    this.assignedDate,
    this.warranty,
    this.amcCost,
    this.amcDuration,
    this.cmcCost,
    this.cmcDuration,
    this.installationStatus,
    this.serviceStatus,
    this.installedAt,
    this.serviceRequestid,
    this.serviceYet,
    this.service_logs,
  });

  ProductDetails.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    assignedProductId = json['assigned_product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    modelNo = json['model_no'];
    brand = json['brand'];
    qrImage = json['qr_image'];
    reagentsBased = json['reagents_based'];
    assignedDate = json['assigned_date'];
    warranty = json['warranty'];
    amcCost = json['amc_cost'];
    amcDuration = json['amc_duration'];
    cmcCost = json['cmc_cost'];
    cmcDuration = json['cmc_duration'];
    installationStatus = json['installation_status'];
    serviceStatus = json['service_status'];
    installedAt = json['installed_at'];
    serviceRequestid = json['service_request_id'];
    serviceYet = json['number_of_services_yet'];
    service_logs = json['service_log'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['assigned_product_id'] = this.assignedProductId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['model_no'] = this.modelNo;
    data['brand'] = this.brand;
    data['qr_image'] = this.qrImage;
    data['reagents_based'] = this.reagentsBased;
    data['assigned_date'] = this.assignedDate;
    data['warranty'] = this.warranty;
    data['amc_cost'] = this.amcCost;
    data['amc_duration'] = this.amcDuration;
    data['cmc_cost'] = this.cmcCost;
    data['cmc_duration'] = this.cmcDuration;
    data['installation_status'] = this.installationStatus;
    data['service_status'] = this.serviceStatus;
    data['installed_at'] = this.installedAt;
    data['service_request_id'] = this.serviceRequestid;
    data['number_of_services_yet'] = this.serviceYet;
    data['service_log'] = this.service_logs;
    return data;
  }
}
