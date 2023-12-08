import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/utils/app_util.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkLoginState();
    return Container(
      color: colorPrimary,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: Image.asset(
        "assets/icons/ic_logo_in_splash.png",
        width: 130.w,
        height: 130.w,
      ),
    );
  }

  Future<void> checkLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    AppUtil.instance.isLogin =
        prefs.getBool(CommonConstants.keyIsLogin) ?? false;
    Future.delayed(
        const Duration(milliseconds: 100),
        () => Navigator.of(context).pushNamedAndRemoveUntil(
              AppUtil.instance.isLogin ? home : login,
              (route) => false,
            ));
  }
}
