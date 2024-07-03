import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smart_rent/data_layer/models/currency/currency_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_account_model.dart';

import 'package:smart_rent/data_layer/models/reports/payments/payments_report_model.dart';
import 'package:smart_rent/data_layer/models/smart_model.dart';
import 'package:smart_rent/ui/pages/collections_report/bloc/collections_report_bloc.dart';
import 'package:smart_rent/ui/pages/currency/bloc/currency_bloc.dart';
import 'package:smart_rent/ui/pages/payments/bloc/payment_bloc.dart';
import 'package:smart_rent/ui/pages/payments_report/bloc/payments_report_bloc.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_drop_downs.dart';
import 'package:smart_rent/ui/widgets/app_search_textfield.dart';
import 'package:smart_rent/ui/widgets/auth_textfield.dart';
import 'package:smart_rent/ui/widgets/smart_widget.dart';
import 'package:smart_rent/utilities/app_init.dart';
import 'package:smart_rent/utilities/extra.dart';
///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PaymentsWidget extends StatefulWidget {
  const PaymentsWidget({super.key});

  @override
  State<PaymentsWidget> createState() => _PaymentsWidgetState();
}

class _PaymentsWidgetState extends State<PaymentsWidget> {

  TextEditingController searchController = TextEditingController();

  List<PaymentReportModel> payments = <PaymentReportModel>[];
  List<PaymentReportModel> filteredData = <PaymentReportModel>[];
  late PaymentScheduleDataSource paymentDataSource;

  late SingleValueDropDownController _propertyModelCont;

  int selectedPropertyId = 0;
  CurrencyModel? currencyModel;
  String selectedCurrencyCode = '';
  int selectedCurrencyId = 0;



  void filterPayments(String query) {
    setState(() {
      filteredData = payments.where((collection) {
        // Check if any required fields are null before accessing them
        if (collection.tenantunit == null ||
            collection.tenantunit!.tenant == null ||
            collection.tenantunit!.tenant!.clientProfiles == null ||
            collection.account == null) {
          return false;
        }

        // Perform filtering based on the query
        return collection.tenantunit!.unit!.name.toString().toLowerCase().contains(query.toLowerCase()) ||
            collection.tenantunit!.tenant!.clientProfiles!.first.firstName.toString().toLowerCase().contains(query.toLowerCase()) ||
            collection.tenantunit!.tenant!.clientProfiles!.first.lastName.toString().toLowerCase().contains(query.toLowerCase()) ||
            collection.tenantunit!.tenant!.clientProfiles!.first.companyName.toString().toLowerCase().contains(query.toLowerCase()) ||
            collection.account!.name.toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
    print('My Filtered payments List $filteredData');
    print('My Initial payments List $payments');
  }


  // void filterPayments(String query,) {
  //
  //   setState(() {
  //     filteredData = payments
  //         .where((collection) =>
  //     collection.tenantunit!.unit!.name
  //         .toString()
  //         .toLowerCase()
  //         .contains(query.toLowerCase())
  //         ||
  //         collection.tenantunit!.tenant!.clientProfiles!.first.firstName
  //             .toString()
  //             .toLowerCase()
  //             .contains(query.toLowerCase())
  //         ||
  //         collection.tenantunit!.tenant!.clientProfiles!.first.lastName
  //             .toString()
  //             .toLowerCase()
  //             .contains(query.toLowerCase())
  //         ||
  //         collection.tenantunit!.tenant!.clientProfiles!.first.companyName
  //             .toString()
  //             .toLowerCase()
  //             .contains(query.toLowerCase())
  //         ||
  //         collection.account!.name
  //             .toString()
  //             .toLowerCase()
  //             .contains(query.toLowerCase())
  //     )
  //         .toList();
  //   });
  //   print('My Filtered payments List $filteredData');
  //   print('My Initial payments List $payments');
  // }

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
    dateToday = '${today.year}-${today.month}-${today.day}';
    print('init date $dateToday');
    selectedCurrencyCode =  currentUserBaseCurrencyCode.toString();

  }

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: AppSearchTextField(
            controller: searchController,
            hintText: 'Search',
            obscureText: false,
            function: (){},
            onChanged: filterPayments,
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
                      hintText: 'Property',
                      menuItems: state.properties == null ? [] : state.properties!,
                      controller: _propertyModelCont,
                      onChanged: (value) {
                        setState(() {
                          selectedPropertyId = value.value.id;
                        });
                        print('Property is $selectedPropertyId');
                        context.read<PaymentsReportBloc>().add(LoadPaymentsReportSchedules(selectedPropertyId, dateToday.isEmpty ? formatedDate1 : dateToday, selectedCurrencyId));
                        searchController.clear();
                        filteredData.clear();
                      },
                      // fillColor: AppTheme.grey_100,
                      fillColor: Colors.transparent,
                      height: 35,
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                    );
                  },
                ),
              ),

