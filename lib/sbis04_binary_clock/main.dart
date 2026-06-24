import 'theme/custom_theme.dart';
import 'theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;

import 'my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ),
  );
}
