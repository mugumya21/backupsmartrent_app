import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smart_rent/data_layer/models/currency/currency_model.dart';
import 'package:smart_rent/data_layer/models/period/period_model.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/data_layer/models/tenant/tenant_model.dart';
import 'package:smart_rent/data_layer/models/tenant_unit/tenant_unit_model.dart';
import 'package:smart_rent/data_layer/models/unit/unit_model.dart';
import 'package:smart_rent/ui/pages/currency/bloc/currency_bloc.dart';
import 'package:smart_rent/ui/pages/period/bloc/period_bloc.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/pages/tenant_unit/bloc/form/tenant_unit_form_bloc.dart';
import 'package:smart_rent/ui/pages/tenant_unit/bloc/tenant_unit_bloc.dart';
import 'package:smart_rent/ui/pages/tenants/bloc/tenant_bloc.dart';
import 'package:smart_rent/ui/pages/units/bloc/unit_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/amount_text_field.dart';
import 'package:smart_rent/ui/widgets/app_drop_downs.dart';
import 'package:smart_rent/ui/widgets/custom_accordion.dart';
import 'package:smart_rent/ui/widgets/custom_textbox.dart';
import 'package:smart_rent/ui/widgets/form_title_widget.dart';
import 'package:smart_rent/utilities/app_init.dart';

class UpdateTenantUnitForm extends StatefulWidget {
  final String addButtonText;
  final bool isUpdate;
  final Property property;
  final BuildContext parentContext;
  late final List<TenantUnitModel> initialTenantUnits;
  final TenantUnitModel tenantUnitModel;

  UpdateTenantUnitForm(
      {super.key,
        required this.addButtonText,
        required this.isUpdate,
        required this.property,
        required this.parentContext,
        required this.initialTenantUnits, required this.tenantUnitModel,
      });

  @override
  State<UpdateTenantUnitForm> createState() => _UpdateTenantUnitFormState();
}

class _UpdateTenantUnitFormState extends State<UpdateTenantUnitForm> {
  TextEditingController durationController = TextEditingController();

  TextEditingController unitAmountController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController discountedAmountController = TextEditingController();

  TextEditingController startDateController = TextEditingController();

  TextEditingController endDateController = TextEditingController();

  TenantModel? tenant;

  UnitModel unit = UnitModel();

  PeriodModel period = PeriodModel();
  UnitModel unitModel = UnitModel();

  int selectedCurrencyId = 0;

  CurrencyModel? currencyModel;

  int? initialDurationId;

  // CurrencyModel currency = CurrencyModel();
  var numberFormat = NumberFormat("###,###,###,###,###");

