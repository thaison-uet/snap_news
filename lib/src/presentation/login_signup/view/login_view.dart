import 'package:flutter/material.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/presentation/common/widget/background.dart';
import 'package:news_app/src/presentation/login_signup/widget/login_form.dart';
import 'package:news_app/src/presentation/login_signup/widget/login_top_image.dart';
import 'package:news_app/src/utils/responsive.dart';

import '../../common/widget/curve_clipper.dart';
import '../../common/widget/loading_indicator.dart';

class LoginView extends StatefulWidget {
  bool isShowLoading = false;

  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background(
            child: Column(
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 8,
                        child: LoginForm(
                            setStateLoadingIndicatorAction:
                                loadingIndicatorCallback),
                      ),
                      const Spacer(),
                    ],
                  )),
            )
          ],
        )),
        LoadingView(isVisible: widget.isShowLoading)
      ],
    );
  }

  void loadingIndicatorCallback(bool isShow) {
    setState(() {
      widget.isShowLoading = isShow;
    });
  }
}
