class ReasonList {
  int error;
  String status;
  List<String> reasons;

  ReasonList({this.error, this.status, this.reasons});

  ReasonList.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    status = json['status'];
    reasons = json['reasons'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status'] = this.status;
    data['reasons'] = this.reasons;
    return data;
  }
}