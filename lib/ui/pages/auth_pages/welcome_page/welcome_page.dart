import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rent/data_layer/services/auth_service.dart';
import 'package:smart_rent/ui/pages/auth_pages/login_page/bloc/login_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/auth_textfield.dart';
import 'package:smart_rent/ui/widgets/custom_image.dart';
import 'package:smart_rent/ui/widgets/wide_button.dart';
import 'package:smart_rent/utilities/app_init.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final globalKey = GlobalKey();

  bool isAuthingUser = false;
  bool showLogin = true;
  bool isSendingResetRequest = false;
  bool hasFocus1 = false;
  bool hasFocus2 = false;
  bool shownChangeUser = true;
  var _height = 40.0;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      // body: BlocProvider(
      //   create: (context) => ProfilePicBloc(),
      //   child: BlocBuilder<ProfilePicBloc, ProfilePicState>(
      //     builder: (context, state) {
      //       return _buildBody();
      //     },
      //   ),
      // ),

      body: _buildBody(),

    );
  }

  Widget _buildTextWithLink(String data, String link) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: data,
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.whiteColor),
              ),
              TextSpan(
                text: link,
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.whiteColor,
                    color: AppTheme.whiteColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri(
                      scheme: "mailto",
                      path: "info@infosectechno.com",
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Infosec Technologies Info mail',
                      }),
                    ));
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextWithAction(String data) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: data,
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.whiteColor,
                    color: AppTheme.whiteColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await FlutterPhoneDirectCaller.callNumber('+256779416755');
                  },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _onPressed() {
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
                  print('My username is =${box.read('name')}');
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
          // context.read<LoginBloc>().add(FocusPassword());
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

  _signUserIn() async {
    final box = GetSecureStorage(
        password: 'infosec_technologies_ug_rent_manager');

    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.popUntil(context, (route) => false);
    Navigator.pushNamed(context, '/root');

    setState(() {
      savedBox.write('email', emailController.text.trim());
      savedBox.write('name', currentUsername);
    });

    print('My email =${savedBox.read('email')}');
    print('My name =${savedBox.read('name')}');

    // box.write('image', currentUser.avatar);

    // context.read<ProfilePicBloc>().add(GetProfilePic());
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

  _getCurrentUserData() async {
    final box = GetSecureStorage(
        password: 'infosec_technologies_ug_rent_manager');

    String? email = savedBox.read('email');
    String? name = savedBox.read('name');
    String? image = savedBox.read('image');

    setState(() {
      emailController.text = email ?? "";
      currentUsername = name;
      currentUserAvatar = image;
    });
  }

  Widget _buildPasswordResetBody() {
    return Column(
      children: [
        const Center(
          child: Text(
            'A Password reset link will be sent to the email entered below, '
            'click Proceed to continue',
            style: TextStyle(color: AppTheme.whiteColor, fontSize: 18),
          ),
        ),
        const SizedBox(height: 20),
        AutofillGroup(
          child: AppTextField(
            autofillHints: [AutofillHints.email],
            controller: emailController,
            hintText: 'email',
            // enabled: !isAuthingUser,
            obscureText: false,
            isEmail: true,
            style:  TextStyle(color: AppTheme.whiteColor),
            borderSide:  BorderSide(color: AppTheme.whiteColor),
            fillColor: AppTheme.primary,
          ),
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

  Widget _buildSignInBody() {
    return Column(
      children: [
        Center(
          child: Text(
            'Welcome back, $currentUsername!',
            style:  TextStyle(
                color: AppTheme.whiteColor,
                fontSize: 20,
                fontWeight: FontWeight.w300),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // const ProfilePic(
        //   width: 70,
        //   height: 70,
        // ),
        const SizedBox(
          height: 10,
        ),
        AutofillGroup(
          child: Focus(
            child: AuthPasswordTextField(
              autofillHints: [AutofillHints.password],
              controller: passwordController,
              hintText: 'password',
              // enabled: !isAuthingUser,
              borderSide: const BorderSide(color: AppTheme.gray45),
              style: const TextStyle(color: AppTheme.gray45),
              fillColor: Colors.transparent,
              iconColor: AppTheme.gray45,
            ),
            // onFocusChange: (hasFocus) {
            //   if (hasFocus1) {
            //     hasFocus1 = false;
            //   }
            //   hasFocus2 = true;
            //   (hasFocus2) ? _height = 0 : _height = 40;
            //   setState(() {});
            // },
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
                onPressed: _onPressed,
                bgColor: AppTheme.gray45,
                textStyle: const TextStyle(color: Colors.black54, fontSize: 18),
              ),
        const SizedBox(
          height: 10,
        ),
        if (emailController.text.isNotEmpty && shownChangeUser)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.gray45),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              'Change User',
              style: TextStyle(color: AppTheme.gray45, fontSize: 18),
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (kDebugMode)
          TextButton(
            onPressed: () {
              setState(() {
                showLogin = false;
              });
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

  Widget _buildBody() {
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
                              Container(
                                width: MediaQuery.of(context).size.width *.9,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                      image: AssetImage('assets/images/logo_white.png'),
                                  )
                                ),

                              ),

                              Icon(Icons.person, color: Colors.white, size: 50,),
                              (showLogin)
                                  ? _buildSignInBody()
                                  : _buildPasswordResetBody(),
                              const SizedBox(height: 10),
                              _buildFooter(),
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

  Widget _buildFooter() {
    return Column(
      children: [
        _buildTextWithLink('contact us: ', 'info@infosectechno.com'),
        const SizedBox(height: 8),
        _buildTextWithAction('+256 (0)779416755'),
        const SizedBox(height: 8),
        Text(
          'copyright @ ${DateTime.now().year} SmartCase Manager',
          style: const TextStyle(
            color: AppTheme.inActiveColor,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _getCurrentUserData();
  }
}
