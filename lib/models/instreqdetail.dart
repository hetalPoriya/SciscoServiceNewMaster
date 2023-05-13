class InstallationReqDetail {
  InstallationProduct installationProduct;
  String status;
  int error;

  InstallationReqDetail({this.installationProduct, this.status, this.error});

  InstallationReqDetail.fromJson(Map<String, dynamic> json) {
    installationProduct = json['installation_product'] != null
        ? new InstallationProduct.fromJson(json['installation_product'])
        : null;
    status = json['status'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.installationProduct != null) {
      data['installation_product'] = this.installationProduct.toJson();
    }
    data['status'] = this.status;
    data['error'] = this.error;
    return data;
  }
}

class InstallationProduct {
  String customerId;
  String customerName;
  String customerMobile;
  String customerEmail;
  String customerWhatsapp;
  String productId;
  String productName;
  String productImage;
  String productBrand;
  String modelNo;
  String assignedOn;
  String qrImage;
  String installationStatus;
  String preInstallation;
  String installedAt;

  InstallationProduct(
      {this.customerId,
        this.customerName,
        this.customerMobile,
        this.customerEmail,
        this.customerWhatsapp,
        this.productId,
        this.productName,
        this.productImage,
        this.productBrand,
        this.modelNo,
        this.assignedOn,
        this.qrImage,
        this.installationStatus,
        this.preInstallation,
        this.installedAt});

  InstallationProduct.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerMobile = json['customer_mobile'];
    customerEmail = json['customer_email'];
    customerWhatsapp = json['customer_whatsapp'];
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    productBrand = json['product_brand'];
    modelNo = json['model_no'];
    assignedOn = json['assigned_on'];
    qrImage = json['qr_image'];
    installationStatus = json['installation_status'];
    preInstallation = json['pre_installation'];
    installedAt = json['installed_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_mobile'] = this.customerMobile;
    data['customer_email'] = this.customerEmail;
    data['customer_whatsapp'] = this.customerWhatsapp;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['product_brand'] = this.productBrand;
    data['model_no'] = this.modelNo;
    data['assigned_on'] = this.assignedOn;
    data['qr_image'] = this.qrImage;
    data['installation_status'] = this.installationStatus;
    data['pre_installation'] = this.preInstallation;
    data['installed_at'] = this.installedAt;
    return data;
  }
}