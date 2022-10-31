import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iqnet/app/modules/home/news_model.dart';

class NewsCacheImpl {
  final GetStorage getStorage = GetStorage();
  Future<NewsResponse?> getNews() async {
    var news = await getStorage.read('cacheNews');
    if (news == null) {
      return null;
    } else {
      return NewsResponse.fromJson(jsonDecode(news));
    }
  }

  Future<void> saveNews(NewsResponse newsResponse) async {
    try {
      getStorage.write('cacheNews', jsonEncode(newsResponse.toJson()));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    // print("news saved");
  }

  Future<void> clearStorage() async {
    getStorage.erase();
  }
}
