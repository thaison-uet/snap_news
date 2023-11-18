import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/src/data/datasources/network/network_local_data_source.dart';
import 'package:news_app/src/utils/app_util.dart';

import '../../../core/core.dart';
import '../../models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<NewsModel> getNewGlobal({
    required bool isHeadlines,
    String? category,
    String? query,
    int? limit,
    int? page,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final NetworkContainer http;
  String? newsApiKey;

  NewsRemoteDataSourceImpl({
    required this.http,
  });

  @override
  Future<NewsModel> getNewGlobal({
    required bool isHeadlines,
    String? category,
    String? query,
    int? limit,
    int? page,
  }) async {
    var networkLocalDataSource = NetworkLocalDataSourceImpl(StorageHelper());
    AppUtil.instance.apiKey = await networkLocalDataSource.readApiKey();
    newsApiKey = AppUtil.instance.apiKey;
    if (newsApiKey == null) {
      networkLocalDataSource.writeApiKey(listApiKey[0]);
      AppUtil.instance.apiKey = await networkLocalDataSource.readApiKey();
      newsApiKey = AppUtil.instance.apiKey;
    }
    print("SSSSS: newsApiKey = $newsApiKey");

    limit ??= 1;
    page ??= 1;
    category ??= "";
    query ??= "";
    if (isHeadlines) {
      final response = await http.method(
        path:
            "top-headlines?language=$language&category=$category&q=$query&pageSize=$limit&page=$page&apiKey=$newsApiKey",
        methodType: MethodType.get,
      );

      if (response.statusCode == 200) {
        return NewsModel.fromJson(response.data);
      } else {
        throw DioError;
      }
    } else {
      final response = await http.method(
        path:
            "everything?q=$query&language=$language&pageSize=$limit&page=$page&apiKey=$newsApiKey",
        methodType: MethodType.get,
      );

      if (response.statusCode == 200) {
        return NewsModel.fromJson(response.data);
      } else {
        throw DioError;
      }
    }
  }
}
