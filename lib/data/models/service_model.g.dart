// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
      id: json['id'] as String,
      createdDate: json['created_date'] as String?,
      serviceLv1Name: json['tendichvucap1'] as String?,
      iconUrl: json['hinhanhicon'] as String?,
      description: json['mota'] as String?,
      userId: json['userid'] as String?,
    );

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_date': instance.createdDate,
      'tendichvucap1': instance.serviceLv1Name,
      'hinhanhicon': instance.iconUrl,
      'mota': instance.description,
      'userid': instance.userId,
    };
