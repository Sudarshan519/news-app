import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

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

  Future<NewsResponse?> getNewsHeadlines() async {
    var url = 'top-headlines/?country=us';

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
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
