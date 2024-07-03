import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_rent/data_layer/models/reports/collections/collections_report_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/collections_report_repo_impl.dart';
import 'package:smart_rent/utilities/app_init.dart';

part 'collections_report_event.dart';
part 'collections_report_state.dart';



class CollectionsReportBloc extends Bloc<CollectionsReportEvent, CollectionsReportState> {
  CollectionsReportBloc() : super(CollectionsReportState()) {
    on<LoadCollectionsReportEvent>(_mapFetchCollectionsReportToState);
    on<LoadCollectionsPeriods>(_mapFetchUnpaidPeriodsToState);
  }


  _mapFetchCollectionsReportToState(
      LoadCollectionsReportEvent event, Emitter<CollectionsReportState> emit) async {
    emit(state.copyWith(status: CollectionsReportStatus.loading));
    await CollectionsReportRepoImpl().getCollectionsReport(currentUserToken.toString(), event.propertyId,
        event.periodDate, event.currencyId)
        .then((schedules) {
      if (schedules.isNotEmpty) {
        emit(state.copyWith(
            status: CollectionsReportStatus.success, paymentSchedules: schedules));
      } else {
        emit(state.copyWith(status: CollectionsReportStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: CollectionsReportStatus.error));
      if (kDebugMode) {
        log("Error: $error");
        log("Stacktrace: $stackTrace");
      }
    });
  }


  _mapFetchUnpaidPeriodsToState(
      LoadCollectionsPeriods event, Emitter<CollectionsReportState> emit) async {
    emit(state.copyWith(status: CollectionsReportStatus.loadingPeriods));
    await CollectionsReportRepoImpl().getCollectionsDates(currentUserToken.toString())
        .then((periods) {
      if (periods.isNotEmpty) {
        emit(state.copyWith(
            status: CollectionsReportStatus.successPeriods, periods: periods));
      } else {
        emit(state.copyWith(status: CollectionsReportStatus.emptyPeriods));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: CollectionsReportStatus.errorPeriods));
      if (kDebugMode) {
        log("Error: $error");
        log("Stacktrace: $stackTrace");
      }
    });
  }


  @override
  void onEvent(CollectionsReportEvent event) {
    log(event.toString());
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<CollectionsReportEvent, CollectionsReportState> transition) {
    log(transition.toString());
    super.onTransition(transition);
  }

  @override
  void onChange(Change<CollectionsReportState> change) {
    log(change.toString());
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    log(error.toString());
    log(stackTrace.toString());
    super.onError(error, stackTrace);
  }

}


