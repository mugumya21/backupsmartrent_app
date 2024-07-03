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
import 'package:smart_rent/data_layer/repositories/interfaces/payment_repo.dart';
import 'package:smart_rent/utilities/app_init.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class PaymentRepoImpl implements PaymentRepo {
  @override
  Future<List<PaymentAccountsModel>> getAllPaymentAccounts(
      String token, int propertyId) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url =
          Uri.parse('$appUrl/api/rent/payments/create/prefill/$propertyId');

      var response = await client.get(url, headers: headers);
      List accountData = jsonDecode(response.body)['accounts'];
      if (kDebugMode) {
        print("payment accounts RESPONSE: ${response.body}");
        print("payment accounts data: ${accountData}");
      }
      return accountData
          .map((nation) => PaymentAccountsModel.fromJson(nation))
          .toList();
    } finally {
      client.close();
    }
  }

  // @override
  // Future<List<PaymentsModel>> getAllPayments(
  //     String token, int propertyId) async {
  //   var client = RetryClient(http.Client());
  //   try {
  //     var headers = {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       HttpHeaders.acceptHeader: 'application/json',
  //       HttpHeaders.authorizationHeader: 'Bearer $token'
  //     };
  //
  //     var url = Uri.parse('$appUrl/api/rent/paymentslist/$propertyId');
  //
  //     var response = await client.get(url, headers: headers);
  //     List paymentsData = jsonDecode(response.body);
  //     if (kDebugMode) {
  //       print("payments RESPONSE: ${response.body}");
  //       print("payments data: ${paymentsData}");
  //     }
  //     return paymentsData
  //         .map((payment) => PaymentsModel.fromJson(payment))
  //         .toList();
  //   } finally {
  //     client.close();
  //   }
  // }


  @override
  Future<List<PaymentListModel>> getAllPayments(
      String token, int propertyId) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/rent/paymentslist/$propertyId');

      var response = await client.get(url, headers: headers);
      List paymentsData = jsonDecode(response.body);
      if (kDebugMode) {
        print("payments RESPONSE: ${response.body}");
        print("payments data: ${paymentsData}");
      }
      return paymentsData
          .map((payment) => PaymentListModel.fromJson(payment))
          .toList();
    } finally {
      client.close();
    }
  }


  // @override
  // Future<List<PaymentsModel>> getPayments(String token) async {
  //   var client = RetryClient(http.Client());
  //   try {
  //     var headers = {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       HttpHeaders.acceptHeader: 'application/json',
  //       HttpHeaders.authorizationHeader: 'Bearer $token'
  //     };
  //
  //     var url = Uri.parse('$appUrl/api/rent/payments');
  //
  //     var response = await client.get(url, headers: headers);
  //     List paymentsData = jsonDecode(response.body);
  //     if (kDebugMode) {
  //       print("payments RESPONSE: ${response.body}");
  //       print("payments data: ${paymentsData}");
  //     }
  //     return paymentsData
  //         .map((payment) => PaymentsModel.fromJson(payment))
  //         .toList();
  //   } finally {
  //     client.close();
  //   }
  // }


  @override
  Future<List<PaymentListModel>> getPayments(String token) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/rent/payments');

      var response = await client.get(url, headers: headers);
      List paymentsData = jsonDecode(response.body);
      if (kDebugMode) {
        print("payments RESPONSE: ${response.body}");
        print("payments data: ${paymentsData}");
      }
      return paymentsData
          .map((payment) => PaymentListModel.fromJson(payment))
          .toList();
    } finally {
      client.close();
    }
  }

  @override
  Future<List<PaymentModeModel>> getAllPaymentModes(
      String token, int propertyId) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url =
          Uri.parse('$appUrl/api/rent/payments/create/prefill/$propertyId');

      var response = await client.get(url, headers: headers);
      List modeData = jsonDecode(response.body)['paymentmodes'];
      if (kDebugMode) {
        print("payment modes RESPONSE: ${response.body}");
        print("payment modes data: ${modeData}");
      }
      return modeData
          .map((payment) => PaymentModeModel.fromJson(payment))
          .toList();
    } finally {
      client.close();
    }
  }

  // @override
  // Future<List<PaymentSchedulesModel>> getAllPaymentSchedules(
  //     String token, int tenantUnitId,
  //     ) async {
  //   var client = RetryClient(http.Client());
  //   try {
  //     var headers = {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       HttpHeaders.acceptHeader: 'application/json',
  //       HttpHeaders.authorizationHeader: 'Bearer $token'
  //     };
  //
  //     // var url = Uri.parse('$appUrl/api/rent/payments/create/prefill/$propertyId');
  //     var url = Uri.parse('$appUrl/api/rent/gettenantunitschedules/$tenantUnitId');
  //     // var url =  Uri.parse('$appUrl/api/rent/tenantunitsonproperty/$tenantUnitId');
  //     // var url =  Uri.parse('$appUrl/api/rent/tenantunits/$tenantUnitId');
  //
  //
  //     var response = await client.get(url, headers: headers);
  //     List schedulesData = jsonDecode(response.body);
  //     if (kDebugMode) {
  //       print("payment schedules RESPONSE: $response");
  //       print("payment schedules Data: ${response.body}");
  //       print("payment schedules List: $schedulesData");
  //     }
  //     return schedulesData
  //         .map((payment) => PaymentSchedulesModel.fromJson(payment))
  //         .toList();
  //   } finally {
  //     client.close();
  //   }
  // }

  @override
  Future<List<PaymentTenantUnitScheduleModel>> getAllPaymentSchedules(
    String token,
    int tenantUnitId,
  ) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      // var url = Uri.parse('$appUrl/api/rent/payments/create/prefill/$propertyId');
      var url =
          Uri.parse('$appUrl/api/rent/gettenantunitschedules/$tenantUnitId');
      // var url =  Uri.parse('$appUrl/api/rent/tenantunitsonproperty/$tenantUnitId');
      // var url =  Uri.parse('$appUrl/api/rent/tenantunits/$tenantUnitId');

      var response = await client.get(url, headers: headers);
      List schedulesData = jsonDecode(response.body);
      if (kDebugMode) {
        print("payment schedules RESPONSE: $response");
        print("payment schedules Data: ${response.body}");
        print("payment schedules List: $schedulesData");
      }
      return schedulesData
          .map((payment) => PaymentTenantUnitScheduleModel.fromJson(payment))
          .toList();
    } finally {
      client.close();
    }
  }

  @override
  Future<dynamic> addPayment(
      String token,
      String paid,
      String amountDue,
      String date,
      int tenantUnitId,
      int accountId,
      int paymentModeId,
      int propertyId,
      List<String> paymentScheduleId) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/rent/payments');

      var response = await client.post(
        url,
        headers: headers,
        body: jsonEncode({
          "paid": paid,
          "amount_due": amountDue,
          "date": date,
          "tenant_unit_id": tenantUnitId,
          "account_id": accountId,
          "payment_mode_id": paymentModeId,
          "property_id": propertyId,
          "payment_schedule_id": paymentScheduleId
        }),
      );

      if (kDebugMode) {
        print("Add Payments RESPONSE: $response");
      }
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('Add Payments response body $responseBody');
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }



  @override
  Future<dynamic> uploadPaymentFile(String token, File imageFile, int docId, int fileTypeId) async {
    String? uniquePhotoId = const Uuid().v4();
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));


    print('my Path = ${imageFile.path}');
    print('my Path extension = ${imageFile.path.split('/').toString()}');
    print('my file = ${imageFile}');

    try {

      Uri url = Uri.https(appUrl.replaceRange(0, 8, ''),
          'api/main/upload');

      final extension = p.extension(imageFile.path);
      String filename = p.basename(imageFile.path);
      FormData formData = FormData.fromMap({
        "docid": docId,
        "filetype": fileTypeId,
        "file": await MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last.toString())
      });

      dio.options.headers["authorization"] = "Bearer ${currentUserToken}";
      var response = await dio.post(url.toString(), data: formData);
      // print(response.body);
      // var data = json.decode(response.body);
      // print(response);
      // print(data);


      if (kDebugMode) {
        print("Upload Payments RESPONSE: $response");
        print("Upload Payments RESPONSE body: ${response.data}");
      }
      var responseBody = jsonDecode(utf8.decode(response.data));
      print('Upload Payments response body $responseBody');
      return jsonDecode(utf8.decode(response.data)) as Map;
    } catch (e) {
      print(e);
    } finally {

    }


  }


  @override
  Future<List<PaymentsDocumentsListModel>> getAllPaymentDocuments(
      String token, int paymentId, int fileTypeId
      ) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      // var url = Uri.parse('$appUrl/api/rent/payments/create/prefill/$propertyId');
      var url =
      Uri.parse('$appUrl/api/main/documents/$paymentId/filetype/$fileTypeId');
      // var url =  Uri.parse('$appUrl/api/rent/tenantunitsonproperty/$tenantUnitId');
      // var url =  Uri.parse('$appUrl/api/rent/tenantunits/$tenantUnitId');

      var response = await client.get(url, headers: headers);
      List documentData = jsonDecode(response.body);
      if (kDebugMode) {
        print("payment documents RESPONSE: $response");
        print("payment documents Data: ${response.body}");
        print("payment documents List: $documentData");
      }
      return documentData
          .map((payment) => PaymentsDocumentsListModel.fromJson(payment))
          .toList();
    } finally {
      client.close();
    }
  }


  @override
  Future<dynamic> updatePayment(
      String token,
      String paid,
      String amountDue,
      String date,
      int tenantUnitId,
      int accountId,
      int paymentModeId,
      int propertyId,
      // List<String> paymentScheduleId,
      ) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/rent/payments');

      var response = await client.post(
        url,
        headers: headers,
        body: jsonEncode({
          "paid": paid,
          "amount_due": amountDue,
          "date": date,
          "tenant_unit_id": tenantUnitId,
          "account_id": accountId,
          "payment_mode_id": paymentModeId,
          "property_id": propertyId,
          // "payment_schedule_id": paymentScheduleId
        }),
      );

      if (kDebugMode) {
        print("Add Payments RESPONSE: $response");
      }
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('Add Payments response body $responseBody');
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }


  @override
  Future<dynamic> deletePayment(
      String token,
      int paymentId
      ) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/rent/paymentdelete/$paymentId');

      var response = await client.delete(
        url,
        headers: headers,);

      if (kDebugMode) {
        print("Delete Payment RESPONSE: $response");
      }
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('Delete Payment response body $responseBody');
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }


