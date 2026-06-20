import 'controller/binfi.dart';
import 'utils/theme.dart';
import 'view/HomePage.dart';
import 'package:flutter/material.dart';
import 'deps/get/get.dart';
import 'deps/get_storage/get_storage.dart';

import 'controller/service.dart';

void main() async { // make it async
  await GetStorage.init(); // add this
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      initialBinding: MyBinding(),
      home: HomePage(),
    );
  }
}