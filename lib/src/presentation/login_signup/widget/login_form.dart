import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/presentation/common/widget/already_have_an_account_acheck.dart';
import 'package:news_app/src/utils/app_util.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  final Function(bool) setStateLoadingIndicatorAction;

  const LoginForm({
    Key? key,
    required this.setStateLoadingIndicatorAction,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  StreamSubscription<User?>? authenListener;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? email;
  String? password;

  @override
  void initState() {
    super.initState();

    if (!AppUtil.instance.isLogin) {
      authenListener =
          FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        print("SSSSS: listened in ${ModalRoute.of(context)?.settings.name}");
        if (user == null) {
          print('SSSSS: User is currently signed out!');
          widget.setStateLoadingIndicatorAction(false);
        } else {
          if (AppUtil.instance.isAllowLogin) {
            print(
                'SSSSS: User is signed in: ${user.email} - ${user.displayName}})');
            Future.delayed(const Duration(milliseconds: 200), () {
              clearAllFields();
              widget.setStateLoadingIndicatorAction(false);
            });

            AppUtil.instance.isLogin = true;
            AppUtil.instance.user = user;
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setBool(
                CommonConstants.keyIsLogin, AppUtil.instance.isLogin);

            // ignore: use_build_context_synchronously
            Navigator.of(context).pushNamedAndRemoveUntil(
              home,
              (route) => false,
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Text(
            //   'Login',
            //   textAlign: TextAlign.left,
            //   style: TextStyle(
            //     fontSize: 20,
            //     color: colorPrimary,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(height: CommonConstants.defaultPadding * 2),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: colorPrimary,
              onChanged: (email) {
                setState(() {
                  this.email = email;
                });
              },
              onSaved: (email) {},
              decoration: InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(CommonConstants.defaultPadding),
                  child: const Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: CommonConstants.defaultPadding),
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                cursorColor: colorPrimary,
                onChanged: (password) {
                  setState(() {
                    this.password = password;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Your password",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(CommonConstants.defaultPadding),
                    child: const Icon(Icons.lock),
                  ),
                ),
              ),
            ),
            SizedBox(height: CommonConstants.defaultPadding),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side:
                                const BorderSide(color: Colors.transparent)))),
                onPressed: isValidForm()
                    ? () {
                        login();
                      }
                    : null,
                child: Text(
                  "Login".toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: CommonConstants.defaultPadding),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.of(context).pushNamed(signUp);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return SignUpView();
                //     },
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();
    if (!isValidForm()) {
      return;
    }

    widget.setStateLoadingIndicatorAction(true);

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      clearAllFields();
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Fluttertoast.showToast(
            msg: "No user found for that email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: colorPrimaryOpacity80,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password') {
        print('Your password is incorrect.');
        Fluttertoast.showToast(
            msg: "Your password is incorrect.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: colorPrimaryOpacity80,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'invalid-credential') {
        print('User not found.');
        Fluttertoast.showToast(
            msg: "User not found.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: colorPrimaryOpacity80,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print('${e.message}');
        Fluttertoast.showToast(
            msg: "${e.message}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: colorPrimaryOpacity80,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      widget.setStateLoadingIndicatorAction(false);
    }
  }

  bool isValidForm() {
    return (email?.isNotEmpty ?? false) &&
        ((password?.length ?? 0) >= 6) &&
        ((password?.length ?? 0) <= 24);
  }

  void clearAllFields() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    // print('SSSSS: cancel listener login');
    // authenListener?.cancel();
    super.dispose();
  }
}