  @override
  void initState() {
    super.initState();
    startDateController.text = DateFormat('dd/MM/yyyy').format(widget.tenantUnitModel.fromDate!);
    endDateController.text = DateFormat('dd/MM/yyyy').format(widget.tenantUnitModel.toDate!);
    durationController.text = widget.tenantUnitModel.duration.toString();
    unitAmountController.text = widget.tenantUnitModel.amount.toString();
    discountedAmountController.text = widget.tenantUnitModel.discountAmount.toString();
    descriptionController.text = widget.tenantUnitModel.description == null ? '' : widget.tenantUnitModel.description.toString();
    currencyModel = widget.tenantUnitModel.currencyModel;
    tenant = widget.tenantUnitModel.tenant!;
    unit = UnitModel(id: widget.tenantUnitModel.unit!.id, name: widget.tenantUnitModel.unit!.name);
    initialDurationId = widget.tenantUnitModel.period!.id;
    period = widget.tenantUnitModel.period!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: BlocConsumer<TenantUnitFormBloc, TenantUnitFormState>(
        builder: (context, state) {
          return Column(
            children: [
              FormTitle(
                name: '${widget.isUpdate ? "Edit" : "Edit"}  Tenant',
                addButtonText: widget.isUpdate ? "Update" : "Update",
                onSave: () {

                  if(durationController.text == ''){
                    Fluttertoast.showToast(msg: 'Enter No. Of Months', gravity: ToastGravity.TOP);
                  } else {
                    print(selectedCurrencyId);
                    context.read<TenantUnitFormBloc>().add(
                      UpdateTenantUnitEvent(
                          currentUserToken.toString(),
                          tenant!.id!,
                          unit.id!,
                          period.id!,
                          durationController.text.replaceAll(',', '').trim(),
                          DateFormat('dd/MM/yyyy').format(
                              DateFormat('dd/MM/yyyy')
                                  .parse(startDateController.text)),
                          // DateFormat('yyyy-MM-dd').format(
                          //     DateFormat('dd/MM/yyyy')
                          //         .parse(endDateController.text)),
                          DateFormat('dd/MM/yyyy').format(
                              DateFormat('dd/MM/yyyy')
                                  .parse(endDateController.text)),
                          unitAmountController.text.replaceAll(',', '').trim(),
                          selectedCurrencyId == 0
                              ? currencyModel!.id!.toInt()
                              : selectedCurrencyId,
                          discountedAmountController.text
                              .replaceAll(',', '')
                              .trim(),
                          descriptionController.text,
                          widget.property.id!,
                          widget.tenantUnitModel.id!
                      ),
                    );
                  }


                },
                isElevated: true,
                onCancel: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
        listener: (context, state) {
          if (state.status.isLoading) {
            const LoadingWidget();
          }
          if (state.status.isSuccess) {
            try{
              widget.parentContext
                  .read<TenantUnitBloc>()
                  .add(LoadTenantUnitsEvent(widget.property.id!));
              widget.initialTenantUnits = state.tenantUnits!;
            } catch (e) {
              print(e);
            }
            Navigator.pop(context);
          }
          if (state.status.isError) {
            Fluttertoast.showToast(
                msg: state.message!,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, TenantUnitFormState state) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              BlocBuilder<TenantBloc, TenantState>(
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<TenantBloc>().add(LoadAllTenantsEvent());
                  }
                  if (state.status.isSuccess) {
                    return Column(
                      children: [
                        CustomApiGenericTenantModelDropdown<TenantModel>(
                          defaultValue: state.tenants!.firstWhere(
                                (tenant) => tenant.id == widget.tenantUnitModel.tenant!.id,
                            orElse: () => tenant!,
                          ),
                          hintText: 'Select tenant',
                          menuItems: state.tenants!,
                          onChanged: (value) {
                            if (value != null) {
                              tenant = value;
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                  if (state.status.isLoading) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                  if (state.status.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: Text("No tenants available"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                  return const SizedBox(height: 10);
                },
              ),
              BlocBuilder<UnitBloc, UnitState>(
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context
                        .read<UnitBloc>()
                        .add(LoadAllUnitsEvent(widget.property.id!));
                  }
                  if (state.status.isSuccess) {

                    if(state.units.where((unit) => unit.isAvailable == 1).toList().isEmpty) {
                      // Fluttertoast.showToast(msg: 'Please Add A Unit', gravity: ToastGravity.TOP);

                      return TenantUnitDropdown<UnitModel>(
                        hintText: 'No Vacant Units',
                        menuItems: [],
                        onChanged: (value) {

                        },
                      );
                    } else {
                      return TenantUnitDropdown<UnitModel>(
                        defaultValue: state.units.firstWhere(
                              (unit) => unit.id == widget.tenantUnitModel.unit!.id,
                          orElse: () => unit,
                        ),

                        hintText: 'Select unit name/number',
                        // menuItems: state.units.where((unit) => unit.isAvailable == 1 ).toList(),
                        menuItems: state.units,
                        onChanged: (value) {
                          if (value != null) {
                            unit = value;
                            unitAmountController.text =
                                numberFormat.format(value.amount);
                            discountedAmountController.text =
                                numberFormat.format(value.amount);
                          }
                        },
                      );

                    }

                  }
                  if (state.status.isLoading) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                  if (state.status.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child:
                            const Center(child: Text("No vacant units")),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                  return const SizedBox(height: 10);
                },
              ),
              BlocBuilder<PeriodBloc, PeriodState>(
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context
                        .read<PeriodBloc>()
                        .add(LoadAllPeriodsEvent(widget.property.id!));
                  }
                  if (state.status.isLoading) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                  if(state.status.isSuccess){
                    return Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomApiGenericDropdown<PeriodModel>(
                                    defaultValue: state.periods.firstWhere(
                                          (period) => period.id == widget.tenantUnitModel.period!.id,
                                      orElse: () => period,
                                    ),
                                    hintText: 'Select period',
                                    menuItems: state.periods,
                                    onChanged: (value) {
                                      period = value!;
                                      setState(() {
                                        initialDurationId = value.id;
                                      });
                                      setState(() {
                                        durationController.text = '';
                                      });
                                      print('my initialDID = $initialDurationId');
                                      // context
                                      //     .read<PeriodBloc>()
                                      //     .add(SelectPeriodEvent(value.id!));
                                    },
                                  ),
                                ),
                                SizedBox(width: 10,),
                                // if (state.status.isDurationSelected)
                                //   const SizedBox(width: 10),
                                // if (state.status.isDurationSelected)
                                  Expanded(
                                    child: NumberField(
                                      // hint: _placeHolder(
                                      //     state.durationIdSelected!),
                                      hint: _placeHolder(initialDurationId!),
                                      maxLength: 50,
                                      controller: durationController,
                                      onChanged: (value) {
                                        String duration;
                                        if (value.isEmpty) {
                                          duration = "0";
                                        } else {
                                          duration = value;
                                        }
                                        // _durationCalc(state.durationIdSelected!,
                                        //     int.parse(duration));
                                        _durationCalc(initialDurationId!,
                                            int.parse(duration));
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        DateAccordion(
                          dateController: startDateController,
                          title: "From",
                          onChanged: () {
                            // _durationCalc(
                            //   state.durationIdSelected!,
                            //   int.parse(
                            //     durationController.text,
                            //   ),
                            // );
                            _durationCalc(
                              initialDurationId!,
                              int.parse(
                                durationController.text,
                              ),
                            );

                            setState(() {});
                          },
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 15),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("To"),
                              SizedBox(
                                width: 120,
                                child: SmartCaseTextField(
                                  hint: "To",
                                  maxLength: 50,
                                  minLines: 1,
                                  maxLines: 1,
                                  readOnly: true,
                                  controller: endDateController,
                                  addBottomMargin: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox(height: 10);
                },
              ),
              AmountTextField(
                hintText: 'Unit amount',
                controller: unitAmountController,
                obscureText: false,
                keyBoardType: const TextInputType.numberWithOptions(),
                enabled: false,
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Agreed Amount",
                    style: TextStyle(
                      color: AppTheme.primaryDarker,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: AppTheme.primaryDarker,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<CurrencyBloc, CurrencyState>(
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context
                        .read<CurrencyBloc>()
                        .add(LoadAllCurrenciesEvent(widget.property.id!));
                  }
                  if (state.status.isSuccess) {
                    currencyModel =
                        state.currencies!.firstWhere(
                              (currency) => currency.code == 'UGX',
                          // orElse: () => null as CurrencyModel,
                        );
                    print('Success Cureency Id == $selectedCurrencyId');
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomApiGenericDropdown<CurrencyModel>(
                            hintText: 'Select currency',
                            menuItems: state.currencies,
                            onChanged: (value) {
                              setState(() {
                                selectedCurrencyId = value!.id!;
                              });
                              print('new currency =$selectedCurrencyId');
                              // if (value != null) {
                              //   currency = value;
                              // }
                            },
                            defaultValue: currencyModel,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AmountTextField(
                            hintText: 'Discounted amount',
                            controller: discountedAmountController,
                            obscureText: false,
                            keyBoardType:
                            const TextInputType.numberWithOptions(),
                          ),
                        ),
                      ],
                    );
                  }
                  if (state.status.isLoading) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                  return const SizedBox(height: 10);
                },
              ),
              const SizedBox(height: 10),
              CustomTextArea(
                  hint: 'Description', controller: descriptionController),
            ],
          ),
        )
      ],
    );
  }

  _placeHolder(int selectedDurationId) {
    switch (selectedDurationId) {
      case 1:
        return 'Enter No. Of Days';
      case 2:
        return 'Enter No. Of Weeks';
      case 3:
        return 'Enter No. Of Months';
      case 4:
        return 'Enter No. Of Years';
      default:
        return 'Enter duration';
    }
  }

  _durationCalc(int selectedDurationId, int duration) {
    DateTime date = DateTime.now();
    print("SELECTED ID: ${selectedDurationId}");
    switch (selectedDurationId) {
      case 1:
        date = Jiffy.parse(startDateController.text, pattern: 'dd/MM/yyyy')
            .add(days: duration)
            .dateTime;
        break;
      case 2:
        date = Jiffy.parse(startDateController.text, pattern: 'dd/MM/yyyy')
            .add(weeks: duration)
            .dateTime;
        break;
      case 3:
        date = Jiffy.parse(startDateController.text, pattern: 'dd/MM/yyyy')
            .add(months: duration)
            .dateTime;
        break;
      case 4:
        date = Jiffy.parse(startDateController.text, pattern: 'dd/MM/yyyy')
            .add(years: duration)
            .dateTime;
        break;
    }
    endDateController.text = DateFormat('dd/MM/yyyy').format(date);
    print("Date: ${endDateController.text}");
  }
}
