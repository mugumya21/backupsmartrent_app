
import 'package:smart_rent/data_layer/models/smart_model.dart';



// To parse this JSON data, do
//
//     final loggedInSmartUser = loggedInSmartUserFromJson(jsonString);

import 'dart:convert';

LoggedInSmartUser loggedInSmartUserFromJson(String str) => LoggedInSmartUser.fromJson(json.decode(str));

String loggedInSmartUserToJson(LoggedInSmartUser data) => json.encode(data.toJson());

class LoggedInSmartUser {
  bool? success;
  String? message;
  CurrentSmartUser? user;

  LoggedInSmartUser({
    this.success,
    this.message,
    this.user,
  });

  factory LoggedInSmartUser.fromJson(Map<String, dynamic> json) => LoggedInSmartUser(
    success: json["success"],
    message: json["message"],
    user: json["user"] == null ? null : CurrentSmartUser.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "user": user?.toJson(),
  };
}

class CurrentSmartUser extends SmartModel{
  int? id;
  dynamic name;
  String? email;
  String? appUrl;
  dynamic emailVerifiedAt;
  dynamic password;
  dynamic rememberToken;
  dynamic createdAt;
  dynamic updatedAt;

  CurrentSmartUser({
    this.id,
    this.name,
    this.email,
    this.appUrl,
    this.emailVerifiedAt,
    this.password,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  });

  factory CurrentSmartUser.fromJson(Map<String, dynamic> json) => CurrentSmartUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    appUrl: json["app_url"],
    emailVerifiedAt: json["email_verified_at"],
    password: json["password"],
    rememberToken: json["remember_token"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "app_url": appUrl,
    "email_verified_at": emailVerifiedAt,
    "password": password,
    "remember_token": rememberToken,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };

  @override
  int getId() { return id!;
  }

  @override
  String getName() { return name;
  }

  @override
  String getCode() {
    return '';
  }

}



class SmartUser extends SmartModel {
  int id;
  String? initials;
  String? firstName;
  String? middleName;
  String? lastName;
  String? telephone;
  dynamic dateOfBirth;
  int? gender;
  int? departmentId;
  String? code;
  String? idNumber;
  String? nssfNumber;
  String? tinNumber;
  dynamic height;
  String? bloodGroup;
  String? personalEmail;
  String? permanentAddress;
  String? presentAddress;
  bool? isAddressSame;
  String? officeNumber;
  String? mobileNumber;
  int? userId;
  int? salutationId;
  int? maritalStatusId;

  SmartUser(
      {required this.id,
      this.initials,
      required this.firstName,
      this.middleName,
      required this.lastName,
      required this.telephone,
      required this.dateOfBirth,
      required this.gender,
      this.departmentId,
      this.code,
      this.idNumber,
      this.nssfNumber,
      this.tinNumber,
      this.height,
      this.bloodGroup,
      required this.personalEmail,
      this.permanentAddress,
      this.presentAddress,
      this.isAddressSame,
      this.officeNumber,
      this.mobileNumber,
      required this.userId,
      this.salutationId,
      this.maritalStatusId});

  factory SmartUser.fromJson(Map json) {
    return SmartUser(
      id: json["id"],
      initials: json["initials"],
      firstName: json["first_name"],
      middleName: json["middle_name"],
      lastName: json["last_name"],
      telephone: json["telephone"],
      dateOfBirth: json["date_of_birth"],
      gender: json["gender"],
      departmentId: json["department_id"],
      code: json["code"],
      idNumber: json["id_number"],
      nssfNumber: json["nssf_number"],
      tinNumber: json["tin_number"],
      height: json["height"],
      bloodGroup: json["blood_group"],
      personalEmail: json["personal_email"],
      permanentAddress: json["permanent_address"],
      presentAddress: json["present_address"],
      isAddressSame: json["is_address_same"] == 1 ? true : false,
      officeNumber: json["office_number"],
      mobileNumber: json["mobile_number"],
      userId: json["user_id"],
      salutationId: json["salutation_id"],
      maritalStatusId: json["marital_status_id"],
    );
  }

  static toJson(SmartUser employee) {
    return {
      "id": employee.id,
      "initials": employee.initials,
      "first_name": employee.firstName,
      "middle_name": employee.middleName,
      "last_name": employee.lastName,
      "telephone": employee.telephone,
      "date_of_birth": employee.dateOfBirth,
      "gender": employee.gender,
      "department_id": employee.departmentId,
      "code": employee.code,
      "id_number": employee.idNumber,
      "nssf_number": employee.nssfNumber,
      "tin_number": employee.tinNumber,
      "height": employee.height,
      "blood_group": employee.bloodGroup,
      "personal_email": employee.personalEmail,
      "permanent_address": employee.permanentAddress,
      "present_address": employee.presentAddress,
      "is_address_same": employee.isAddressSame,
      "office_number": employee.officeNumber,
      "mobile_number": employee.mobileNumber,
      "user_id": employee.userId,
      "salutation_id": employee.salutationId,
      "marital_status_id": employee.maritalStatusId,
    };
  }

