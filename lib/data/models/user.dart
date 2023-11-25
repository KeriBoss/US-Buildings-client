import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  String phoneNumber;
  String password;
  String? phoneFcmToken;

  User({
    required this.phoneNumber,
    required this.password,
    this.phoneFcmToken,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        phoneNumber: json['sodienthoai'] as String,
        password: json['matkhau'] as String,
        phoneFcmToken: json['fcmtoken'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sodienthoai': phoneNumber,
        'matkhau': password,
        'fcmtoken': phoneFcmToken,
      };
}
