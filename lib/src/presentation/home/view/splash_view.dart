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
    return Scaffold(
      backgroundColor: Guide.isDark(context) ? colorsBlack : colorWhite,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: Image.asset(
                    "assets/icons/app.jpg",
                    width: 130.w,
                    height: 130.w,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("An Application Made With")
                          .normalSized(12)
                          .colors(Guide.isDark(context)
                              ? darkThemeText
                              : colorTextGray),
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    AppUtil.instance.isLogin =
        prefs.getBool(CommonConstants.keyIsLogin) ?? false;
    Future.delayed(
        const Duration(milliseconds: 50),
        () => Navigator.of(context).pushNamedAndRemoveUntil(
              AppUtil.instance.isLogin ? home : login,
              (route) => false,
            ));
  }
}
