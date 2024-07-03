import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:smart_rent/data_layer/models/floor/floor_model.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/ui/pages/floors/bloc/floor_bloc.dart';
import 'package:smart_rent/ui/pages/floors/bloc/form/floor_form_bloc.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/pages/properties/widgets/no_data_widget.dart';
import 'package:smart_rent/ui/pages/properties/widgets/not_found_widget.dart';
import 'package:smart_rent/ui/pages/property_details/forms/floor/add_property_floor_form.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_search_textfield.dart';
import 'package:smart_rent/ui/widgets/smart_error_widget.dart';
import 'package:smart_rent/ui/widgets/smart_widget.dart';
import 'package:smart_rent/utilities/extra.dart';

class FloorsSuccessWidget extends StatefulWidget {
  final Property property;

  const FloorsSuccessWidget({super.key, required this.property});

  @override
  State<FloorsSuccessWidget> createState() => _FloorsSuccessWidgetState();
}

class _FloorsSuccessWidgetState extends State<FloorsSuccessWidget> {

  TextEditingController searchController = TextEditingController();

  List<FloorModel> filteredData = <FloorModel>[];
  List<FloorModel> initialFloors =<FloorModel>[];

  void filterFloors(String query,) {

    setState(() {
      filteredData = initialFloors
          .where((floor) =>
          floor.name
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
    print('My Filtered Floors List $filteredData');
    print('My Initial Floors List $initialFloors');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FloorBloc, FloorState>(
      listener: (context, state) => log('RECEIVED STATUS: ${state.status}'),
      builder: (context, state) {
        if (state.status.isInitial) {
          context.read<FloorBloc>().add(LoadAllFloorsEvent(widget.property.id!));
        }
        if (state.status.isLoading) {
          return const LoadingWidget();
        }
        if (state.status.isNotFound) {
          return const NotFoundWidget();
        }
        if (state.status.isEmpty) {
          return _buildEmptyBody(context);
        }
        if (state.status.isError) {
          return SmartErrorWidget(
            message: 'Error loading floors',
            onPressed: () {
              context.read<FloorBloc>().add(LoadAllFloorsEvent(widget.property.id!));
            },
          );
        }
        if (state.status.isSuccess) {
          initialFloors = state.floors!;
          return _buildSuccessBody(context);
        }
        return const SmartWidget();
      },
    );
  }

  Widget _buildSuccessBody(BuildContext parentContext,) {
    return Scaffold(
      backgroundColor: AppTheme.appBgColor,
      appBar: _buildAppTitle(),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_floor",
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
        onPressed: () => showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: parentContext,
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => FloorFormBloc()),
                ],
                child: AddPropertyFloorForm(
                  parentContext: parentContext,
                  addButtonText: 'Add',
                  isUpdate: false,
                  property: widget.property,
                  initialFloors: initialFloors,
                ),
              );
            }),
        backgroundColor: AppTheme.primary,
      ),
      body: ListView.builder(
        controller: floorsScrollController,
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index){
          var floor = filteredData.isEmpty ? initialFloors[index] : filteredData[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            // width: width,
            // height: height,
            decoration: BoxDecoration(
              color: AppTheme.whiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: .1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: ListTile(
              title: Text(floor.name!.capitalizeFirst!),
            ),
          );
        },
        itemCount: filteredData.isEmpty ? initialFloors.length : filteredData.length,
      ),
    );
  }

  Widget _buildEmptyBody(BuildContext parentContext,) {
    return Scaffold(
      backgroundColor: AppTheme.appBgColor,
      appBar: _buildAppTitle(),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_floor",
        onPressed: () => showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: parentContext,
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => FloorFormBloc()),
                ],
                child: AddPropertyFloorForm(
                  parentContext: parentContext,
                  addButtonText: 'Add',
                  isUpdate: false,
                  property: widget.property,
                  initialFloors: initialFloors,

                ),
              );
            }),
        backgroundColor: AppTheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),
      body: NoDataWidget(
        message: "No floors",
        onPressed: () {
          parentContext.read<FloorBloc>().add(LoadAllFloorsEvent(widget.property.id!));
        },
        subText: 'floors',
      ),
    );
  }

  PreferredSize _buildAppTitle() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: Container(
        padding: const EdgeInsets.only(
          top: 15,
          left: 10,
          right: 10,
          bottom: 15,
        ),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: AppSearchTextField(
          controller: searchController,
          hintText: 'Search Floors',
          obscureText: false,
          onChanged: filterFloors,
          function: () {},
          fillColor: AppTheme.grey_100,
        ),
      ),
    );
  }
}
