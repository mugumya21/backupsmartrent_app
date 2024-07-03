part of 'un_paid_report_bloc.dart';

enum UnpaidReportStatus { initial, loading, success, empty, error, accessDenied,
  initialPeriods, loadingPeriods, successPeriods, emptyPeriods, errorPeriods, accessDeniedPeriods,
  initialReportProperties, loadingReportProperties, successReportProperties, emptyReportProperties,
  errorReportProperties, accessDeniedReportProperties
}


class UnPaidReportState extends Equatable {
  final List<UnpaidReportScheduleModel>? paymentSchedules;
  final List<dynamic>? periods;
  final UnpaidReportStatus status;
  final List<UnpaidProperty>? properties;

  const UnPaidReportState({
    this.paymentSchedules,
    this.status = UnpaidReportStatus.initial,
    this.periods,
    this.properties,
});

  @override
  // TODO: implement props
  List<Object?> get props => [paymentSchedules, status, periods, properties];

  UnPaidReportState copyWith({
    List<UnpaidReportScheduleModel>? paymentSchedules,
    UnpaidReportStatus? status,
    List<dynamic>? periods,
    List<UnpaidProperty>? properties,
    // List<Property>? reportProperties,
}) {
    return UnPaidReportState(
      paymentSchedules: paymentSchedules ?? this.paymentSchedules,
      status: status ?? this.status,
      periods: periods ?? this.periods,
      properties: properties ?? this.properties,

      // reportProperties: reportProperties ?? this.reportProperties,
    );
  }

}


class UnPaidReportInitial extends UnPaidReportState {
  @override
  List<Object> get props => [];
}
