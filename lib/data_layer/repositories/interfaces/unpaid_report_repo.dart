abstract class UnpaidReportRepo {
  Future<dynamic> getUnpaidReportSchedules(String token, int? propertyId, String? periodDate,
      DateTime unpaidDate, int? currencyId
      );
  Future<dynamic> getUnpaidDates(String token);
  Future<dynamic> getALlReportProperties(String token);
}
