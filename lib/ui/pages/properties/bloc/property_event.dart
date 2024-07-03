part of 'property_bloc.dart';

@immutable
class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => [];
}

class LoadPropertiesEvent extends PropertyEvent {}

class LoadReportPropertiesEvent extends PropertyEvent {}

class RefreshPropertiesEvent extends PropertyEvent {}

class LoadSinglePropertyEvent extends PropertyEvent {
  final int id;

  const LoadSinglePropertyEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class PropertyAddedEvent extends PropertyEvent {}

class PropertySearchEvent extends PropertyEvent {
  final String query;
  const PropertySearchEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class PropertyUpdateEvent extends PropertyEvent {}

class LoadAllPropertyDocuments extends PropertyEvent {
  const LoadAllPropertyDocuments( this.docId, this.fileTypeId);
  final int docId;
  final int fileTypeId;

  @override
  List<Object?> get props => [ docId, fileTypeId];
}


class UploadPropertyFileEvent extends PropertyEvent {
  const UploadPropertyFileEvent(this.file, this.docId, this.fileTypeId);
  final File file;
  final int docId;
  final int fileTypeId;

  @override
  List<Object?> get props => [file, docId, fileTypeId];
}


class UploadPropertyMainImageEvent extends PropertyEvent {
  const UploadPropertyMainImageEvent(this.docId, this.externalId, this.docTypeId);
  final int docId;
  final int externalId;
  final int docTypeId;

  @override
  List<Object?> get props => [docId, externalId, docTypeId];
}