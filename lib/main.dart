import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_rent/data_layer/services/navigation/locator.dart';
import 'package:smart_rent/data_layer/services/navigation/navigator_service.dart';
import 'package:smart_rent/ui/pages/account/bloc/account_bloc.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/bloc/auth/auth_bloc.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/bloc/login_bloc.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/login_page.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/widgets/reset_password_page.dart';
import 'package:smart_rent/ui/pages/auth_pages/welcome_page/welcome_page.dart';
import 'package:smart_rent/ui/pages/collections_report/bloc/collections_report_bloc.dart';
import 'package:smart_rent/ui/pages/currency/bloc/currency_bloc.dart';
import 'package:smart_rent/ui/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:smart_rent/ui/pages/floors/bloc/floor_bloc.dart';
import 'package:smart_rent/ui/pages/payment_account/bloc/payment_account_bloc.dart';
import 'package:smart_rent/ui/pages/payment_mode/bloc/payment_mode_bloc.dart';
import 'package:smart_rent/ui/pages/payment_schedules/bloc/payment_schedules_bloc.dart';
import 'package:smart_rent/ui/pages/payments/bloc/payment_bloc.dart';
import 'package:smart_rent/ui/pages/payments_report/bloc/payments_report_bloc.dart';
import 'package:smart_rent/ui/pages/period/bloc/period_bloc.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/pages/property_categories/bloc/property_category_bloc.dart';
import 'package:smart_rent/ui/pages/property_details/property_details_page.dart';
import 'package:smart_rent/ui/pages/property_details/screens/property_view_docs_screen.dart';
import 'package:smart_rent/ui/pages/property_types/bloc/property_type_bloc.dart';
import 'package:smart_rent/ui/pages/root/bloc/nav_bar_bloc.dart';
import 'package:smart_rent/ui/pages/root/root_page.dart';
import 'package:smart_rent/ui/pages/tenant_unit/bloc/tenant_unit_bloc.dart';
import 'package:smart_rent/ui/pages/tenants/bloc/tenant_bloc.dart';
import 'package:smart_rent/ui/pages/unit_types/bloc/unit_type_bloc.dart';
import 'package:smart_rent/ui/pages/units/bloc/unit_bloc.dart';
import 'package:smart_rent/ui/pages/unpaid_reports/bloc/un_paid_report_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/profile_pic_widget/bloc/profile_pic_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_rent/utilities/app_init.dart';

