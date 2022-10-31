import 'package:get/get.dart';
import 'package:iqnet/app/data/local_impl/local_impl.dart';
import 'package:iqnet/app/data/news_provider.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsProvider>(() => NewsProvider());
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<NewsCacheImpl>(() => NewsCacheImpl());
  }
}
