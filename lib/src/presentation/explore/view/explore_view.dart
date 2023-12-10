import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/core.dart';
import '../../../domain/entitites/news_entities.dart';
import '../../home/bloc/enum_home_bloc.dart';
import '../../home/bloc/home_news/home_news_bloc.dart';
import '../../home/widget/trending_skeleton_widget.dart';

class ExploreViews extends StatefulWidget {
  const ExploreViews({super.key});

  @override
  State<ExploreViews> createState() => _ExploreViewsState();
}

class _ExploreViewsState extends State<ExploreViews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Guide.isDark(context) ? colorsBlack : colorWhite,
        centerTitle: false,
        actions: [
          ElevatedButton(
            onPressed: () => Guide.to(name: searchNews),
            style: ElevatedButton.styleFrom(
              primary: Guide.isDark(context) ? colorsBlack : colorWhite,
              elevation: 0,
            ),
            child: SvgPicture.asset("assets/icons/search_line.svg",
                height: 24.h,
                width: 24.w,
                color: Guide.isDark(context) ? darkThemeText : colorsBlack),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Discover",
            )
                .blackSized(26)
                .colors(Guide.isDark(context) ? darkThemeText : colorsBlack),
            const Text("Search all news around the world").boldSized(12).colors(
                  Guide.isDark(context) ? darkThemeText : colorTextGray,
                ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: Guide.isDark(context)
                  ? [colorsBlack, colorsBlack]
                  : [
                      colorWhite,
                      colorWhite,
                    ],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeNewsBloc>().add(
                    const GetEverythingNews(
                      limit: 20,
                      page: 1,
                    ),
                  );
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  BlocBuilder<HomeNewsBloc, HomeNewsState>(
                    builder: (_, state) {
                      if (state.statusEverything == HomeBlocStatus.loading) {
                        List loading = [1, 2, 3, 4, 5, 6];
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

                      if (state.statusEverything == HomeBlocStatus.loaded) {
                        List<NewsArticleEntities> everything =
                            state.everything?.articles ?? [];
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: everything
                                .asMap()
                                .map(
                                  (index, value) => MapEntry(
                                    index,
                                    GestureDetector(
                                      onTap: () => Guide.to(
                                        name: detail,
                                        arguments: everything[index],
                                      ),
                                      child: Container(
                                        // margin: EdgeInsets.symmetric(
                                        //   horizontal: 15.w,
                                        //   vertical: 5.h,
                                        // ),
                                        margin: EdgeInsets.only(
                                            top: 5.h,
                                            left: 15.w,
                                            right: 15.w,
                                            bottom: 10.h),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              child: SizedBox(
                                                width: 100.w,
                                                height: 85.h,
                                                child: everything[index]
                                                        .urlToImage
                                                        .isNotEmpty
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            everything[index]
                                                                .urlToImage,
                                                        imageBuilder: (c,
                                                                image) =>
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image: image,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                        errorWidget: (context,
                                                            url, error) {
                                                          print(
                                                              'CachedNetworkImage error: ${error.toString()}');
                                                          return Image.asset(
                                                              width: 115.w,
                                                              height: 85.h,
                                                              CommonConstants
                                                                  .emptyImagePath,
                                                              fit: BoxFit
                                                                  .contain);
                                                        })
                                                    : Image.asset(
                                                        width: 140.w,
                                                        height: 85.h,
                                                        CommonConstants
                                                            .emptyImagePath,
                                                        fit: BoxFit.fill),
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                              height: 85.h,
                                              padding: EdgeInsets.fromLTRB(
                                                  14.w, 8.h, 0.w, 8.h),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: Text(
                                                      everything[index].title,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ).blackSized(14).colors(
                                                          Guide.isDark(context)
                                                              ? darkThemeText
                                                              : colorsBlack,
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              everything[index]
                                                                  .source
                                                                  .name,
                                                            )
                                                                .boldSized(10)
                                                                .colors(
                                                                    colorTextGray)
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(timeago.format(
                                                                      everything[
                                                                              index]
                                                                          .publishedAt))
                                                                  .boldSized(10)
                                                                  .colors(
                                                                    colorTextGray,
                                                                  )),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                          ],
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
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
