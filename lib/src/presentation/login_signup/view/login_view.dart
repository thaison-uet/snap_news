import 'package:flutter/material.dart';
import 'package:news_app/src/presentation/common/widget/background.dart';
import 'package:news_app/src/presentation/login_signup/widget/login_form.dart';
import 'package:news_app/src/presentation/login_signup/widget/login_top_image.dart';
import 'package:news_app/src/utils/responsive.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginView(),
          desktop: Row(
            children: [
              Expanded(
                child: LoginViewTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginView extends StatelessWidget {
  const MobileLoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoginViewTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
