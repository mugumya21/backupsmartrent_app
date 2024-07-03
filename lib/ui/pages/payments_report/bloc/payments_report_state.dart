

part of 'payments_report_bloc.dart';


enum PaymentReportStatus { initial, loading, success, empty, error, accessDenied,
  initialPeriods, loadingPeriods, successPeriods, emptyPeriods, errorPeriods, accessDeniedPeriods
}

class PaymentsReportState extends Equatable {
  final List<PaymentReportModel>? paymentSchedules;
  final PaymentReportStatus status;
  final List<dynamic>? periods;
  const PaymentsReportState({
    this.paymentSchedules,
    this.status = PaymentReportStatus.initial,
    this.periods
  });

  @override
  // TODO: implement props
  List<Object?> get props => [paymentSchedules, status, periods];

  PaymentsReportState copyWith({
    List<PaymentReportModel>? paymentSchedules,
    PaymentReportStatus? status,
    List<dynamic>? periods,
  }) {
    return PaymentsReportState(
        paymentSchedules: paymentSchedules ?? this.paymentSchedules,
        status: status ?? this.status,
        periods: periods ?? this.periods
    );
  }

}


class PaymentsReportInitial extends PaymentsReportState {
  @override
  List<Object> get props => [];
}
