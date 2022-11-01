import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'widgets/news_headline_item.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('News App'),
          actions: [
            IconButton(
                onPressed: () {
                  controller.changeTheme();
                },
                icon: Obx(
                  () => Icon(controller.isDarkMode
                      ? Icons.brightness_2
                      : Icons.brightness_6),
                ))
          ],
        ),
        body: Obx(() => controller.newsLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.newsResponse.status == 'ok'
                ? RefreshIndicator(
                    onRefresh: () async {
                      await controller.refreshNews();
                    },
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      controller: controller.scrollController,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...controller.newsResponse.articles!.map(
                                (article) => NewsHeadline(article: article)),
                            if (controller.moreNews.isTrue)
                              const CircularProgressIndicator(),
                          ]),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      controller.refreshNews();
                    },
                    child: const Text(
                      "Check Your Connection\nTry Again",
                      textAlign: TextAlign.center,
                    ))));
  }
}
