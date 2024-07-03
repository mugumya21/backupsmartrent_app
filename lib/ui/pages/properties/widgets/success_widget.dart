import 'package:intl/intl.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/pages/properties/widgets/property_item_widget.dart';
import 'package:smart_rent/ui/pages/root/bloc/nav_bar_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_search_textfield.dart';
import 'package:smart_rent/utilities/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SuccessWidget extends StatefulWidget {
  const SuccessWidget({super.key});

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {

  TextEditingController searchController = TextEditingController();
  final searchFieldFocus = FocusNode();


  List<Property> filteredData = <Property>[];
  late List<Property> initialProperties;

  void filterProperties(String query,) {

    setState(() {
      filteredData = initialProperties
          .where((property) =>
      property.name
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
    print('My Filtered Property List $filteredData');
    print('My Initial Property List $initialProperties');
  }

  @override
  Widget build(BuildContext context) {
    propertiesScrollController.addListener(() {
      if (propertiesScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (context.read<NavBarBloc>().state.isVisible != false) {
          context.read<NavBarBloc>().add(ChangeNavBarVisibility(
              false, context.read<NavBarBloc>().state.idSelected));
        }
      } else {
        if (context.read<NavBarBloc>().state.isVisible != true) {
          context.read<NavBarBloc>().add(ChangeNavBarVisibility(
              true, context.read<NavBarBloc>().state.idSelected));
        }
      }
    });

    return BlocBuilder<PropertyBloc, PropertyState>(
      builder: (context, state) {
        initialProperties = state.properties!;
        return Scaffold(
          backgroundColor: AppTheme.appBgColor,
          appBar: AppBar(
            title: _buildAppTitle(),
            backgroundColor: AppTheme.appBgColor,
            toolbarHeight: 70,
          ),
          body: ListView.builder(
            controller: propertiesScrollController,
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (context, index) => PropertyItemWidget(
              property: filteredData.isEmpty ? initialProperties[index] : filteredData[index],
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.pushNamed(
                  context,
                  "/property_details",
                  arguments: filteredData.isEmpty ? initialProperties[index] : filteredData[index],
                );
              },
            ),
            itemCount: filteredData.isEmpty ? initialProperties.length : filteredData.length,
          ),
        );

        // if(state.status ==  PropertyStatus.initial){
        //
        // } if(state.status == PropertyStatus.success){
        //
        // }
        // return Container();

      },
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
          hintText: 'Search Properties',
          obscureText: false,
          function: () {
          },
          onChanged: filterProperties,
          fillColor: AppTheme.grey_100,
        ),
      ),
    );
  }
}
