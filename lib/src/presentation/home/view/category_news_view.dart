import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/src/domain/domain.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/core.dart';
import '../bloc/category_news/category_news_bloc.dart';
import '../bloc/enum_home_bloc.dart';
import '../widget/trending_skeleton_widget.dart';

class CategoryNewsView extends StatefulWidget {
  final CategoryNewsViewArgument category;
  const CategoryNewsView({
    super.key,
    required this.category,
  });

  @override
  State<CategoryNewsView> createState() => _CategoryNewsViewState();
}

class _CategoryNewsViewState extends State<CategoryNewsView> {
  late ScrollController controller;
  bool isLoading = false;

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(() {
      var maxScrollExtent = controller.position.maxScrollExtent - 600;
      print("SSSSS: offset: ${controller.offset} >= $maxScrollExtent");
      if (controller.offset >= maxScrollExtent && !isLoading) {
        print("SSSSS: offset: getMoreByHeadlines");
        print("SSSSS1: getMoreByHeadlines");
        isLoading = true;
        context.read<CategoryNewsBloc>().add(
              CategoryNewsGetMoreByHeadlines(
                category: widget.category.category,
                query: widget.category.query,
              ),
            );
        return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: Guide.isDark(context) ? colorsBlack : colorWhite,
          centerTitle: true,
          title: Text(Guide.capitalize(widget.category.category))
              .boldSized(16)
              .colors(Guide.isDark(context) ? darkThemeText : colorsBlack)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            !widget.category.isKeyword
                ? context.read<CategoryNewsBloc>().add(
                      CategoryNewsGetByHeadlines(
                        category: widget.category.category,
                        limit: 20,
                        page: 1,
                        query: "",
                      ),
                    )
                : context.read<CategoryNewsBloc>().add(
                      CategoryNewsGetByHeadlines(
                        category: widget.category.category,
                        limit: 20,
                        page: 1,
                        query: "",
                      ),
                    );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Guide.isDark(context)
                    ? [
                        colorsBlack,
                        colorsBlackGray,
                      ]
                    : [
                        colorWhite,
                        colorGray,
                      ],
                // stops: [],
              ),
            ),
            child: BlocBuilder<CategoryNewsBloc, CategoryNewsState>(
              builder: (_, state) {
                print("SSSSS1: state.status = ${state.status}");
                if (state.status == HomeBlocStatus.loading) {
                  isLoading = true;
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

                if (state.status == HomeBlocStatus.loaded ||
                    state.status == HomeBlocStatus.failure) {
                  print("SSSSS1: state.currentPage = ${state.currentPage}");
                  Future.delayed(
                      Duration(
                          milliseconds: state.status == HomeBlocStatus.loaded
                              ? 2000
                              : 0), () {
                    isLoading = false;
                  });
                  List<NewsArticleEntities> data = [];
                  data = state.article;
                  return ListView.builder(
                    controller: controller,
                    itemCount:
                        state.hasReachedMax ? data.length : data.length + 1,
                    itemBuilder: (ctx, index) {
                      if (data.length <= index) {
                        return Container();
                      }
                      var imageUrl = data[index].urlToImage;
                      return index >= data.length
                          ? data.length >= 10
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Center(
                                      child: SizedBox(
                                        height: 33.h,
                                        child: const CircularProgressIndicator(
                                          color: colorPrimary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    )
                                  ],
                                )
                              : Container()
                          : GestureDetector(
                              onTap: () => Guide.to(
                                name: detail,
                                arguments: data[index],
                              ),
                              child: Container(
                                height: 85.h,
                                margin: EdgeInsets.symmetric(
                                    vertical: 4.h, horizontal: 15.w),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: SizedBox(
                                        width: 100.w,
                                        height: 85.h,
                                        child: imageUrl.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: imageUrl,
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
                                                      height: 85.h,
                                                      CommonConstants
                                                          .emptyImagePath,
                                                      fit: BoxFit.contain);
                                                })
                                            : Image.asset(
                                                width: 100.w,
                                                height: 85.h,
                                                CommonConstants.emptyImagePath,
                                                fit: BoxFit.contain),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            14.w, 8.h, 0.w, 8.h),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                data[index].title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ).boldSized(14).colors(
                                                  Guide.isDark(context)
                                                      ? darkThemeText
                                                      : colorsBlack),
                                            ),
                                            SizedBox(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        data[index].source.name,
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
                                                          data[index]
                                                              .publishedAt,
                                                        ),
                                                      ).boldSized(10).colors(
                                                          colorTextGray),
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
                            );
                    },
                  );
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