  @override
  int getId() {
    return id;
  }

  @override
  String getName() {
    return "$firstName ${middleName ?? ''} $lastName";
  }

  @override
  String getCode() {
    return '';
  }

}





// class CurrentSmartUser extends SmartModel {
//   int id;
//   String? initials;
//   String? firstName;
//   String? middleName;
//   String? lastName;
//   String? telephone;
//   dynamic dateOfBirth;
//   int? gender;
//   int? departmentId;
//   String? code;
//   String? idNumber;
//   String? nssfNumber;
//   String? tinNumber;
//   dynamic height;
//   String? bloodGroup;
//   String? personalEmail;
//   String? permanentAddress;
//   String? presentAddress;
//   bool? isAddressSame;
//   String? officeNumber;
//   String? mobileNumber;
//   int? userId;
//   int? salutationId;
//   int? maritalStatusId;
//   String? avatar;
//   String token;
//   String url;
//
//   CurrentSmartUser({
//     required this.id,
//     this.initials,
//     required this.firstName,
//     this.middleName,
//     required this.lastName,
//     required this.telephone,
//     required this.dateOfBirth,
//     required this.gender,
//     this.departmentId,
//     this.code,
//     this.idNumber,
//     this.nssfNumber,
//     this.tinNumber,
//     this.height,
//     this.bloodGroup,
//     required this.personalEmail,
//     this.permanentAddress,
//     this.presentAddress,
//     this.isAddressSame,
//     this.officeNumber,
//     this.mobileNumber,
//     required this.userId,
//     this.salutationId,
//     this.maritalStatusId,
//     this.avatar,
//     required this.token,
//     required this.url,
//   });
//
//   factory CurrentSmartUser.fromJson(Map json) {
//     return CurrentSmartUser(
//       id: json['employee']["id"],
//       initials: json['employee']["initials"],
//       firstName: json['employee']["first_name"],
//       middleName: json['employee']["middle_name"],
//       lastName: json['employee']["last_name"],
//       telephone: json['employee']["telephone"],
//       dateOfBirth: json['employee']["date_of_birth"],
//       gender: json['employee']["gender"],
//       departmentId: json['employee']["department_id"],
//       code: json['employee']["code"],
//       idNumber: json['employee']["id_number"],
//       nssfNumber: json['employee']["nssf_number"],
//       tinNumber: json['employee']["tin_number"],
//       height: json['employee']["height"],
//       bloodGroup: json['employee']["blood_group"],
//       personalEmail: json['employee']["personal_email"],
//       permanentAddress: json['employee']["permanent_address"],
//       presentAddress: json['employee']["present_address"],
//       isAddressSame: json['employee']["is_address_same"] == 1 ? true : false,
//       officeNumber: json['employee']["office_number"],
//       mobileNumber: json['employee']["mobile_number"],
//       userId: json['employee']["user_id"],
//       salutationId: json['employee']["salutation_id"],
//       maritalStatusId: json['employee']["marital_status_id"],
//       avatar: json["avatar"],
//       token: json["token"],
//       url: json["url"],
//     );
//   }
//
//   static toJson(CurrentSmartUser employee) {
//     return {
//       "id": employee.id,
//       "initials": employee.initials,
//       "first_name": employee.firstName,
//       "middle_name": employee.middleName,
//       "last_name": employee.lastName,
//       "telephone": employee.telephone,
//       "date_of_birth": employee.dateOfBirth,
//       "gender": employee.gender,
//       "department_id": employee.departmentId,
//       "code": employee.code,
//       "id_number": employee.idNumber,
//       "nssf_number": employee.nssfNumber,
//       "tin_number": employee.tinNumber,
//       "height": employee.height,
//       "blood_group": employee.bloodGroup,
//       "personal_email": employee.personalEmail,
//       "permanent_address": employee.permanentAddress,
//       "present_address": employee.presentAddress,
//       "is_address_same": employee.isAddressSame,
//       "office_number": employee.officeNumber,
//       "mobile_number": employee.mobileNumber,
//       "user_id": employee.userId,
//       "salutation_id": employee.salutationId,
//       "marital_status_id": employee.maritalStatusId,
//       "avatar": employee.avatar,
//     };
//   }
//
//   @override
//   int getId() {
//     return id;
//   }
//
//   @override
//   String getName() {
//     return "$firstName ${middleName ?? ''} $lastName";
//   }
// }
