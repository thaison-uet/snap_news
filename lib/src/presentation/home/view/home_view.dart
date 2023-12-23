import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:news_app/src/core/components/component_skeleton.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/domain/entitites/category_type.dart';
import 'package:news_app/src/presentation/common/widget/loading_indicator.dart';
import 'package:news_app/src/presentation/home/widget/hot_skeleton_widget.dart';
import 'package:news_app/src/presentation/login_signup/view/login_view.dart';
import 'package:news_app/src/utils/app_util.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../domain/entitites/news_entities.dart';
import '../bloc/enum_home_bloc.dart';
import '../bloc/home_news/home_news_bloc.dart';
import '../bloc/theme/theme_mode_bloc.dart';
import '../widget/trending_skeleton_widget.dart';

class HomeView extends StatefulWidget {
  bool isShowLoading = false;

  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> offerPercentage = ['10%', '30%', '50%'];
  final List<NewsEntities> data = [];
  late PageController controller;
  int _cIndex = 0;
  List<String> homeTitles = [];

  @override
  void initState() {
    controller = PageController();
    AppUtil.instance.user ??= FirebaseAuth.instance.currentUser;
    if (AppUtil.instance.user != null) {
      homeTitles = [
        "${AppUtil.instance.user!.displayName}! News time, dive in!",
        "What's breaking, ${AppUtil.instance.user!.displayName}",
        "Read the latest buzz",
        "News for you, ${AppUtil.instance.user!.displayName}",
        "Breaking news alert!"
      ];
    } else {
      homeTitles = ["Hello"]; // This case should not occurs
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: Guide.isDark(context) ? colorsBlack : colorWhite,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(homeTitles[Random().nextInt(homeTitles.length)])
                  .blackSized(23)
                  .colors(Guide.isDark(context) ? darkThemeText : colorsBlack),
              const SizedBox(height: 4),
              Text(
                DateFormat.yMMMMEEEEd().format(
                  DateTime.now(),
                ),
              ).boldSized(12).colors(colorTextGray),
            ],
          ),
          actions: [
            BlocBuilder<ThemeModeBloc, ThemeModeState>(
              builder: (_, state) {
                return Switch(
                  value: state.isDarkMode,
                  onChanged: (value) {
                    BlocProvider.of<ThemeModeBloc>(context)
                        .add(const ChangeThemeModeEvent());
                  },
                  activeColor: colorPrimary,
                  activeTrackColor: darkThemeText,
                  inactiveThumbColor: colorPrimary,
                  inactiveTrackColor: borderGray,
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Guide.isDark(context) ? colorsBlack : colorWhite,
                  elevation: 0,
                ),
                child: Image.asset("assets/icons/ic_sign_out.png",
                    width: 24.w, height: 24.h, color: colorPrimary)),
          ],
        ),
        body: Stack(children: [
          RefreshIndicator(
            onRefresh: () async {
              context.read<HomeNewsBloc>().add(const GetRecommendationNews());
              context.read<HomeNewsBloc>().add(const GetHotNews());
              context.read<HomeNewsBloc>().add(const GetTrendingNews());
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: Guide.isDark(context)
                      ? [
                          colorsBlack,
                          // colorsBlackGray,
                          colorsBlack
                        ]
                      : [
                          colorWhite,
                          // colorGray,
                          colorWhite
                        ],
                  // stops: [],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _sliderNewsWidget(),
                    SizedBox(height: 25.h),
                    // _categorySliderWidget(),
                    // SizedBox(height: 20.h),
                    _hotTextWidget(),
                    SizedBox(height: 10.h),
                    _hotNewsWidget(),
                    SizedBox(height: 25.h),
                    _recommendationTextWidget(),
                    SizedBox(height: 10.h),
                    _recommendationNews(),
                    SizedBox(height: 25.h),
                  ],
                ),
              ),
            ),
          ),
          LoadingView(isVisible: widget.isShowLoading)
        ]),
      ),
    );
  }

  Future<void> signOut() async {
    setState(() {
      widget.isShowLoading = true;
    });
    await FirebaseAuth.instance.signOut().then((value) async {
      setState(() {
        widget.isShowLoading = true;
      });
      AppUtil.instance.isLogin = false;
      AppUtil.instance.user = null;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(CommonConstants.keyIsLogin, AppUtil.instance.isLogin);

      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          PageRouteBuilder(pageBuilder: (BuildContext context,
              Animation animation, Animation secondaryAnimation) {
            return LoginView();
          }, transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          }),
          (Route route) => false);
    });
  }

  Widget _recommendationTextWidget() {
    return BlocBuilder<HomeNewsBloc, HomeNewsState>(
      builder: (_, state) {
        return state.statusRecommendation == HomeBlocStatus.loading
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Shimmer.fromColors(
                  baseColor:
                      Guide.isDark(context) ? Colors.white24 : Colors.black,
                  highlightColor: darkThemeText,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Skeleton(width: 80.w),
                      Skeleton(width: 80.w),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Recommendation").boldSized(16).colors(
                            Guide.isDark(context)
                                ? darkThemeText
                                : colorsBlack),
                        GestureDetector(
                          onTap: () => Guide.to(
                            name: categoryNews,
                            arguments: CategoryNewsViewArgument(
                              category: "business",
                              query: "",
                              isKeyword: false,
                            ),
                          ),
                          child: const Text("See more")
                              .boldSized(12)
                              .colors(colorPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _recommendationNews() {
    return BlocBuilder<HomeNewsBloc, HomeNewsState>(
      builder: (_, state) {
        if (state.statusRecommendation == HomeBlocStatus.loading) {
          List loading = [1, 2, 3];
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: loading
                  .asMap()
                  .map(
                    (index, value) => MapEntry(
                      index,
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 5.h,
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Guide.isDark(context)
                              ? Colors.white24
                              : Colors.black,
                          highlightColor: darkThemeText,
                          child: const TrendingSkeletonWidget(),
                        ),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          );
        }
        if (state.statusRecommendation == HomeBlocStatus.loaded) {
          final recommendation = state.recommendation?.articles ?? [];
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: recommendation
                    .asMap()
                    .map(
                      (index, value) => MapEntry(
                        index,
                        GestureDetector(
                          onTap: () => Guide.to(
                            name: detail,
                            arguments: recommendation[index],
                          ),
                          child: Container(
                            height: 85.h,
                            margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              // color: Theme.of(context).brightness ==
                              //         Brightness.dark
                              //     ? colorsBlack
                              //     : colorWhite,
                              color: transparent,
                              border: Border.all(
                                // color: Theme.of(context).brightness ==
                                //         Brightness.dark
                                //     ? Colors.grey.withOpacity(0.1)
                                //     : borderGray,
                                color: transparent,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: SizedBox(
                                    width: 100.w,
                                    height: 85.h,
                                    child: recommendation[index]
                                            .urlToImage
                                            .isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: recommendation[index]
                                                .urlToImage,
                                            imageBuilder: (c, image) =>
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                            errorWidget: (context, url, error) {
                                              print(
                                                  'CachedNetworkImage error: $error');
                                              return Image.asset(
                                                  width: 115.w,
                                                  height: 100.h,
                                                  CommonConstants
                                                      .emptyImagePath,
                                                  fit: BoxFit.contain);
                                            })
                                        : Image.asset(
                                            width: 115.w,
                                            height: 100.h,
                                            CommonConstants.emptyImagePath,
                                            fit: BoxFit.contain),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    // padding: EdgeInsets.symmetric(
                                    //   horizontal: 10.w,
                                    //   vertical: 8.h,
                                    // ),
                                    padding: EdgeInsets.fromLTRB(
                                        14.w, 8.h, 0.w, 8.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          // width: 220.w,
                                          width: double.infinity,
                                          child: Text(
                                            recommendation[index].title,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ).boldSized(14).colors(
                                              Guide.isDark(context)
                                                  ? darkThemeText
                                                  : colorsBlack),
                                        ),
                                        // SizedBox(
                                        //   width: 220.w,
                                        //   child: Text(
                                        //     recommendation[index].description,
                                        //     maxLines: 3,
                                        //     textAlign: TextAlign.justify,
                                        //     overflow: TextOverflow.ellipsis,
                                        //   ).normalSized(12).colors(
                                        //         Guide.isDark(context)
                                        //             ? darkThemeText
                                        //             : colorsBlack,
                                        //       ),
                                        // ),
                                        SizedBox(
                                          // width: 220.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    recommendation[index]
                                                        .source
                                                        .name,
                                                  )
                                                      .boldSized(10)
                                                      .colors(colorTextGray)
                                                ],
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    timeago.format(
                                                      recommendation[index]
                                                          .publishedAt,
                                                    ),
                                                  )
                                                      .boldSized(10)
                                                      .colors(colorTextGray),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
          );
        }

        return Container(
          height: 100.h,
        );
      },
    );
  }

  Widget _hotTextWidget() {
    return BlocBuilder<HomeNewsBloc, HomeNewsState>(
      builder: (_, state) {
        return state.statusRecommendation == HomeBlocStatus.loading
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Shimmer.fromColors(
                  baseColor:
                      Guide.isDark(context) ? Colors.white24 : Colors.black,
                  highlightColor: darkThemeText,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Skeleton(width: 80.w),
                      Skeleton(width: 80.w),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Hot News").boldSized(16).colors(
                            Guide.isDark(context)
                                ? darkThemeText
                                : colorsBlack),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.star,
                          size: 14.w,
                          color: colorStar,
                        ),
                      ],
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _hotNewsWidget() {
    return BlocBuilder<HomeNewsBloc, HomeNewsState>(
      builder: (_, state) {
        if (state.statusHot == HomeBlocStatus.loading) {
          List loading = [1, 2];
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: loading
                  .asMap()
                  .map(
                    (index, value) => MapEntry(
                      index,
                      Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 15.w : 0,
                          right: 7.w,
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Guide.isDark(context)
                              ? Colors.white24
                              : Colors.black,
                          highlightColor: darkThemeText,
                          child: const HotSekeletonWidget(),
                        ),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          );
        }
        if (state.statusHot == HomeBlocStatus.loaded) {
          final articles = state.hot?.articles ?? [];
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: articles
                  .asMap()
                  .map(
                    (index, value) => MapEntry(
                      index,
                      GestureDetector(
                        onTap: () => Guide.to(
                          name: detail,
                          arguments: articles[index],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 15.w : 0,
                            right: 7.w,
                          ),
                          child: Container(
                            width: 200.w,
                            height: 215.h,
                            margin: EdgeInsets.only(right: 6.w),
                            decoration: BoxDecoration(
                              color: Guide.isDark(context)
                                  ? colorsBlack
                                  : colorWhite,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                  width: 0.7,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? colorsBlackGray
                                      : borderGray),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.r),
                                    topRight: Radius.circular(8.r),
                                  ),
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    height: 100.h,
                                    child: Stack(
                                      children: [
                                        articles[index].urlToImage.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    articles[index].urlToImage,
                                                imageBuilder: (c, image) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) {
                                                  print(
                                                      'CachedNetworkImage error: ${CachedNetworkImage}');
                                                  return Image.asset(
                                                      width: 115.w,
                                                      height: 100.h,
                                                      CommonConstants
                                                          .emptyImagePath,
                                                      fit: BoxFit.contain);
                                                })
                                            : Image.asset(
                                                width: double.maxFinite,
                                                height: 100.h,
                                                CommonConstants.emptyImagePath,
                                                fit: BoxFit.contain),
                                        // Positioned(
                                        //   top: 9.h,
                                        //   right: 10.w,
                                        //   child: Container(
                                        //     width: 35.w,
                                        //     height: 15.h,
                                        //     decoration: BoxDecoration(
                                        //       color: Guide.isDark(context)
                                        //           ? colorsBlack
                                        //           : colorWhite,
                                        //       borderRadius:
                                        //           BorderRadius.circular(
                                        //         8.r,
                                        //       ),
                                        //     ),
                                        //     child: Padding(
                                        //       padding: EdgeInsets.symmetric(
                                        //         horizontal: 5.w,
                                        //       ),
                                        //       child: Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment
                                        //                 .spaceBetween,
                                        //         children: [
                                        //           const Text("Hot")
                                        //               .semiBoldSizedItalic(9)
                                        //               .colors(
                                        //                 Guide.isDark(context)
                                        //                     ? darkThemeText
                                        //                     : colorsBlack,
                                        //               ),

                                        //           Icon(
                                        //             Icons.star,
                                        //             size: 9.w,
                                        //             color: colorStar,
                                        //           ),
                                        //           // Image.asset(
                                        //           //   "assets/icons/icons_fire.png",
                                        //           //   width: 9.4.w,
                                        //           //   height: 8.5.h,
                                        //           // )
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 8.h,
                                  ),
                                  child: const Text(
                                    "HOT", // TODO: sondt
                                  ).boldSized(10).colors(textGray),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                  ),
                                  child: SizedBox(
                                    width: 164.w,
                                    child: Text(
                                      articles[index].title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ).boldSized(15).colors(
                                          Guide.isDark(context)
                                              ? darkThemeText
                                              : colorsBlack,
                                        ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    bottom: 9.h,
                                    top: 9.h,
                                  ),
                                  child: SizedBox(
                                    width: 210.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            // CircleAvatar(
                                            //   radius: 10.r,
                                            //   backgroundColor: colorPrimary,
                                            //   backgroundImage: index + 1 < 5
                                            //       ? AssetImage(
                                            //           "assets/profile/${index + 1}.jpg",
                                            //         )
                                            //       : const AssetImage(
                                            //           "assets/profile/5.jpg",
                                            //         ),
                                            // ),
                                            // SizedBox(
                                            //   width: 7.w,
                                            // ),
                                            SizedBox(
                                              width: 110.w,
                                              child: Text(
                                                articles[index].source.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              )
                                                  .boldSized(10)
                                                  .colors(colorTextGray),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            timeago.format(
                                              articles[index].publishedAt,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.end,
                                          ).boldSized(10).colors(colorTextGray),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _categorySliderWidget() {
    List category = [
      CategoryType.business.name,
      CategoryType.entertainment.name,
      CategoryType.general.name,
      CategoryType.health.name,
      CategoryType.science.name,
      CategoryType.sports.name,
      CategoryType.technology.name
    ];
    return BlocBuilder<HomeNewsBloc, HomeNewsState>(
      builder: (_, state) {
        return state.statusTrending == HomeBlocStatus.loading
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: category
                      .asMap()
                      .map((key, value) => MapEntry(
                          key,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Shimmer.fromColors(
                              baseColor: Guide.isDark(context)
                                  ? Colors.white24
                                  : Colors.black,
                              highlightColor: darkThemeText,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Skeleton(width: 80.w),
                                ],
                              ),
                            ),
                          )))
                      .values
                      .toList(),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: category
                      .asMap()
                      .map(
                        (index, value) => MapEntry(
                          index,
                          GestureDetector(
                            onTap: () => Guide.to(
                              name: categoryNews,
                              arguments: CategoryNewsViewArgument(
                                category: category[index],
                                query: "",
                                isKeyword: false,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? 15.w : 0,
                                right: 7.w,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Guide.isDark(context)
                                      ? colorsBlack
                                      : colorWhite,
                                  border: Border.all(
                                    color: Guide.isDark(context)
                                        ? Colors.grey.withOpacity(0.3)
                                        : colorGray,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 13.w, vertical: 7.h),
                                child: Text(Guide.capitalize(
                                  category[index],
                                )).blackSized(11.sp).colors(
                                      Guide.isDark(context)
                                          ? darkThemeText
                                          : colorsBlack,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              );
      },
    );
  }

  Widget _sliderNewsWidget() {
    return BlocBuilder<HomeNewsBloc, HomeNewsState>(
      builder: (_, state) {
        if (state.statusTrending == HomeBlocStatus.loading) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 40.h,
            ),
            child: Shimmer.fromColors(
              baseColor: Guide.isDark(context) ? Colors.white24 : Colors.black,
              highlightColor: darkThemeText,
              child: const TrendingSkeletonWidget(),
            ),
          );
        }
        if (state.statusTrending == HomeBlocStatus.loaded) {
          final trending = state.trending?.articles ?? [];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 200.h,
            width: 360.w,
            decoration: BoxDecoration(
              color: Guide.isDark(context) ? colorsBlack : colorWhite,
              boxShadow: Guide.isDark(context)
                  ? [
                      const BoxShadow(
                        color: textGray,
                        offset: Offset(
                          0.5,
                          0.5,
                        ),
                        blurRadius: 0.5,
                        spreadRadius: 0.1,
                      )
                    ]
                  : [],
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: PageView.builder(
              controller: controller,
              itemCount: trending.length,
              onPageChanged: (index) {
                setState(() {
                  _cIndex = index;
                });
              },
              itemBuilder: (_, index) {
                var imageUrl = trending[index].urlToImage;
                return GestureDetector(
                  onTap: () => Guide.to(
                    name: detail,
                    arguments: trending[index],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                imageBuilder: (c, image) => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: image,
                                          fit: BoxFit.cover,
                                          colorFilter: Theme.of(context)
                                                      .brightness ==
                                                  Brightness.dark
                                              ? ColorFilter.mode(
                                                  Colors.black.withOpacity(0.3),
                                                  BlendMode.softLight,
                                                )
                                              : ColorFilter.mode(
                                                  Colors.black.withOpacity(0.8),
                                                  BlendMode.softLight,
                                                ),
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, url, error) {
                                  print(
                                      'CachedNetworkImage error: ${CachedNetworkImage}');
                                  return Image.asset(
                                      width: 115.w,
                                      height: 100.h,
                                      CommonConstants.emptyImagePath,
                                      fit: BoxFit.contain);
                                })
                            : Image.asset(CommonConstants.emptyImagePath,
                                fit: BoxFit.contain),
                      ),
                      Positioned(
                        bottom: 12.h,
                        right: 15.w,
                        left: 15.w,
                        child: Container(
                          width: 330.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Guide.isDark(context)
                                ? colorsBlack
                                : colorWhite,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: Guide.isDark(context)
                                  ? darkThemeText
                                  : borderGray,
                              width: 0.3,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 11.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 260.w,
                                      child: Text(
                                        trending[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ).boldSized(18).colors(
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? darkThemeText
                                                : colorsBlack,
                                          ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.remove_red_eye_outlined,
                                          size: 20.h,
                                          color: colorTextGray,
                                        ),
                                        Text("${Random().nextInt(299)} K")
                                            .boldSized(10)
                                            .colors(colorTextGray),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 9.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        // CircleAvatar(
                                        //   radius: 12.r,
                                        //   backgroundColor: colorPrimary,
                                        //   backgroundImage: index + 1 < 5
                                        //       ? AssetImage(
                                        //           "assets/profile/${index + 1}.jpg",
                                        //         )
                                        //       : const AssetImage(
                                        //           "assets/profile/5.jpg",
                                        //         ),
                                        // ),
                                        // SizedBox(
                                        //   width: 7.w,
                                        // ),
                                        Text(trending[index].source.name)
                                            .boldSized(10)
                                            .colors(colorTextGray)
                                      ],
                                    ),
                                    Text(
                                      timeago.format(
                                        trending[index].publishedAt,
                                      ),
                                    ).boldSized(10).colors(colorTextGray),
                                  ],
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15.h,
                        left: 15.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 6.h,
                            horizontal: 17.w,
                          ),
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: const Text("Trending").boldSized(11).colors(
                                Guide.isDark(context)
                                    ? colorsBlack
                                    : colorWhite,
                              ),
                        ),
                      ),
                      Positioned(
                        top: 15.h,
                        right: 15.w, // Position from Right
                        child: SizedBox(
                          height: 10.h,
                          child: ListView.builder(
                            itemCount: trending.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: 15,
                                  decoration: _cIndex == index
                                      ? BoxDecoration(
                                          color:
                                              colorPrimary, // Selected Slider Indicator Color
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                        )
                                      : BoxDecoration(
                                          color: Guide.isDark(context)
                                              ? darkThemeText
                                              : colorGray, // Selected Slider Indicator Color
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
