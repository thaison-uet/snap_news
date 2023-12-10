import 'package:firebase_auth/firebase_auth.dart';

class AppUtil {
  AppUtil._privateConstructor();

  bool isLogin = false;
  bool isAllowLogin = true;
  User? user;
  String? apiKey;
  bool isJustUpdatedApiKey = false;
  String userRecommendationKeySearch = "flutter";

  static final AppUtil _instance = AppUtil._privateConstructor();

  static AppUtil get instance => _instance;
}
