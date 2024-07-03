// To parse this JSON data, do
//
//     final paymentReportScheduleModel = paymentReportScheduleModelFromJson(jsonString);

import 'dart:convert';

import 'package:smart_rent/data_layer/models/tenant_unit/tenant_unit_model.dart';
import 'package:smart_rent/data_layer/models/unit/unit_model.dart';

List<UnpaidReportScheduleModel> paymentReportScheduleModelFromJson(String str) => List<UnpaidReportScheduleModel>.from(json.decode(str).map((x) => UnpaidReportScheduleModel.fromJson(x)));

String paymentReportScheduleModelToJson(List<UnpaidReportScheduleModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UnpaidReportScheduleModel {
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
  PaymentReportTenantUnit? tenantUnitModel;
  PaymentReportUnit? unitModel;
  UnpaidSearch? search;
  int? foreignDiscountAmount;
  int? baseDiscountAmount;
  int? foreignPaid;
  int? basePaid;
  int? foreignBalance;
  int? baseBalance;
  int? foreignAmount;
  int? baseAmount;

  UnpaidReportScheduleModel({
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
    this.tenantUnitModel,
    this.unitModel,
    this.search,
    this.foreignDiscountAmount,
    this.baseDiscountAmount,
    this.foreignPaid,
    this.basePaid,
    this.foreignBalance,
    this.baseBalance,
    this.foreignAmount,
    this.baseAmount
  });

  factory UnpaidReportScheduleModel.fromJson(Map<String, dynamic> json) => UnpaidReportScheduleModel(
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
    tenantUnitModel: json["tenantunit"] == null ? null : PaymentReportTenantUnit.fromJson(json["tenantunit"]),
    unitModel: json["unit"] == null ? null : PaymentReportUnit.fromJson(json["unit"]),
    search: json["search"] == null ? null : UnpaidSearch.fromJson(json["search"]),
    foreignDiscountAmount: json["foreign_discount_amount"],
    baseDiscountAmount: json["base_discount_amount"],
    foreignPaid: json["foreign_paid"],
    basePaid: json["base_paid"],
    foreignBalance: json["foreign_balance"],
    baseBalance: json["base_balance"],


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
    "tenantunit": tenantUnitModel?.toJson(),
    "unit": unitModel?.toJson(),
    "search": search?.toJson(),
    "foreign_discount_amount": foreignDiscountAmount,
    "base_discount_amount": baseDiscountAmount,
    "foreign_paid": foreignPaid,
    "base_paid": basePaid,
    "foreign_balance": foreignBalance,
    "base_balance": baseBalance,

  };
}

class PaymentReportTenantUnit {
  int? id;
  DateTime? fromDate;
  DateTime? toDate;
  int? amount;
  int? duration;
  int? discountAmount;
  int? currencyId;
  String? description;
  int? unitId;
  int? tenantId;
  int? scheduleId;
  int? propertyId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  PaymentReportTenant? tenant;
  int? convertedAmount;
  int? usdAmount;
  int? ugxAmount;
  int? convertedDiscountAmount;
  int? usdDiscountAmount;
  int? ugxDiscountAmount;

  PaymentReportTenantUnit({
    this.id,
    this.fromDate,
    this.toDate,
    this.amount,
    this.duration,
    this.discountAmount,
    this.currencyId,
    this.description,
    this.unitId,
    this.tenantId,
    this.scheduleId,
    this.propertyId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.tenant,
    this.convertedAmount,
    this.usdAmount,
    this.ugxAmount,
    this.convertedDiscountAmount,
    this.usdDiscountAmount,
    this.ugxDiscountAmount,
  });

  factory PaymentReportTenantUnit.fromJson(Map<String, dynamic> json) => PaymentReportTenantUnit(
    id: json["id"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    amount: json["amount"],
    duration: json["duration"],
    discountAmount: json["discount_amount"],
    currencyId: json["currency_id"],
    description: json["description"],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    scheduleId: json["schedule_id"],
    propertyId: json["property_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    tenant: json["tenant"] == null ? null : PaymentReportTenant.fromJson(json["tenant"]),
    convertedAmount: json["converted_amount"],
    usdAmount: json["usd_amount"],
    ugxAmount: json["ugx_amount"],
    convertedDiscountAmount: json["converted_discount_amount"],
    usdDiscountAmount: json["usd_discount_amount"],
    ugxDiscountAmount: json["ugx_discount_amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "amount": amount,
    "duration": duration,
    "discount_amount": discountAmount,
    "currency_id": currencyId,
    "description": description,
    "unit_id": unitId,
    "tenant_id": tenantId,
    "schedule_id": scheduleId,
    "property_id": propertyId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "tenant": tenant?.toJson(),
    "converted_amount": convertedAmount,
    "usd_amount": usdAmount,
    "ugx_amount": ugxAmount,
    "converted_discount_amount": convertedDiscountAmount,
    "usd_discount_amount": usdDiscountAmount,
    "ugx_discount_amount": ugxDiscountAmount,
  };
}

class PaymentReportTenant {
  int? id;
  Number? number;
  int? clientTypeId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ClientProfile>? clientProfiles;

  PaymentReportTenant({
    this.id,
    this.number,
    this.clientTypeId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.clientProfiles,
  });

  factory PaymentReportTenant.fromJson(Map<String, dynamic> json) => PaymentReportTenant(
    id: json["id"],
    number: numberValues.map[json["number"]],
    clientTypeId: json["client_type_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    clientProfiles: json["client_profiles"] == null ? [] : List<ClientProfile>.from(json["client_profiles"]!.map((x) => ClientProfile.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "number": numberValues.reverse[number],
    "client_type_id": clientTypeId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "client_profiles": clientProfiles == null ? [] : List<dynamic>.from(clientProfiles!.map((x) => x.toJson())),
  };
}

class ClientProfile {
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

  ClientProfile({
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

  factory ClientProfile.fromJson(Map<String, dynamic> json) => ClientProfile(
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

enum LastName {
  AISHA
}

final lastNameValues = EnumValues({
  "AISHA": LastName.AISHA
});

enum Number {
  C_20240207071834,
  C_20240207081944,
  C_20240220112355
}

final numberValues = EnumValues({
  "C-20240207071834": Number.C_20240207071834,
  "C-20240207081944": Number.C_20240207081944,
  "C-20240220112355": Number.C_20240220112355
});

class PaymentReportUnit {
  int? id;
  String? name;
  int? amount;
  int? isAvailable;
  String? squareMeters;
  String? description;
  int? unitType;
  int? floorId;
  int? scheduleId;
  int? propertyId;
  int? currencyId;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  PaymentReportUnit({
    this.id,
    this.name,
    this.amount,
    this.isAvailable,
    this.squareMeters,
    this.description,
    this.unitType,
    this.floorId,
    this.scheduleId,
    this.propertyId,
    this.currencyId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentReportUnit.fromJson(Map<String, dynamic> json) => PaymentReportUnit(
    id: json["id"],
    name: json["name"],
    amount: json["amount"],
    isAvailable: json["is_available"],
    squareMeters: json["square_meters"],
    description: json["description"],
    unitType: json["unit_type"],
    floorId: json["floor_id"],
    scheduleId: json["schedule_id"],
    propertyId: json["property_id"],
    currencyId: json["currency_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "amount": amount,
    "is_available": isAvailable,
    "square_meters": squareMeters,
    "description": description,
    "unit_type": unitType,
    "floor_id": floorId,
    "schedule_id": scheduleId,
    "property_id": propertyId,
    "currency_id": currencyId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}


// class UnpaidSearch {
//   String? propertyId;
//   String? from;
//   String? to;
//   String? unitId;
//   String? tenantId;
//   String? tenantSelected;
//   String? periodDate;
//   DateTime? thismonth;
//   DateTime? lastmonth;
//   List<DateTime>? dates;
//
//   UnpaidSearch({
//     this.propertyId,
//     this.from,
//     this.to,
//     this.unitId,
//     this.tenantId,
//     this.tenantSelected,
//     this.periodDate,
//     this.thismonth,
//     this.lastmonth,
//     this.dates,
//   });
//
//   factory UnpaidSearch.fromJson(Map<String, dynamic> json) => UnpaidSearch(
//     propertyId: json["property_id"],
//     from: json["from"],
//     to: json["to"],
//     unitId: json["unit_id"],
//     tenantId: json["tenant_id"],
//     tenantSelected: json["tenant_selected"],
//     periodDate: json["period_date"],
//     thismonth: json["thismonth"] == null
//         ? null
//         : DateTime.parse(json["thismonth"]),
//     lastmonth: json["lastmonth"] == null
//         ? null
//         : DateTime.parse(json["lastmonth"]),
//     dates: json["dates"] == null
//         ? []
//         : [
//       if (json["thismonth"] != null)
//         DateTime.parse(json["thismonth"]),
//       if (json["lastmonth"] != null)
//         DateTime.parse(json["lastmonth"]),
//       ...List<DateTime>.from(json["dates"].map((x) => DateTime.parse(x))),
//     ],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "property_id": propertyId,
//     "from": from,
//     "to": to,
//     "unit_id": unitId,
//     "tenant_id": tenantId,
//     "tenant_selected": tenantSelected,
//     "period_date": periodDate,
//     "thismonth": thismonth == null
//         ? null
//         : "${thismonth!.year.toString().padLeft(4, '0')}-${thismonth!.month.toString().padLeft(2, '0')}-${thismonth!.day.toString().padLeft(2, '0')}",
//     "lastmonth": lastmonth == null
//         ? null
//         : "${lastmonth!.year.toString().padLeft(4, '0')}-${lastmonth!.month.toString().padLeft(2, '0')}-${lastmonth!.day.toString().padLeft(2, '0')}",
//     "dates": dates == null
//         ? []
//         : [
//       if (thismonth != null)
//         "${thismonth!.year.toString().padLeft(4, '0')}-${thismonth!.month.toString().padLeft(2, '0')}-${thismonth!.day.toString().padLeft(2, '0')}",
//       if (lastmonth != null)
//         "${lastmonth!.year.toString().padLeft(4, '0')}-${lastmonth!.month.toString().padLeft(2, '0')}-${lastmonth!.day.toString().padLeft(2, '0')}",
//       ...dates!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}"),
//     ],
//   };
// }


class UnpaidSearch {
  String? propertyId;
  String? from;
  String? to;
  String? unitId;
  String? tenantId;
  String? tenantSelected;
  String? periodDate;
  DateTime? thismonth;
  DateTime? lastmonth;
  List<DateTime>? dates;

  UnpaidSearch({
    this.propertyId,
    this.from,
    this.to,
    this.unitId,
    this.tenantId,
    this.tenantSelected,
    this.periodDate,
    this.thismonth,
    this.lastmonth,
    this.dates,
  });

  factory UnpaidSearch.fromJson(Map<String, dynamic> json) => UnpaidSearch(
    propertyId: json["property_id"],
    from: json["from"],
    to: json["to"],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    tenantSelected: json["tenant_selected"],
    periodDate: json["period_date"],
    thismonth: json["thismonth"] == null ? null : DateTime.parse(json["thismonth"]),
    lastmonth: json["lastmonth"] == null ? null : DateTime.parse(json["lastmonth"]),
    dates: json["dates"] == null ? [] : List<DateTime>.from(json["dates"]!.map((x) => DateTime.parse(x))),
  );

  Map<String, dynamic> toJson() => {
    "property_id": propertyId,
    "from": from,
    "to": to,
    "unit_id": unitId,
    "tenant_id": tenantId,
    "tenant_selected": tenantSelected,
    "period_date": periodDate,
    "thismonth": "${thismonth!.year.toString().padLeft(4, '0')}-${thismonth!.month.toString().padLeft(2, '0')}-${thismonth!.day.toString().padLeft(2, '0')}",
    "lastmonth": "${lastmonth!.year.toString().padLeft(4, '0')}-${lastmonth!.month.toString().padLeft(2, '0')}-${lastmonth!.day.toString().padLeft(2, '0')}",
    "dates": dates == null ? [] : List<dynamic>.from(dates!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
