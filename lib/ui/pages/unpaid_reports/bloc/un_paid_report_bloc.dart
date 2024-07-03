import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_rent/data_layer/models/payment/payment_reports_schedule_model.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/data_layer/models/reports/unpaid/unpaid_reports_model.dart';
// import 'package:smart_rent/data_layer/models/payment/payment_reports_schedule_model.dart' as unpaid;
import 'package:smart_rent/data_layer/repositories/implementation/unpaid_report_repo_impl.dart';
import 'package:smart_rent/utilities/app_init.dart';


part 'un_paid_report_event.dart';
part 'un_paid_report_state.dart';

class UnPaidReportBloc extends Bloc<UnPaidReportEvent, UnPaidReportState> {
  UnPaidReportBloc() : super(UnPaidReportState()) {
    on<LoadUnpaidReportSchedules>(_mapFetchUnpaidReportSchedulesToState);
    on<LoadUnpaidPeriods>(_mapFetchUnpaidPeriodsToState);
    on<LoadUnpaidProperties>(_mapFetchUnpaidPropertiesToState);
  }


  _mapFetchUnpaidReportSchedulesToState(
      LoadUnpaidReportSchedules event, Emitter<UnPaidReportState> emit) async {
    emit(state.copyWith(status: UnpaidReportStatus.loading));
    await UnpaidReportRepoImpl().getUnpaidReportSchedules(currentUserToken.toString(), event.propertyId, event.periodDate,
      event.unpaidDate!, event.currencyId
    )
        .then((schedules) {
      if (schedules.isNotEmpty) {
        emit(state.copyWith(
            status: UnpaidReportStatus.success, paymentSchedules: schedules));
      } else {
        emit(state.copyWith(status: UnpaidReportStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: UnpaidReportStatus.error));
      if (kDebugMode) {
        log("Error: $error");
        log("Stacktrace: $stackTrace");
      }
    });
  }

  _mapFetchUnpaidPeriodsToState(
      LoadUnpaidPeriods event, Emitter<UnPaidReportState> emit) async {
    emit(state.copyWith(status: UnpaidReportStatus.loadingPeriods));
    await UnpaidReportRepoImpl().getUnpaidDates(currentUserToken.toString())
        .then((periods) {
      if (periods.isNotEmpty) {
        emit(state.copyWith(
            status: UnpaidReportStatus.successPeriods, periods: periods));
      } else {
        emit(state.copyWith(status: UnpaidReportStatus.emptyPeriods));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: UnpaidReportStatus.errorPeriods));
      if (kDebugMode) {
        log("Error: $error");
        log("Stacktrace: $stackTrace");
      }
    });
  }


  _mapFetchUnpaidPropertiesToState(
      LoadUnpaidProperties event, Emitter<UnPaidReportState> emit) async {
    emit(state.copyWith(status: UnpaidReportStatus.loadingReportProperties));
    await UnpaidReportRepoImpl()
        .getALlReportProperties(currentUserToken.toString())
        .then((properties) {
      if (properties.isNotEmpty) {
        emit(state.copyWith(
            status: UnpaidReportStatus.success, properties: properties));
      } else {
        emit(state.copyWith(status: UnpaidReportStatus.emptyReportProperties));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: UnpaidReportStatus.errorReportProperties));
      if (kDebugMode) {
        log("Error: $error");
        log("Stacktrace: $stackTrace");
      }
    });
  }



  @override
  void onEvent(UnPaidReportEvent event) {
    log(event.toString());
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<UnPaidReportEvent, UnPaidReportState> transition) {
    log(transition.toString());
    super.onTransition(transition);
  }

  @override
  void onChange(Change<UnPaidReportState> change) {
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
