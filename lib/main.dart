import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      title: "News App",
      initialRoute: AppPages.INITIAL,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      theme: ThemeData.light(),

      darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.system,
    ),
  );
}
