import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/core.dart';
import '../../../domain/domain.dart';
import '../../bookmark/bloc/bookmark/bookmark_news_bloc.dart';

class DetailNewsView extends StatelessWidget {
  final List<NewsArticleEntities> response;
  const DetailNewsView({
    super.key,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BookmarkNewsBloc, BookmarkNewsState>(
        listener: (_, state) {},
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.h,
              floating: true,
              pinned: true,
              // title: Container(
              //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              //   decoration: BoxDecoration(
              //     color: Guide.isDark(context) ? colorsBlack : colorWhite,
              //     borderRadius: BorderRadius.circular(10.r),
              //   ),
              //   child: Text(
              //     Uri.parse(response[0].url).host,
              //   ).normalSized(15).colors(colorPrimary),
              // ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Guide.isDark(context) ? colorsBlack : colorWhite,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: Guide.isDark(context) ? colorPrimary : colorPrimary,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => context
                      .read<BookmarkNewsBloc>()
                      .add(BookmarkNewsAddEvent(add: response)),
                  icon: Icon(
                    Icons.bookmark_add,
                    color: Guide.isDark(context) ? colorPrimary : colorPrimary,
                  ),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.symmetric(horizontal: 10.w),
                collapseMode: CollapseMode.parallax,
                background: SizedBox(
                  width: 120.w,
                  height: 100.h,
                  child: Stack(
                    children: [
                      response[0].urlToImage.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: response[0].urlToImage,
                              imageBuilder: (c, image) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: image,
                                        fit: BoxFit.cover,
                                        colorFilter: Guide.isDark(context)
                                            ? ColorFilter.mode(
                                                Colors.black.withOpacity(0.9),
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
                                    'CachedNetworkImage error: ${error.toString()}');
                                return Image.asset(
                                    width: 115.w,
                                    height: 100.h,
                                    CommonConstants.emptyImagePath,
                                    fit: BoxFit.contain);
                              })
                          : Image.asset(
                              height: 100.h,
                              CommonConstants.emptyImagePath,
                              fit: BoxFit.contain),
                      Positioned(
                        bottom: -1,
                        right: 0,
                        left: 0,
                        child: Column(
                          children: [
                            Container(
                              height: 15.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? colorsBlack
                                    : colorWhite,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.r),
                                  topRight: Radius.circular(25.r),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 170.w, vertical: 12.h),
                                child: Divider(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? colorWhite
                                      : borderGray,
                                  thickness: 3.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: Guide.isDark(context) ? colorsBlack : colorWhite,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 55.h,
                        padding: EdgeInsets.symmetric(vertical: 4.w),
                        child: Row(
                          children: [
                            // CircleAvatar(
                            //   radius: 25.r,
                            //   backgroundColor: colorPrimary,
                            //   backgroundImage:
                            //       const AssetImage("assets/profile/3.jpg"),
                            // ),
                            // SizedBox(
                            //   width: 10.w,
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width -
                                      2 * (10.w + 4.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text("Article by")
                                          .normalSized(11)
                                          .colors(
                                            Guide.isDark(context)
                                                ? darkThemeText
                                                : colorTextGray,
                                          ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat.yMMMMEEEEd().format(
                                                response[0].publishedAt),
                                          ).normalSized(11).colors(
                                                Guide.isDark(context)
                                                    ? darkThemeText
                                                    : colorTextGray,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 250.w,
                                  child: Text(
                                    response[0].author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ).boldSized(12).colors(
                                        Guide.isDark(context)
                                            ? darkThemeText
                                            : colorTextGray,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        response[0].title,
                      ).blackSized(20).colors(
                            Guide.isDark(context)
                                ? darkThemeText
                                : colorTextGray,
                          ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Stack(alignment: Alignment.bottomCenter, children: [
                        Container(
                          child: Text(
                            convertContent(response[0].content),
                          ).normalSized(13).colors(
                                Guide.isDark(context)
                                    ? darkThemeText
                                    : colorTextGray,
                              ),
                        ),
                        GestureDetector(
                          onTap: () => openNews(response[0].url),
                          child: Container(
                              width: double.infinity,
                              height: 28,
                              color: transparent),
                        )
                      ]),
                      SizedBox(
                        height: 10.h,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> openNews(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      Fluttertoast.showToast(
          msg: "Could not launch $url",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: colorPrimaryOpacity80,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception('Could not launch $url');
    }
  }

  String convertContent(String content) {
    String convertedContent = content;
    int replaceStartIndex = content.indexOf('[+');
    int replaceEndIndex = content.length;
    if (replaceStartIndex >= 0) {
      convertedContent = content.replaceRange(
          replaceStartIndex, replaceEndIndex, "Read full article");
    }
    return convertedContent;
  }
}
