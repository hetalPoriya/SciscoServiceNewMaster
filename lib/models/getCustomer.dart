class GetCutomer {
  int error;
  String status;
  List<Customerss> customers;

  GetCutomer({this.error, this.status, this.customers});

  GetCutomer.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    status = json['status'];
    if (json['customers'] != null) {
      customers = <Customerss>[];
      json['customers'].forEach((v) {
        customers.add(new Customerss.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status'] = this.status;
    if (this.customers != null) {
      data['customers'] = this.customers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customerss {
  String id;
  String name;
  String email;
  String mobile;
  // String

  Customerss({this.id, this.name, this.email, this.mobile});

  Customerss.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    return data;
  }
}
