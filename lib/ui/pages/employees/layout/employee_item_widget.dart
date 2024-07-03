import 'package:smart_rent/data_layer/models/employee/employee_model.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/user_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:icons_plus/icons_plus.dart';


class EmployeeItemWidget extends StatelessWidget {
  final EmployeeModel employeeModel;
  const EmployeeItemWidget({super.key, required this.employeeModel});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Colors.transparent,
              foregroundColor: AppTheme.blue,
              icon: FontAwesome.pen_to_square,
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Colors.transparent,
              foregroundColor: AppTheme.red,
              icon: FontAwesome.trash_can,
            ),
          ],
        ),
        child: UserCardWidget(employeeModel: employeeModel,));
  }
}
