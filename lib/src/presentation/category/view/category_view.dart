import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app/src/core/extensions/extension_string.dart';
import 'package:news_app/src/domain/entitites/category_type.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/core.dart';
import '../../../domain/entitites/news_entities.dart';
import '../../home/bloc/enum_home_bloc.dart';
import '../../home/bloc/home_news/home_news_bloc.dart';
import '../../home/widget/trending_skeleton_widget.dart';

class CategoryViews extends StatefulWidget {
  List<CategoryType> categories = [
    CategoryType.general,
    CategoryType.health,
    CategoryType.business,
    CategoryType.sports,
    CategoryType.science,
    CategoryType.entertainment,
    CategoryType.technology
  ];

  CategoryViews({super.key});

  @override
  State<CategoryViews> createState() => _CategoryViewsState();
}

class _CategoryViewsState extends State<CategoryViews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Guide.isDark(context) ? colorsBlack : colorWhite,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Category",
            )
                .blackSized(26)
                .colors(Guide.isDark(context) ? darkThemeText : colorsBlack),
            const Text("Read news by categories").boldSized(12).colors(
                  Guide.isDark(context) ? darkThemeText : colorTextGray,
                ),
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        color: colorWhite,
        margin:
            EdgeInsets.only(top: 5.h, left: 15.w, right: 15.w, bottom: 10.h),
        padding: EdgeInsets.only(top: 10.h, bottom: 24.h),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical, child: listCategory()),
      )),
    );
  }

  ListView listCategory() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 16);
        },
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: widget.categories.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          CategoryType category = widget.categories[index];
          return GestureDetector(
            onTap: () => showNewsBy(category),
            child: SizedBox(
              width: double.infinity,
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Stack(alignment: Alignment.center, children: [
                  Image.asset(category.imageName,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover),
                  Container(
                      color: category.color,
                      width: double.infinity,
                      height: double.infinity),
                  Stack(
                    children: <Widget>[
                      Text(
                        category.name.capitalize(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = colorTextGray,
                        ),
                      ),
                      Text(
                        category.name.capitalize(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: colorWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  )
                ]),
              ),
            ),
          );
        });
  }

  void showNewsBy(CategoryType category) {
    Guide.to(
        name: categoryNews,
        arguments: CategoryNewsViewArgument(
            category: category.name, query: "", isKeyword: false));
  }
}
