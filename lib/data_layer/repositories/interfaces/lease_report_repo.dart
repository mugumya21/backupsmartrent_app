abstract class LeaseReportRepo {
  Future<dynamic> getLeaseReport(String token, int? propertyId, int? unitId, int? tenantId);
}
