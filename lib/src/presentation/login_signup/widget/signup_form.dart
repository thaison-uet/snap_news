import 'package:flutter/material.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/presentation/common/widget/already_have_an_account_acheck.dart';
import 'package:news_app/src/presentation/login_signup/view/login_view.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: colorPrimary,
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
            padding:
                EdgeInsets.symmetric(vertical: CommonConstants.defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: colorPrimary,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(CommonConstants.defaultPadding),
                  child: const Icon(Icons.lock),
                ),
              ),
            ),
          ),
          SizedBox(height: CommonConstants.defaultPadding / 2),
          ElevatedButton(
            onPressed: () {},
            child: Text("Sign Up".toUpperCase()),
          ),
          SizedBox(height: CommonConstants.defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginView();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
