class CustomerList {
  List<Customers> customers;
  int status;
  String error;

  CustomerList({this.customers, this.status, this.error});

  CustomerList.fromJson(Map<String, dynamic> json) {
    if (json['customers'] != null) {
      customers = <Customers>[];
      json['customers'].forEach((v) {
        customers.add(new Customers.fromJson(v));
      });
    }
    status = json['status'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customers != null) {
      data['customers'] = this.customers.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['error'] = this.error;
    return data;
  }
}

class Customers {
  String id;
  String name;
  String email;
  String mobile;
  String password;
  String whatsappNo;
  String stateId;
  String cityId;
  String category;
  String organization;
  String address;
  String serviceEngineerId;
  String createdAt;

  Customers(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.password,
      this.whatsappNo,
      this.stateId,
      this.cityId,
      this.category,
      this.organization,
      this.address,
      this.serviceEngineerId,
      this.createdAt});

  Customers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    whatsappNo = json['whatsapp_no'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    category = json['category'];
    organization = json['organization'];
    address = json['address'];
    serviceEngineerId = json['service_engineer_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['whatsapp_no'] = this.whatsappNo;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['category'] = this.category;
    data['organization'] = this.organization;
    data['address'] = this.address;
    data['service_engineer_id'] = this.serviceEngineerId;
    data['created_at'] = this.createdAt;
    return data;
  }
}
