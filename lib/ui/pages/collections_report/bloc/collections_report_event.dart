part of 'collections_report_bloc.dart';

 class CollectionsReportEvent extends Equatable {
  const CollectionsReportEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class LoadCollectionsReportEvent extends CollectionsReportEvent {
  final int propertyId;
  final String periodDate;
  final int currencyId;

  const LoadCollectionsReportEvent(this.propertyId, this.periodDate, this.currencyId);
}

class LoadCollectionsPeriods extends CollectionsReportEvent {
}