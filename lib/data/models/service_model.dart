import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
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

  Map<String, dynamic> toJson(ServiceModel instance) => <String, dynamic>{
        'id': instance.id,
        'created_date': instance.createdDate,
        'tendichvucap1': instance.serviceLv1Name,
        'tendichvucap2': instance.serviceLv2Name,
        'tendichvu': instance.serviceName,
        'hinhanhicon': instance.iconUrl,
        'mota': instance.description,
        'gia': instance.price,
        'userid': instance.userId,
      };
}
