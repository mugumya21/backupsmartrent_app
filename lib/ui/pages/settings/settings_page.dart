import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smart_rent/data_layer/services/auth_service.dart';
import 'package:smart_rent/ui/pages/account/bloc/account_bloc.dart';
import 'package:smart_rent/ui/pages/account/form/change_password_form.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/appbar_content.dart';
import 'package:flutter/material.dart';
import 'package:smart_rent/utilities/app_init.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
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
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){

                showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                                create: (context) =>
                                    AccountBloc()),
                          ],
                          child:  ChangePasswordForm(
                              addButtonText: 'Change', isUpdate: false));
                    });

              },
              child: Row(
                children: [
                  Icon(Icons.password, size: 30,),
                  SizedBox(width: 10,),
                  Text('Change Password', style: AppTheme.blueAppTitle3,)
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){

                AuthService.signOutUser(context);

              },
              child: Row(
                children: [
                  Icon(Icons.logout, size: 30, color: AppTheme.red,),
                  SizedBox(width: 10,),
                  Text('Logout', style: AppTheme.blueAppTitle3,)
                ],
              ),
            ),
          ),



        ],
      ),
    );
  }
}
