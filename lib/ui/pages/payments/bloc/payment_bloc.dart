import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_rent/data_layer/dtos/implementation/payment_dto_impl.dart';
import 'package:smart_rent/data_layer/models/payment/add_payment_response_model.dart';
import 'package:smart_rent/data_layer/models/payment/delete_payment_respnse_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_document_list_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_list_model.dart';
import 'package:smart_rent/data_layer/models/payment/payments_model.dart';
import 'package:smart_rent/data_layer/models/payment/upload_file_response_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/payment_repo_impl.dart';
import 'package:smart_rent/utilities/app_init.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentState()) {
    on<RefreshPaymentsEvent>(_mapRefreshPaymentsEventToState);
    on<LoadAllPayments>(_mapFetchAllPaymentsToState);
    on<LoadPayments>(_mapFetchPaymentsToState);
    on<UploadPaymentFileEvent>(_mapUploadPaymentFileEventToState);
    on<LoadAllPaymentDocuments>(_mapFetchAllPaymentDocumentsToState);
    on<DeletePaymentEvent>(_mapDeletePaymentEventToState);
  }

  _mapFetchAllPaymentsToState(
      LoadAllPayments event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    await PaymentRepoImpl()
        .getAllPayments(currentUserToken.toString(), event.propertyId)
        .then((floors) {
      if (floors.isNotEmpty) {
        emit(state.copyWith(status: PaymentStatus.success, payments: floors));
      } else {
        emit(state.copyWith(status: PaymentStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: PaymentStatus.error));
      if (kDebugMode) {
        print("Error: $error");
        print("Stacktrace: $stackTrace");
      }
    });
  }

  _mapFetchPaymentsToState(
      LoadPayments event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    await PaymentRepoImpl()
        .getPayments(currentUserToken.toString())
        .then((payments) {
      if (payments.isNotEmpty) {
        emit(state.copyWith(status: PaymentStatus.success, payments: payments));
      } else {
        emit(state.copyWith(status: PaymentStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: PaymentStatus.error));
      if (kDebugMode) {
        print("Error: $error");
        print("Stacktrace: $stackTrace");
      }
    });
  }

  _mapRefreshPaymentsEventToState(
      RefreshPaymentsEvent event, Emitter<PaymentState> emit) async {
    await PaymentRepoImpl()
        .getAllPayments(currentUserToken.toString(), event.propertyId)
        .then((floors) {
      if (floors.isNotEmpty) {
        emit(state.copyWith(status: PaymentStatus.success, payments: floors));
      } else {
        emit(state.copyWith(status: PaymentStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: PaymentStatus.error));
      if (kDebugMode) {
        print("Error: $error");
        print("Stacktrace: $stackTrace");
      }
    });
  }


  _mapUploadPaymentFileEventToState(
      UploadPaymentFileEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(
        status: PaymentStatus.loadingUpload,));
    await PaymentDtoImpl.uploadPaymentFile(
        currentUserToken.toString(),
        event.file,
        event.docId,
        event.fileTypeId,
      )
        .then((response) {
      log('success upload1 ${response.message}');

      if (response != null) {
        log('success upload2 ${response.message}');
        emit(state.copyWith(
            status: PaymentStatus.successUpload,
            uploadPaymentFileResponseModel: response,
            message: response.message));
      } else {
        log('failed upload1 ${response.message}');
        emit(state.copyWith(
          status: PaymentStatus.accessDeniedUpload,
          isPaymentLoading: false,
        ));
      }
    }).onError((error, stackTrace) {
      log('failed upload2 ${error}');
      emit(state.copyWith(
          status: PaymentStatus.errorUpload,
          isPaymentLoading: false,
          message: error.toString()));
    });
  }

  _mapFetchAllPaymentDocumentsToState(
      LoadAllPaymentDocuments event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    await PaymentRepoImpl()
        .getAllPaymentDocuments(currentUserToken.toString(), event.docId, event.fileTypeId)
        .then((documents) {
      if (documents.isNotEmpty) {
        emit(state.copyWith(status: PaymentStatus.success, paymentsDocumentsList: documents));
      } else {
        emit(state.copyWith(status: PaymentStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: PaymentStatus.error));
      if (kDebugMode) {
        print("Error: $error");
        print("Stacktrace: $stackTrace");
      }
    });
  }


  _mapDeletePaymentEventToState(
      DeletePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(status: PaymentStatus.loadingDelete,));
    await PaymentDtoImpl.deletePayment(
        currentUserToken.toString(),
        event.id
    ).then((response) {
      print('success ${response.message}');

      if (response.message != null) {
        emit(state.copyWith(
            status: PaymentStatus.successDelete,
            deletePaymentResponseModel: response));
        print('Delete Tenant Unit success ==  ${response.message}');
      } else if (response.message != null) {
        emit(state.copyWith(
            status: PaymentStatus.errorDelete,
            deletePaymentResponseModel: response,
            message: response.message.toString()));
        print('Delete Tenant Unit failed ==  ${response.message}');
      } else {
        emit(state.copyWith(
          status: PaymentStatus.accessDeniedDelete,
        ));
      }
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      emit(state.copyWith(
          status: PaymentStatus.errorDelete,
          message: error.toString()));
    });
  }



  @override
  void onEvent(PaymentEvent event) {
    print(event);
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<PaymentEvent, PaymentState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  void onChange(Change<PaymentState> change) {
    print(change);
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print(error);
    print(stackTrace);
    super.onError(error, stackTrace);
  }
}
