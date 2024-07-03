import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/data_layer/models/tenant_unit/tenant_unit_model.dart';
import 'package:smart_rent/ui/pages/currency/bloc/currency_bloc.dart';
import 'package:smart_rent/ui/pages/period/bloc/period_bloc.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/pages/properties/widgets/no_data_widget.dart';
import 'package:smart_rent/ui/pages/properties/widgets/not_found_widget.dart';
import 'package:smart_rent/ui/pages/tenant_unit/bloc/form/tenant_unit_form_bloc.dart';
import 'package:smart_rent/ui/pages/tenant_unit/bloc/tenant_unit_bloc.dart';
import 'package:smart_rent/ui/pages/tenant_unit/forms/tenant_unit_form.dart';
import 'package:smart_rent/ui/pages/tenant_unit/forms/update_tenant_unit_form.dart';
import 'package:smart_rent/ui/pages/tenant_unit/layouts/tenant_unit_details_page_layout.dart';
import 'package:smart_rent/ui/pages/tenants/bloc/tenant_bloc.dart';
import 'package:smart_rent/ui/pages/units/bloc/unit_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_search_textfield.dart';
import 'package:smart_rent/ui/widgets/smart_error_widget.dart';
import 'package:smart_rent/ui/widgets/smart_widget.dart';
import 'package:smart_rent/utilities/extra.dart';

class TenantUnitTabScreenLayout extends StatefulWidget {
  final Property property;

  const TenantUnitTabScreenLayout({super.key, required this.property});

  @override
  State<TenantUnitTabScreenLayout> createState() => _TenantUnitTabScreenLayoutState();
}

class _TenantUnitTabScreenLayoutState extends State<TenantUnitTabScreenLayout> {


  TextEditingController searchController = TextEditingController();