// @override
//    Future<dynamic> uploadPaymentFile(String token, dynamic imageFile, int docId, int fileTypeId) async {
//
//
//   try {
//
//     var fullUrl = '$appUrl/api/main/upload';
//
//     final request = http.MultipartRequest('POST', Uri.parse(fullUrl));
//
//     request.fields['filetype'] = fileTypeId.toString();
//     request.fields['docid'] = docId.toString();
//
//     request.files.add(imageFile);
//
//     request.headers.addAll({
//       'Accept' : 'application/json',
//       'Content-type': 'application/json;charset=UTF-8',
//       'Charset': 'utf-8',
//       // 'Content-type': 'multipart/form-data',
//
//     });
//     var response = await http.Response.fromStream(await request.send());
//     // print(response.body);
//     // var data = json.decode(response.body);
//     // print(response);
//     // print(data);
//
//
//     if (kDebugMode) {
//       print("Upload Payments RESPONSE: $response");
//     }
//     var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
//     print('Upload Payments response body $responseBody');
//     return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   } catch (e) {
//     print(e);
//   } finally {
//
//   }
//
//
//   }




  // static Future<File> compressImage(String photoId, File image) async {
  //   final tempDirection = await getTemporaryDirectory();
  //   final path = tempDirection.path;
  //
  //   XFile? compressedImageXFile = await FlutterImageCompress.compressAndGetFile(
  //     image.absolute.path,
  //     '$path/img_$photoId.jpg',
  //     quality: 55,
  //   );
  //
  //   File compressedImage = File(compressedImageXFile!.path);
  //   return compressedImage;
  // }


}
