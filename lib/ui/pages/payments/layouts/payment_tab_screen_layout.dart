import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_rent/data_layer/models/payment/payment_list_model.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/ui/pages/payment_schedules/bloc/payment_schedules_bloc.dart';
import 'package:smart_rent/ui/pages/payments/bloc/form/payment_form_bloc.dart';
import 'package:smart_rent/ui/pages/payments/bloc/payment_bloc.dart';
import 'package:smart_rent/ui/pages/payments/forms/add_payment_form.dart';
import 'package:smart_rent/ui/pages/payments/layouts/payment_details_screen.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/pages/properties/widgets/no_data_widget.dart';
import 'package:smart_rent/ui/pages/properties/widgets/not_found_widget.dart';
import 'package:smart_rent/ui/pages/tenant_unit/bloc/tenant_unit_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_search_textfield.dart';
import 'package:smart_rent/ui/widgets/smart_error_widget.dart';
import 'package:smart_rent/ui/widgets/smart_widget.dart';
import 'package:smart_rent/utilities/extra.dart';

class PaymentTabScreenLayout extends StatefulWidget {
  final Property property;

  const PaymentTabScreenLayout({super.key, required this.property});

  @override
  State<PaymentTabScreenLayout> createState() => _PaymentTabScreenLayoutState();
}

class _PaymentTabScreenLayoutState extends State<PaymentTabScreenLayout> {


  final TextEditingController searchController = TextEditingController();

  // late List<PaymentSchedulesModel> filteredData;
  List<PaymentListModel> filteredData = <PaymentListModel>[];
  List<PaymentListModel> payments = <PaymentListModel>[];



