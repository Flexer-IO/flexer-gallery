import 'package:flutter/material.dart';
import 'navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    Navigation.initPaths();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progress Button',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Cast to dynamic to bypass static type checking for the generator getter.
      onGenerateRoute: (Navigation.router as dynamic).generator as RouteFactory,
    );
  }
}