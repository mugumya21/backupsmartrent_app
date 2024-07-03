import 'dart:convert';
import 'dart:io';

import 'package:smart_rent/configs/app_configs.dart';
import 'package:smart_rent/data_layer/models/currency/currency_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_reports_schedule_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_schedules_model.dart';
import 'package:smart_rent/data_layer/models/reports/payments/payments_report_model.dart';
import 'package:smart_rent/data_layer/models/reports/unpaid/unpaid_reports_model.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/currency_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/payments_report_repo.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/unpaid_report_repo.dart';


class PaymentsReportRepoImpl implements PaymentsReportRepo {
  @override
  Future<List<PaymentReportModel>> getPaymentsReportSchedules(
      String token, int? propertyId, String? periodDate, int? currencyId) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      // var url = Uri.parse('$appUrl/api/reports/paymentsreport');
      // var url = Uri.parse('$appUrl/api/reports/paymentsreport?form-submit=&property_id=$propertyId&period_date=$periodDate');
      var url = Uri.parse('$appUrl/api/reports/paymentsreport?from=&to=&period_date=$periodDate&property_id=$propertyId&unit_id=&rental_period_date=&tenant_id=&currency_id=$currencyId&form-submit=');

      var response = await client.get(url, headers: headers);
      List paymentsData = jsonDecode(response.body)['payments'];
      if (kDebugMode) {
        print("payments Report RESPONSE: $response");
        print("payments Report RESPONSE: ${response.body}");
      }

      List<PaymentReportModel> paymentsList =  paymentsData
          .map((nation) => PaymentReportModel.fromJson(nation))
          .toList();

      paymentsList.sort((a, b) => b.amount!.compareTo(a.amount!));

      return paymentsList;
      // return unpaidData
      //     .map((nation) => PaymentReportModel.fromJson(nation))
      //     .toList();
      return [];
    } finally {
      client.close();
    }
  }


  @override
  Future<List<dynamic>> getPaymentsDates(String token) async {
    var client = RetryClient(http.Client());


    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/reports/paymentsreport');

      var response = await client.get(url, headers: headers);
      List<dynamic> collectionsDatesData = jsonDecode(response.body)['search']['dates'];
      // print('my response $response');
      print('my url $url');
      if (kDebugMode) {
        print("payments report dates RESPONSE: $response");
        print("payments report dates RESPONSE: ${response.body}");
      }

      // Convert the dynamic list of date strings to DateTime objects
      List<DateTime> dates = collectionsDatesData
          .map((dateString) => DateTime.parse(dateString))
          .toList();

      // Add today's date
      DateTime today = DateTime.now();
      dates.insert(0, today);

      // DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
      // dates.insert(1, yesterday);
      //
      // DateTime thisWeek = DateTime.now().subtract(Duration(days: 7));
      // dates.insert(2, thisWeek);

      // Add the date a month ago
      DateTime aMonthAgo = DateTime.now().subtract(Duration(days: 30));
      dates.insert(1, aMonthAgo);

      // return collectionsDatesData;
      return dates;
    } finally {
      client.close();
    }

  }

}
