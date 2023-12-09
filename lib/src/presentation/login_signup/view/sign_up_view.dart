import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/presentation/common/widget/background.dart';
import 'package:news_app/src/presentation/common/widget/loading_indicator.dart';
import 'package:news_app/src/presentation/login_signup/widget/sign_up_top_image.dart';
import 'package:news_app/src/presentation/login_signup/widget/signup_form.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';
import 'package:news_app/src/utils/responsive.dart';

class SignUpView extends StatefulWidget {
  bool isShowLoading = false;

  SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background(
          child: Column(
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
                    child: Icon(
                      Icons.arrow_back,
                      color:
                          Guide.isDark(context) ? colorPrimary : colorPrimary,
                    )),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Spacer(),
                      Expanded(
                          flex: 8,
                          child: SignUpForm(
                              setStateLoadingIndicatorAction:
                                  loadingIndicatorCallback)),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              // SocalSignUp()
            ],
          ),
        ),
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
