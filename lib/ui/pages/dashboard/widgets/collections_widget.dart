import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smart_rent/data_layer/models/currency/currency_model.dart';
import 'package:smart_rent/data_layer/models/payment/payments_model.dart';
import 'package:smart_rent/data_layer/models/reports/collections/collections_report_model.dart';
import 'package:smart_rent/data_layer/models/smart_model.dart';
import 'package:smart_rent/data_layer/services/receipt/collections_report_receipt_pdf.dart';
import 'package:smart_rent/ui/pages/collections_report/bloc/collections_report_bloc.dart';
import 'package:smart_rent/ui/pages/currency/bloc/currency_bloc.dart';
import 'package:smart_rent/ui/pages/payments/bloc/payment_bloc.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_button.dart';
import 'package:smart_rent/ui/widgets/app_drop_downs.dart';
import 'package:smart_rent/ui/widgets/app_search_textfield.dart';
import 'package:smart_rent/ui/widgets/auth_textfield.dart';
import 'package:smart_rent/ui/widgets/smart_widget.dart';
import 'package:smart_rent/utilities/app_init.dart';
import 'package:smart_rent/utilities/extra.dart';
///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CollectionsWidget extends StatefulWidget {
  const CollectionsWidget({super.key});

  @override
  State<CollectionsWidget> createState() => _CollectionsWidgetState();
}

class _CollectionsWidgetState extends State<CollectionsWidget> {


  final CollectionsReceiptPrintPdf collectionsReceiptPrintPdf = CollectionsReceiptPrintPdf();
  int number = 0;

  TextEditingController searchController = TextEditingController();
  List<CollectionsReportModel> payments = <CollectionsReportModel>[];
  List<CollectionsReportModel> filteredData = <CollectionsReportModel>[];
  late CollectionsReportDataSource paymentDataSource;

  late SingleValueDropDownController _propertyModelCont;

  int selectedPropertyId = 0;
  String selectedPropertyName = '';
  String selectedPropertyTotalUnits = '';
  String selectedPropertyOccupiedUnits = '';
  String selectedPropertyVacantUnits = '';
  // String baseCurrencyCode = 'UGX';

  CurrencyModel? currencyModel;
  int selectedCurrencyId = 0;
  String selectedCurrencyCode = '';

