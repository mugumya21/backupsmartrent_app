import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smart_rent/data_layer/models/currency/currency_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_reports_schedule_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_schedules_model.dart';
import 'package:smart_rent/data_layer/models/smart_model.dart';
import 'package:smart_rent/ui/pages/currency/bloc/currency_bloc.dart';
import 'package:smart_rent/ui/pages/payments/bloc/payment_bloc.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/pages/unpaid_reports/bloc/un_paid_report_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_drop_downs.dart';
import 'package:smart_rent/ui/widgets/app_search_textfield.dart';
import 'package:smart_rent/ui/widgets/auth_textfield.dart';
import 'package:smart_rent/ui/widgets/smart_error_widget.dart';
import 'package:smart_rent/ui/widgets/smart_widget.dart';
import 'package:smart_rent/utilities/app_init.dart';
import 'package:smart_rent/utilities/extra.dart';
///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../data_layer/models/property/property_response_model.dart';

class UnpaidWidget extends StatefulWidget {
  const UnpaidWidget({super.key});

  @override
  State<UnpaidWidget> createState() => _UnpaidWidgetState();
}

class _UnpaidWidgetState extends State<UnpaidWidget> {



  TextEditingController searchController = TextEditingController();

  List<UnpaidReportScheduleModel> payments = <UnpaidReportScheduleModel>[];
  List<UnpaidReportScheduleModel> filteredData = <UnpaidReportScheduleModel>[];
  late UnpaidPaymentScheduleDataSource paymentDataSource;

  late SingleValueDropDownController _propertyModelCont;

  int selectedPropertyId = 0;

  DateTime nextMonthDate = DateTime.now().add(Duration(days: 30));

