abstract class PaymentsReportRepo {
  Future<dynamic> getPaymentsReportSchedules(String token, int? propertyId, String? periodDate, int? currencyId);
  Future<dynamic> getPaymentsDates(String token,);
}
