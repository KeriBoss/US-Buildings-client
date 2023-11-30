class ServiceModel {
  String id;
  String? createdDate;
  String? serviceLv1Name;
  String? serviceLv2Name;
  String? serviceName;
  String? iconUrl;
  String? price;
  String? description;
  String? userId;

  ServiceModel({
    required this.id,
    this.createdDate,
    this.serviceLv1Name,
    this.serviceLv2Name,
    this.serviceName,
    this.price,
    this.iconUrl,
    this.description,
    this.userId,
  });

  static ServiceModel fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['id'] as String,
        createdDate: json['created_date'] as String?,
        serviceLv1Name: json['tendichvucap1'] as String?,
        serviceLv2Name: json['tendichvucap2'] as String?,
        serviceName: json['tendichvu'] as String?,
        iconUrl: json['hinhanhicon'] as String?,
        description: json['mota'] as String?,
        price: json['gia'] as String?,
        userId: json['userid'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'created_date': createdDate,
        'tendichvucap1': serviceLv1Name,
        'tendichvucap2': serviceLv2Name,
        'tendichvu': serviceName,
        'hinhanhicon': iconUrl,
        'mota': description,
        'gia': price,
        'userid': userId,
      };
}
