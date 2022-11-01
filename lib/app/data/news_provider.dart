import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:iqnet/app/data/network/failure.dart';

import '../modules/home/news_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return NewsResponse.fromJson(map);
      if (map is List) {
        return map.map((item) => NewsResponse.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = 'https://newsapi.org/v2/';
  }

  Future<Either<Failure, NewsResponse>> getNews(int page) async {
    print('page' + page.toString());
    var url = "everything/?q=bitcoin&page=$page&pageSize=20";
    print(url);
    var headersList = {
      'Accept': '*/*',
      'x-api-key': "${dotenv.env['API_KEY']}"
    };
    try {
      var req = await get(url, headers: headersList);
      print(req.body);
      if (req.statusCode! >= 200 && req.statusCode! < 300) {
        return Right(req.body);
      } else {
        if (kDebugMode) {
          print(req.bodyString);
        }
        return Left(
            Failure(req.statusCode!, jsonDecode(req.bodyString!)['message']));
      }
    } on SocketException catch (e) {
      if (kDebugMode) print(e.message);
      return Left(Failure(e.port!, e.message));
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return Left(DefaultFailure());
    }
  }

  Future<Either<Failure, NewsResponse>> getNewsHeadlines(int page) async {
    var url = 'top-headlines/?country=us&page=$page&pageSize=10';

    var headersList = {
      'Accept': '*/*',
      'x-api-key': "${dotenv.env['API_KEY']}"
    };
    try {
      var req = await get(url, headers: headersList);
      if (req.statusCode! >= 200 && req.statusCode! < 300) {
        return req.body;
      } else {
        if (kDebugMode) {
          print(req.bodyString);
        }
        return Left(
            Failure(req.statusCode!, jsonDecode(req.bodyString!)['message']));
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return Left(DefaultFailure());
    }
  }
}
