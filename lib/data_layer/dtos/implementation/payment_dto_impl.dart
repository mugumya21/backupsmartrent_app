

import 'dart:io';

import 'package:smart_rent/data_layer/models/payment/add_payment_response_model.dart';
import 'package:smart_rent/data_layer/models/payment/delete_payment_respnse_model.dart';
import 'package:smart_rent/data_layer/models/payment/upload_file_response_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/payment_repo_impl.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/payment_repo.dart';

class PaymentDtoImpl {
  static Future<AddPaymentResponseModel> addPayment(
      String token, String paid, String amountDue,
      String date, int tenantUnitId, int accountId, int paymentModeId,
      int propertyId, List<String> paymentScheduleId, {
    Function()? onSuccess,
    Function()? onError,
  }) async {
    PaymentRepo paymentRepo = PaymentRepoImpl();
    var result = await paymentRepo
        .addPayment( token, paid, amountDue, date, tenantUnitId, accountId, paymentModeId,
         propertyId,  paymentScheduleId)
        .then((response) => AddPaymentResponseModel.fromJson(response));

    return result;
  }


  static Future<UploadPaymentFileResponseModel> uploadPaymentFile(
      String token, dynamic imageFile, int docId, int fileTypeId, {
        Function()? onSuccess,
        Function()? onError,
      }) async {
    PaymentRepo paymentRepo = PaymentRepoImpl();
    var result = await paymentRepo.uploadPaymentFile( token, imageFile, docId, fileTypeId)
        .then((response) => UploadPaymentFileResponseModel.fromJson(response));

    return result;
  }


  static Future<AddPaymentResponseModel> updatePayment(
      String token, String paid, String amountDue,
      String date, int tenantUnitId, int accountId, int paymentModeId,
      int propertyId,  {
        Function()? onSuccess,
        Function()? onError,
      }) async {
    PaymentRepo paymentRepo = PaymentRepoImpl();
    var result = await paymentRepo
        .updatePayment( token, paid, amountDue, date, tenantUnitId, accountId, paymentModeId,
        propertyId)
        .then((response) => AddPaymentResponseModel.fromJson(response));

    return result;
  }


  static Future<DeletePaymentResponseModel> deletePayment(
      String token,
      int tenantUnitId,{
        Function()? onSuccess,
        Function()? onError,
      }) async {
    print("In here");
    var result;
    PaymentRepo paymentRepo = PaymentRepoImpl();
    await paymentRepo
        .deletePayment(
      token,
      tenantUnitId,
    )
        .then((response) => result = DeletePaymentResponseModel.fromJson(response));
    print("Then here");

    return result;
  }


}
