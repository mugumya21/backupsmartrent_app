// To parse this JSON data, do
//
//     final currentSmartUserLoginResponse = currentSmartUserLoginResponseFromJson(jsonString);

import 'dart:convert';

CurrentSmartUserLoginResponse currentSmartUserLoginResponseFromJson(String str) => CurrentSmartUserLoginResponse.fromJson(json.decode(str));

String currentSmartUserLoginResponseToJson(CurrentSmartUserLoginResponse data) => json.encode(data.toJson());

class CurrentSmartUserLoginResponse {
  bool? success;
  String? token;
  String? baseCurrencyCode;
  String? letterHead;
  CurrentSmartUserModel? user;

  CurrentSmartUserLoginResponse({
    this.success,
    this.token,
    this.baseCurrencyCode,
    this.letterHead,
    this.user,
  });

  factory CurrentSmartUserLoginResponse.fromJson(Map<String, dynamic> json) => CurrentSmartUserLoginResponse(
    success: json["success"],
    token: json["token"],
    baseCurrencyCode: json["base_currency_code"],
    letterHead: json["letter_head"],
    user: json[" user"] == null ? null : CurrentSmartUserModel.fromJson(json[" user"]),

  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "token": token,
    "base_currency_code": baseCurrencyCode,
    "letter_head": letterHead,
    " user": user?.toJson(),

  };
}



class CurrentSmartUserModel {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  int? isActive;
  String? theme;
  DateTime? createdAt;
  DateTime? updatedAt;

  CurrentSmartUserModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.isActive,
    this.theme,
    this.createdAt,
    this.updatedAt,
  });

  factory CurrentSmartUserModel.fromJson(Map<String, dynamic> json) => CurrentSmartUserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    isActive: json["is_active"],
    theme: json["theme"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "is_active": isActive,
    "theme": theme,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}




class LoginResponse {
  final bool? success;
  final String? token;
  final String? message;

  LoginResponse({
    this.success,
    this.token,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      token: json['token'],
      message: json['message'],
    );
  }
}