  void filterUnpaidReports(String query,) {

    setState(() {
      filteredData = payments
          .where((schedule) =>
      schedule.unitModel!.name
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())
          ||
          schedule.tenantUnitModel!.tenant!.clientProfiles!.first.firstName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())
          ||
          schedule.tenantUnitModel!.tenant!.clientProfiles!.first.lastName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())
          ||
          schedule.tenantUnitModel!.tenant!.clientProfiles!.first.companyName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())
          || DateFormat('d MMM, yy')
          .format(schedule.fromDate!)
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()) ||
          DateFormat('d MMM, yy')
              .format(schedule.fromDate!)
              .toLowerCase()
              .contains(query.toLowerCase())
      )
          .toList();
    });
    print('My Filtered Collections List $filteredData');
    print('My Initial Collections List $payments');
  }

  DateTime yesterday = DateTime.now().add(Duration(days: 30));
  late String dateYesterday;

  DateTime today = DateTime.now();
  late String dateToday;

  CurrencyModel? currencyModel;
  String selectedCurrencyCode = '';
  int selectedCurrencyId = 0;


  var myDate = DateTime.now();
  late String formatedDate1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _propertyModelCont = SingleValueDropDownController();
    formatedDate1 = "${myDate.year}-${myDate.month}-${myDate.day}";
    dateToday = '';
    // dateToday = '${today.year}-${today.month}-${today.day}';
    dateYesterday = '${yesterday.year}-${yesterday.month}-${yesterday.day}';
    print('init unpaid date $dateToday');
    selectedCurrencyCode =  currentUserBaseCurrencyCode.toString();

  }

  @override
  Widget build(BuildContext context) {

    var value = DateTime.now().add(Duration(days: 30));
    var nextMonthFormattedDate = value.toString().replaceRange(11, value.toString().length, '');

    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: AppSearchTextField(
            controller: searchController,
            hintText: 'Search',
            obscureText: false,
            function: (){},
            onChanged: filterUnpaidReports,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width : 130,
                child: BlocBuilder<UnPaidReportBloc, UnPaidReportState>(
                builder: (context, state) {
                  if (state.status == UnpaidReportStatus.initial) {
                    context.read<UnPaidReportBloc>().add(LoadUnpaidProperties());
                  }
                  if (state.status == UnpaidReportStatus.emptyReportProperties) {
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
                  if (state.status == UnpaidReportStatus.errorReportProperties) {
                    return const Center(
                      child: Text('An Error Occurred'),
                    );
                  }

                  return SearchableReportPropertyModelListDropDown<SmartPropertyModel>(
                    hintText: 'Property',
                    menuItems: state.properties == null ? [] : state.properties!,
                    controller: _propertyModelCont,
                    onChanged: (value) {
                      setState(() {
                        selectedPropertyId = value.value.id;
                      });
                      print('Property is $selectedPropertyId');

                      if(dateToday == nextMonthFormattedDate){
                        context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, '', today, selectedCurrencyId));
                        searchController.clear();
                        filteredData.clear();
                      } else  {
                        context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, dateToday, today, selectedCurrencyId));
                        searchController.clear();
                        filteredData.clear();

                      }

                      // context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, dateToday, today));
                      // searchController.clear();
                      // filteredData.clear();
                      print('Property is $selectedPropertyId');
                    },
                    fillColor: Colors.transparent,
                    height: 35,
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                  );
                },
              ),),
              // SizedBox(width: 10,),
             Container(
               width: 160,
               child:  BlocBuilder<UnPaidReportBloc, UnPaidReportState>(
               builder: (context, state) {
                 if (state.status == UnpaidReportStatus.initial) {
                   context.read<UnPaidReportBloc>().add(LoadUnpaidPeriods());
                 }
                 if (state.status == UnpaidReportStatus.emptyPeriods) {
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
                 if (state.status == UnpaidReportStatus.emptyPeriods) {
                   return const Center(
                     child: Text('An Error Occurred'),
                   );
                 }

                 return CustomUnpaidReportPeriodGenericDropdown<dynamic>(
                   defaultValue: state.periods == null ? DateTime.now() : state.periods!.first,
                   hintText: 'Select Period *',
                   menuItems: state.periods == null ? [] : state.periods!,
                   fillColor: Colors.transparent,
                   onChanged: (value){
                     print('my dater ${value}');
                     var myNewValue =  value.toString().replaceRange(11, value.toString().length, '');
                     print('latest date = $myNewValue');
                     print('date Today = $dateToday');
                     setState(() {
                       dateToday =myNewValue;
                       today = value as DateTime;
                     });

                     print('newsest date =$nextMonthFormattedDate');

                     print('todays String Date = $dateToday');
                     print('todays date = $today');
                     print('todays date2 = ${DateTime.now().add(Duration(days: 30))}');

                     // print('my formDate = ${myFormattedTomorrowDate.runtimeType}');
                     // print('my formDate = ${myFormattedTomorrowDate}');
                     if(dateToday == nextMonthFormattedDate){
                       context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, '', today, selectedCurrencyId));
                       searchController.clear();
                       filteredData.clear();
                     } else  {
                       context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, dateToday, today, selectedCurrencyId));
                       searchController.clear();
                       filteredData.clear();

                     }

                     // context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, myNewValue, today));
                     // searchController.clear();
                     // filteredData.clear();


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
                          if(dateToday == nextMonthFormattedDate){
                            context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, '', today, selectedCurrencyId));
                            searchController.clear();
                            filteredData.clear();
                          } else  {
                            context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, dateToday, today, selectedCurrencyId));
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

        // Container(
        //   width: 100,
        //   child: BlocBuilder<CurrencyBloc, CurrencyState>(
        //     builder: (context, state) {
        //       if (state.status.isInitial) {
        //         context
        //             .read<CurrencyBloc>()
        //             .add(LoadAllCurrenciesEvent(selectedPropertyId));
        //       }
        //       if (state.status.isSuccess) {
        //         // currencyModel = state.currencies.firstWhere(
        //         //       (currency) => currency.code == 'UGX',
        //         //   // orElse: () => null as CurrencyModel,
        //         // );
        //         currencyModel = state.currencies.firstWhere(
        //               (currency) => currentUserBaseCurrencyCode == currency.code,
        //           // orElse: () => currencyModel!, // Provide a default CurrencyModel object
        //         );
        //
        //         return SizedBox(
        //           width: 200,
        //           child: CustomApiGenericDropdown<CurrencyModel>(
        //             fillColor: AppTheme.grey_100,
        //             hintText: 'Select currency',
        //             menuItems: state.currencies == null
        //                 ? []
        //                 : state.currencies!,
        //             onChanged: (value) {
        //               setState(() {
        //                 selectedCurrencyId = value!.id!;
        //                 // baseCurrencyCode = value.code.toString();
        //                 selectedCurrencyCode = value.code.toString();
        //               });
        //               // if (value != null) {
        //               //   currency = value;
        //               // }
        //               if(dateToday == nextMonthFormattedDate){
        //                 context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, '', today, selectedCurrencyId));
        //                 searchController.clear();
        //                 filteredData.clear();
        //               } else  {
        //                 context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, dateToday, today, selectedCurrencyId));
        //                 searchController.clear();
        //                 filteredData.clear();
        //
        //               }
        //
        //             },
        //             defaultValue: currencyModel,
        //           ),
        //         );
        //       }
        //       // if (state.status.isLoading) {
        //       //   return Column(
        //       //     children: [
        //       //       SizedBox(
        //       //         height: 50,
        //       //         child: Container(
        //       //           decoration: BoxDecoration(
        //       //             borderRadius: BorderRadius.circular(10),
        //       //             color: Colors.white,
        //       //           ),
        //       //           child: const Center(
        //       //             child: CupertinoActivityIndicator(),
        //       //           ),
        //       //         ),
        //       //       ),
        //       //       const SizedBox(height: 10),
        //       //     ],
        //       //   );
        //       // }
        //       return const SizedBox(height: 10);
        //     },
        //   ),
        // ),

        SizedBox(height: 5,),
        
        BlocBuilder<UnPaidReportBloc, UnPaidReportState>(
          builder: (context, state) {
        
        
            if (state.status ==  UnpaidReportStatus.initial) {
              context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules(selectedPropertyId, dateToday, today, selectedCurrencyId));
            }
            if (state.status == UnpaidReportStatus.success) {
        
              payments = state.paymentSchedules ?? <UnpaidReportScheduleModel>[];
              paymentDataSource = UnpaidPaymentScheduleDataSource(paymentData: filteredData.isEmpty ? payments : filteredData, selectedCurrencyCode: selectedCurrencyCode);
              return _buildBody(context, state, paymentDataSource);
            }
            if (state.status == UnpaidReportStatus.loading) {
              return const LoadingWidget();
            }
            if (state.status == UnpaidReportStatus.error) {
              return Center(child: Text('Error loading unpaid report table', style: AppTheme.blueAppTitle3,),);
              // return SmartErrorWidget(
              //   message: 'Error loading unpaid report table',
              //   onPressed: () {
              //     context.read<UnPaidReportBloc>().add(LoadUnpaidReportSchedules());
              //   },
              // );
            }
            if (state.status == UnpaidReportStatus.empty) {
              return Center(child: Text('No Unpaid Report', style: AppTheme.blueAppTitle3,),);
              // return NoDataWidget(
              //   message: "No payments available",
              //   onPressed: () {
              //     context.read<PaymentBloc>().add(LoadPayments());
              //   },
              // );
            }
            return const SmartWidget();
            return _buildBody(context, state, paymentDataSource);
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, UnPaidReportState state,
      UnpaidPaymentScheduleDataSource paymentDataSource,
      ) {

    return Expanded(

        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     children: [
            //       AppSearchTextField(
            //           controller: TextEditingController(),
            //           hintText: 'Search',
            //           obscureText: false,
            //           function: (){},
            //       ),
            //       SizedBox(height: 5,),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           BlocBuilder<PropertyBloc, PropertyState>(
            //             builder: (context, state) {
            //               if (state.status == PropertyStatus.initial) {
            //                 context.read<PropertyBloc>().add(LoadPropertiesEvent());
            //               }
            //               if (state.status == PropertyStatus.empty) {
            //                 return Padding(
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
            //               );
            //             },
            //           ),
            //           SizedBox(width: 10,),
            //           BlocBuilder<UnPaidReportBloc, UnPaidReportState>(
            //             builder: (context, state) {
            //               if (state.status == UnpaidReportStatus.initial) {
            //                 context.read<UnPaidReportBloc>().add(LoadUnpaidPeriods());
            //               }
            //               if (state.status == UnpaidReportStatus.empty) {
            //                 return Padding(
            //                   padding: EdgeInsets.only(bottom: 10),
            //                   child: AppTextField(
            //                     hintText: 'No Dates',
            //                     obscureText: false,
            //                     enabled: false,
            //                   ),
            //                 );
            //               }
            //               if (state.status == UnpaidReportStatus.error) {
            //                 return const Center(
            //                   child: Text('An Error Occurred'),
            //                 );
            //               }
            //               return Expanded(
            //                   child: CustomGenericDropdown<dynamic>(
            //                     hintText: 'Select Period',
            //                     menuItems: state.periods == null ? [] : state.periods!,
            //                     fillColor: AppTheme.grey_100,
            //                     onChanged: (value){
            //
            //                     },
            //                   ));
            //               },
            //           ),
            //
            //         ],
            //       ),
            //
            //
            //     ],
            //   ),
            // ),
            //
            // SizedBox(height: 5,),

            // _buildHeader(context, state),
            _buildHeader(context),
            const Divider(
              color: AppTheme.inActiveColor,
            ),
            Expanded(child: _buildDataTable(paymentDataSource)),
            const SizedBox(height: 90),
          ],
        ),
      );
  }

  Widget _buildDataTable(UnpaidPaymentScheduleDataSource paymentDataSource) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: AppTheme.gray.withOpacity(.2),
        headerHoverColor: AppTheme.gray.withOpacity(.3),
      ),
      child: SfDataGrid(
        onQueryRowHeight: (details) {
          if (details.rowIndex == 0) {
            return 40;
          }
          return details.getIntrinsicRowHeight(details.rowIndex);
        },
        // allowSorting: true,
        // allowFiltering: true,
        allowSwiping: false,
        allowTriStateSorting: true,
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
              alignment: Alignment.center, child:  Text('Unit',
            style: AppTheme.tableTitle1,
          ))),

      GridColumn(
          columnName: 'period',
          label: Container(
              padding: const EdgeInsets.all(1.0),
              alignment: Alignment.center, child:  Text('Period',
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
    ];
  }


  Widget _buildHeader(BuildContext context,
      // UnPaidReportState state,
      ) {
    int sumListRecursive(List<UnpaidReportScheduleModel> numbers) {
      if (numbers.isEmpty) {
        return 0;
      }
      return currentUserBaseCurrencyCode == selectedCurrencyCode ? (numbers.first.baseDiscountAmount == null ? 0 : numbers.first.baseDiscountAmount! + sumListRecursive(numbers.sublist(1)))
          : (numbers.first.foreignDiscountAmount == null ? 0 : numbers.first.foreignDiscountAmount! + sumListRecursive(numbers.sublist(1)));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Unpaid:', style: AppTheme.appTitle3,),
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
           Text("${selectedCurrencyCode.isEmpty ? currentUserBaseCurrencyCode : selectedCurrencyCode}  ${amountFormatter.format(sumListRecursive(payments).toString())}",
             style: AppTheme.blueAppTitle3,
           ),
        ],
      ),
    );
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.


class UnpaidPaymentScheduleDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  UnpaidPaymentScheduleDataSource({required List<UnpaidReportScheduleModel> paymentData, required String selectedCurrencyCode}) {
    _paymentData = paymentData
        .map<DataGridRow>((schedule) => DataGridRow(
        cells: [
      DataGridCell<String>(columnName: 'tenant', value: schedule.tenantUnitModel!.tenant!.clientTypeId == 1
          ? '${schedule.tenantUnitModel!.tenant!.clientProfiles!.first.firstName!.capitalizeFirst} ${schedule.tenantUnitModel!.tenant!.clientProfiles!.first.lastName!.capitalizeFirst}'.replaceAll('_', ' ')
          : schedule.tenantUnitModel!.tenant!.clientProfiles!.first.companyName!.replaceAll('_', ' ')),
      DataGridCell<String>(columnName: 'unit', value: '${schedule.unitModel!.name}'),
      DataGridCell<String>(columnName: 'period', value: '${DateFormat('d MMM, yy').format(schedule.fromDate!)}\n${DateFormat('d MMM, yy').format(schedule.toDate!)}'),
      DataGridCell<String>(columnName: 'amount', value: currentUserBaseCurrencyCode == selectedCurrencyCode ? (amountFormatter.format(schedule == null ? 0.toString() : schedule.baseDiscountAmount.toString()))
          : (amountFormatter.format(schedule == null ? 0.toString() : schedule.foreignDiscountAmount.toString()))),
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


// class PaymentDataSource extends DataGridSource {
//   /// Creates the employee data source class with required details.
//   PaymentDataSource({required List<PaymentsModel> paymentData}) {
//     _paymentData = paymentData
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//               DataGridCell<String>(
//                   columnName: 'tenant', value: e.property!.name),
//               DataGridCell<DateTime>(columnName: 'period', value: e.date),
//               DataGridCell<int>(columnName: 'amount', value: e.amount)
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
//         child: Text(e.value.toString()),
//       );
//     }).toList());
//   }
// }
