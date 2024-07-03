// To parse this JSON data, do
//
//     final paymentReportScheduleResponseModel = paymentReportScheduleResponseModelFromJson(jsonString);

import 'dart:convert';

PaymentReportScheduleResponseModel paymentReportScheduleResponseModelFromJson(String str) => PaymentReportScheduleResponseModel.fromJson(json.decode(str));

String paymentReportScheduleResponseModelToJson(PaymentReportScheduleResponseModel data) => json.encode(data.toJson());

class PaymentReportScheduleResponseModel {
  List<PaymentReportModel>? payments;
  Search? search;

  PaymentReportScheduleResponseModel({
    this.payments,
    this.search,
  });

  factory PaymentReportScheduleResponseModel.fromJson(Map<String, dynamic> json) => PaymentReportScheduleResponseModel(
    payments: json["payments"] == null ? [] : List<PaymentReportModel>.from(json["payments"]!.map((x) => PaymentReportModel.fromJson(x))),
    search: json["search"] == null ? null : Search.fromJson(json["search"]),
  );

  Map<String, dynamic> toJson() => {
    "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x.toJson())),
    "search": search?.toJson(),
  };
}

class PaymentReportModel {
  int? id;
  DateTime? date;
  int? amount;
  int? amountDue;
  int? propertyId;
  int? accountId;
  int? paymentModeId;
  int? tenantUnitId;
  dynamic description;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Tenantunit? tenantunit;
  Property? property;
  Account? account;
  int? baseAmount;
  int? baseAmountDue;
  int? foreignAmount;
  int? foreignAmountDue;

  PaymentReportModel({
    this.id,
    this.date,
    this.amount,
    this.amountDue,
    this.propertyId,
    this.accountId,
    this.paymentModeId,
    this.tenantUnitId,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.tenantunit,
    this.property,
    this.account,
    this.baseAmount,
    this.baseAmountDue,
    this.foreignAmount,
    this.foreignAmountDue,
  });

