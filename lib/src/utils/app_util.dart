class AppUtil {
  AppUtil._privateConstructor();

  bool isLogin = false;
  String? apiKey;
  bool isJustUpdatedApiKey = false;
  String userRecommendationKeySearch = "movie";

  static final AppUtil _instance = AppUtil._privateConstructor();

  static AppUtil get instance => _instance;
}
