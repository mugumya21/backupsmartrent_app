part of 'un_paid_report_bloc.dart';


class UnPaidReportEvent extends Equatable {
  const UnPaidReportEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadUnpaidReportSchedules extends UnPaidReportEvent {
  final int? propertyId;
  final String? periodDate;
  final DateTime? unpaidDate;
  final int? currencyId;

  const LoadUnpaidReportSchedules(this.propertyId, this.periodDate, this.unpaidDate, this.currencyId);
}

class LoadUnpaidPeriods extends UnPaidReportEvent {}

class LoadUnpaidProperties extends UnPaidReportEvent {}
