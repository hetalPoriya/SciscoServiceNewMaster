class InstallationDone {
  List<Installations> installations;
  String status;
  int error;

  InstallationDone({this.installations, this.status, this.error});

  InstallationDone.fromJson(Map<String, dynamic> json) {
    if (json['installations'] != null) {
      installations = <Installations>[];
      json['installations'].forEach((v) {
        installations.add(new Installations.fromJson(v));
      });
    }
    status = json['status'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.installations != null) {
      data['installations'] =
          this.installations.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['error'] = this.error;
    return data;
  }
}

class Installations {
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
  String status;
  String preInstallation;
  String installedAt;
  String assigned_product_id;

  Installations(
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
      this.status,
      this.preInstallation,
      this.installedAt,
      this.assigned_product_id});

  Installations.fromJson(Map<String, dynamic> json) {
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
    status = json['status'];
    preInstallation = json['pre_installation'];
    installedAt = json['installed_at'];
    assigned_product_id = json['assigned_product_id'];
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
    data['status'] = this.status;
    data['pre_installation'] = this.preInstallation;
    data['installed_at'] = this.installedAt;
    data['assigned_product_id'] = this.assigned_product_id;
    return data;
  }
}
