import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iqnet/app/modules/home/news_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetail extends StatelessWidget {
  const NewsDetail({Key? key, required this.article}) : super(key: key);
  final Articles article;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(article.title!,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(article.source!.name!,
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        Jiffy(DateTime.parse(article.publishedAt!)).fromNow(),
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
              CachedNetworkImage(
                imageUrl: article.urlToImage!,
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Text(article.description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Text(article.content ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              TextButton(
                  onPressed: () async {
                    await launch(
                      article.url!,
                      forceSafariVC: true,
                      forceWebView: true,
                      enableJavaScript: true,
                    );
                    // if (await canLaunchUrl(Uri.parse(article.url!))) {
                    //   await launchUrl(Uri.parse(article.url!),
                    //       mode: LaunchMode.inAppWebView);
                    // }
                  },
                  child: const Text('View Full Article')),
            ],
          ),
        ),
      ),
    );
  }
}
