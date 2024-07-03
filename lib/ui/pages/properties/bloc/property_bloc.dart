import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_rent/data_layer/dtos/implementation/property_dto_impl.dart';
import 'package:smart_rent/data_layer/models/property/add_response_model.dart';
import 'package:smart_rent/data_layer/models/property/property_documents_list_model.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/data_layer/models/property/update_property_response_model.dart';
import 'package:smart_rent/data_layer/models/property/upload_property_file_response_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/property_repo_impl.dart';
import 'package:smart_rent/utilities/app_init.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  PropertyBloc() : super(const PropertyState()) {
    on<RefreshPropertiesEvent>(_mapRefreshPropertiesToState);
    on<LoadPropertiesEvent>(_mapFetchPropertiesToState);
    on<LoadSinglePropertyEvent>(_mapViewSinglePropertyDetailsEventToState);
    on<LoadAllPropertyDocuments>(_mapFetchAllPropertyDocumentsToState);
    on<UploadPropertyFileEvent>(_mapUploadPropertyFileEventToState);
    on<UploadPropertyMainImageEvent>(_mapUpdatePropertyMainImageEventToState);
  }

  _mapRefreshPropertiesToState(
      RefreshPropertiesEvent event, Emitter<PropertyState> emit) async {
    await PropertyRepoImpl()
        .getALlProperties(currentUserToken.toString())
        .then((properties) {
      if (properties.isNotEmpty) {
        emit(state.copyWith(
            status: PropertyStatus.success, properties: properties));
      } else {
        emit(state.copyWith(status: PropertyStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: PropertyStatus.error));
      if (kDebugMode) {
        log("Error: $error");
        log("Stacktrace: $stackTrace");
      }
    });
  }

  _mapFetchPropertiesToState(
      LoadPropertiesEvent event, Emitter<PropertyState> emit) async {
    emit(state.copyWith(status: PropertyStatus.loading));
    await PropertyRepoImpl()
        .getALlProperties(currentUserToken.toString())
        .then((properties) {
      if (properties.isNotEmpty) {
        emit(state.copyWith(
            status: PropertyStatus.success, properties: properties));
      } else {
        emit(state.copyWith(status: PropertyStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: PropertyStatus.error));
      if (kDebugMode) {
        log("Error: $error");
        log("Stacktrace: $stackTrace");
      }
    });
  }



  _mapViewSinglePropertyDetailsEventToState(
      LoadSinglePropertyEvent event, Emitter<PropertyState> emit) async {
    emit(state.copyWith(
      status: PropertyStatus.loadingDetails,
    ));
    await PropertyRepoImpl()
        .getSingleProperty(event.id, currentUserToken.toString())
        .then((property) async {
      if (property != null) {
        emit(state.copyWith(
            status: PropertyStatus.successDetails, property: property));
      } else {
        emit(state.copyWith(
            status: PropertyStatus.emptyDetails, property: null));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          status: PropertyStatus.errorDetails, isPropertyLoading: false));
    });
  }

  _mapFetchAllPropertyDocumentsToState(
      LoadAllPropertyDocuments event, Emitter<PropertyState> emit) async {
    emit(state.copyWith(status: PropertyStatus.loading));

    await PropertyRepoImpl()
        .getAllPropertyDocuments(currentUserToken.toString(), event.docId, event.fileTypeId)
        .then((documents) {
      if (documents.isNotEmpty) {
        emit(state.copyWith(status: PropertyStatus.success, propertyDocumentsList: documents));
      } else {
        emit(state.copyWith(status: PropertyStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: PropertyStatus.error));
      if (kDebugMode) {
        print("Error: $error");
        print("Stacktrace: $stackTrace");
      }
    });
  }

  _mapUploadPropertyFileEventToState(
      UploadPropertyFileEvent event, Emitter<PropertyState> emit) async {
    emit(state.copyWith(
      status: PropertyStatus.loadingUpload,));
    await PropertyDtoImpl.uploadPropertyFile(
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
            status: PropertyStatus.successUpload,
            uploadPropertyFileResponseModel: response,
            message: response.message));
      } else {
        log('failed upload1 ${response.message}');
        emit(state.copyWith(
          status: PropertyStatus.accessDeniedUpload,
          isPaymentLoading: false,
        ));
      }
    }).onError((error, stackTrace) {
      log('failed upload2 ${error}');
      emit(state.copyWith(
          status: PropertyStatus.errorUpload,
          isPaymentLoading: false,
          message: error.toString()));
    });
  }


  _mapUpdatePropertyMainImageEventToState(
      UploadPropertyMainImageEvent event, Emitter<PropertyState> emit) async {
    emit(state.copyWith(
        status: PropertyStatus.loadingUploadPic, isPropertyLoading: true));
    await PropertyDtoImpl.updatePropertyMainImage(
      currentUserToken.toString(),
      event.docId,
      event.externalId,
      event.docTypeId
    )
        .then((response) async {
      log('success ${response}');

      if (response != null) {
        await PropertyRepoImpl()
            .getALlProperties(currentUserToken.toString())
            .then((properties) {
          if (properties.isNotEmpty) {
            emit(state.copyWith(
                status: PropertyStatus.successUploadPic, properties: properties));
          } else {
            emit(state.copyWith(status: PropertyStatus.emptyUploadPic));
          }
        }).onError((error, stackTrace) {
          emit(state.copyWith(status: PropertyStatus.errorUploadPic));
          if (kDebugMode) {
            log("Error: $error");
            log("Stacktrace: $stackTrace");
          }
        }).then((value) {
          emit(state.copyWith(
              status: PropertyStatus.successUploadPic,
              isPropertyLoading: false,
              updatePropertyResponseModel: response));
        });
      } else {
        emit(state.copyWith(
          status: PropertyStatus.accessDeniedUploadPic,
          isPropertyLoading: false,
        ));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          status: PropertyStatus.errorUploadPic,
          isPropertyLoading: false,
          message: error.toString()));
    });
  }


  @override
  void onEvent(PropertyEvent event) {
    log(event.toString());
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<PropertyEvent, PropertyState> transition) {
    log(transition.toString());
    super.onTransition(transition);
  }

  @override
  void onChange(Change<PropertyState> change) {
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
