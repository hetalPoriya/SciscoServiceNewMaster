class LoginRespoModel {
  String error;
  String error_msg;
  String status;
  String email;
  String customer_id;
  String service_engineer_id;
  String customer_name;
  String engineer_status;
  String service_engineer_name;
  String engineer_name;
  String engineer_email;
  String engineer_mobile;
  String installations_pending;
  String installations_done;
  String services_pending;
  String services_done;

  LoginRespoModel(
      this.error,
      this.error_msg,
      this.status,
      this.email,
      this.customer_id,
      this.service_engineer_id,
      this.customer_name,
      this.engineer_status,
      this.engineer_name,
      this.engineer_email,
      this.engineer_mobile,
      this.service_engineer_name,
      this.installations_pending,
      this.installations_done,
      this.services_pending,
      this.services_done);

  factory LoginRespoModel.fromJson(Map<String, dynamic> json) {
    return LoginRespoModel(
        json['error'].toString(),
        json['error_msg'],
        json['status'],
        json['email'],
        json['customer_id'],
        json['service_engineer_id'],
        json['customer_name'],
        json['engineer_status'],
        json['engineer_name'],
        json['engineer_email'],
        json['engineer_mobile'],
        json['service_engineer_name'],
        json['installations_pending'].toString(),
        json['installations_done'].toString(),
        json['services_pending'].toString(),
        json['services_done'].toString());
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "error_msg": error_msg,
        "status": status,
        "email": email,
        "customer_id": customer_id,
        "service_engineer_id": service_engineer_id,
        "customer_name": customer_name,
        "engineer_name": engineer_name,
        "engineer_email": engineer_email,
        "engineer_mobile": engineer_mobile,
        "engineer_status": engineer_status,
        "service_engineer_name": service_engineer_name,
        "installations_pending": installations_pending,
        "installations_done": installations_done,
        "services_pending": services_pending,
        "services_done": services_done
      };
}
