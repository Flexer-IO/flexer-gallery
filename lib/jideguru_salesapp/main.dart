import 'package:flutter/material.dart';
import 'ui/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final String title = "Sales UI";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Home(
        header: title,
      ),
    );
  }
}