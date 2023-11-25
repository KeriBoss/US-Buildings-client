import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel {
  String id;
  String? createdDate;
  String? serviceLv1Name;
  String? iconUrl;
  String? description;
  String? userId;

  ServiceModel({
    required this.id,
    this.createdDate,
    this.serviceLv1Name,
    this.iconUrl,
    this.description,
    this.userId,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}
