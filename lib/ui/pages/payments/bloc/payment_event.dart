part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class LoadAllPayments extends PaymentEvent {
  final int propertyId;

  const LoadAllPayments(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

class LoadPayments extends PaymentEvent {
  @override
  List<Object?> get props => [];
}

class RefreshPaymentsEvent extends PaymentEvent {
  final int propertyId;

  const RefreshPaymentsEvent(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}


class UploadPaymentFileEvent extends PaymentEvent {
  const UploadPaymentFileEvent(this.file, this.docId, this.fileTypeId);
  final File file;
  final int docId;
  final int fileTypeId;

  @override
  List<Object?> get props => [file, docId, fileTypeId];
}


class LoadAllPaymentDocuments extends PaymentEvent {
  const LoadAllPaymentDocuments( this.docId, this.fileTypeId);
  final int docId;
  final int fileTypeId;

  @override
  List<Object?> get props => [ docId, fileTypeId];
}


class DeletePaymentEvent extends PaymentEvent {
  final int id;

  const DeletePaymentEvent(this.id);

  @override
  List<Object?> get props => [id];
}