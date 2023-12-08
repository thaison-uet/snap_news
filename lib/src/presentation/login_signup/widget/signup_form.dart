import 'dart:async';
import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/presentation/common/widget/already_have_an_account_acheck.dart';
import 'package:news_app/src/utils/app_util.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpForm extends StatefulWidget {
  final Function(bool) setStateLoadingIndicatorAction;

  const SignUpForm({
    Key? key,
    required this.setStateLoadingIndicatorAction,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  StreamSubscription<User?>? authenListener;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();
  String? name;
  String? email;
  String? password;
  String? confirmedPassword;

  @override
  void initState() {
    super.initState();

    AppUtil.instance.isAllowLogin = false;
    if (!AppUtil.instance.isLogin) {
      authenListener =
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
        print("SSSSS: listened in ${ModalRoute.of(context)?.settings.name}");
        if (user == null) {
          print('SSSSS: User is currently signed out!');
          widget.setStateLoadingIndicatorAction(false);
        } else {
          user.updateDisplayName(name).then((value) {
            FirebaseAuth.instance.signOut().then((value) {
              print('SSSSS: Sign-up successfully');

              Future.delayed(const Duration(milliseconds: 200), () {
                clearAllFields();
                widget.setStateLoadingIndicatorAction(false);
              });

              Fluttertoast.showToast(
                  msg: "Thanks for signing up.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: colorPrimaryOpacity80,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.of(context)
                    .popUntil((route) => route.settings.name == login);
              });

              // Navigator.of(context).popUntil(
              //   home,
              //   (route) => false,
              // );
              // Guide.to(
              //   name: home,
              // );
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Sign Up',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: colorPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: CommonConstants.defaultPadding * 2),
          TextFormField(
            controller: nameController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: colorPrimary,
            onChanged: (name) {
              setState(() {
                this.name = name;
              });
            },
            onSaved: (name) {},
            decoration: InputDecoration(
              hintText: "Your name",
              prefixIcon: Padding(
                padding: EdgeInsets.all(CommonConstants.defaultPadding),
                child: const Icon(Icons.person_3_outlined),
              ),
            ),
          ),
          SizedBox(height: CommonConstants.defaultPadding),
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
          SizedBox(height: CommonConstants.defaultPadding),
          TextFormField(
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
          SizedBox(height: CommonConstants.defaultPadding),
          TextFormField(
            controller: confirmedPasswordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: colorPrimary,
            onChanged: (confirmedPassword) {
              setState(() {
                this.confirmedPassword = confirmedPassword;
              });
            },
            decoration: InputDecoration(
              hintText: "Confirm your password",
              prefixIcon: Padding(
                padding: EdgeInsets.all(CommonConstants.defaultPadding),
                child: const Icon(Icons.lock),
              ),
            ),
          ),
          SizedBox(height: CommonConstants.defaultPadding),
          SizedBox(height: CommonConstants.defaultPadding / 2),
          SizedBox(height: CommonConstants.defaultPadding),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: Colors.transparent)))),
              onPressed: isValidForm()
                  ? () {
                      signUp();
                    }
                  : null,
              child: Text(
                "Sign Up".toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: CommonConstants.defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> signUp() async {
    FocusScope.of(context).unfocus();
    if (!isValidForm()) {
      return;
    }

    widget.setStateLoadingIndicatorAction(true);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
    } on FirebaseAuthException catch (e) {
      clearAllFields();
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Fluttertoast.showToast(
            msg: "${e.message}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: colorPrimaryOpacity80,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Fluttertoast.showToast(
            msg: "${e.message}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: colorPrimaryOpacity80,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
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
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: colorPrimaryOpacity80,
          textColor: Colors.white,
          fontSize: 16.0);
      widget.setStateLoadingIndicatorAction(false);
    }
  }

  bool isValidForm() {
    return (name?.isNotEmpty ?? false) &&
        ((name?.length ?? 0) <= 20) &&
        ((password?.length ?? 0) >= 6) &&
        ((password?.length ?? 0) <= 24) &&
        ((confirmedPassword?.length ?? 0) >= 6) &&
        ((confirmedPassword?.length ?? 0) <= 24) &&
        confirmedPassword == password;
  }

  void clearAllFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmedPasswordController.clear();
  }

  @override
  void dispose() {
    AppUtil.instance.isAllowLogin = true;
    // print('SSSSS: cancel listener signup');
    // authenListener?.cancel();
    super.dispose();
  }
}
