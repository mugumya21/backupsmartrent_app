import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_rent/data_layer/models/payment/payment_reports_schedule_model.dart';
import 'package:smart_rent/data_layer/models/reports/payments/payments_report_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/payments_report_repo_impl.dart';
import 'package:smart_rent/utilities/app_init.dart';

part 'payments_report_event.dart';
part 'payments_report_state.dart';

class PaymentsReportBloc extends Bloc<PaymentsReportEvent, PaymentsReportState> {
  PaymentsReportBloc() : super(PaymentsReportState()) {
    on<LoadPaymentsReportSchedules>(_mapFetchPaymentsReportSchedulesToState);
    on<LoadPaymentsDates>(_mapFetchPaymentsPeriodsToState);
  }

  _mapFetchPaymentsReportSchedulesToState(
      LoadPaymentsReportSchedules event, Emitter<PaymentsReportState> emit) async {
    emit(state.copyWith(status: PaymentReportStatus.loading));
    await PaymentsReportRepoImpl().getPaymentsReportSchedules(currentUserToken.toString(), event.propertyId,
        event.periodDate, event.currencyId)
        .then((schedules) {
      if (schedules.isNotEmpty) {
        emit(state.copyWith(
            status: PaymentReportStatus.success, paymentSchedules: schedules));
      } else {
        emit(state.copyWith(status: PaymentReportStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: PaymentReportStatus.error));
      if (kDebugMode) {
        log("Error: $error");
        log("Stacktrace: $stackTrace");
      }
    });
  }


  _mapFetchPaymentsPeriodsToState(
      LoadPaymentsDates event, Emitter<PaymentsReportState> emit) async {
    emit(state.copyWith(status: PaymentReportStatus.loadingPeriods));
    await PaymentsReportRepoImpl().getPaymentsDates(currentUserToken.toString())
        .then((periods) {
      if (periods.isNotEmpty) {
        emit(state.copyWith(
            status: PaymentReportStatus.successPeriods, periods: periods));
      } else {
        emit(state.copyWith(status: PaymentReportStatus.emptyPeriods));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: PaymentReportStatus.errorPeriods));
      if (kDebugMode) {
        log("Error: $error");
        log("Stacktrace: $stackTrace");
      }
    });
  }



  @override
  void onEvent(PaymentsReportEvent event) {
    log(event.toString());
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<PaymentsReportEvent, PaymentsReportState> transition) {
    log(transition.toString());
    super.onTransition(transition);
  }

  @override
  void onChange(Change<PaymentsReportState> change) {
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
