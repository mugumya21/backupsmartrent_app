import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/ui/pages/floors/floors_page.dart';
import 'package:smart_rent/ui/pages/payments/layouts/payment_tab_screen_layout.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/pages/property_details/screens/details_success_screen.dart';
import 'package:smart_rent/ui/pages/property_details/screens/documents_success_screen.dart';
import 'package:smart_rent/ui/pages/tenant_unit/layouts/tenant_unit_tab_screen_layout.dart';
import 'package:smart_rent/ui/pages/units/layouts/unit_tab_screen_layout.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/appbar_content.dart';

class PropertyDetailsLayout extends StatelessWidget {
  final Property property;

  const PropertyDetailsLayout({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppTheme.appBgColor,
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: const TitleBarImageHolder(),
          bottom: _buildAppTitle(),
          foregroundColor: AppTheme.whiteColor,
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (context) => PropertyBloc(),
              child: DetailsSuccessScreen(property: property),
            ),
            // const DocumentsSuccessScreen(),
            FloorsPage(property: property),
            // UnitsSuccessScreen(property: property),
            UnitsTabScreenLayout(property: property),
            // const TenantsSuccessScreen(),
            TenantUnitTabScreenLayout(property: property),
            // PaymentsSuccessScreen(property: property,),
            PaymentTabScreenLayout(property: property),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppTitle() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        decoration: const BoxDecoration(color: AppTheme.primaryDarker),
        child: const TabBar(
          tabAlignment: TabAlignment.start,
          indicatorColor: Color(0xFF2D80E3),
          // enableFeedback: true,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 5,
                color: Color(0xFF2D80E3),
              ),
            ),
          ),
          tabs: [
            Tab(
              child: Text(
                "Details",
                style: TextStyle(
                  color: AppTheme.whiteColor,
                ),
              ),
            ),
            // Tab(
            //   child: Text(
            //     "Documents",
            //     style: TextStyle(
            //       color: AppTheme.whiteColor,
            //     ),
            //   ),
            // ),
            Tab(
              child: Text(
                "Floors",
                style: TextStyle(
                  color: AppTheme.whiteColor,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Units",
                style: TextStyle(
                  color: AppTheme.whiteColor,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Tenants",
                style: TextStyle(
                  color: AppTheme.whiteColor,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Payments",
                style: TextStyle(
                  color: AppTheme.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