              Container(
                width: 160,
                child:BlocBuilder<PaymentsReportBloc, PaymentsReportState>(
                builder: (context, state) {
                  if (state.status == PaymentReportStatus.initial) {
                    context.read<PaymentsReportBloc>().add(LoadPaymentsDates());
                  }
                  if (state.status == PaymentReportStatus.emptyPeriods) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: AppTextField(
                        hintText: 'No Dates',
                        obscureText: false,
                        enabled: false,
                      ),
                    );
                  }
                  if (state.status == PaymentReportStatus.errorPeriods) {
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
                      print('latest date = $myNewValue');
                      print('date Today = $dateToday');
                      setState(() {
                        dateToday =myNewValue;
                      });

                      if(selectedPropertyId == 0) {
                        Fluttertoast.showToast(msg: 'Now select a property', gravity: ToastGravity.TOP);

                      } else {
                        context.read<PaymentsReportBloc>().add(LoadPaymentsReportSchedules(selectedPropertyId, myNewValue, selectedCurrencyId));
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
                          // if (value != null) {
                          //   currency = value;
                          // }
                          if(selectedPropertyId == 0) {
                            Fluttertoast.showToast(msg: 'Now select a property', gravity: ToastGravity.TOP);

                          } else {
                            context.read<PaymentsReportBloc>().add(LoadPaymentsReportSchedules(selectedPropertyId, dateToday.isEmpty ? formatedDate1 : dateToday, selectedCurrencyId));
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

        // const SizedBox(height: 10),
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
        //           fillColor: AppTheme.grey_100,
        //           hintText: 'Select currency',
        //           menuItems: state.currencies == null
        //               ? []
        //               : state.currencies!,
        //           onChanged: (value) {
        //             setState(() {
        //               selectedCurrencyId = value!.id!;
        //               // baseCurrencyCode = value.code.toString();
        //               selectedCurrencyCode = value.code.toString();
        //             });
        //             // if (value != null) {
        //             //   currency = value;
        //             // }
        //             if(selectedPropertyId == 0) {
        //               Fluttertoast.showToast(msg: 'Now select a property', gravity: ToastGravity.TOP);
        //
        //             } else {
        //               context.read<PaymentsReportBloc>().add(LoadPaymentsReportSchedules(selectedPropertyId, dateToday.isEmpty ? formatedDate1 : dateToday, selectedCurrencyId));
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


        BlocBuilder<PaymentsReportBloc, PaymentsReportState>(
          builder: (context, state) {


            if (state.status ==  PaymentReportStatus.initial) {
              // context.read<PaymentsReportBloc>().add(LoadPaymentsReportSchedules());
            }
            if (state.status == PaymentReportStatus.success) {

              payments = state.paymentSchedules!;
              paymentDataSource = PaymentScheduleDataSource(paymentData:filteredData.isEmpty ?  payments : filteredData, selectedCurrencyCode: selectedCurrencyCode);
              return _buildBody(context, state, paymentDataSource);
            }
            if (state.status == PaymentReportStatus.loading) {
              return const LoadingWidget();
            }
            if (state.status == PaymentReportStatus.error) {
              return Center(child: Text('Error loading payments report table', style: AppTheme.blueAppTitle3,),);
              // return SmartErrorWidget(
              //   message: 'Error loading unpaid report table',
              //   onPressed: () {
              //     context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules());
              //   },
              // );
            }
            if (state.status == PaymentReportStatus.empty) {
              return Center(child: Text('No Payments Report', style: AppTheme.blueAppTitle3,),);
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

  Widget _buildBody(BuildContext context, PaymentsReportState state,
      PaymentScheduleDataSource paymentDataSource) {
    return Expanded(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          //   child: AppSearchTextField(
          //     controller: searchController,
          //     hintText: 'Search',
          //     obscureText: false,
          //     function: () {},
          //   ),
          // ),
          // SizedBox(height: 5),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8),
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
          //             child: SearchablePropertyModelListDropDown<SmartPropertyModel>(
          //               hintText: 'Property',
          //               menuItems: state.properties == null ? [] : state.properties!,
          //               controller: _propertyModelCont,
          //               onChanged: (value) {
          //                 setState(() {
          //                   selectedPropertyId = value.value.id;
          //                 });
          //                 print('Property is $selectedPropertyId');
          //               },
          //               fillColor: AppTheme.grey_100,
          //               height: 35,
          //               contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //
          //             ),
          //           );
          //         },
          //       ),
          //       SizedBox(width: 10),
          //       Expanded(
          //         child: CustomGenericDropdown(
          //           hintText: 'Select Period',
          //           menuItems: [],
          //           fillColor: AppTheme.grey_100,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 5),
          _buildHeader(context, state), // Assuming _buildHeader returns a widget
          Divider(color: AppTheme.inActiveColor),
          Expanded(child: _buildDataTable(paymentDataSource)), // Assuming _buildDataTable returns a widget
          SizedBox(height: 90),
        ],
      ),
    );


    // return Column(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
    //       child: AppSearchTextField(
    //         controller: searchController,
    //         hintText: 'Search',
    //         obscureText: false,
    //         function: (){},
    //       ),
    //     ),
    //
    //     SizedBox(height: 5,),
    //      Padding(
    //       padding:EdgeInsets.symmetric(horizontal: 8,),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           BlocBuilder<PropertyBloc, PropertyState>(
    //             builder: (context, state) {
    //               if (state.status == PropertyStatus.initial) {
    //                 context
    //                     .read<PropertyBloc>()
    //                     .add(LoadPropertiesEvent());
    //               }
    //               if (state.status == PropertyStatus.empty) {
    //                 return  Padding(
    //                   padding: EdgeInsets.only(bottom: 10),
    //                   child: AppTextField(
    //                     hintText: 'No Properties',
    //                     obscureText: false,
    //                     enabled: false,
    //                   ),
    //                 );
    //               }
    //               if (state.status == PropertyStatus.error) {
    //                 return const Center(
    //                   child: Text('An Error Occurred'),
    //                 );
    //               }
    //               return Expanded(
    //                 child: SearchablePropertyModelListDropDown<SmartPropertyModel>(
    //                   hintText: 'Property',
    //                   menuItems: state.properties == null
    //                       ? []
    //                       : state.properties!,
    //                   controller: _propertyModelCont,
    //                   onChanged: (value) {
    //                     setState(() {
    //                       selectedPropertyId = value.value.id;
    //                     });
    //
    //
    //                     print('Property is $selectedPropertyId}');
    //                   },
    //                 ),
    //               );
    //             },
    //           ),
    //           // Expanded(child: CustomGenericDropdown(hintText: 'Select Property', menuItems: [],
    //           //   fillColor: AppTheme.grey_100,
    //           // )),
    //           SizedBox(width: 10,),
    //           Expanded(child: CustomGenericDropdown(hintText: 'Select Period', menuItems: [],
    //             fillColor: AppTheme.grey_100,
    //           )),
    //
    //         ],
    //       ),
    //     ),
    //     SizedBox(height: 5,),
    //
    //     _buildHeader(context, state),
    //     const Divider(
    //       color: AppTheme.inActiveColor,
    //     ),
    //     Expanded(child: _buildDataTable(paymentDataSource)),
    //     const SizedBox(height: 90),
    //   ],
    // );
  }

  Widget _buildDataTable(PaymentScheduleDataSource paymentDataSource) {
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
          columnName: 'tenant',
          label: Container(
              padding: const EdgeInsets.all(1.0),
              alignment: Alignment.center,
              child:  Text(
                'Tenant',
                style: AppTheme.tableTitle1,
              ))),
      GridColumn(
          columnName: 'unit',
          width: 65,
          label: Container(
              padding: const EdgeInsets.all(1.0),
              alignment: Alignment.center,
              child:  Text('Unit',
                style: AppTheme.tableTitle1,
              ))),
      GridColumn(
          columnName: 'amount',
          label: Container(
              padding: const EdgeInsets.all(1.0),
              alignment: Alignment.center,
              child:  Text(
                'Amount',
                overflow: TextOverflow.ellipsis,
                style: AppTheme.tableTitle1,
              ))),
      GridColumn(
          columnName: 'account',
          label: Container(
              padding: const EdgeInsets.all(1.0),
              alignment: Alignment.center,
              child:  Text(
                'Account',
                overflow: TextOverflow.ellipsis,
                style: AppTheme.tableTitle1,
              ))),
    ];
  }

  // List<PaymentsModel> getPaymentData(BuildContext context) {
  //   // return context.read<PaymentBloc>().state.payments!;
  //   return [
  //     PaymentsModel(
  //       description: 'Ashley Aisha',
  //         property: Property(name: 'F1-001'),
  //         amount: 100000000,
  //       paymentAccountsModel: PaymentAccountsModel(name: 'Petty Cash')
  //     ),
  //     PaymentsModel(
  //         description: 'Ashley Aisha',
  //         property: Property(name: 'F1-001'),
  //         amount: 100000000,
  //         paymentAccountsModel: PaymentAccountsModel(name: 'Petty Cash')
  //     ),
  //     PaymentsModel(
  //         description: 'Ashley Aisha',
  //         property: Property(name: 'F1-001'),
  //         amount: 100000000,
  //         paymentAccountsModel: PaymentAccountsModel(name: 'Petty Cash')
  //     ),
  //     PaymentsModel(
  //         description: 'Ashley Aisha',
  //         property: Property(name: 'F1-001'),
  //         amount: 100000000,
  //         paymentAccountsModel: PaymentAccountsModel(name: 'Petty Cash')
  //     ),
  //     PaymentsModel(
  //         description: 'Ashley Aisha',
  //         property: Property(name: 'F1-001'),
  //         amount: 100000000,
  //         paymentAccountsModel: PaymentAccountsModel(name: 'Petty Cash')
  //     ),     PaymentsModel(
  //         description: 'Ashley Aisha',
  //         property: Property(name: 'F1-001'),
  //         amount: 100000000,
  //         paymentAccountsModel: PaymentAccountsModel(name: 'Petty Cash')
  //     ),
  //     PaymentsModel(
  //         description: 'Ashley Aisha',
  //         property: Property(name: 'F1-001'),
  //         amount: 100000000,
  //         paymentAccountsModel: PaymentAccountsModel(name: 'Petty Cash')
  //     ),
  //     PaymentsModel(
  //         description: 'Ashley Aisha',
  //         property: Property(name: 'F1-001'),
  //         amount: 100000000,
  //         paymentAccountsModel: PaymentAccountsModel(name: 'Petty Cash')
  //     ),
  //
  //
  //
  //   ];
  // }

  // Widget _buildDataTable() {


  Widget _buildHeader(BuildContext context, PaymentsReportState state) {

    int sumListRecursive(List<PaymentReportModel> numbers) {
      if (numbers.isEmpty) {
        return 0;
      }
      return currentUserBaseCurrencyCode == selectedCurrencyCode ? (numbers.first.baseAmount == null ? 0 : numbers.first.baseAmount! + sumListRecursive(numbers.sublist(1)))
          : (numbers.first.foreignAmount == null ? 0 :numbers.first.foreignAmount! + sumListRecursive(numbers.sublist(1)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Payments', style: AppTheme.appTitle3,),
          // DropdownButtonHideUnderline(
          //   child: DropdownButton2<String>(
          //     isExpanded: true,
          //     hint: Text(
          //       'Select period',
          //       style: TextStyle(
          //         fontSize: 14,
          //         color: Theme.of(context).hintColor,
          //       ),
          //     ),
          //     items: items
          //         .map((String item) => DropdownMenuItem<String>(
          //               value: item,
          //               child: Text(
          //                 item,
          //                 style: const TextStyle(
          //                   fontSize: 14,
          //                 ),
          //               ),
          //             ))
          //         .toList(),
          //     value: selectedValue,
          //     onChanged: (String? value) {
          //       // TODO: Add state management here later.
          //     },
          //     buttonStyleData: const ButtonStyleData(
          //       padding: EdgeInsets.symmetric(horizontal: 16),
          //       height: 40,
          //       width: 140,
          //     ),
          //     menuItemStyleData: const MenuItemStyleData(
          //       height: 40,
          //     ),
          //   ),
          // ),
           Text("${selectedCurrencyCode.isEmpty ? currentUserBaseCurrencyCode : selectedCurrencyCode} ${amountFormatter.format(sumListRecursive(state.paymentSchedules!).toString())}", style: AppTheme.blueAppTitle3,),
        ],
      ),
    );
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
// class PaymentDataSource extends DataGridSource {
//   /// Creates the employee data source class with required details.
//   PaymentDataSource({required List<PaymentsModel> paymentData}) {
//     _paymentData = paymentData
//         .map<DataGridRow>((payment) => DataGridRow(cells: [
//       DataGridCell<String>(columnName: 'tenant', value: payment.description),
//               // DataGridCell<String>(columnName: 'tenant', value: payment.tenantUnitModel!.tenant!.clientTypeId == 1
//               //     ? '${payment.tenantUnitModel!.tenant!.clientProfiles!.first.firstName} ${payment.tenantUnitModel!.tenant!.clientProfiles!.first.lastName}'
//               //     : '${payment.tenantUnitModel!.tenant!.clientProfiles!.first.companyName}'),
//               DataGridCell<String>(columnName: 'unit', value: payment.property!.name),
//               DataGridCell<String>(columnName: 'amount', value: amountFormatter.format(payment.amount.toString())),
//               DataGridCell<String>(columnName: 'account', value: payment.paymentAccountsModel!.name)
//             ]))
//         .toList();
//   }
//
//   List<DataGridRow> _paymentData = [];
//
//   @override
//   List<DataGridRow> get rows => _paymentData;
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((e) {
//       return Container(
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(8.0),
//         child: Text(e.value.toString(), textAlign: TextAlign.center,),
//       );
//     }).toList());
//   }
// }


class PaymentScheduleDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  PaymentScheduleDataSource({required List<PaymentReportModel> paymentData, required String selectedCurrencyCode}) {
    _paymentData = paymentData
        .map<DataGridRow>((schedule) => DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'tenant', value: schedule.tenantunit.isNull ? '' : schedule.tenantunit!.tenant!.clientTypeId == 1
            ? '${schedule.tenantunit!.tenant!.clientProfiles!.first.firstName!.capitalizeFirst} ${schedule.tenantunit!.tenant!.clientProfiles!.first.lastName!.capitalizeFirst}'.replaceAll('_', ' ')
            : schedule.tenantunit!.tenant!.clientProfiles!.first.companyName!.replaceAll('_', ' ')),
        DataGridCell<String>(columnName: 'unit', value: schedule.tenantunit.isNull ? '' : '${schedule.tenantunit!.unit!.name}'),
        // DataGridCell<String>(columnName: 'period', value: '${DateFormat('d MMM, yy').format(schedule!)}\n${DateFormat('d MMM, yy').format(schedule.toDate!)}'),
        DataGridCell<String>(columnName: 'amount', value: currentUserBaseCurrencyCode == selectedCurrencyCode ? (amountFormatter.format(schedule.baseAmount == null ? 0.toString() : schedule.baseAmount.toString()))
            : amountFormatter.format(schedule == null ? 0.toString() : schedule.foreignAmount.toString())),
        DataGridCell<String>(columnName: 'account', value: schedule.account.isNull ? '' :schedule.account!.name.toString().replaceAll('_', ' ')),
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
