import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iqnet/app/data/local_impl/local_impl.dart';
import 'package:iqnet/app/data/news_provider.dart';
import 'package:iqnet/app/modules/home/news_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  var newsList = NewsResponse.empty().obs;
  var newsLoading = false.obs;
  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  NewsResponse get newsResponse => newsList.value;
  final NewsCacheImpl newsCacheImpl = Get.find();
  final NewsProvider newsProvider = Get.find();
  @override
  void onInit() {
    super.onInit();
    _isDarkMode(Get.isDarkMode);
    fetchNews();
  }

  fetchNews() async {
    newsLoading(true);
    var news = await newsProvider.getNewsHeadlines();

    if (news != null) {
      newsList(news);
      await newsCacheImpl.saveNews(news);
    } else {
      var news = await newsCacheImpl.getNews();
      newsList(news);
    }
    newsLoading(false);
  }

  refreshNews() {
    newsList(NewsResponse.empty());
    fetchNews();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void changeTheme() async {
    Get.changeTheme(isDarkMode ? ThemeData.light() : ThemeData.dark());
    _isDarkMode.toggle();
  }
}
