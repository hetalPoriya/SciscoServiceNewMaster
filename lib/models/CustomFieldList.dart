class CustomFieldList {
  String product_id;
  String field_type;
  String label;
  String options;

  CustomFieldList(
      this.product_id,
      this.field_type,
      this.label,
      this.options);

  factory CustomFieldList.fromJson(Map<String, dynamic> json) =>
      CustomFieldList(
          json["product_id"],
          json["field_type"],
          json["label"],
          json["options"]);

  Map<String, dynamic> toJson() => {
    "product_id": product_id,
    "field_type": field_type,
    "label": label,
    "options": options
  };
}
