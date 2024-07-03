import 'dart:convert';
import 'dart:io';

import 'package:smart_rent/configs/app_configs.dart';
import 'package:smart_rent/data_layer/models/payment/payment_reports_schedule_model.dart';
import 'package:smart_rent/data_layer/models/reports/unpaid/unpaid_reports_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/unpaid_report_repo.dart';


class UnpaidReportRepoImpl implements UnpaidReportRepo {
  @override
  Future<List<UnpaidReportScheduleModel>> getUnpaidReportSchedules(
      String token, int? propertyId, String? periodDate, DateTime unpaidDate,
      int? currencyId
      ) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/reports/unpaidrentreport?form-submit=&property_id=$propertyId&period_date=$periodDate&currency_id=$currencyId');

      var response = await client.get(url, headers: headers);
      List unpaidData = jsonDecode(response.body)['schedules'] ?? [];
      if (kDebugMode) {
        print("unpaid Report RESPONSE: $response");
        print("unpaid Report RESPONSE: ${response.body}");
      }


      List<UnpaidReportScheduleModel> unpaidList = unpaidData
          .map((schedule) => UnpaidReportScheduleModel.fromJson(schedule))
          .toList();

      unpaidList.sort((a, b) => b.balance!.compareTo(a.balance!));

      return unpaidList;

      // return unpaidData
      //     .map((nation) => UnpaidReportScheduleModel.fromJson(nation))
      //     .toList();
      return [];
    } finally {
      client.close();
    }
  }


  // @override
  // Future<List<dynamic>> getUnpaidDates(String token) async {
  //   var client = RetryClient(http.Client());
  //   try {
  //     var headers = {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       HttpHeaders.acceptHeader: 'application/json',
  //       HttpHeaders.authorizationHeader: 'Bearer $token'
  //     };
  //
  //     var url = Uri.parse('$appUrl/api/reports/unpaidrentreport');
  //
  //     var response = await client.get(url, headers: headers);
  //     List<dynamic> unpaidData = jsonDecode(response.body)['search']['dates'];
  //
  //     if (kDebugMode) {
  //       print("unpaid dates RESPONSE: $response");
  //       print("unpaid dates RESPONSE: ${response.body}");
  //     }
  //
  //     // Convert the dynamic list of date strings to DateTime objects
  //     List<DateTime> dates = unpaidData
  //         .map((dateString) => DateTime.parse(dateString))
  //         .toList();
  //
  //     return unpaidData;
  //     // return dates;
  //   } finally {
  //     client.close();
  //   }
  // }


  @override
  Future<List<dynamic>> getUnpaidDates(String token) async {
    var client = RetryClient(http.Client());




    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/reports/unpaidrentreport');

      var response = await client.get(url, headers: headers);
      List<dynamic> collectionsDatesData = jsonDecode(response.body)['search']['dates'];
      // print('my response $response');
      print('my url $url');
      if (kDebugMode) {
        print("unpaid dates RESPONSE: $response");
        print("unpaid dates RESPONSE: ${response.body}");
      }

      // Convert the dynamic list of date strings to DateTime objects
      List<DateTime> dates = collectionsDatesData
          .map((dateString) => DateTime.parse(dateString))
          .toList();

      // Add tomorrow's date
      DateTime tomorrow = DateTime.now().add(Duration(days: 30));
      dates.insert(0, tomorrow);


      // Add today's date
      DateTime today = DateTime.now();
      dates.insert(1, today);

      // Add the date a month ago
      DateTime aMonthAgo = DateTime.now().subtract(Duration(days: 30));
      dates.insert(2, aMonthAgo);

      // return collectionsDatesData;
      return dates;
    } finally {
      client.close();
    }

  }


  @override
  Future<List<UnpaidProperty>> getALlReportProperties(String token) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/rent/properties');

      var response = await client.get(url, headers: headers);
      List propertyData = jsonDecode(response.body)['properties'] ?? [];
      if (kDebugMode) {
        print("report property RESPONSE: $response");
        print("report property Data: $propertyData");

      }

      List<UnpaidProperty> upaidProperties = propertyData
          .map((property) => UnpaidProperty.fromJson(property))
          .toList();

      UnpaidProperty unpaidProperty = UnpaidProperty(id: 0, name: 'All Properties');

      upaidProperties.insert(0, unpaidProperty);

      return upaidProperties;

      // return propertyData
      //     .map((property) => UnpaidProperty.fromJson(property))
      //     .toList();
    } finally {
      client.close();
    }
  }



// @override
  // Future<List<UnpaidReportScheduleModel>> getUnpaidDates(
  //     String token) async {
  //   var client = RetryClient(http.Client());
  //   try {
  //     var headers = {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       HttpHeaders.acceptHeader: 'application/json',
  //       HttpHeaders.authorizationHeader: 'Bearer $token'
  //     };
  //
  //     var url = Uri.parse('$appUrl/api/reports/unpaidrentreport');
  //
  //     var response = await client.get(url, headers: headers);
  //     List unpaidData = jsonDecode(response.body)['search']['dates'];
  //     if (kDebugMode) {
  //       print("unpaid dates RESPONSE: $response");
  //       print("unpaid dates RESPONSE: ${response.body}");
  //     }
  //     return unpaidData
  //         .map((nation) => UnpaidReportScheduleModel.fromJson(nation))
  //         .toList();
  //     return [];
  //   } finally {
  //     client.close();
  //   }
  // }



}
