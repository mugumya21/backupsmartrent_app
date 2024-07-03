import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:smart_rent/data_layer/models/tenant/tenant_model.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/pages/tenants/bloc/tenant_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_search_textfield.dart';
import 'package:smart_rent/ui/widgets/appbar_content.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class TenantsPage extends StatefulWidget {
  const TenantsPage({super.key});

  @override
  State<TenantsPage> createState() => _TenantsPageState();
}

class _TenantsPageState extends State<TenantsPage> {

  TextEditingController searchController = TextEditingController();

  List<TenantModel> tenants = <TenantModel>[];
  List<TenantModel> filteredData = <TenantModel>[];
  late TenantListDataSource tenantListDataSource;

  void filterTenants(String query,) {

    setState(() {
      filteredData = tenants
          .where((tenant) =>

      tenant.clientProfiles!.first.firstName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())
          ||
          tenant.clientProfiles!.first.lastName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())
          ||
          tenant.clientProfiles!.first.companyName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())
      )
          .toList();
    });
    print('My Filtered tenants List $filteredData');
    print('My Initial tenants List $tenants');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const TitleBarImageHolder(),
        centerTitle: true,
        foregroundColor: AppTheme.whiteColor,
      ),


      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: AppSearchTextField(
              controller: searchController,
              hintText: 'Search',
              obscureText: false,
              function: (){},
              onChanged: filterTenants,
            ),
          ),


          BlocBuilder<TenantBloc, TenantState>(
            builder: (context, state) {


              if (state.status ==  TenantStatus.initial) {
                context.read<TenantBloc>().add(LoadAllTenantsEvent());
              }
              if (state.status == TenantStatus.success) {

                tenants = state.tenants!;
                tenantListDataSource = TenantListDataSource(tenants: filteredData.isEmpty ? tenants : filteredData);
                return Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tenants:', style: AppTheme.appTitle3,),
                            Text(tenants.length.toString(), style: AppTheme.blueAppTitle3,),
                          ],
                        ),
                      ),
                      Expanded(child: Container(child: _buildDataTable(tenantListDataSource), height: double.infinity,)),
                    ],
                  ),
                );
              }
              if (state.status == TenantStatus.loading) {
                return const LoadingWidget();
              }
              if (state.status == TenantStatus.error) {
                return Center(child: Text('Error loading tenants'),);

              }
              if (state.status == TenantStatus.empty) {
                return Center(child: Text('No Tenants'),);

              }
              return  Container();
            },
          ),

        ],
      ),



    );

  }

  Widget _buildDataTable(TenantListDataSource paymentDataSource) {
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
          columnName: 'name',
          label: Container(
              padding: const EdgeInsets.all(1.0),
              alignment: Alignment.center,
              child:  Text(
                'Name',
                style: AppTheme.tableTitle1,
              ))),
      GridColumn(
          columnName: 'type',
          width: 90,
          label: Container(
              padding: const EdgeInsets.all(1.0),
              alignment: Alignment.center, child:  Text('Type',
            style: AppTheme.tableTitle1,
          ))),

      GridColumn(
          columnName: 'telephone',
          label: Container(
              padding: const EdgeInsets.all(1.0),
              alignment: Alignment.center, child:  Text('Number',
            style: AppTheme.tableTitle1,
          ))),

    ];
  }
}

class TenantListDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  TenantListDataSource({required List<TenantModel> tenants}) {
    _tenants = tenants
        .map<DataGridRow>((tenant) => DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'name', value: tenant.clientTypeId == 1
            ? '${tenant.clientProfiles!.first.lastName!.capitalizeFirst}'.replaceAll('_', ' ')
            : tenant.clientProfiles!.first.companyName!.replaceAll('_', ' ')),
        DataGridCell<String>(columnName: 'type', value: '${tenant.clientType!.name}'),
        DataGridCell<String>(columnName: 'telephone', value: '${tenant.number}'),
      ],
    ))
        .toList();
  }

  List<DataGridRow> _tenants = [];

  @override
  List<DataGridRow> get rows => _tenants;

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