abstract class CollectionsReportRepo {
  Future<dynamic> getCollectionsReport(String token, int? propertyId, String? periodDate, int? currencyId);
  Future<dynamic> getCollectionsDates(String token,);
}
