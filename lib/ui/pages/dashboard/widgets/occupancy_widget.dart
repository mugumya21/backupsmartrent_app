import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smart_rent/data_layer/models/payment/payments_model.dart';
import 'package:smart_rent/ui/pages/payments/bloc/payment_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/utilities/extra.dart';
///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OccupancyWidget extends StatelessWidget {
  const OccupancyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    // final List<String> items = [
    //   'Today',
    //   'Yesterday',
    //   'Last week',
    //   'Month',
    //   '3 Month',
    //   'Custom',
    // ];
    // String? selectedValue;

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, constraints),
            const Divider(
              color: AppTheme.inActiveColor,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0, right: 8.0,
        top: 8.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 30,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.primary),
                  ),
                  child: const Text("Filter"),
                ),
              ),
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
               Text("3,000,000,000/=", style: AppTheme.blueAppTitle3,),
            ],
          ),
          const SizedBox(height: 10),
          DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.whiteColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: const TabBar(
                        labelColor: AppTheme.whiteColor,
                        unselectedLabelColor: AppTheme.darker,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: AppTheme.darker,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        tabs: [
                          Tab(
                            child: Text("Occupied"),
                          ),
                          Tab(
                            child: Text("Vacant"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraints.minWidth,
                    height: constraints.maxHeight,
                    child: const TabBarView(
                      children: [
                        DataTable1(),
                        DataTable2(),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class DataTable2 extends StatelessWidget {
  const DataTable2({super.key});

  @override
  Widget build(BuildContext context) {
    List<PaymentsModel> payments = <PaymentsModel>[];
    late OccupancyAvailableDataSource paymentDataSource;

    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        payments = getPaymentData(context);
        paymentDataSource = OccupancyAvailableDataSource(paymentData: payments);
        // if (state.status.isInitial) {
        //   context.read<PaymentBloc>().add(LoadPayments());
        // }
        // if (state.status.isSuccess) {
        //   payments = getPaymentData(context);
        //   paymentDataSource = OccupancyAvailableDataSource(paymentData: payments);
        //   return _buildBody(context, state, paymentDataSource);
        // }
        // if (state.status.isLoading) {
        //   return const LoadingWidget();
        // }
        // if (state.status.isError) {
        //   return SmartErrorWidget(
        //     message: 'Error loading payments table',
        //     onPressed: () {
        //       context.read<PaymentBloc>().add(LoadPayments());
        //     },
        //   );
        // }
        // if (state.status.isEmpty) {
        //   return NoDataWidget(
        //     message: "No payments available",
        //     onPressed: () {
        //       context.read<PaymentBloc>().add(LoadPayments());
        //     },
        //   );
        // }
        // return const SmartWidget();
        return _buildBody(context, state, paymentDataSource);
      },
    );
  }

  Widget _buildBody(BuildContext context, PaymentState state,
      OccupancyAvailableDataSource paymentDataSource) {
    return Column(
      children: [
        const Divider(
          color: AppTheme.inActiveColor,
        ),
        Expanded(child: _buildDataTable(paymentDataSource)),
        const SizedBox(height: 90),
      ],
    );
  }

  Widget _buildDataTable(OccupancyAvailableDataSource paymentDataSource) {
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
          columnName: 'property',
          label: SizedBox(
            child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Property',
                  style: AppTheme.appTitle1,
                )),
          )),
      GridColumn(
          columnName: 'unit',
          width: 100,
          label: Container(
              alignment: Alignment.center, child: Text('Unit',
            style: AppTheme.appTitle1,
          ))),
    ];
  }

  List<PaymentsModel> getPaymentData(BuildContext context) {
    // return context.read<PaymentBloc>().state.payments!;
    return [
      PaymentsModel(
        description: 'F01-01',
        property: Property(name: 'Pioneer Mall'),
      ),

      PaymentsModel(
        description: 'F01-01',
        property: Property(name: 'Pioneer Mall'),
      ),

      PaymentsModel(
        description: 'F01-01',
        property: Property(name: 'Pioneer Mall'),
      ),

      PaymentsModel(
        description: 'F01-01',
        property: Property(name: 'Pioneer Mall'),
      ),


    ];
  }
}

