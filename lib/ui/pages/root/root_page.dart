import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_rent/ui/pages/currency/bloc/currency_bloc.dart';
import 'package:smart_rent/ui/pages/dashboard/dashboard_page.dart';
import 'package:smart_rent/ui/pages/employees/employees_page.dart';
import 'package:smart_rent/ui/pages/floors/bloc/floor_bloc.dart';
import 'package:smart_rent/ui/pages/floors/bloc/form/floor_form_bloc.dart';
import 'package:smart_rent/ui/pages/floors/forms/add_floor_form.dart';
import 'package:smart_rent/ui/pages/payments/bloc/form/payment_form_bloc.dart';
import 'package:smart_rent/ui/pages/payments/forms/add_home_payment_form.dart';
import 'package:smart_rent/ui/pages/period/bloc/period_bloc.dart';
import 'package:smart_rent/ui/pages/properties/bloc/form/property_form_bloc.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/pages/properties/forms/add_property_form.dart';
import 'package:smart_rent/ui/pages/root/bloc/nav_bar_bloc.dart';
import 'package:smart_rent/ui/pages/root/widgets/bottom_nav_bar.dart';
import 'package:smart_rent/ui/pages/root/widgets/screen.dart';
import 'package:smart_rent/ui/pages/settings/settings_page.dart';
import 'package:smart_rent/ui/pages/tenant_unit/bloc/form/tenant_unit_form_bloc.dart';
import 'package:smart_rent/ui/pages/tenant_unit/forms/add_home_tenant_unit_form.dart';
import 'package:smart_rent/ui/pages/tenants/bloc/tenant_bloc.dart';
import 'package:smart_rent/ui/pages/tenants/tenants_page.dart';
import 'package:smart_rent/ui/pages/units/bloc/form/unit_form_bloc.dart';
import 'package:smart_rent/ui/pages/units/bloc/unit_bloc.dart';
import 'package:smart_rent/ui/pages/units/forms/add_home_unit_form.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // File? propertyPic;
  // String? propertyImagePath;
  // String? propertyImageExtension;
  // String? propertyFileName;
  // Uint8List? propertyBytes;
  //
  // final TextEditingController titleController = TextEditingController();
  // final TextEditingController addressController = TextEditingController();
  // final TextEditingController descriptionController = TextEditingController();
  // final TextEditingController locationController = TextEditingController();
  // final TextEditingController sqmController = TextEditingController();
  //
  // List<String> searchableList = ['Orange', 'Watermelon', 'Banana'];
  //
  // int selectedPropertyTypeId = 0;
  // int selectedPropertyCategoryId = 0;
  //
  // final ScrollController scrollController = ScrollController();

  PageController controller = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,

      floatingActionButton: BottomNavBar(
        screens: _screens(),
        onFabTap: _buildAddWidget,
      ),
      body: BlocBuilder<NavBarBloc, NavBarState>(
        builder: (context, state) {
          return _buildRootViewStack();
        },
      ),
    );
  }

  List<Screen> _screens() {
    return [
      const Screen(
        index: 0,
        name: "Home",
        icon: Icons.home,
        widget: DashboardPage(),
      ),
      const Screen(
        index: 1,
        name: "Employees",
        icon: Icons.people,
        widget: EmployeesPage(),
      ),
      const Screen(),
      const Screen(
        index: 3,
        name: "Tenants",
        icon: Icons.people_outline_rounded,
        widget: TenantsPage(),
      ),
      const Screen(
        index: 4,
        name: "Settings",
        icon: Icons.settings,
        widget: SettingsPage(),
      ),
    ];
  }

  Widget _buildRootViewStack() {
    return IndexedStack(
      index: context.read<NavBarBloc>().state.idSelected,
      children: List.generate(
        _screens().length,
        (index) => _screens()[index].widget ?? Container(),
      ),
    );
  }

  _buildAddWidget() {
    return showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      showDragHandle: true,
      builder: (context) => SizedBox(
        width: double.infinity,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton.outlined(
                        style: const ButtonStyle(
                          iconColor: MaterialStatePropertyAll(
                            AppTheme.inActiveColor,
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(
                              color: AppTheme.inActiveColor,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
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
                                    ],
                                    child: const AddPropertyForm(
                                        addButtonText: 'Add', isUpdate: false));
                              });
                        },
                        icon: const Icon(Icons.house),
                        iconSize: 45,
                      ),
                      const Text(
                        "Add Property",
                        style: TextStyle(
                          color: AppTheme.inActiveColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton.outlined(
                        style: const ButtonStyle(
                          iconColor: MaterialStatePropertyAll(
                            AppTheme.inActiveColor,
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(
                              color: AppTheme.inActiveColor,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => FloorFormBloc(),
                                    )
                                  ],
                                  child: AddFloorForm(
                                    addButtonText: 'Add',
                                    isUpdate: false,
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.bed),
                        iconSize: 45,
                      ),
                      const Text(
                        "Add Floor",
                        style: TextStyle(
                          color: AppTheme.inActiveColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton.outlined(
                        style: const ButtonStyle(
                          iconColor: MaterialStatePropertyAll(
                            AppTheme.inActiveColor,
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(
                              color: AppTheme.inActiveColor,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                        create: (context) => UnitFormBloc()),
                                    BlocProvider(
                                        create: (context) => FloorBloc()),
                                    BlocProvider(
                                        create: (context) => TenantBloc()),
                                    BlocProvider(
                                        create: (context) => UnitBloc()),
                                    BlocProvider(
                                        create: (context) => PeriodBloc()),
                                    BlocProvider(
                                        create: (context) => CurrencyBloc()),
                                    BlocProvider(
                                        create: (context) =>
                                            TenantUnitFormBloc()),
                                  ],
                                  child: const AddHomeUnitForm(
                                    addButtonText: 'Add',
                                    isUpdate: false,
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.bed),
                        iconSize: 45,
                      ),
                      const Text(
                        "Add Unit",
                        style: TextStyle(
                          color: AppTheme.inActiveColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Column(
                  //   children: [
                  //     IconButton.outlined(
                  //       style: const ButtonStyle(
                  //         iconColor: MaterialStatePropertyAll(
                  //           AppTheme.inActiveColor,
                  //         ),
                  //         side: MaterialStatePropertyAll(
                  //           BorderSide(
                  //             color: AppTheme.inActiveColor,
                  //           ),
                  //         ),
                  //       ),
                  //       onPressed: () {},
                  //       icon: const Icon(Icons.person),
                  //       iconSize: 45,
                  //     ),
                  //     const Text(
                  //       "Add Tenant",
                  //       style: TextStyle(
                  //         color: AppTheme.inActiveColor,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton.outlined(
                        style: const ButtonStyle(
                          iconColor: MaterialStatePropertyAll(
                            AppTheme.inActiveColor,
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(
                              color: AppTheme.inActiveColor,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                        create: (context) => PropertyBloc()),
                                    BlocProvider(
                                        create: (context) => TenantBloc()),
                                    BlocProvider(
                                        create: (context) =>
                                            TenantUnitFormBloc()),
                                  ],
                                  child: const AddHomeTenantUnitForm(
                                    addButtonText: 'Add',
                                    isUpdate: false,
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.house),
                        iconSize: 45,
                      ),
                      const Text(
                        "Add Tenant Unit",
                        style: TextStyle(
                          color: AppTheme.inActiveColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton.outlined(
                        style: const ButtonStyle(
                          iconColor: MaterialStatePropertyAll(
                            AppTheme.inActiveColor,
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(
                              color: AppTheme.inActiveColor,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
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
                                        create: (context) => PaymentFormBloc()),
                                  ],
                                  child: const AddHomePaymentForm(
                                    addButtonText: 'Add',
                                    isUpdate: false,
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.bed),
                        iconSize: 45,
                      ),
                      const Text(
                        "Add Payment",
                        style: TextStyle(
                          color: AppTheme.inActiveColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
