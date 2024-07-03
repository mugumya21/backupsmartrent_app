import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_rent/configs/app_configs.dart';
import 'package:smart_rent/data_layer/models/payment/payment_account_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_document_list_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_list_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_mode_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_schedules_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_tenant_unit_schedule_model.dart';
import 'package:smart_rent/data_layer/models/payment/payments_model.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/account_repo.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/payment_repo.dart';
import 'package:smart_rent/utilities/app_init.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class AccountRepoImpl implements AccountRepo {

  @override
  Future<dynamic> changePassword(
   String token,
   int userId,
   String oldPassword,
   String password,
   String passwordConfirmation,
) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/admin/changepassword');

      var response = await client.post(
        url,
        headers: headers,
        body: jsonEncode({
          "user_id": userId,
          "old_password": oldPassword,
          "password": password,
          "password_confirmation": passwordConfirmation,
        }),
      );

      if (kDebugMode) {
        print("Change Password RESPONSE: $response");
      }
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('Change Password response body $responseBody');
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }




}
