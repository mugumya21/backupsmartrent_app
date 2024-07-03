import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';

class PropertiesSearchController {
  final BuildContext context;
  final PropertyState propertyState;
  PropertiesSearchController( {required this.context, required this.propertyState});

  onChange(String value) {
    value = value.toLowerCase();

    List<Property> propertyList =
    propertyState.properties!.where((property) => property.name!.toLowerCase().contains(value)).toList();

    if (value.isEmpty) {
      propertyList = [];
      context.read<PropertyBloc>().add(PropertySearchEvent(value));
    }
    context.read<PropertyBloc>().add(PropertySearchEvent(value));
  }
}