import 'package:flutter/material.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/presentation/common/widget/already_have_an_account_acheck.dart';
import 'package:news_app/src/presentation/login_signup/view/sign_up_view.dart';
import 'package:news_app/src/utils/app_util.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
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
              onPressed: () {
                AppUtil.instance.isLogin = true;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  home,
                  (route) => false,
                );
              },
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpView();
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
