import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iqnet/app/data/local_impl/local_impl.dart';
import 'package:iqnet/app/data/news_provider.dart';
import 'package:iqnet/app/modules/home/news_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  /// Infinite Scroll
  final scrollController = ScrollController();
  final _pageCount = 1.obs;

  /// news initiliazition
  var newsList = NewsResponse.empty().obs;

  /// initial loading
  var newsLoading = false.obs;

  /// more loading
  var moreNews = false.obs;
  final _isDarkMode = false.obs;
  int get pageCount => _pageCount.value;
  bool get isDarkMode => _isDarkMode.value;
  NewsResponse get newsResponse => newsList.value;

  /// last page
  var endofPage = false.obs;
  final NewsCacheImpl newsCacheImpl = Get.find();
  final NewsProvider newsProvider = Get.find();
  @override
  void onInit() {
    super.onInit();
    _isDarkMode(Get.isDarkMode);
    scrollListener();
    fetchNews();
  }

  // Infinite Scroll to Page
  scrollListener() {
    scrollController.addListener(() {
      if (newsLoading.value != true || moreNews.value != true) {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          increment();
          fetchNews();
          if (kDebugMode) {
            print(pageCount);
          }
        }
      }
    });
  }

  /// fetch news from api
  fetchNews() async {
    if (pageCount > 1 && endofPage.isTrue) {
      moreNews(true);
      // var news = await newsProvider.getNewsHeadlines();

      var result = await newsProvider.getNews(pageCount);
      moreNews(false);
      result.fold((failure) {
        decrement();
        Get.rawSnackbar(message: failure.message);
      }, (news) {
        if (news.articles!.length == 10) {
          increment();
          newsList.value.articles!.addAll(news.articles!);
        } else {
          endofPage(true);
        }
      });
    } else {
      newsLoading(true);
      // var news = await newsProvider.getNewsHeadlines(pageCount);
      var news = await newsProvider.getNews(pageCount);
      newsLoading(false);
      news.fold((failure) async {
        var news = await newsCacheImpl.getNews();
        increment();
        if (news != NewsResponse.empty()) newsList(news);
        Get.rawSnackbar(message: failure.message);
      }, (news) => newsList.value.articles!.addAll(news.articles!));
    }
  }

  /// refresh page
  refreshNews() {
    newsList(NewsResponse.empty());
    _pageCount(1);
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

  void increment() => _pageCount.value++;
  void decrement() {
    if (pageCount > 1) _pageCount.value--;
  }

  void changeTheme() async {
    Get.changeTheme(isDarkMode ? ThemeData.light() : ThemeData.dark());
    _isDarkMode.toggle();
  }
}
