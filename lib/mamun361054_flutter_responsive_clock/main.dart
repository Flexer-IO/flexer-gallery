import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'size_config_two.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

import 'models/theme_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        return OrientationBuilder(
          builder: (context,orientation){
            SizeConfigTwo().init(constraints, orientation);
            return ChangeNotifierProvider(
              create: (context) => ThemeModel(),
              child: Consumer<ThemeModel>(
                  builder: (context,theme,child){
                    return MaterialApp(
                      title: 'Flutter Clock',
                      debugShowCheckedModeBanner: false,
                      theme: themeData(context),
                      darkTheme: dartThemeData(context),
                      themeMode: theme.isLightTheme ? ThemeMode.light : ThemeMode.dark,
                      home: HomeScreen(),
                    );
                  }),
            );
          },
        );
      },
    );
  }
}
