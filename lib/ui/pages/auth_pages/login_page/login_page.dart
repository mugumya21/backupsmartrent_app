import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:smart_rent/data_layer/services/auth_service.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/bloc/auth/auth_bloc.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/bloc/login_bloc.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/widgets/login_footer_widget.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/widgets/login_widget.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/widgets/reset_password_widget.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/widgets/sign_in_widget.dart';
import 'package:smart_rent/ui/pages/auth_pages/welcome_page/welcome_page.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/auth_textfield.dart';
import 'package:smart_rent/ui/widgets/profile_pic_widget/bloc/profile_pic_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_rent/ui/widgets/wide_button.dart';
import 'package:smart_rent/utilities/app_init.dart';

import '../../../widgets/custom_image.dart';
import 'dart:developer' as developer;




class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  bool isAuthingUser = false;
  bool showLogin = true;
  bool isSendingResetRequest = false;
  bool hasFocus1 = false;
  bool hasFocus2 = false;
  bool shownChangeUser = true;


  String? email;

  var _height = 40.0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restartView();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: BlocBuilder<ProfilePicBloc, ProfilePicState>(
        builder: (context, state) {
          return _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 0, 1)
                                .withOpacity(0.2),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(30))),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomImage(
                                "assets/images/title_bar_white.png",
                                trBackground: false,
                                isNetwork: false,
                                isElevated: false,
                                width: MediaQuery.of(context).size.width * .6,
                                imageFit: BoxFit.contain,
                                radius: 0,
                              ),
                              (showLogin)
                                  ? _buildLoginBody()
                                  : _buildPasswordResetBody(),
                              // BlocBuilder<LoginBloc, LoginState>(
                              //   builder: (context, state) {
                              //     if (state.status.isInitial) {
                              //       context
                              //           .read<LoginBloc>()
                              //           .add(LoginInitial());
                              //     }
                              //     if (state.status.isLoginUser) {
                              //       return LoginWidget();
                              //     }
                              //     if (state.status.isForgotPassword) {
                              //       return ResetPasswordWidget();
                              //     }
                              //     if (state.status.isSignInUser) {
                              //       return SignInWidget();
                              //     }
                              //     return LoginWidget();
                              //   },
                              // ),
                              const SizedBox(height: 10),
                              const LoginFooterWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Text(
            'Welcome',
            softWrap: true,
            style: TextStyle(
                color: AppTheme.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        AutofillGroup(
          child: Column(
            children: [
              Focus(
                child: AppTextField(
                  autofillHints: const [AutofillHints.email],
                  hintText: 'email',
                  enabled: !isAuthingUser,
                  controller: emailController,
                  obscureText: false,
                  isEmail: true,
                  style: const TextStyle(color: AppTheme.gray45),
                  borderSide: const BorderSide(color: AppTheme.gray45),
                  fillColor: Colors.transparent,
                ),
                onFocusChange: (hasFocus) {
                  // if (context.read<AuthBloc>().state.isPasswordFocus) {
                  //   context.read<AuthBloc>().add(FocusEmail());
                  // }
                  // (context.read<AuthBloc>().state.isEmailFocused)
                  //     ? _height = 0
                  //     : _height = 40;

                  // context.read<AuthBloc>().add(RefreshScreen());
                },
              ),
              const SizedBox(height: 10),
              Focus(
                child: AuthPasswordTextField(
                  autofillHints: const [AutofillHints.password],
                  controller: passwordController,
                  hintText: 'password',
                  enabled: !isAuthingUser,
                  borderSide: const BorderSide(color: AppTheme.gray45),
                  style: const TextStyle(color: AppTheme.gray45),
                  fillColor: Colors.transparent,
                  iconColor: AppTheme.gray45,
                ),
                onFocusChange: (hasFocus) {
                  if (context.read<LoginBloc>().state.isEmailFocused) {
                    context.read<LoginBloc>().add(FocusPassword());
                  }
                  (context.read<LoginBloc>().state.isPasswordFocus)
                      ? _height = 0
                      : _height = 40;
                  // context.read<AuthBloc>().add(RefreshScreen());
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        (isAuthingUser)
            ? const CupertinoActivityIndicator(
          color: AppTheme.gray45,
          radius: 20,
        )
            : WideButton(
          name: 'Login',
          onPressed: () => _onPressed(context),
          bgColor: AppTheme.gray45,
          textStyle: const TextStyle(color: Colors.black54, fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        if (email != null &&
            email!.isNotEmpty &&
            shownChangeUser)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.gray45),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
              // context.read<LoginBloc>().add(SignInUser());
            },
            child: Text(
              'Back to ${currentUsername ?? "user"}',
              style: const TextStyle(color: AppTheme.gray45, fontSize: 18),
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        // if (kDebugMode)
        TextButton(
          onPressed: () {
            setState(() {
              showLogin = false;
            });
            // context.read<LoginBloc>().add(ForgotPassword());
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(
              color: AppTheme.whiteColor,
            ),
          ),
        ),
      ],
    );
  }

  _onPressed(BuildContext context) {
    if (emailController.text.isNotEmpty) {
      if (EmailValidator.validate(emailController.text.trim())) {
        if (passwordController.text.isNotEmpty) {

          setState(() {
            isAuthingUser = true;
            shownChangeUser = false;
          });


          AuthService.checkIfUserExists(
            emailController.text.trim(),
            onError: _handleError,
            onNoUser: _handleWrongEmail,
          ).then(
                  (url) {
                print('My User URL = $url');
                AuthService.signInUser(
                  url!,
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  onSuccess: _signUserIn,
                  onWrongPassword: _handleWrongPass,
                  onError: _handleError,
                ).then((user) {
                  final box = GetSecureStorage(
                      password: 'infosec_technologies_ug_rent_manager');
                  print('My User = $user');
                  savedBox.write('name', user!.user!.name.toString());
                  print('My username is =${savedBox.read('name')}');
                });
                });


          // AuthService.checkIfUserExists(
          //   emailController.text.trim(),
          //   onError: _handleError,
          //   onNoUser: _handleWrongEmail,
          // ).then(
          //       (url) {
          //         print('My User URL = $url');
          //         AuthService.signInUser(
          //           url!,
          //           emailController.text.trim(),
          //           passwordController.text.trim(),
          //           onSuccess: _signUserIn,
          //           onWrongPassword: _handleWrongPass,
          //           onError: _handleError,
          //         );
          //       }).then((user) {
          //         print('My User = $user');
          //         print('My User elements = ${user}');
          //         // if (user != null)
          //         //   AuthService.uploadFCMToken(emailController.text.trim())
          //       },
          // );

          // context.read<AuthBloc>().add(
          //   AuthenticateUser(
          //     emailController.text,
          //     passwordController.text,
          //   ),
          // );

        } else {
          Fluttertoast.showToast(
              msg: "No Password provided",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: AppTheme.red,
              textColor: AppTheme.whiteColor,
              fontSize: 16.0);
          context.read<LoginBloc>().add(FocusPassword());
        }
      } else {
        Fluttertoast.showToast(
            msg: "Email not valid",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: AppTheme.red,
            textColor: AppTheme.whiteColor,
            fontSize: 16.0);
        // context.read<AuthBloc>().add(FocusEmail());
      }
    } else {
      Fluttertoast.showToast(
          msg: "No email provided",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.red,
          textColor: AppTheme.whiteColor,
          fontSize: 16.0);
      // context.read<AuthBloc>().add(FocusEmail());
    }
  }

  _signUserIn() async {
    final box = GetSecureStorage(
        password: 'infosec_technologies_ug_rent_manager');

    // currentUserToken = state.token;

    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.popUntil(context, (route) => false);
    Navigator.pushNamed(context, '/root');

    savedBox.write('email', emailController.text.trim()).then((value) => setState(() {

    }));
    print('My email =${box.read('email')}');


    // box.write('image', currentUser.avatar);

    context.read<ProfilePicBloc>().add(GetProfilePic());
  }


  Widget _buildPasswordResetBody() {
    return Column(
      children: [
        const Text(
          'A Password reset link will be sent to the email entered below, '
              'click Proceed to continue',
          style: TextStyle(color: AppTheme.whiteColor, fontSize: 18),
        ),
        const SizedBox(height: 20),
        AppTextField(
          controller: emailController,
          hintText: 'email',
          enabled: !isAuthingUser,
          obscureText: false,
          isEmail: true,
          style: const TextStyle(color: AppTheme.whiteColor),
          borderSide: const BorderSide(color: AppTheme.whiteColor),
          fillColor: AppTheme.primary,
        ),
        const SizedBox(height: 10),
        _buildButtons(),
      ],
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            style: ButtonStyle(
              backgroundColor:
              MaterialStateColor.resolveWith((states) => AppTheme.gray45),
            ),
            onPressed: () {
              setState(() {
                isSendingResetRequest = false;
                showLogin = true;
              });
            },
            alignment: Alignment.center,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppTheme.primary,
              size: 30,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .6,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.gray45),
              ),
              onPressed: _onResetPressed,
              child: isSendingResetRequest
                  ? const SizedBox(
                height: 25,
                width: 25,
                child: CupertinoActivityIndicator(
                  color: AppTheme.gray45,
                ),
              )
                  : const Text(
                'Proceed',
                style: TextStyle(color: AppTheme.gray45, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onResetPressed() {
    if (EmailValidator.validate(emailController.text.trim())) {
      setState(() {
        isSendingResetRequest = true;
      });

      AuthService.requestReset(
        emailController.text,
        onError: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Fluttertoast.showToast(
              msg: "An error occurred",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: AppTheme.red,
              textColor: AppTheme.whiteColor,
              fontSize: 16.0);

          setState(() {
            isSendingResetRequest = false;
            showLogin = false;
          });
        },
        onSuccess: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Fluttertoast.showToast(
              msg: "Reset password link sent on your email",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: AppTheme.green,
              textColor: AppTheme.whiteColor,
              fontSize: 16.0);
          setState(() {
            isSendingResetRequest = false;
            showLogin = true;
          });
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Email not valid",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.red,
          textColor: AppTheme.whiteColor,
          fontSize: 16.0);
    }
  }

  restartView() async {
    _getCurrentUserData().then((value) {
      setState(() {});
    });
  }

  Future<void> _getCurrentUserData() async {
    email = savedBox.read('email');
  }

  _handleWrongEmail() {
    Fluttertoast.showToast(
        msg: "User not found",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppTheme.red,
        textColor: AppTheme.whiteColor,
        fontSize: 16.0);
    setState(() {
      isAuthingUser = false;
    });
  }

  _handleWrongPass() {
    Fluttertoast.showToast(
        msg: "Incorrect password",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppTheme.red,
        textColor: AppTheme.whiteColor,
        fontSize: 16.0);
    setState(() {
      isAuthingUser = false;
    });
  }

  _handleError() {
    Fluttertoast.showToast(
        msg: "An error occurred",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppTheme.red,
        textColor: AppTheme.whiteColor,
        fontSize: 16.0);
    setState(() {
      isAuthingUser = false;
    });
  }


}




// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//
//
//   bool isAuthingUser = false;
//   bool showLogin = true;
//   bool isSendingResetRequest = false;
//   bool hasFocus1 = false;
//   bool hasFocus2 = false;
//   bool shownChangeUser = true;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.primary,
//       body: BlocBuilder<ProfilePicBloc, ProfilePicState>(
//         builder: (context, state) {
//           return _buildBody(context);
//         },
//       ),
//     );
//   }
//
//   Widget _buildBody(BuildContext context) {
//     return SingleChildScrollView(
//       physics: const NeverScrollableScrollPhysics(),
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Center(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(30),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                       child: Container(
//                         padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
//                         decoration: BoxDecoration(
//                             color: const Color.fromRGBO(0, 0, 0, 1)
//                                 .withOpacity(0.2),
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(30))),
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         child: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CustomImage(
//                                 "assets/images/title_bar_white.png",
//                                 trBackground: false,
//                                 isNetwork: false,
//                                 isElevated: false,
//                                 width: MediaQuery.of(context).size.width * .6,
//                                 imageFit: BoxFit.contain,
//                                 radius: 0,
//                               ),
//                               BlocBuilder<LoginBloc, LoginState>(
//                                 builder: (context, state) {
//                                   if (state.status.isInitial) {
//                                     context
//                                         .read<LoginBloc>()
//                                         .add(LoginInitial());
//                                   }
//                                   if (state.status.isLoginUser) {
//                                     return LoginWidget();
//                                   }
//                                   if (state.status.isForgotPassword) {
//                                     return ResetPasswordWidget();
//                                   }
//                                   if (state.status.isSignInUser) {
//                                     return SignInWidget();
//                                   }
//                                   return LoginWidget();
//                                 },
//                               ),
//                               const SizedBox(height: 10),
//                               const LoginFooterWidget(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
