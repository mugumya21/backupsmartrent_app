part of 'payment_bloc.dart';

enum PaymentStatus {
  initial,
  loading,
  success,
  empty,
  error,
  accessDenied,
  initialUpload,
  loadingUpload,
  successUpload,
  emptyUpload,
  errorUpload,
  accessDeniedUpload,
  loadingDelete,
  successDelete,
  emptyDelete,
  errorDelete,
  accessDeniedDelete,
}

extension PaymentStatusX on PaymentStatus {
  bool get isInitial => this == PaymentStatus.initial;

  bool get isSuccess => this == PaymentStatus.success;

  bool get isError => this == PaymentStatus.error;

  bool get isLoading => this == PaymentStatus.loading;

  bool get isEmpty => this == PaymentStatus.empty;
}

class PaymentState extends Equatable {
  final List<PaymentListModel>? payments;
  // final List<PaymentsModel>? payments;
  final PaymentStatus status;
  final PaymentsModel? paymentsModel;
  final AddPaymentResponseModel? addPaymentResponseModel;
  final bool? isPaymentLoading;
  final String? message;
  final File? file;
  final UploadPaymentFileResponseModel? uploadPaymentFileResponseModel;
  final List<PaymentsDocumentsListModel>? paymentsDocumentsList;
  final DeletePaymentResponseModel? deletePaymentResponseModel;

  const PaymentState(
      {this.payments,
      this.status = PaymentStatus.initial,
      this.paymentsModel,
      this.addPaymentResponseModel,
      this.isPaymentLoading = false,
      this.message = '',
      this.file,
      this.uploadPaymentFileResponseModel,
      this.paymentsDocumentsList,
      this.deletePaymentResponseModel,
      });

  @override
  // TODO: implement props
  List<Object?> get props => [
        payments,
        status,
        paymentsModel,
        addPaymentResponseModel,
        isPaymentLoading,
        message,
    file,
    uploadPaymentFileResponseModel,
    paymentsDocumentsList,
    deletePaymentResponseModel,
      ];

  PaymentState copyWith({
    List<PaymentListModel>? payments,
    // List<PaymentsModel>? payments,
    PaymentStatus? status,
    PaymentsModel? paymentsModel,
    AddPaymentResponseModel? addPaymentResponseModel,
    bool? isPaymentLoading,
    String? message,
    dynamic file,
    UploadPaymentFileResponseModel? uploadPaymentFileResponseModel,
    List<PaymentsDocumentsListModel>? paymentsDocumentsList,
    DeletePaymentResponseModel? deletePaymentResponseModel,
  }) {
    return PaymentState(
        payments: payments ?? this.payments,
        status: status ?? this.status,
        paymentsModel: paymentsModel ?? this.paymentsModel,
        addPaymentResponseModel:
            addPaymentResponseModel ?? this.addPaymentResponseModel,
        isPaymentLoading: isPaymentLoading ?? this.isPaymentLoading,
        message: message ?? this.message,
        file: file ?? this.file,
      uploadPaymentFileResponseModel: uploadPaymentFileResponseModel ?? this.uploadPaymentFileResponseModel,
      paymentsDocumentsList: paymentsDocumentsList ?? this.paymentsDocumentsList,
      deletePaymentResponseModel: deletePaymentResponseModel ?? this.deletePaymentResponseModel,
    );
  }
}

class PaymentInitial extends PaymentState {
  @override
  List<Object> get props => [];
}
