import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:iqnet/app/modules/home/news_model.dart';

class NewsCacheImpl {
  final GetStorage getStorage = GetStorage();
  Future<NewsResponse?> getNews() async {
    var news = await getStorage.read('cacheNews');
    if (news == null) {
      return NewsResponse.empty();
    } else {
      return NewsResponse.fromJson(jsonDecode(news));
    }
  }

  Future<void> saveNews(NewsResponse newsResponse) async {
    try {
      getStorage.write('cacheNews', jsonEncode(newsResponse.toJson()));
    } catch (e) {}
    // print("news saved");
  }
}
