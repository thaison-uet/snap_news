import 'package:flutter/material.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/presentation/common/widget/background.dart';
import 'package:news_app/src/presentation/login_signup/widget/login_form.dart';
import 'package:news_app/src/presentation/login_signup/widget/login_top_image.dart';
import 'package:news_app/src/utils/responsive.dart';

import '../../common/widget/curve_clipper.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
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
    );
  }
}

class MobileLoginView extends StatelessWidget {
  const MobileLoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipPath(
          clipper: CurveClipper(),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(
                "assets/images/img_login_cover.jpg",
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.fitWidth,
              ),
              Container(
                color: colorPrimaryOpacity40,
                height: MediaQuery.of(context).size.height * 0.3,
              ),
            ],
          ),
        ),
        // LoginViewTopImage(),
        Expanded(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              alignment: Alignment.center,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Expanded(
                    flex: 8,
                    child: LoginForm(),
                  ),
                  Spacer(),
                ],
              )),
        )
      ],
    );
  }
}
