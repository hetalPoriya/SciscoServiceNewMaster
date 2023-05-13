class MyProfileModel {
  String name;
  String email;
  String mobile;
  String whatsapp_no;
  String organization;
  String address;
  String error;

  MyProfileModel(
      this.name,
      this.email,
      this.mobile,
      this.whatsapp_no,
      this.organization,
      this.address,
      this.error
      );

  factory MyProfileModel.fromJson(Map<String, dynamic> json) {
    return MyProfileModel(
      json['name'],
      json['email'],
      json['mobile'],
      json['whatsapp_no'],
      json['organization'],
      json['address'],
      json['error']
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "mobile": mobile,
    "whatsapp_no": whatsapp_no,
    "organization": organization,
    "address": address,
    "error": error
  };
}
