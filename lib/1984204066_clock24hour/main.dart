import 'package:flutter/material.dart';
import 'bubble.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '24 hours clock',
      home: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 1,
          title: const Text('休息一下'),
        ),
        body: Center(
          child: BobblePage(),
        ),
      ),
    );
  }
}