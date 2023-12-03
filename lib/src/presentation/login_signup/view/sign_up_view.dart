import 'package:flutter/material.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/presentation/common/widget/background.dart';
import 'package:news_app/src/presentation/login_signup/widget/sign_up_top_image.dart';
import 'package:news_app/src/presentation/login_signup/widget/signup_form.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';
import 'package:news_app/src/utils/responsive.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Responsive(
        mobile: const MobileSignUpView(),
        desktop: Row(
          children: [
            const Expanded(
              child: SignUpViewTopImage(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 450,
                    child: SignUpForm(),
                  ),
                  SizedBox(height: CommonConstants.defaultPadding / 2),
                  // SocalSignUp()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MobileSignUpView extends StatelessWidget {
  const MobileSignUpView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        // SignUpViewTopImage(),
        Container(
          margin: const EdgeInsets.only(top: 52, left: 18),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              "assets/icons/ic_back.png",
              color: colorPrimary,
              width: 22,
              height: 22,
            ),
          ),
        ),
        const Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 8,
                  child: SignUpForm(),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
        // SocalSignUp()
      ],
    );
  }
}
