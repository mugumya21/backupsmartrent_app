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

class TenantUnitForm extends StatefulWidget {
  final String addButtonText;
  final bool isUpdate;
  final Property property;
  final BuildContext parentContext;
  late final List<TenantUnitModel> initialTenantUnits;

   TenantUnitForm(
      {super.key,
      required this.addButtonText,
      required this.isUpdate,
      required this.property,
      required this.parentContext,
      required this.initialTenantUnits,
      });

  @override
  State<TenantUnitForm> createState() => _TenantUnitFormState();
}

class _TenantUnitFormState extends State<TenantUnitForm> {
  TextEditingController durationController = TextEditingController();

  TextEditingController unitAmountController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController discountedAmountController = TextEditingController();

  TextEditingController startDateController = TextEditingController();

  TextEditingController endDateController = TextEditingController();

  TenantModel tenant = TenantModel();

  UnitModel unit = UnitModel();

  PeriodModel period = PeriodModel();

  int selectedCurrencyId = 0;

  CurrencyModel? currencyModel;
  CurrencyModel? myCurrency;

  // CurrencyModel currency = CurrencyModel();
  var numberFormat = NumberFormat("###,###,###,###,###");

  @override
  void initState() {
    super.initState();
    startDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    endDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
                name: '${widget.isUpdate ? "Edit" : "New"}  Tenant',
                addButtonText: widget.isUpdate ? "Update" : "Add",
                onSave: () {

                  // DateFormat('yyyy-MM-dd').format(
                  //     DateFormat('dd/MM/yyyy')
                  //         .parse(startDateController.text)),
                  // DateFormat('yyyy-MM-dd').format(
                  // DateFormat('dd/MM/yyyy')
                  //     .parse(endDateController.text)),

                  print(selectedCurrencyId);
                  context.read<TenantUnitFormBloc>().add(
                        AddTenantUnitEvent(
                          currentUserToken.toString(),
                          tenant.id!,
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
                        ),
                      );
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
                      Fluttertoast.showToast(msg: 'Please Add A Unit', gravity: ToastGravity.TOP);

                      return TenantUnitDropdown<UnitModel>(
                        hintText: 'No Vacant Units',
                        menuItems: [],
                        onChanged: (value) {

                        },
                      );
                    } else {
                      return TenantUnitDropdown<UnitModel>(
                        hintText: 'Select unit name/number',
                        menuItems: state.units.where((unit) => unit.isAvailable == 1 ).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            unit = value;
                            unitAmountController.text =
                                numberFormat.format(value.amount);
                            discountedAmountController.text =
                                numberFormat.format(value.amount);
                            // var myCurrency = value.currencyModel;
                            setState(() {
                              myCurrency = value.currencyModel;
                            });

                            context
                                .read<CurrencyBloc>()
                                .add(LoadAllCurrenciesEvent(widget.property.id!));
                            // print('My CMOdel =$myCurrency');
                            // print('My CMOdel Value =${myCurrency!.code}');

                            // print('selected Unit Currency $currencyModel');
                            // print('selected Unit Currency ${currencyModel!.code}');

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
                  if (state.status.isSuccess ||
                      state.status.isDurationSelected) {
                    return Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomApiGenericDropdown<PeriodModel>(
                                    hintText: 'Select period',
                                    menuItems: state.periods,
                                    onChanged: (value) {
                                      period = value!;
                                      context
                                          .read<PeriodBloc>()
                                          .add(SelectPeriodEvent(value.id!));
                                    },
                                  ),
                                ),
                                if (state.status.isDurationSelected)
                                  const SizedBox(width: 10),
                                if (state.status.isDurationSelected)
                                  Expanded(
                                    child: NumberField(
                                      hint: _placeHolder(
                                          state.durationIdSelected!),
                                      maxLength: 50,
                                      controller: durationController,
                                      onChanged: (value) {
                                        String duration;
                                        if (value.isEmpty) {
                                          duration = "0";
                                        } else {
                                          duration = value;
                                        }
                                        _durationCalc(state.durationIdSelected!,
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
                            _durationCalc(
                              state.durationIdSelected!,
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

                          // margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("To"),
                              SizedBox(
                                width: 200,
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
              SizedBox(height: 10,),
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

                    currencyModel = state.currencies.firstWhere((thisCurrency) {
                      return myCurrency == null ? thisCurrency.code == 'UGX' : thisCurrency.code == myCurrency!.code.toString();
                    });

                    // currencyModel =
                    // myCurrency ?? state.currencies!.firstWhere(
                    //           (currency) => currency.code == 'UGX',
                    //       // orElse: () => null as CurrencyModel,
                    //       orElse: () => myCurrency!,
                    //     );
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
                            // defaultValue: myCurrency,
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
