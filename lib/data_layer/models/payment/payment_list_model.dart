// To parse this JSON data, do
//
//     final paymentListModel = paymentListModelFromJson(jsonString);

import 'dart:convert';

import 'package:smart_rent/data_layer/models/currency/currency_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_account_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_mode_model.dart';

List<PaymentListModel> paymentListModelFromJson(String str) => List<PaymentListModel>.from(json.decode(str).map((x) => PaymentListModel.fromJson(x)));

String paymentListModelToJson(List<PaymentListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentListModel {
  int? paymentId;
  DateTime? date;
  int? amount;
  int? amountDue;
  PropertyName? propertyName;
  String? unitName;
  Period? period;
  List<SchedulesPerPayment>? schedulesPerPayment;
  List<TenantProfile>? tenantProfile;
  Period? tenantType;
  PaymentModeModel? paymentModeModel;
  PaymentAccountsModel? paymentAccountModel;
  CurrencyModel? currencyModel;
  int? docid;
  int? filetype;
  String? letterHead;
  bool? canDelete;


  PaymentListModel({
    this.paymentId,
    this.date,
    this.amount,
    this.amountDue,
    this.propertyName,
    this.unitName,
    this.period,
    this.schedulesPerPayment,
    this.tenantProfile,
    this.tenantType,
    this.paymentModeModel,
    this.paymentAccountModel,
    this.currencyModel,
    this.docid,
    this.filetype,
    this.letterHead,
    this.canDelete,

  });

  factory PaymentListModel.fromJson(Map<String, dynamic> json) => PaymentListModel(
    paymentId: json["payment_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    amount: json["amount"],
    amountDue: json["amount_due"],
    propertyName: propertyNameValues.map[json["property_name"]],
    unitName: json["unit_name"],
    period: json["period"] == null ? null : Period.fromJson(json["period"]),
    schedulesPerPayment: json["schedules_per_payment"] == null ? [] : List<SchedulesPerPayment>.from(json["schedules_per_payment"]!.map((x) => SchedulesPerPayment.fromJson(x))),
    tenantProfile: json["tenant_profile"] == null ? [] : List<TenantProfile>.from(json["tenant_profile"]!.map((x) => TenantProfile.fromJson(x))),
    tenantType: json["tenant_type"] == null ? null : Period.fromJson(json["tenant_type"]),
    paymentModeModel: json["payment_mode"] == null ? null : PaymentModeModel.fromJson(json["payment_mode"]),
    paymentAccountModel: json["payment_account"] == null ? null : PaymentAccountsModel.fromJson(json["payment_account"]),
    currencyModel: json["currency"] == null ? null : CurrencyModel.fromJson(json["currency"]),
    docid: json["docid"],
    filetype: json["filetype"],
    letterHead: json["letter_head"],
    canDelete: json["can_delete"],

  );

  Map<String, dynamic> toJson() => {
    "payment_id": paymentId,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "amount": amount,
    "amount_due": amountDue,
    "property_name": propertyNameValues.reverse[propertyName],
    "unit_name": unitName,
    "period": period?.toJson(),
    "schedules_per_payment": schedulesPerPayment == null ? [] : List<dynamic>.from(schedulesPerPayment!.map((x) => x.toJson())),
    "tenant_profile": tenantProfile == null ? [] : List<dynamic>.from(tenantProfile!.map((x) => x.toJson())),
    "tenant_type": tenantType?.toJson(),
    "payment_mode": paymentModeModel?.toJson(),
    "payment_account": paymentAccountModel?.toJson(),
    "currency": currencyModel?.toJson(),
    "docid": unitName,
    "filetype": unitName,
    "letter_head": letterHead,
    "can_delete": canDelete,

  };
}

class Period {
  int? id;
  Code? code;
  Description? name;
  Description? description;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Period({
    this.id,
    this.code,
    this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Period.fromJson(Map<String, dynamic> json) => Period(
    id: json["id"],
    code: codeValues.map[json["code"]],
    name: descriptionValues.map[json["name"]],
    description: descriptionValues.map[json["description"]],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": codeValues.reverse[code],
    "name": descriptionValues.reverse[name],
    "description": descriptionValues.reverse[description],
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

enum Code {
  COM,
  IND,
  MONTHLY,
  WEEKLY
}

final codeValues = EnumValues({
  "COM": Code.COM,
  "IND": Code.IND,
  "MONTHLY": Code.MONTHLY,
  "WEEKLY": Code.WEEKLY
});

enum Description {
  COMPANY,
  INDIVIDUAL,
  MONTHLY,
  WEEKLY
}

final descriptionValues = EnumValues({
  "Company": Description.COMPANY,
  "Individual": Description.INDIVIDUAL,
  "Monthly": Description.MONTHLY,
  "Weekly": Description.WEEKLY
});

enum PropertyName {
  PIONEER_MALL
}

final propertyNameValues = EnumValues({
  "PIONEER MALL": PropertyName.PIONEER_MALL
});

class SchedulesPerPayment {
  Schedule? schedule;

  SchedulesPerPayment({
    this.schedule,
  });

  factory SchedulesPerPayment.fromJson(Map<String, dynamic> json) => SchedulesPerPayment(
    schedule: json["schedule"] == null ? null : Schedule.fromJson(json["schedule"]),
  );

  Map<String, dynamic> toJson() => {
    "schedule": schedule?.toJson(),
  };
}

class Schedule {
  int? id;
  DateTime? fromDate;
  DateTime? toDate;
  int? discountAmount;
  int? paid;
  int? balance;
  int? balanceCForward;
  String? description;
  int? unitId;
  int? tenantId;
  int? tenantUnitId;
  int? scheduleId;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Schedule({
    this.id,
    this.fromDate,
    this.toDate,
    this.discountAmount,
    this.paid,
    this.balance,
    this.balanceCForward,
    this.description,
    this.unitId,
    this.tenantId,
    this.tenantUnitId,
    this.scheduleId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    discountAmount: json["discount_amount"],
    paid: json["paid"],
    balance: json["balance"],
    balanceCForward: json["balance_c_forward"],
    description: json["description"],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    tenantUnitId: json["tenant_unit_id"],
    scheduleId: json["schedule_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "discount_amount": discountAmount,
    "paid": paid,
    "balance": balance,
    "balance_c_forward": balanceCForward,
    "description": description,
    "unit_id": unitId,
    "tenant_id": tenantId,
    "tenant_unit_id": tenantUnitId,
    "schedule_id": scheduleId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class TenantProfile {
  int? id;
  String? firstName;
  dynamic middleName;
  String? lastName;
  String? companyName;
  DateTime? dateOfBirth;
  int? gender;
  Address? address;
  String? tin;
  String? number;
  dynamic email;
  String? nin;
  dynamic designation;
  dynamic description;
  int? clientId;
  int? nationId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  TenantProfile({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.companyName,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.tin,
    this.number,
    this.email,
    this.nin,
    this.designation,
    this.description,
    this.clientId,
    this.nationId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory TenantProfile.fromJson(Map<String, dynamic> json) => TenantProfile(
    id: json["id"],
    firstName: json["first_name"],
    middleName: json["middle_name"],
    lastName: json["last_name"],
    companyName: json["company_name"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    gender: json["gender"],
    address: addressValues.map[json["address"]],
    tin: json["tin"],
    number: json["number"],
    email: json["email"],
    nin: json["nin"],
    designation: json["designation"],
    description: json["description"],
    clientId: json["client_id"],
    nationId: json["nation_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "middle_name": middleName,
    "last_name": lastName,
    "company_name": companyName,
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "address": addressValues.reverse[address],
    "tin": tin,
    "number": number,
    "email": email,
    "nin": nin,
    "designation": designation,
    "description": description,
    "client_id": clientId,
    "nation_id": nationId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

enum Address {
  HFBBFHFH,
  NAKAWA,
  NTINDA
}

final addressValues = EnumValues({
  "hfbbfhfh": Address.HFBBFHFH,
  "NAKAWA": Address.NAKAWA,
  "NTINDA": Address.NTINDA
});

enum Name {
  ASHLEY,
  GAJU_COLLECTIONS,
  JP_HOLDINGS
}

final nameValues = EnumValues({
  "ASHLEY": Name.ASHLEY,
  "GAJU COLLECTIONS": Name.GAJU_COLLECTIONS,
  "JP Holdings": Name.JP_HOLDINGS
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}















//
// // To parse this JSON data, do
// //
// //     final paymentListModel = paymentListModelFromJson(jsonString);
//
// import 'dart:convert';
//
// List<PaymentListModel> paymentListModelFromJson(String str) => List<PaymentListModel>.from(json.decode(str).map((x) => PaymentListModel.fromJson(x)));
//
// String paymentListModelToJson(List<PaymentListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class PaymentListModel {
//   int? paymentId;
//   DateTime? date;
//   int? amount;
//   int? amountDue;
//   PropertyName? propertyName;
//   String? unitName;
//   ItemsWithSchedule? itemsWithSchedule;
//   List<Tenant>? tenant;
//
//   PaymentListModel({
//     this.paymentId,
//     this.date,
//     this.amount,
//     this.amountDue,
//     this.propertyName,
//     this.unitName,
//     this.itemsWithSchedule,
//     this.tenant,
//   });
//
//   factory PaymentListModel.fromJson(Map<String, dynamic> json) => PaymentListModel(
//     paymentId: json["payment_id"],
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//     amount: json["amount"],
//     amountDue: json["amount_due"],
//     propertyName: propertyNameValues.map[json["property_name"]],
//     unitName: json["unit_name"],
//     itemsWithSchedule: json["items_with_schedule"] == null ? null : ItemsWithSchedule.fromJson(json["items_with_schedule"]),
//     tenant: json["tenant"] == null ? [] : List<Tenant>.from(json["tenant"]!.map((x) => Tenant.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "payment_id": paymentId,
//     "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//     "amount": amount,
//     "amount_due": amountDue,
//     "property_name": propertyNameValues.reverse[propertyName],
//     "unit_name": unitName,
//     "items_with_schedule": itemsWithSchedule?.toJson(),
//     "tenant": tenant == null ? [] : List<dynamic>.from(tenant!.map((x) => x.toJson())),
//   };
// }
//
// class ItemsWithSchedule {
//   int? id;
//   DateTime? fromDate;
//   DateTime? toDate;
//   int? discountAmount;
//   int? paid;
//   int? balance;
//   int? balanceCForward;
//   String? description;
//   int? unitId;
//   int? tenantId;
//   int? tenantUnitId;
//   int? scheduleId;
//   int? createdBy;
//   int? updatedBy;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   ItemsWithSchedule({
//     this.id,
//     this.fromDate,
//     this.toDate,
//     this.discountAmount,
//     this.paid,
//     this.balance,
//     this.balanceCForward,
//     this.description,
//     this.unitId,
//     this.tenantId,
//     this.tenantUnitId,
//     this.scheduleId,
//     this.createdBy,
//     this.updatedBy,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory ItemsWithSchedule.fromJson(Map<String, dynamic> json) => ItemsWithSchedule(
//     id: json["id"],
//     fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
//     toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
//     discountAmount: json["discount_amount"],
//     paid: json["paid"],
//     balance: json["balance"],
//     balanceCForward: json["balance_c_forward"],
//     description: json["description"],
//     unitId: json["unit_id"],
//     tenantId: json["tenant_id"],
//     tenantUnitId: json["tenant_unit_id"],
//     scheduleId: json["schedule_id"],
//     createdBy: json["created_by"],
//     updatedBy: json["updated_by"],
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//     updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
//     "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
//     "discount_amount": discountAmount,
//     "paid": paid,
//     "balance": balance,
//     "balance_c_forward": balanceCForward,
//     "description": description,
//     "unit_id": unitId,
//     "tenant_id": tenantId,
//     "tenant_unit_id": tenantUnitId,
//     "schedule_id": scheduleId,
//     "created_by": createdBy,
//     "updated_by": updatedBy,
//     "created_at": createdAt?.toIso8601String(),
//     "updated_at": updatedAt?.toIso8601String(),
//   };
// }
//
// enum PropertyName {
//   PIONEER_MALL
// }
//
// final propertyNameValues = EnumValues({
//   "PIONEER MALL": PropertyName.PIONEER_MALL
// });
//
// class Tenant {
//   int? id;
//   Name? firstName;
//   dynamic middleName;
//   LastName? lastName;
//   Name? companyName;
//   DateTime? dateOfBirth;
//   int? gender;
//   Address? address;
//   String? tin;
//   String? number;
//   dynamic email;
//   String? nin;
//   dynamic designation;
//   dynamic description;
//   int? clientId;
//   int? nationId;
//   int? createdBy;
//   dynamic updatedBy;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   Tenant({
//     this.id,
//     this.firstName,
//     this.middleName,
//     this.lastName,
//     this.companyName,
//     this.dateOfBirth,
//     this.gender,
//     this.address,
//     this.tin,
//     this.number,
//     this.email,
//     this.nin,
//     this.designation,
//     this.description,
//     this.clientId,
//     this.nationId,
//     this.createdBy,
//     this.updatedBy,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
//     id: json["id"],
//     firstName: nameValues.map[json["first_name"]],
//     middleName: json["middle_name"],
//     lastName: lastNameValues.map[json["last_name"]],
//     companyName: nameValues.map[json["company_name"]],
//     dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
//     gender: json["gender"],
//     address: addressValues.map[json["address"]],
//     tin: json["tin"],
//     number: json["number"],
//     email: json["email"],
//     nin: json["nin"],
//     designation: json["designation"],
//     description: json["description"],
//     clientId: json["client_id"],
//     nationId: json["nation_id"],
//     createdBy: json["created_by"],
//     updatedBy: json["updated_by"],
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//     updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "first_name": nameValues.reverse[firstName],
//     "middle_name": middleName,
//     "last_name": lastNameValues.reverse[lastName],
//     "company_name": nameValues.reverse[companyName],
//     "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
//     "gender": gender,
//     "address": addressValues.reverse[address],
//     "tin": tin,
//     "number": number,
//     "email": email,
//     "nin": nin,
//     "designation": designation,
//     "description": description,
//     "client_id": clientId,
//     "nation_id": nationId,
//     "created_by": createdBy,
//     "updated_by": updatedBy,
//     "created_at": createdAt?.toIso8601String(),
//     "updated_at": updatedAt?.toIso8601String(),
//   };
// }
//
// enum Address {
//   HFBBFHFH,
//   NAKAWA,
//   NTINDA
// }
//
// final addressValues = EnumValues({
//   "hfbbfhfh": Address.HFBBFHFH,
//   "NAKAWA": Address.NAKAWA,
//   "NTINDA": Address.NTINDA
// });
//
// enum Name {
//   ASHLEY,
//   GAJU_COLLECTIONS,
//   JP_HOLDINGS
// }
//
// final nameValues = EnumValues({
//   "ASHLEY": Name.ASHLEY,
//   "GAJU COLLECTIONS": Name.GAJU_COLLECTIONS,
//   "JP Holdings": Name.JP_HOLDINGS
// });
//
// enum LastName {
//   AISHA
// }
//
// final lastNameValues = EnumValues({
//   "AISHA": LastName.AISHA
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
