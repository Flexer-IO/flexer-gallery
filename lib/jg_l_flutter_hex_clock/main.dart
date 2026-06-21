import 'package:flutter/material.dart';
import 'hexClock.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        PageBG(),
        SimpleClock(),
      ],
    );
  }
}