import 'ui/pages/employees/bloc/employee_bloc.dart';
import 'dart:core';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp],);

  setupLocator();
  // Shared Preferences.
  await GetSecureStorage.init(
      password: 'infosec_technologies_ug_rent_manager');




  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavBarBloc()),
        BlocProvider(create: (context) => DashboardBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ProfilePicBloc()),
        BlocProvider(create: (context) => PropertyBloc()),
        BlocProvider(create: (context) => PropertyTypeBloc()),
        BlocProvider(create: (context) => PropertyCategoryBloc()),
        BlocProvider(create: (context) => FloorBloc()),
        BlocProvider(create: (context) => CurrencyBloc()),
        BlocProvider(create: (context) => PeriodBloc()),
        BlocProvider(create: (context) => PaymentBloc()),
        BlocProvider(create: (context) => PaymentAccountBloc()),
        BlocProvider(create: (context) => PaymentModeBloc()),
        BlocProvider(create: (context) => PeriodBloc()),
        BlocProvider(create: (context) => PaymentSchedulesBloc()),
        BlocProvider(create: (context) => TenantUnitBloc()),
        BlocProvider(create: (context) => UnitBloc()),
        BlocProvider(create: (context) => UnPaidReportBloc()),
        BlocProvider(create: (context) => PaymentsReportBloc()),
        BlocProvider(create: (context) => CollectionsReportBloc()),
        BlocProvider(create: (context) => TenantBloc()),
        BlocProvider(create: (context) => EmployeeBloc()),
        BlocProvider(create: (context) => AccountBloc()),
        BlocProvider(create: (context) => UnitTypeBloc()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final _appLinks = AppLinks(); //

  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDeepLinks();
    savedBox.writeIfNull('email', '');

  }


  restartView() async {
    _getCurrentUserData().then((value) {
      setState(() {});
    });
  }

  Future<void> _getCurrentUserData() async {
    savedBox.read('email');
  }


  void initDeepLinks() {
    // Handle incoming deep links

    _appLinks.uriLinkStream.listen((event) {
      String? resetToken;
      print('MY Event event == $event');
      print('MY Event path1 == ${event.path}');
      print('MY Event query == ${event.query}');
      print('MY Event data == ${event.data}');
      print('MY Event path == ${event.pathSegments}');
      print('MY Event query param == ${event.queryParameters}');
      print('MY Event path seg == ${event.pathSegments}');
      print('MY Event path seg1 == ${event.pathSegments[0]}');
      print('MY Event path seg2 == ${event.pathSegments[1]}');
      print('MY Event path seg3 == ${event.pathSegments[2]}');
      print('MY Event path email == ${event.queryParameters['email'].toString()}');


      if(event.path.startsWith('/password/reset/')){
        Get.to(() => ResetPasswordPage(email: event.queryParameters['email'].toString(), token: event.pathSegments[2].toString()));
        print('PASSSWOORD RESET PATH');
      } else if(event.path.startsWith('/inquiry/')){
        // Get.to(() => const LoginPage());
        print('LOGIN PATH');
      }else {
        print('NO PATH OPENED');
      }

    });

  }


  @override
  Widget build(BuildContext context) {


    final sessionConfig = SessionConfig(
        invalidateSessionForAppLostFocus: const Duration(minutes: 5),
        invalidateSessionForUserInactivity: const Duration(minutes: 5));

    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {

        locator<NavigationService>().navigateTo("/sign_in");
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   "/",
        //   (route) => false,
        // );
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        locator<NavigationService>().navigateTo("/sign_in");
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   "/",
        //   (route) => false,
        // );
      }
    });

    print('My saved email ${savedEmail}');
    // final box = GetSecureStorage(
    //     password: 'infosec_technologies_ug_rent_manager');
    // String? email = box.read('email');
    // currentUsername = box.read('name');


    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      child: GetMaterialApp(

        // navigatorKey: _navKey,
        navigatorKey: locator<NavigationService>().navigatorKey,
        title: 'SmartRent Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primary),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(

          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        themeMode: ThemeMode.light,

        getPages: [
          GetPage(name: '/', page: () => (savedEmail == null || savedEmail == '') ?  const LoginPage() :  const WelcomePage(),),
          GetPage(name: '/login', page: () => const LoginPage()),
          GetPage(name: '/sign_in', page: () => const WelcomePage()),
          GetPage(name: '/root', page: () => const RootPage()),
          GetPage(name: '/property_details', page: () => const PropertyDetailsPage()),


        ],

        routes: {
          '/': (context) => (savedEmail == null || savedEmail == '') ?  const LoginPage() :  const WelcomePage(),
          '/login': (context) =>  const LoginPage(),
          '/sign_in': (context) =>  const WelcomePage(),
          // '/sign_in': (context) =>  WelcomePage(),

          // '/': (context) => (savedEmail != null && savedEmail!.isNotEmpty && savedEmail != "")
          //     ?  WelcomePage()
          //     :  LoginPage(),
          // '/': (context) => const ResetPasswordPage(email: 'dsdds@gmail.com', token: 'sddsd',),
          '/root': (context) => const RootPage(),
          '/property_details': (context) => const PropertyDetailsPage(),
        },

      ),
    );

    // return GetMaterialApp(
    //   title: 'SmartRent Manager',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primary),
    //     useMaterial3: true,
    //   ),
    //   darkTheme: ThemeData(
    //     brightness: Brightness.dark,
    //     /* dark theme settings */
    //   ),
    //   themeMode: ThemeMode.light,
    //   routes: {
    //     '/': (context) => const LoginPage(),
    //     '/root': (context) => const RootPage(),
    //     '/property_details': (context) => const PropertyDetailsPage(),
    //   },
    // );

  }
}
