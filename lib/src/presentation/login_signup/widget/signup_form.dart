import 'package:flutter/material.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/presentation/common/widget/already_have_an_account_acheck.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String? name;
  String? email;
  String? password;
  String? confirmedPassword;

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
                      // TODO: sign up
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

  bool isValidForm() {
    return (name?.isNotEmpty ?? false) &&
        ((name?.length ?? 0) <= 20) &&
        ((password?.length ?? 0) >= 6) &&
        ((password?.length ?? 0) <= 24) &&
        ((confirmedPassword?.length ?? 0) >= 6) &&
        ((confirmedPassword?.length ?? 0) <= 24) &&
        confirmedPassword == password;
  }
}