  factory PaymentReportModel.fromJson(Map<String, dynamic> json) => PaymentReportModel(
    id: json["id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    amount: json["amount"],
    amountDue: json["amount_due"],
    propertyId: json["property_id"],
    accountId: json["account_id"],
    paymentModeId: json["payment_mode_id"],
    tenantUnitId: json["tenant_unit_id"],
    description: json["description"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    tenantunit: json["tenantunit"] == null ? null : Tenantunit.fromJson(json["tenantunit"]),
    property: json["property"] == null ? null : Property.fromJson(json["property"]),
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
    baseAmount: json["base_amount"],
    baseAmountDue: json["base_amount_due"],
    foreignAmount: json["foreign_amount"],
    foreignAmountDue: json["foreign_amount_due"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "amount": amount,
    "amount_due": amountDue,
    "property_id": propertyId,
    "account_id": accountId,
    "payment_mode_id": paymentModeId,
    "tenant_unit_id": tenantUnitId,
    "description": description,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "tenantunit": tenantunit?.toJson(),
    "property": property?.toJson(),
    "account": account?.toJson(),
    "base_amount": baseAmount,
    "base_amount_due": baseAmountDue,
    "foreign_amount": foreignAmount,
    "foreign_amount_due": foreignAmountDue,
  };
}

class Account {
  int? id;
  String? name;
  String? number;
  int? currencyId;
  int? balance;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Account({
    this.id,
    this.name,
    this.number,
    this.currencyId,
    this.balance,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json["id"],
    name: json["name"],
    number: json["number"],
    currencyId: json["currency_id"],
    balance: json["balance"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "number": number,
    "currency_id": currencyId,
    "balance": balance,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}



class Property {
  int? id;
  String? name;
  String? number;
  String? location;
  String? squareMeters;
  String? description;
  int? propertyTypeId;
  int? propertyCategoryId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Property({
    this.id,
    this.name,
    this.number,
    this.location,
    this.squareMeters,
    this.description,
    this.propertyTypeId,
    this.propertyCategoryId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json["id"],
    name: json["name"],
    number: json["number"],
    location: json["location"],
    squareMeters: json["square_meters"],
    description: json["description"],
    propertyTypeId: json["property_type_id"],
    propertyCategoryId: json["property_category_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "number": number,
    "location": location,
    "square_meters": squareMeters,
    "description": description,
    "property_type_id": propertyTypeId,
    "property_category_id": propertyCategoryId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Tenantunit {
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
  List<Schedule>? schedules;
  Unit? unit;
  Tenant? tenant;
  int? convertedAmount;
  // int? usdAmount;
  // int? ugxAmount;
  // int? convertedDiscountAmount;
  // int? usdDiscountAmount;
  // int? ugxDiscountAmount;
  int? foreignAmount;
  int? baseAmount;
  int? convertedDiscountAmount;
  int? foreignDiscountAmount;
  int? baseDiscountAmount;

  Tenantunit({
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
    this.schedules,
    this.unit,
    this.tenant,
    this.convertedAmount,
    // this.usdAmount,
    // this.ugxAmount,
    // this.convertedDiscountAmount,
    // this.usdDiscountAmount,
    // this.ugxDiscountAmount,
    this.foreignAmount,
    this.baseAmount,
    this.convertedDiscountAmount,
    this.foreignDiscountAmount,
    this.baseDiscountAmount,

  });

  factory Tenantunit.fromJson(Map<String, dynamic> json) => Tenantunit(
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
    schedules: json["schedules"] == null ? [] : List<Schedule>.from(json["schedules"]!.map((x) => Schedule.fromJson(x))),
    unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
    tenant: json["tenant"] == null ? null : Tenant.fromJson(json["tenant"]),
    convertedAmount: json["converted_amount"],
    // usdAmount: json["usd_amount"],
    // ugxAmount: json["ugx_amount"],
    // convertedDiscountAmount: json["converted_discount_amount"],
    // usdDiscountAmount: json["usd_discount_amount"],
    // ugxDiscountAmount: json["ugx_discount_amount"],
    foreignAmount: json["foreign_amount"],
    baseAmount: json["base_amount"],
    convertedDiscountAmount: json["converted_discount_amount"],
    foreignDiscountAmount: json["foreign_discount_amount"],
    baseDiscountAmount: json["base_discount_amount"],
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
    "schedules": schedules == null ? [] : List<dynamic>.from(schedules!.map((x) => x.toJson())),
    "unit": unit?.toJson(),
    "tenant": tenant?.toJson(),
    "converted_amount": convertedAmount,
    // "usd_amount": usdAmount,
    // "ugx_amount": ugxAmount,
    // "converted_discount_amount": convertedDiscountAmount,
    // "usd_discount_amount": usdDiscountAmount,
    // "ugx_discount_amount": ugxDiscountAmount,
    "foreign_amount": foreignAmount,
    "base_amount": baseAmount,
    "converted_discount_amount": convertedDiscountAmount,
    "foreign_discount_amount": foreignDiscountAmount,
    "base_discount_amount": baseDiscountAmount,
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

class Tenant {
  int? id;
  String? number;
  int? clientTypeId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ClientProfile>? clientProfiles;

  Tenant({
    this.id,
    this.number,
    this.clientTypeId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.clientProfiles,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
    id: json["id"],
    number: json["number"],
    clientTypeId: json["client_type_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    clientProfiles: json["client_profiles"] == null ? [] : List<ClientProfile>.from(json["client_profiles"]!.map((x) => ClientProfile.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "number": number,
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
  String? address;
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
    address: json["address"],
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
    "address": address,
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


class Unit {
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
  int? foreignAmount;
  int? baseAmount;

  Unit({
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
    this.foreignAmount,
    this.baseAmount,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
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
    foreignAmount: json["foreign_amount"],
    baseAmount: json["base_amount"],
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
    "foreign_amount": foreignAmount,
    "base_amount": baseAmount,
  };
}

class Search {
  String? propertyId;
  String? from;
  String? to;
  String? unitId;
  String? tenantId;
  String? tenantSelected;
  String? periodDate;
  String? rentalPeriodDate;
  DateTime? thismonth;
  DateTime? lastmonth;
  List<DateTime>? dates;

  Search({
    this.propertyId,
    this.from,
    this.to,
    this.unitId,
    this.tenantId,
    this.tenantSelected,
    this.periodDate,
    this.rentalPeriodDate,
    this.thismonth,
    this.lastmonth,
    this.dates,
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    propertyId: json["property_id"],
    from: json["from"],
    to: json["to"],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    tenantSelected: json["tenant_selected"],
    periodDate: json["period_date"],
    rentalPeriodDate: json["rental_period_date"],
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
    "rental_period_date": rentalPeriodDate,
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