  void filterCollections(String query,) {

    setState(() {
      filteredData = payments
          .where((collection) =>
          collection.tenantunit!.unit!.name
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())
          ||
              collection.tenantunit!.tenant!.clientProfiles!.first.firstName
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase())
              ||
              collection.tenantunit!.tenant!.clientProfiles!.first.lastName
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase())
              ||
              collection.tenantunit!.tenant!.clientProfiles!.first.companyName
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase())
      )
          .toList();
    });
    print('My Filtered Collections List $filteredData');
    print('My Initial Collections List $payments');
  }

  DateTime today = DateTime.now();
  late String dateToday;

  var myDate = DateTime.now();
  late String formatedDate1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _propertyModelCont = SingleValueDropDownController();
    formatedDate1 = "${myDate.year}-${myDate.month}-${myDate.day}";
    // dateToday = '${today.year}-${today.month}-${today.day}';
    dateToday = '';
    print('init date $dateToday');
    print('init2 date2 $formatedDate1');
    selectedCurrencyCode =  currentUserBaseCurrencyCode.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    selectedPropertyId = 0;
    print('new selected Id =$selectedPropertyId');
  }

  @override
  Widget build(BuildContext context) {

    // int sumListRecursive(List<CollectionsReportModel> numbers) {
    //   if (numbers.isEmpty) {
    //     return 0;
    //   }
    //   return numbers.first.paid! + sumListRecursive(numbers.sublist(1));
    // }

    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: AppSearchTextField(
            controller: searchController,
            hintText: 'Search',
            obscureText: false,
            function: (){},
            onChanged: filterCollections,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 130,
                child: BlocBuilder<PropertyBloc, PropertyState>(
                  builder: (context, state) {
                    if (state.status == PropertyStatus.initial) {
                      context.read<PropertyBloc>().add(LoadPropertiesEvent());
                    }
                    if (state.status == PropertyStatus.empty) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: AppTextField(
                          hintText: 'No Properties',
                          obscureText: false,
                          enabled: false,
                          fillColor: Colors.transparent,
                        ),
                      );
                    }
                    if (state.status == PropertyStatus.error) {
                      return const Center(
                        child: Text('An Error Occurred'),
                      );
                    }
                    return SearchablePropertyModelListDropDown<SmartPropertyModel>(
                      hintText: 'Property *',
                      menuItems: state.properties == null ? [] : state.properties!,
                      controller: _propertyModelCont,
                      onChanged: (value) {
                        setState(() {
                          selectedPropertyId = value.value.id;
                          selectedPropertyName = value.value.name;
                          selectedPropertyTotalUnits = value.value.totalUnits.toString();
                          selectedPropertyOccupiedUnits = value.value.occupiedUnits.toString();
                          selectedPropertyVacantUnits = value.value.availableUnits.toString();
                        });
                        print('Property is $selectedPropertyId');
                        print('Property Name is $selectedPropertyName');
                        print('Property Total $selectedPropertyTotalUnits');
                        print('Property Occupied $selectedPropertyOccupiedUnits');
                        print('Property Vacant $selectedPropertyVacantUnits');

                        if(dateToday.isEmpty){
                          context.read<CollectionsReportBloc>().add(LoadCollectionsReportEvent(selectedPropertyId, formatedDate1, selectedCurrencyId));

                        } else {
                          context.read<CollectionsReportBloc>().add(LoadCollectionsReportEvent(selectedPropertyId, dateToday, selectedCurrencyId));

                        }

                        searchController.clear();
                        filteredData.clear();
                        print('My Date Today = $dateToday');
                      },
                      fillColor: Colors.transparent,
                      // fillColor: AppTheme.grey_100,
                      height: 35,
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                    );
                  },
                ),
              ),

              Container(
                width: 160,
                child:BlocBuilder<CollectionsReportBloc, CollectionsReportState>(
                builder: (context, state) {
                  if (state.status == CollectionsReportStatus.initial) {
                    context.read<CollectionsReportBloc>().add(LoadCollectionsPeriods());
                  }
                  if (state.status == CollectionsReportStatus.emptyPeriods) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: AppTextField(
                        hintText: 'No Dates',
                        obscureText: false,
                        enabled: false,
                        fillColor: Colors.transparent,
                      ),
                    );
                  }
                  if (state.status == CollectionsReportStatus.errorPeriods) {
                    return const Center(
                      child: Text('An Error Occurred'),
                    );
                  }
                  return CustomCollectionsReportPeriodGenericDropdown<dynamic>(
                    defaultValue: state.periods == null ? DateTime.now() : state.periods!.first,
                    hintText: 'Select Period *',
                    menuItems: state.periods == null ? [] : state.periods!,
                    // fillColor: AppTheme.grey_100,
                    fillColor: Colors.transparent,
                    onChanged: (value){
                      print('my dater ${value}');
                      var myNewValue =  value.toString().replaceRange(11, value.toString().length, '');

                      setState(() {
                        dateToday =myNewValue;
                      });

                      print('latest date = $myNewValue');
                      print('date Today = $dateToday');
                      if(selectedPropertyId == 0) {
                        Fluttertoast.showToast(msg: 'Now select a property', gravity: ToastGravity.TOP);

                      } else {
                        context.read<CollectionsReportBloc>().add(LoadCollectionsReportEvent(selectedPropertyId, myNewValue, selectedCurrencyId));
                        searchController.clear();
                        filteredData.clear();
                      }


                    },
                  );
                },
              ),),

              Container(
                width: 100,
                child: BlocBuilder<CurrencyBloc, CurrencyState>(
                  builder: (context, state) {
                    if (state.status.isInitial) {
                      context
                          .read<CurrencyBloc>()
                          .add(LoadAllCurrenciesEvent(selectedPropertyId));
                    }
                    if (state.status.isSuccess) {
                      // currencyModel = state.currencies.firstWhere(
                      //       (currency) => currency.code == 'UGX',
                      //   // orElse: () => null as CurrencyModel,
                      // );
                      currencyModel = state.currencies.firstWhere(
                            (currency) => currentUserBaseCurrencyCode == currency.code,
                        // orElse: () => currencyModel!, // Provide a default CurrencyModel object
                      );

                      return CurrencyApiGenericDropdown<CurrencyModel>(
                        // fillColor: AppTheme.grey_100,
                        fillColor: Colors.transparent,
                        hintText: 'Select currency',
                        menuItems: state.currencies == null
                            ? []
                            : state.currencies!,
                        onChanged: (value) {
                          setState(() {
                            selectedCurrencyId = value!.id!;
                            // baseCurrencyCode = value.code.toString();
                            selectedCurrencyCode = value.code.toString();
                          });
                          // print('Selected Currency Code = $baseCurrencyCode');
                          // if (value != null) {
                          //   currency = value;
                          // }
                          if(selectedPropertyId == 0) {
                            Fluttertoast.showToast(msg: 'Now select a property', gravity: ToastGravity.TOP);

                          } else {
                            context.read<CollectionsReportBloc>().add(LoadCollectionsReportEvent(selectedPropertyId, dateToday.isEmpty ? formatedDate1 : dateToday, selectedCurrencyId));
                            searchController.clear();
                            filteredData.clear();
                          }

                        },
                        defaultValue: currencyModel,
                      );
                    }
                    // if (state.status.isLoading) {
                    //   return Column(
                    //     children: [
                    //       SizedBox(
                    //         height: 50,
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             color: Colors.white,
                    //           ),
                    //           child: const Center(
                    //             child: CupertinoActivityIndicator(),
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(height: 10),
                    //     ],
                    //   );
                    // }
                    return const SizedBox(height: 10);
                  },
                ),
              ),

            ],
          ),
        ),

        const SizedBox(width: 10),
        // BlocBuilder<CurrencyBloc, CurrencyState>(
        //   builder: (context, state) {
        //     if (state.status.isInitial) {
        //       context
        //           .read<CurrencyBloc>()
        //           .add(LoadAllCurrenciesEvent(selectedPropertyId));
        //     }
        //     if (state.status.isSuccess) {
        //       // currencyModel = state.currencies.firstWhere(
        //       //       (currency) => currency.code == 'UGX',
        //       //   // orElse: () => null as CurrencyModel,
        //       // );
        //       currencyModel = state.currencies.firstWhere(
        //             (currency) => currentUserBaseCurrencyCode == currency.code,
        //         // orElse: () => currencyModel!, // Provide a default CurrencyModel object
        //       );
        //
        //       return SizedBox(
        //         width: 200,
        //         child: CustomApiGenericDropdown<CurrencyModel>(
        //           // fillColor: AppTheme.grey_100,
        //           fillColor: Colors.transparent,                  hintText: 'Select currency',
        //           menuItems: state.currencies == null
        //               ? []
        //               : state.currencies!,
        //           onChanged: (value) {
        //             setState(() {
        //               selectedCurrencyId = value!.id!;
        //               // baseCurrencyCode = value.code.toString();
        //               selectedCurrencyCode = value.code.toString();
        //             });
        //             // print('Selected Currency Code = $baseCurrencyCode');
        //             // if (value != null) {
        //             //   currency = value;
        //             // }
        //             if(selectedPropertyId == 0) {
        //               Fluttertoast.showToast(msg: 'Now select a property', gravity: ToastGravity.TOP);
        //
        //             } else {
        //               context.read<CollectionsReportBloc>().add(LoadCollectionsReportEvent(selectedPropertyId, dateToday.isEmpty ? formatedDate1 : dateToday, selectedCurrencyId));
        //               searchController.clear();
        //               filteredData.clear();
        //             }
        //
        //           },
        //           defaultValue: currencyModel,
        //         ),
        //       );
        //     }
        //     // if (state.status.isLoading) {
        //     //   return Column(
        //     //     children: [
        //     //       SizedBox(
        //     //         height: 50,
        //     //         child: Container(
        //     //           decoration: BoxDecoration(
        //     //             borderRadius: BorderRadius.circular(10),
        //     //             color: Colors.white,
        //     //           ),
        //     //           child: const Center(
        //     //             child: CupertinoActivityIndicator(),
        //     //           ),
        //     //         ),
        //     //       ),
        //     //       const SizedBox(height: 10),
        //     //     ],
        //     //   );
        //     // }
        //     return const SizedBox(height: 10);
        //   },
        // ),

        SizedBox(height: 5,),

        // Padding(
        //   padding:EdgeInsets.symmetric(horizontal: 8,),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       BlocBuilder<PropertyBloc, PropertyState>(
        //         builder: (context, state) {
        //           if (state.status == PropertyStatus.initial) {
        //             context.read<PropertyBloc>().add(LoadPropertiesEvent());
        //           }
        //           if (state.status == PropertyStatus.empty) {
        //             return Padding(
        //               padding: EdgeInsets.only(bottom: 10),
        //               child: AppTextField(
        //                 hintText: 'No Properties',
        //                 obscureText: false,
        //                 enabled: false,
        //               ),
        //             );
        //           }
        //           if (state.status == PropertyStatus.error) {
        //             return const Center(
        //               child: Text('An Error Occurred'),
        //             );
        //           }
        //           return Column(
        //             children: [
        //               Icon(Bootstrap.asterisk, size: 10, color: AppTheme.red,),
        //               SearchablePropertyModelListDropDown<SmartPropertyModel>(
        //                 hintText: 'Property',
        //                 menuItems: state.properties == null ? [] : state.properties!,
        //                 controller: _propertyModelCont,
        //                 onChanged: (value) {
        //                   setState(() {
        //                     selectedPropertyId = value.value.id;
        //                   });
        //                   print('Property is $selectedPropertyId');
        //                 },
        //                 fillColor: AppTheme.grey_100,
        //                 height: 35,
        //                 contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        //
        //               ),
        //             ],
        //           );
        //         },
        //       ),
        //       SizedBox(width: 10,),
        //
        //       BlocBuilder<CollectionsReportBloc, CollectionsReportState>(
        //         builder: (context, state) {
        //           if (state.status == CollectionsReportStatus.initial) {
        //             context.read<CollectionsReportBloc>().add(LoadCollectionsPeriods());
        //           }
        //           if (state.status == CollectionsReportStatus.emptyPeriods) {
        //             return Padding(
        //               padding: EdgeInsets.only(bottom: 10),
        //               child: AppTextField(
        //                 hintText: 'No Dates',
        //                 obscureText: false,
        //                 enabled: false,
        //               ),
        //             );
        //           }
        //           if (state.status == CollectionsReportStatus.errorPeriods) {
        //             return const Center(
        //               child: Text('An Error Occurred'),
        //             );
        //           }
        //           return Column(
        //             children: [
        //               Icon(Bootstrap.asterisk, size: 10, color: AppTheme.red,),
        //               CustomGenericDropdown<dynamic>(
        //                 hintText: 'Select Period',
        //                 menuItems: state.periods == null ? [] : state.periods!,
        //                 fillColor: AppTheme.grey_100,
        //                 onChanged: (value){
        //
        //                 },
        //               ),
        //             ],
        //           );
        //         },
        //       ),
        //
        //       // Expanded(
        //       //   child: Column(
        //       //     children: [
        //       //           Icon(Bootstrap.asterisk, size: 10, color: AppTheme.red,),
        //       //       BlocBuilder<CollectionsReportBloc, CollectionsReportState>(
        //       //         builder: (context, state) {
        //       //           if (state.status == CollectionsReportStatus.initial) {
        //       //             context.read<CollectionsReportBloc>().add(LoadCollectionsPeriods());
        //       //           }
        //       //           if (state.status == CollectionsReportStatus.empty) {
        //       //             return Padding(
        //       //               padding: EdgeInsets.only(bottom: 10),
        //       //               child: AppTextField(
        //       //                 hintText: 'No Dates',
        //       //                 obscureText: false,
        //       //                 enabled: false,
        //       //               ),
        //       //             );
        //       //           }
        //       //           if (state.status == CollectionsReportStatus.error) {
        //       //             return const Center(
        //       //               child: Text('An Error Occurred'),
        //       //             );
        //       //           }
        //       //           return Expanded(
        //       //               child: CustomGenericDropdown<dynamic>(
        //       //                 hintText: 'Select Period',
        //       //                 menuItems: state.periods == null ? [] : state.periods!,
        //       //                 fillColor: AppTheme.grey_100,
        //       //                 onChanged: (value){
        //       //
        //       //                 },
        //       //               ));
        //       //         },
        //       //       ),
        //       //     ],
        //       //   ),
        //       // ),
        //
        //       // Expanded(child: Column(
        //       //   children: [
        //       //     Icon(Bootstrap.asterisk, size: 10, color: AppTheme.red,),
        //       //     CustomGenericDropdown(
        //       //       hintText: 'Select Period',
        //       //       menuItems: [],
        //       //       fillColor: AppTheme.grey_100,
        //       //     ),
        //       //   ],
        //       // )),
        //
        //     ],
        //   ),
        // ),

        BlocBuilder<CollectionsReportBloc, CollectionsReportState>(
          builder: (context, state) {


            if (state.status ==  CollectionsReportStatus.initial) {
              // context.read<CollectionsReportBloc>().add(LoadCollectionsReportEvent(selectedPropertyId, selectedPeriodDate));
            }
            if (state.status == CollectionsReportStatus.success) {

              payments = state.paymentSchedules!;
              paymentDataSource = CollectionsReportDataSource(
                  paymentData: filteredData.isEmpty ? payments : filteredData, selectedCurrencyCode: selectedCurrencyCode);
              return _buildBody(context, state, paymentDataSource);
            }
            if (state.status == CollectionsReportStatus.loading) {
              return const LoadingWidget();
            }
            if (state.status == CollectionsReportStatus.error) {
              return Center(child: Text('Error loading collections report table', style: AppTheme.blueAppTitle3,),);
              // return SmartErrorWidget(
              //   message: 'Error loading unpaid report table',
              //   onPressed: () {
              //     context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules());
              //   },
              // );
            }
            if (state.status == CollectionsReportStatus.empty) {
              return Center(child: Text('No Collections Report', style: AppTheme.blueAppTitle3,),);
              // return NoDataWidget(
              //   message: "No payments available",
              //   onPressed: () {
              //     context.read<PaymentBloc>().add(LoadPayments());
              //   },
              // );
            }
            return const SmartWidget();
            // return _buildBody(context, state, paymentDataSource);
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, CollectionsReportState state,
      CollectionsReportDataSource paymentDataSource) {

    return Expanded(
      child: Column(
        children: [

          // Padding(
          //   padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          //   child: AppSearchTextField(
          //     controller: searchController,
          //     hintText: 'Search',
          //     obscureText: false,
          //     function: (){},
          //   ),
          // ),
          //
          //
          // SizedBox(height: 5,),
          //  Padding(
          //   padding:EdgeInsets.symmetric(horizontal: 8,),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       BlocBuilder<PropertyBloc, PropertyState>(
          //         builder: (context, state) {
          //           if (state.status == PropertyStatus.initial) {
          //             context.read<PropertyBloc>().add(LoadPropertiesEvent());
          //           }
          //           if (state.status == PropertyStatus.empty) {
          //             return Padding(
          //               padding: EdgeInsets.only(bottom: 10),
          //               child: AppTextField(
          //                 hintText: 'No Properties',
          //                 obscureText: false,
          //                 enabled: false,
          //               ),
          //             );
          //           }
          //           if (state.status == PropertyStatus.error) {
          //             return const Center(
          //               child: Text('An Error Occurred'),
          //             );
          //           }
          //           return Expanded(
          //             child: Column(
          //               children: [
          //                 Icon(Bootstrap.asterisk, size: 10, color: AppTheme.red,),
          //                 SearchablePropertyModelListDropDown<SmartPropertyModel>(
          //                   hintText: 'Property',
          //                   menuItems: state.properties == null ? [] : state.properties!,
          //                   controller: _propertyModelCont,
          //                   onChanged: (value) {
          //                     setState(() {
          //                       selectedPropertyId = value.value.id;
          //                     });
          //                     print('Property is $selectedPropertyId');
          //                   },
          //                   fillColor: AppTheme.grey_100,
          //                   height: 35,
          //                   contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //
          //                 ),
          //               ],
          //             ),
          //           );
          //         },
          //       ),
          //       SizedBox(width: 10,),
          //
          //       BlocBuilder<CollectionsReportBloc, CollectionsReportState>(
          //         builder: (context, state) {
          //           if (state.status == CollectionsReportStatus.initial) {
          //             context.read<CollectionsReportBloc>().add(LoadCollectionsPeriods());
          //           }
          //           if (state.status == CollectionsReportStatus.emptyPeriods) {
          //             return Padding(
          //               padding: EdgeInsets.only(bottom: 10),
          //               child: AppTextField(
          //                 hintText: 'No Dates',
          //                 obscureText: false,
          //                 enabled: false,
          //               ),
          //             );
          //           }
          //           if (state.status == CollectionsReportStatus.errorPeriods) {
          //             return const Center(
          //               child: Text('An Error Occurred'),
          //             );
          //           }
          //           return Expanded(
          //               child: Column(
          //                 children: [
          //                   Icon(Bootstrap.asterisk, size: 10, color: AppTheme.red,),
          //                   CustomGenericDropdown<dynamic>(
          //                     hintText: 'Select Period',
          //                     menuItems: state.periods == null ? [] : state.periods!,
          //                     fillColor: AppTheme.grey_100,
          //                     onChanged: (value){
          //
          //                     },
          //                   ),
          //                 ],
          //               ));
          //         },
          //       ),
          //
          //       // Expanded(
          //       //   child: Column(
          //       //     children: [
          //       //           Icon(Bootstrap.asterisk, size: 10, color: AppTheme.red,),
          //       //       BlocBuilder<CollectionsReportBloc, CollectionsReportState>(
          //       //         builder: (context, state) {
          //       //           if (state.status == CollectionsReportStatus.initial) {
          //       //             context.read<CollectionsReportBloc>().add(LoadCollectionsPeriods());
          //       //           }
          //       //           if (state.status == CollectionsReportStatus.empty) {
          //       //             return Padding(
          //       //               padding: EdgeInsets.only(bottom: 10),
          //       //               child: AppTextField(
          //       //                 hintText: 'No Dates',
          //       //                 obscureText: false,
          //       //                 enabled: false,
          //       //               ),
          //       //             );
          //       //           }
          //       //           if (state.status == CollectionsReportStatus.error) {
          //       //             return const Center(
          //       //               child: Text('An Error Occurred'),
          //       //             );
          //       //           }
          //       //           return Expanded(
          //       //               child: CustomGenericDropdown<dynamic>(
          //       //                 hintText: 'Select Period',
          //       //                 menuItems: state.periods == null ? [] : state.periods!,
          //       //                 fillColor: AppTheme.grey_100,
          //       //                 onChanged: (value){
          //       //
          //       //                 },
          //       //               ));
          //       //         },
          //       //       ),
          //       //     ],
          //       //   ),
          //       // ),
          //
          //       // Expanded(child: Column(
          //       //   children: [
          //       //     Icon(Bootstrap.asterisk, size: 10, color: AppTheme.red,),
          //       //     CustomGenericDropdown(
          //       //       hintText: 'Select Period',
          //       //       menuItems: [],
          //       //       fillColor: AppTheme.grey_100,
          //       //     ),
          //       //   ],
          //       // )),
          //
          //     ],
          //   ),
          // ),
          // SizedBox(height: 5,),

          _buildHeader(context, state, selectedCurrencyCode),
          const Divider(
            color: AppTheme.inActiveColor,
          ),
          Expanded(child: _buildDataTable(paymentDataSource)),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _buildDataTable(CollectionsReportDataSource paymentDataSource) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: AppTheme.gray.withOpacity(.2),
        headerHoverColor: AppTheme.gray.withOpacity(.3),
      ),
      child: SfDataGrid(
        onQueryRowHeight: (details) {
          if(details.rowIndex == 0) {
            return 40;
          }
          return details.getIntrinsicRowHeight(details.rowIndex);
        },
        // allowSorting: true,
        // allowFiltering: true,
        allowSwiping: false,
        // allowTriStateSorting: true,
        source: paymentDataSource,
        columnWidthMode: ColumnWidthMode.fill,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columns: _getColumns(),
      ),
    );
  }

  List<GridColumn> _getColumns() {
    return <GridColumn>[

      GridColumn(
          columnName: 'unit',
          width: 65,
          label: Container(
              alignment: Alignment.center,
              child: Text('Unit',
                style: AppTheme.tableTitle1,
              ))),

      GridColumn(
          columnName: 'tenant',
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'Tenant',
                style: AppTheme.tableTitle1,
              ))),

      GridColumn(
          columnName: 'paid',
          label: Container(
              alignment: Alignment.center,
              child:  Text(
                'Paid',
                overflow: TextOverflow.ellipsis,
                style: AppTheme.tableTitle1,
              ))),
      GridColumn(
          columnName: 'balance',
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'Balance',
                overflow: TextOverflow.ellipsis,
                style: AppTheme.tableTitle1,
              ))),
    ];
  }



  // Widget _buildDataTable() {
  Widget _buildHeader(BuildContext context, CollectionsReportState state, String selectedCurrencyCode) {

    // currentUserBaseCurrencyCode == selectedCurrencyCode ?

    int sumAmountDueListRecursive(List<CollectionsReportModel> numbers) {
      if (numbers.isEmpty) {
        return 0;
      }
      return currentUserBaseCurrencyCode == selectedCurrencyCode ? ((numbers.first.baseDiscountAmount == null ? 0 : numbers.first.baseDiscountAmount!) + sumAmountDueListRecursive(numbers.sublist(1)))
          : (numbers.first.foreignDiscountAmount == null ? 0 : numbers.first.foreignDiscountAmount!) + sumAmountDueListRecursive(numbers.sublist(1));
    }

    int sumUnpaidListRecursive(List<CollectionsReportModel> numbers) {
      if (numbers.isEmpty) {
        return 0;
      }
      return currentUserBaseCurrencyCode == selectedCurrencyCode ? ((numbers.first.baseBalance == null ? 0 : numbers.first.baseBalance!) + sumUnpaidListRecursive(numbers.sublist(1)))
          : (numbers.first.foreignBalance == null ? 0 : numbers.first.foreignBalance!) + sumUnpaidListRecursive(numbers.sublist(1));
    }

    int sumPaidListRecursive(List<CollectionsReportModel> numbers) {
      if (numbers.isEmpty) {
        return 0;
      }
      return currentUserBaseCurrencyCode == selectedCurrencyCode ? ((numbers.first.basePaid ==null ? 0 :numbers.first.basePaid!) + sumPaidListRecursive(numbers.sublist(1)))
          : (numbers.first.foreignPaid ==null ? 0 :numbers.first.foreignPaid!) + sumPaidListRecursive(numbers.sublist(1));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Paid', style: AppTheme.appTitle3,),
                  Text("${selectedCurrencyCode.isEmpty ? currentUserBaseCurrencyCode : selectedCurrencyCode} ${amountFormatter.format(sumPaidListRecursive(state.paymentSchedules!).toString())}", style: AppTheme.blueAppTitle3,),

                ],
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Unpaid', style: AppTheme.appTitle3,),
                  Text("${selectedCurrencyCode.isEmpty ? currentUserBaseCurrencyCode : selectedCurrencyCode} ${amountFormatter.format(sumUnpaidListRecursive(state.paymentSchedules!).toString())}", style: AppTheme.blueAppTitle3,),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: ()async{

                var occupiedCount;
                var vacantCount;
                var totalUnitCount;

                DateTime jDate = DateTime.parse(dateToday.isEmpty ? DateTime.now().toString() :  dateToday.trim());

                var newFDate = DateFormat('d MMM, yy').format(jDate);

                if(dateToday.isEmpty){
                  print('empty null used date =$dateToday');
                  print('empty null used date =$dateToday');
                } else {
                  print('date isnt null or empty $jDate');
                  print('formatted date $newFDate');
                }
                List<int> getUniqueIds(List<CollectionsReportModel> items) {
                  Set<int> idSet = {};
                  for (var item in items) {
                    if (item.tenantunit!.id != 0) {
                      idSet.add(item.tenantunit!.id!);
                    }
                    // idSet.add(item.id!);
                  }
                  occupiedCount = idSet.toList().length;
                  print('my Occupied Count = $occupiedCount');
                  return idSet.toList();
                }

                List<int> getUniqueVacantIds(List<CollectionsReportModel> items) {
                  Set<int> idSet = {};
                  for (var item in items) {
                    if (item.tenantunit!.unit!.isAvailable == 1) {
                      idSet.add(item.tenantunit!.unit!.id!);
                    }
                    // idSet.add(item.id!);
                  }
                  vacantCount = idSet.toList().length;
                  print('my Vacant Count = $vacantCount');
                  return idSet.toList();
                }


                List<int> uniqueItems = getUniqueIds(state.paymentSchedules!);
                List<int> uniqueVacantItems = getUniqueVacantIds(state.paymentSchedules!);
                print('my occupied list is $uniqueItems');
                print('my vacant list is $uniqueVacantItems');


                totalUnitCount = occupiedCount + vacantCount;
                print('my total Count = $totalUnitCount');



                final data = await collectionsReceiptPrintPdf.createReceiptPdf(state.paymentSchedules!, sumUnpaidListRecursive(state.paymentSchedules!), selectedPropertyName,
                    sumAmountDueListRecursive(state.paymentSchedules!), sumPaidListRecursive(state.paymentSchedules!),
                    dateToday,newFDate, selectedCurrencyCode, totalUnitCount, occupiedCount, vacantCount, selectedPropertyTotalUnits, selectedPropertyOccupiedUnits, selectedPropertyVacantUnits);
                await collectionsReceiptPrintPdf.savePdfFile(
                    'Smart_Rent_Collections_Receipt_$number', data);
                number++;



              },
              child: SizedBox(
                width: 100,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.print),
                          Text('Print')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}




class CollectionsReportDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  CollectionsReportDataSource({required List<CollectionsReportModel> paymentData, required String selectedCurrencyCode}) {
    _paymentData =  paymentData
        .map<DataGridRow>((schedule) => DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'unit', value: '${schedule.tenantunit!.unit!.name}'),
        DataGridCell<String>(columnName: 'tenant', value: schedule.tenantunit!.tenant == null ? 'Vacant' : schedule.tenantunit!.tenant!.clientTypeId == 1
            ? '${schedule.tenantunit!.tenant!.clientProfiles!.first.firstName!.capitalizeFirst} ${schedule.tenantunit!.tenant!.clientProfiles!.first.lastName!.capitalizeFirst}'.replaceAll('_', ' ')
            : schedule.tenantunit!.tenant!.clientProfiles!.first.companyName!.replaceAll('_', ' ')),
        // DataGridCell<String>(columnName: 'paid', value: amountFormatter.format(schedule.paid.toString())),
        // DataGridCell<String>(columnName: 'balance', value: amountFormatter.format(schedule.balance.toString())),
        DataGridCell<String>(columnName: 'paid', value:  currentUserBaseCurrencyCode == selectedCurrencyCode ? (schedule.basePaid == null ? 0.toString() : amountFormatter.format(schedule.basePaid.toString()))
            : (schedule.foreignPaid == null ? 0.toString() : amountFormatter.format(schedule.foreignPaid.toString()))
        ),
        DataGridCell<String>(columnName: 'balance', value:  currentUserBaseCurrencyCode == selectedCurrencyCode ? (schedule.baseBalance == null ? 0.toString() : amountFormatter.format(schedule.baseBalance.toString()))
            : (schedule.foreignBalance == null ? 0.toString() : amountFormatter.format(schedule.foreignBalance.toString()))
        ),
        // DataGridCell<String>(columnName: 'balance', value: schedule.baseBalance == null ? 0.toString() : amountFormatter.format(schedule.baseBalance.toString())),
      ],
    ))
        .toList();
  }

  List<DataGridRow> _paymentData = [];

  @override
  List<DataGridRow> get rows => _paymentData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString(), textAlign: TextAlign.center,),
          );
        }).toList());
  }
}