  List<TenantUnitModel> filteredData = <TenantUnitModel>[];
  List<TenantUnitModel> initialTenantUnits = <TenantUnitModel>[];
  void filterTenantUnits(String query,) {

    setState(() {
      filteredData = initialTenantUnits
          .where((tenantUnit) =>
          tenantUnit.tenant!.clientProfiles!.first.firstName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())

              || tenantUnit.tenant!.clientProfiles!.first.lastName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())

              || tenantUnit.tenant!.clientProfiles!.first.companyName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())

              || tenantUnit.unit!.name
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())
      )
          .toList();
    });
    print('My Filtered Tenant Units List $filteredData');
    print('My Initial Tenant Units List $initialTenantUnits');
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocProvider(
      create: (context) => TenantUnitBloc(),
      child: BlocListener<TenantUnitBloc, TenantUnitState>(
        listener: (context, state) {
          if(state.status == TenantUnitStatus.successDelete){
                Fluttertoast.showToast(msg: 'Tenant Unit Deleted Successfully',
                    gravity: ToastGravity.TOP,
                  backgroundColor: AppTheme.green
                );
                context.read<TenantUnitBloc>().add(LoadTenantUnitsEvent(widget.property.id!));
              } if(state.status == TenantUnitStatus.errorDelete){
                Fluttertoast.showToast(msg: state.message.toString(),                                   gravity: ToastGravity.TOP,
                );
                context.read<TenantUnitBloc>().add(LoadTenantUnitsEvent(widget.property.id!));
              }
  },
  child: BlocBuilder<TenantUnitBloc, TenantUnitState>(
        builder: (context, state) {
          if (state.status == TenantUnitStatus.initial) {
            context
                .read<TenantUnitBloc>()
                .add(LoadTenantUnitsEvent(widget.property.id!));
          }
          if (state.status == TenantUnitStatus.loading) {
            return const LoadingWidget();
          }
          if (state.status == TenantUnitStatus.loadingDelete) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Deleting Tenant Unit....'),
                LoadingWidget(),
              ],
            );
          }
          if (state.status == TenantUnitStatus.accessDenied) {
            return const NotFoundWidget();
          }
          if (state.status == TenantUnitStatus.empty) {
            return _buildEmptyBody(context, state);
          }
          if (state.status == TenantUnitStatus.error) {
            return SmartErrorWidget(
              message: 'Error loading tenant units',
              onPressed: () {
                context
                    .read<TenantUnitBloc>()
                    .add(LoadTenantUnitsEvent(widget.property.id!));
              },
            );
          }
          if (state.status == TenantUnitStatus.success) {
            initialTenantUnits = state.tenantUnits!;
            return _buildSuccessfulBody(context, state);
          }
          return const SmartWidget();
        },
      ),
),
    );
  }

  Widget _buildSuccessfulBody(
      BuildContext parentContext, TenantUnitState state) {
    return Scaffold(
      backgroundColor: AppTheme.appBgColor,
      appBar: _buildAppTitle(),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_tenant_unit",
        onPressed: () => showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: parentContext,
            builder: (context) {
              return MultiBlocListener(
                listeners: [
                  BlocProvider(create: (context) => TenantBloc()),
                  BlocProvider(create: (context) => UnitBloc()),
                  BlocProvider(create: (context) => PeriodBloc()),
                  BlocProvider(create: (context) => CurrencyBloc()),
                  BlocProvider(create: (context) => TenantUnitFormBloc()),
                ],
                child: TenantUnitForm(
                  parentContext: parentContext,
                  addButtonText: 'Add Tenant',
                  isUpdate: false,
                  property: widget.property,
                  initialTenantUnits: initialTenantUnits,
                ),
              );
            }),
        backgroundColor: AppTheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),
      body: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        controller: tenantUnitsScrollController,
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {

          var tenantUnit = filteredData.isEmpty ? initialTenantUnits[index] : filteredData[index];
          bool isPaid =  tenantUnit.paymentScheduleModel!.any((stu) =>  stu.paid != 0);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TenantUnitDetailsPageLayout(
                            tenantUnitModel: tenantUnit,
                          )));
              // Navigator.push(context, MaterialPageRoute(builder: (context)=> MyDataTable(tenantUnitModel: tenantUnit,)));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              // width: width,
              // height: height,
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
              child: ListTile(
                leading: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-photo/real-estate-broker-agent-presenting-consult-customer-decision-making-sign-insurance-form-agreement_1150-15023.jpg?w=996&t=st=1708346770~exp=1708347370~hmac=d7c8476699ac83e0dbb2375a511e548c2d78c4e1b2d69da7cc5ce31d4c915c90'),
                    ),
                  ],
                ),
                title: Text(
                  tenantUnit.tenant!.clientTypeId == 1
                      ? '${tenantUnit.tenant!.clientProfiles!.first.firstName.toString().capitalizeFirst} ${tenantUnit.tenant!.clientProfiles!.first.lastName.toString().capitalizeFirst} - ${tenantUnit.unit!.name.toString().capitalizeFirst}'
                      : '${tenantUnit.tenant!.clientProfiles!.first.companyName.toString().capitalizeFirst} -  ${tenantUnit.unit!.name.toString().toString().capitalizeFirst}',
                  style: AppTheme.blueAppTitle3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${(tenantUnit.currencyModel != null) ? tenantUnit.currencyModel!.code : ''} ${amountFormatter.format(tenantUnit.discountAmount.toString())} (${tenantUnit.period!.name})',
                      style: AppTheme.subText,
                    ),
                    Text(
                      'Tenancy Period: ${DateFormat('d MMM, yy').format(tenantUnit.fromDate!)} - ${DateFormat('d MMM, yy').format(tenantUnit.toDate!)}',
                      style: AppTheme.subText,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                     !isPaid && tenantUnit.canEdit == true ? GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                  useSafeArea: true,
                                  isScrollControlled: true,
                                  context: parentContext,
                                  builder: (context) {
                                    return MultiBlocListener(
                                      listeners: [
                                        BlocProvider(create: (context) => TenantBloc()),
                                        BlocProvider(create: (context) => UnitBloc()),
                                        BlocProvider(create: (context) => PeriodBloc()),
                                        BlocProvider(create: (context) => CurrencyBloc()),
                                        BlocProvider(create: (context) => TenantUnitFormBloc()),
                                      ],
                                      child: UpdateTenantUnitForm(
                                        parentContext: parentContext,
                                        addButtonText: 'Edit',
                                        isUpdate: true,
                                        property: widget.property,
                                        initialTenantUnits: initialTenantUnits,
                                        tenantUnitModel: tenantUnit,

                                      ),
                                    );
                                  });
                            },
                            child: Icon(Icons.edit)) :  Container(),
                        SizedBox(width: 10,),


                        !isPaid && tenantUnit.canDelete == true ? GestureDetector(
                            onTap: (){
                              context.read<TenantUnitBloc>().add(DeleteTenantUnitEvent(tenantUnit.id!));
                            },
                            child: Icon(Icons.delete)) : Container(),

                        // BlocListener<TenantUnitBloc, TenantUnitState>(
                        //   listener: (context, state) {
                        //     if(state.status == TenantUnitStatus.success){
                        //       Fluttertoast.showToast(msg: 'Tenant Unit Deleted Successfully',
                        //           gravity: ToastGravity.TOP,
                        //         backgroundColor: AppTheme.green
                        //       );
                        //       context.read<TenantUnitBloc>().add(LoadTenantUnitsEvent(widget.property.id!));
                        //     } if(state.status == TenantUnitStatus.error){
                        //       Fluttertoast.showToast(msg: state.message.toString(),                                   gravity: ToastGravity.TOP,
                        //       );
                        //       context.read<TenantUnitBloc>().add(LoadTenantUnitsEvent(widget.property.id!));
                        //     }
                        //   }, child: GestureDetector(
                        //     onTap: (){
                        //       context.read<TenantUnitBloc>().add(DeleteTenantUnitEvent(tenantUnit.id!));
                        //     },
                        //     child: Icon(Icons.delete)),
                        // )

                      ],
                    )

                  ],
                ),
              ),
            ),
          );
        },
        itemCount: filteredData.isEmpty ? initialTenantUnits.length : filteredData.length,
      ),
    );
  }

  Widget _buildEmptyBody(BuildContext parentContext, TenantUnitState state) {
    return Scaffold(
      backgroundColor: AppTheme.appBgColor,
      appBar: _buildAppTitle(),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_tenant_unit",
        onPressed: () => showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: parentContext,
            builder: (context) {
              return MultiBlocListener(
                listeners: [
                  BlocProvider(create: (context) => TenantBloc()),
                  BlocProvider(create: (context) => UnitBloc()),
                  BlocProvider(create: (context) => PeriodBloc()),
                  BlocProvider(create: (context) => CurrencyBloc()),
                  BlocProvider(create: (context) => TenantUnitFormBloc()),
                ],
                child: TenantUnitForm(
                  parentContext: parentContext,
                  addButtonText: 'Add Tenant',
                  isUpdate: false,
                  property: widget.property,
                  initialTenantUnits: initialTenantUnits,
                ),
              );
            }),
        backgroundColor: AppTheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),
      body: NoDataWidget(
        message: "No tenant units",
        onPressed: () {
          parentContext
              .read<TenantUnitBloc>()
              .add(LoadTenantUnitsEvent(widget.property.id!));
        },
        subText: 'tenant units',
      ),
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
          hintText: 'Search Tenant Units',
          obscureText: false,
          function: () {},
          fillColor: AppTheme.grey_100,
          onChanged: filterTenantUnits,
        ),
      ),
    );
  }
}
