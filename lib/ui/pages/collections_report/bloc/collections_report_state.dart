part of 'collections_report_bloc.dart';



enum CollectionsReportStatus { initial, loading, success, empty, error, accessDenied,
  initialPeriods, loadingPeriods, successPeriods, emptyPeriods, errorPeriods, accessDeniedPeriods
}


class CollectionsReportState extends Equatable {
  final List<CollectionsReportModel>? paymentSchedules;
  final CollectionsReportStatus status;
  final List<dynamic>? periods;
  const CollectionsReportState({
    this.paymentSchedules,
    this.status = CollectionsReportStatus.initial,
    this.periods

  });

  @override
  // TODO: implement props
  List<Object?> get props => [paymentSchedules, status, periods];

  CollectionsReportState copyWith({
    List<CollectionsReportModel>? paymentSchedules,
    CollectionsReportStatus? status,
    List<dynamic>? periods,
  }) {
    return CollectionsReportState(
        paymentSchedules: paymentSchedules ?? this.paymentSchedules,
        status: status ?? this.status,
      periods: periods ?? this.periods,
    );
  }

}


class CollectionsReportInitial extends CollectionsReportState {
  @override
  List<Object> get props => [];
}