class DataTable1 extends StatelessWidget {
  const DataTable1({super.key});

  @override
  Widget build(BuildContext context) {
    List<PaymentsModel> payments = <PaymentsModel>[];
    late PaymentDataSource paymentDataSource;

    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        payments = getPaymentData(context);
        paymentDataSource = PaymentDataSource(paymentData: payments);
        // if (state.status.isInitial) {
        //   context.read<PaymentBloc>().add(LoadPayments());
        // }
        // if (state.status.isSuccess) {
        //   payments = getPaymentData(context);
        //   paymentDataSource = PaymentDataSource(paymentData: payments);
        //   return _buildBody(context, state, paymentDataSource);
        // }
        // if (state.status.isLoading) {
        //   return const LoadingWidget();
        // }
        // if (state.status.isError) {
        //   return SmartErrorWidget(
        //     message: 'Error loading payments table',
        //     onPressed: () {
        //       context.read<PaymentBloc>().add(LoadPayments());
        //     },
        //   );
        // }
        // if (state.status.isEmpty) {
        //   return NoDataWidget(
        //     message: "No payments available",
        //     onPressed: () {
        //       context.read<PaymentBloc>().add(LoadPayments());
        //     },
        //   );
        // }
        // return const SmartWidget();
        return _buildBody(context, state, paymentDataSource);
      },
    );
  }

  Widget _buildBody(BuildContext context, PaymentState state,
      PaymentDataSource paymentDataSource) {
    return Column(
      children: [
        const Divider(
          color: AppTheme.inActiveColor,
        ),
        Expanded(child: _buildDataTable(paymentDataSource)),
        const SizedBox(height: 90),
      ],
    );
  }

  Widget _buildDataTable(PaymentDataSource paymentDataSource) {
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
          columnName: 'property',
          label: Container(
              alignment: Alignment.center,
              child:  Text(
                'Property',
                style: AppTheme.darkBlueTitle,
              ))),
      GridColumn(
          columnName: 'unit',
          width: 80,
          label: Container(
              alignment: Alignment.center,
              child: Text('Unit',
                style: AppTheme.darkBlueTitle,
              ))),
      GridColumn(
          columnName: 'tenant',
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'Tenant',
                overflow: TextOverflow.ellipsis,
                style: AppTheme.darkBlueTitle,
              ))),
    ];
  }

  List<PaymentsModel> getPaymentData(BuildContext context) {
    // return context.read<PaymentBloc>().state.payments!;
    return [
      PaymentsModel(
        description: 'F01-01',
          property: Property(name: 'Mapeera House'),
          amount: 100000000),

      PaymentsModel(
          description: 'F01-01',
          property: Property(name: 'Mapeera House'),
          amount: 100000000),

      PaymentsModel(
          description: 'F01-01',
          property: Property(name: 'Mapeera House'),
          amount: 100000000),

      PaymentsModel(
          description: 'F01-01',
          property: Property(name: 'Mapeera House'),
          amount: 100000000),

      PaymentsModel(
          description: 'F01-01',
          property: Property(name: 'Mapeera House'),
          amount: 100000000),

      PaymentsModel(
          description: 'F01-01',
          property: Property(name: 'Mapeera House'),
          amount: 100000000),

    ];
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class PaymentDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  PaymentDataSource({required List<PaymentsModel> paymentData}) {
    _paymentData = paymentData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'property', value: e.property!.name),
              DataGridCell<String>(columnName: 'unit', value: e.description),
              DataGridCell<String>(columnName: 'tenant', value: amountFormatter.format(e.amount.toString()))
            ]))
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

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class OccupancyAvailableDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  OccupancyAvailableDataSource({required List<PaymentsModel> paymentData}) {
    _paymentData = paymentData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'property', value: e.property!.name),
              DataGridCell<String>(columnName: 'unit', value: e.description),
            ]))
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
