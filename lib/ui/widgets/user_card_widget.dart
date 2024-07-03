import 'package:get/get_utils/get_utils.dart';
import 'package:smart_rent/data_layer/models/employee/employee_model.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatelessWidget {
  final EmployeeModel employeeModel;
  const UserCardWidget({super.key, required this.employeeModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
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
        tileColor: AppTheme.itemBgColor,
        leading: CircleAvatar(child: Icon(Icons.person ),),
        title: Text('${employeeModel.firstName.toString().capitalizeFirst} ${employeeModel.lastName.toString().capitalizeFirst}'),
        subtitle: Text(employeeModel.telephone.toString()),
      ),
    );
  }
}
