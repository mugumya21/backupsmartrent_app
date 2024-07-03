import 'package:smart_rent/data_layer/models/employee/employee_model.dart';
import 'package:smart_rent/ui/pages/employees/bloc/employee_bloc.dart';
import 'package:smart_rent/ui/pages/employees/layout/employee_item_widget.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/pages/root/bloc/nav_bar_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_search_textfield.dart';
import 'package:smart_rent/ui/widgets/appbar_content.dart';
import 'package:smart_rent/utilities/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EmployeeSuccessWidget extends StatefulWidget {
  const EmployeeSuccessWidget({super.key});

  @override
  State<EmployeeSuccessWidget> createState() => _EmployeeSuccessWidgetState();
}

class _EmployeeSuccessWidgetState extends State<EmployeeSuccessWidget> {
  TextEditingController searchController = TextEditingController();
  List<EmployeeModel> employees = <EmployeeModel>[];
  List<EmployeeModel> filteredData = <EmployeeModel>[];


  void filterEmployees(String query,) {

    setState(() {
      filteredData = employees
          .where((employee) =>

      employee.firstName
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())
          ||
          employee.lastName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())
          ||
          employee.middleName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())
      )
          .toList();
    });
    print('My Filtered employees List $filteredData');
    print('My Initial employees List $employees');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usersScrollController.addListener(() {
      if (usersScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (context.read<NavBarBloc>().state.isVisible != false) {
          context.read<NavBarBloc>().add(ChangeNavBarVisibility(
              false, context.read<NavBarBloc>().state.idSelected));
        }
      } else {
        if (context.read<NavBarBloc>().state.isVisible != true) {
          context.read<NavBarBloc>().add(ChangeNavBarVisibility(
              true, context.read<NavBarBloc>().state.idSelected));
        }
      }
    });

    return _buildBody();
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: AppTheme.appBgColor,
      appBar: AppBar(
        title: const TitleBarImageHolder(),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
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
              onChanged: filterEmployees,
            ),
          ),


          BlocBuilder<EmployeeBloc, EmployeeState>(
            builder: (context, state) {

              if (state.status ==  EmployeeStatus.initial) {
                context.read<EmployeeBloc>().add(LoadAllEmployees());
              }
              if (state.status == EmployeeStatus.success) {

                employees = state.employees!;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Employees:', style: AppTheme.appTitle3,),
                          Text(employees.length.toString(), style: AppTheme.blueAppTitle3,),
                        ],
                      ),
                    ),

                    ListView.builder(
                        controller: usersScrollController,
                        shrinkWrap: true,
                        itemCount: filteredData.isEmpty ? employees.length : filteredData.length,
                        itemBuilder: (context, index) {
                          var employee = filteredData.isEmpty ? employees[index] : filteredData[index];
                          return EmployeeItemWidget(employeeModel: employee,);
                        }),
                  ],
                );
              }
              if (state.status == EmployeeStatus.loading) {
                return const LoadingWidget();
              }
              if (state.status == EmployeeStatus.error) {
                return Center(child: Text('Error loading employees'),);

              }
              if (state.status == EmployeeStatus.empty) {
                return Center(child: Text('No Employees'),);

              }
              return  Container();
            },
          ),

        ],
      ),
      // body: ListView.builder(
      //     controller: usersScrollController,
      //     shrinkWrap: true,
      //     itemCount: 20,
      //     itemBuilder: (context, index) {
      //       return const EmployeeItemWidget();
      //     }),
    );
  }
}