  void filterPayments(String query) {

    print('My Filtered List $filteredData');
    setState(() {
      filteredData = payments
          .where((schedule) =>
      DateFormat('d MMM, yy')
          .format(schedule.schedulesPerPayment!.first.schedule!.fromDate!)
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()) ||
          DateFormat('d MMM, yy')
              .format(schedule.schedulesPerPayment!.first.schedule!.fromDate!)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocProvider(
      create: (context) => PaymentBloc(),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if(state.status == PaymentStatus.successDelete){
            Fluttertoast.showToast(msg: 'Payment Deleted Successfully',
                gravity: ToastGravity.TOP,
                backgroundColor: AppTheme.green
            );
            context.read<PaymentBloc>().add(LoadAllPayments(widget.property.id!));
          } if(state.status == PaymentStatus.errorDelete){
            Fluttertoast.showToast(msg: state.message.toString(),                                   gravity: ToastGravity.TOP,
            );
            context.read<PaymentBloc>().add(LoadAllPayments(widget.property.id!));
          }
        },
        builder: (context, state) {
          if (state.status == PaymentStatus.initial) {
            context.read<PaymentBloc>().add(LoadAllPayments(widget.property.id!));
          }
          if (state.status == PaymentStatus.loading) {
            return const LoadingWidget();
          }   if (state.status == PaymentStatus.loadingDelete) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Deleting Payment....'),
                LoadingWidget(),
              ],
            );
          }
          if (state.status == PaymentStatus.accessDenied) {
            return const NotFoundWidget();
          }
          if (state.status == PaymentStatus.empty) {
            return _buildEmptyBody(context, state);
          }
          if (state.status == PaymentStatus.error) {
            return SmartErrorWidget(
              message: 'Error loading payments',
              onPressed: () {
                context.read<PaymentBloc>().add(LoadAllPayments(widget.property.id!));
              },
            );
          }
          if (state.status == PaymentStatus.success) {
            payments = state.payments!;
            return _buildSuccessBody(context, filteredData.isEmpty ? payments : filteredData);
          }
          return const SmartWidget();
        },
      ),
    );
  }

  Widget _buildSuccessBody(BuildContext parentContext, List<PaymentListModel> paymentListModel) {
    return Scaffold(
      backgroundColor: AppTheme.appBgColor,
      appBar: _buildAppTitle(),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_payment",
        onPressed: () => showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: parentContext,
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => PaymentSchedulesBloc()),
                  BlocProvider(create: (context) => TenantUnitBloc()),
                  BlocProvider(create: (context) => PaymentFormBloc()),
                ],
                child: AddPaymentForm(
                  parentContext: parentContext,
                  addButtonText: 'Add',
                  isUpdate: false,
                  property: widget.property,
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
        controller: paymentsScrollController,
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {
          // var balanceAmount =
          //     int.parse(paymentListModel[index].amountDue.toString()) -
          //         int.parse(paymentListModel[index].amount.toString());
          return GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentDetailsScreen(
                        paymentListModel: paymentListModel[index],
                      )));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),

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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Paid On: ${DateFormat('dd/MM/yyyy').format(paymentListModel[index].date!)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),

                        // Text(
                        //   'add image',
                        //   style: AppTheme.subText,
                        // )
                        Row(
                          children: [
                            Icon(Icons.file_present),
                            SizedBox(width: 10,),
                            paymentListModel[index].canDelete! ? GestureDetector(
                                onTap: (){
                                  context.read<PaymentBloc>().add(DeletePaymentEvent(paymentListModel[index].paymentId!));

                                },
                                child: Icon(Icons.delete)) : Container()
                          ],
                        ),

                      ],
                    ),

                    // Text('${amountFormatter.format(state.payments![index].amount.toString())}/= (${state.payments![index].paymentAccountsModel == null ? '' : state.payments![index].paymentAccountsModel!.name})',
                    //   style: AppTheme.subTextBold,
                    // ),
                    Text('${paymentListModel[index].currencyModel!.code.toString()} ${amountFormatter.format(paymentListModel[index].amount.toString())}',
                      style: AppTheme.subTextBold,
                    ),

                    // Text(
                    //   '${state.payments![index].tenantUnitModel!.tenant!.clientTypeId == 1 ? '${state.payments![index].tenantUnitModel!.tenant!.clientProfiles!.first.firstName} ${state.payments![index].tenantUnitModel!.tenant!.clientProfiles!.first.lastName}' : '${state.payments![index].tenantUnitModel!.tenant!.clientProfiles!.first.companyName}'} - ${state.payments![index].tenantUnitModel!.unit!.name}',
                    //   style: AppTheme.blueAppTitle3,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   softWrap: true,
                    // ),
                    // Text(
                    //   '${state.payments![index].tenantProfile!.first.firstName ?? state.payments![index].tenantProfile!.first.companyName}',
                    //   style: AppTheme.blueAppTitle3,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   softWrap: true,
                    // ),

                    // Text('Periods ${state.payments![index].paymentScheduleModel!.map((schedule) => schedule.fromDate.toString())}')

                    // state.payments![index].schedulesPerPayment.isNull ? Container() :
                  // Text(
                  //     '${DateFormat('d MMM, yy').format(state.payments![index].schedulesPerPayment!.first.schedule!.fromDate!)} - ${DateFormat('d MMM, yy').format(state.payments![index].schedulesPerPayment!.first.schedule!.toDate!)} /'),
                  //
                    Wrap(
                      spacing: 10,
                      children: paymentListModel[index].schedulesPerPayment!
                          .map((schedule) => Text(
                              '${DateFormat('d MMM, yy').format(schedule.schedule!.fromDate!)} - ${DateFormat('d MMM, yy').format(schedule.schedule!.toDate!)} /'))
                          .toList(),
                    )
                  ],
                ),

                // subtitle: Wrap(
                //   spacing: 10,
                //   children: [
                //     Text(
                //       'Amount Due: ${amountFormatter.format(state.payments![index].amountDue.toString())}/= ,',
                //       style: AppTheme.subTextBold,
                //     ),
                //     Text(
                //       'Paid: ${amountFormatter.format(state.payments![index].amount.toString())}/= ,',
                //       style: AppTheme.subTextBold,
                //     ),
                //     Text(
                //       'Balance: ${amountFormatter.format(balanceAmount.toString())}/= ',
                //       style: AppTheme.subTextBold,
                //     ),
                //   ],
                // ),
                // trailing: Text('on ${DateFormat('dd.MM.yy').format(DateTime.parse(state.payments![index].date.toString()))}'),

              ),
            ),
          );
        },
        itemCount: paymentListModel.length,
      ),
    );
  }

  Widget _buildEmptyBody(BuildContext parentContext, PaymentState state) {
    return Scaffold(
      backgroundColor: AppTheme.appBgColor,
      appBar: _buildAppTitle(),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_floor",
        onPressed: () => showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: parentContext,
            builder: (context) {
              return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => PaymentSchedulesBloc()),
                    BlocProvider(create: (context) => TenantUnitBloc()),
                    BlocProvider(create: (context) => PaymentFormBloc()),
                  ],
                  child: AddPaymentForm(
                    parentContext: parentContext,
                    addButtonText: 'Add',
                    isUpdate: false,
                    property: widget.property,
                  ));
              // return MultiBlocProvider(
              //   providers: [
              //     BlocProvider(
              //         create: (context) => PaymentSchedulesBloc()),
              //     BlocProvider(create: (context) => TenantUnitBloc()),
              //   ],
              //   child: AddPaymentForm(
              //     addButtonText: 'Add',
              //     isUpdate: false,
              //     property: property,
              //   ),
              // );
            }),
        backgroundColor: AppTheme.primary,
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
      body: NoDataWidget(
        message: "No payments",
        onPressed: () {
          parentContext.read<PaymentBloc>().add(LoadAllPayments(widget.property.id!));
        },
        subText: 'payments',
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
          hintText: 'Search payments',
          obscureText: false,
          function: () {},
          fillColor: AppTheme.grey_100,
          onChanged: filterPayments,
        ),
      ),
    );
  }
}
