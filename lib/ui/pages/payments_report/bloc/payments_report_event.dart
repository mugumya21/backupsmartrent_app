part of 'payments_report_bloc.dart';

class PaymentsReportEvent extends Equatable {
  const PaymentsReportEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadPaymentsReportSchedules extends PaymentsReportEvent {
  final int propertyId;
  final String periodDate;
  final int currencyId;

  const LoadPaymentsReportSchedules(this.propertyId, this.periodDate, this.currencyId);
}

class LoadPaymentsDates extends PaymentsReportEvent {

}
