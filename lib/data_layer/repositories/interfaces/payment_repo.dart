import 'dart:io';

abstract class PaymentRepo {
  Future<dynamic> getAllPaymentAccounts(String token, int propertyId);
  Future<dynamic> getAllPayments(String token, int propertyId);
  Future<dynamic> getPayments(String token);
  Future<dynamic> getAllPaymentModes(String token, int propertyId);
  Future<dynamic> getAllPaymentSchedules(String token, int tenantUnitId);
  Future<dynamic> addPayment(String token, String paid, String amountDue,
      String date, int tenantUnitId, int accountId, int paymentModeId,
      int propertyId, List<String> paymentScheduleId);
  Future<dynamic> uploadPaymentFile(String token, File imageFile, int docId, int fileTypeId);
  Future<dynamic> getAllPaymentDocuments(String token, int paymentId, int fileTypeId);
  Future<dynamic> updatePayment(String token, String paid, String amountDue,
      String date, int tenantUnitId, int accountId, int paymentModeId,
      int propertyId,);
  Future<dynamic> deletePayment(String token, int paymentId);

}
