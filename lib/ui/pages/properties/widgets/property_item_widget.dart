import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/ui/pages/properties/bloc/form/property_form_bloc.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/pages/properties/forms/update_property_form.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/custom_image.dart';
import 'package:smart_rent/utilities/extra.dart';
import 'package:gap/gap.dart';

class PropertyItemWidget extends StatelessWidget {
  final Property property;
  final Function()? onTap;

  const PropertyItemWidget({super.key, required this.property, this.onTap});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return GestureDetector(
      key: ValueKey(
          "property-item-widget-${Random().nextDouble()}-${property.name}-${property.description}"),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 15,
          left: 10,
          right: 10,
        ),
        // width: width,
        height: 175,
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
        child: Row(
          children: [
             CustomImage(
              property.imageUrl!.isEmpty ? "assets/images/propertyicon.png" : property.imageUrl.toString(),
              isNetwork: property.imageUrl!.isEmpty ? false : true,
              radius: 10,
              height: 200,
              width: 150,
              isElevated: false,
            ),
            const SizedBox(width: 10),
            PropertyDetails(property: property),
          ],
        ),
      ),
    );
  }
}

class PropertyDetails extends StatelessWidget {
  final Property property;

  const PropertyDetails({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    MoneyFormatter cost = MoneyFormatter(amount: double.parse(property.unitAmount == null ? 0.0.toString() : property.unitAmount.toString()));

    MoneyFormatterOutput fo = cost.output;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            SizedBox(
              width: 175,
              child: Text(
                property.name!.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),


            property.canEdit! ? Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 10,
                child: GestureDetector(
                    onTap: (){
                      showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                      create: (context) =>
                                          PropertyFormBloc()),
                                  BlocProvider(
                                      create: (context) =>
                                          PropertyBloc()),
                                ],
                                child:  UpdatePropertyForm(
                                  addButtonText: 'Add', isUpdate: false, property: property,));
                          });
                    },
                    child: Icon(Icons.edit, color: AppTheme.primaryColor,)),
              ),
            ) : Container(),
          ],
        ),
        property.location == null ? Container() : Text(property.location!),
        SizedBox(width: 10),
        Text('${property.squareMeters!} sqm'),
        SizedBox(width: 10),
        Text('${property.totalUnits} ${property.totalUnits! > 1 ? 'Units' : 'Unit'}'),
        Text('Vacant - ${property.availableUnits} ${property.availableUnits! > 1 ? 'Units' : 'Unit'}', style: TextStyle(
          fontFamily: 'Roboto'
        ),),
        Text('Occupied - ${property.occupiedUnits} ${property.occupiedUnits! > 1 ? 'Units' : 'Unit'}',),
        // Text('${fo.nonSymbol} / ${property.unitSchedule == null ? '' : property.unitSchedule}', style: TextStyle(
        //     fontFamily: 'Roboto'
        // )),
        SizedBox(height: 10,),

      ],
    );
  }
}
