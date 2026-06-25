// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:html';
import 'dart:js_util';
import 'deps/intl/intl.dart';

import 'package:flutter/material.dart';
import 'deps/flutter_analog_clock/flutter_analog_clock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clocks',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Digital Clock in Analog'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Color borderColor;
  bool borderChange = false;
  bool buttons = false;
  late String timeString;
  late String timeStringYear;

  List<String> hourNumbersFirst = [
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    'XI',
    'XII'
  ];
  List<String> hourNumbersLast = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  void getList(){
    setState(() {
      buttons =! buttons;
    });
  }

  void timerMteod() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        borderChange = !borderChange;
        getTime();
      });
    });
  }

  void getTime() {
    setState(() {
      timeString = DateFormat("kk:mm:ss").format(DateTime.now()).toString();
      timeStringYear =
          DateFormat("dd.MM.yyyy").format(DateTime.now()).toString();
    });
  }

  @override
  void initState() {
    timerMteod();
    getTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              FlutterAnalogClock.dark(
                hourNumbers: buttons == false ? hourNumbersFirst:hourNumbersLast,
                width: 300,
                height: 300,
                numberColor: Colors.amber,
                centerPointColor: Colors.amber,
                borderColor:
                    borderChange == false ? Colors.black : Colors.amber,
                borderWidth: 5,
              ),
              Positioned(
                top: 80,
                child: Text(
                  timeString,
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: 105,
                child: Text(
                  timeStringYear,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                bottom: 130,
                  child: IconButton(
                      onPressed: getList,
                      icon: const Icon(
                        Icons.change_circle,
                        size: 25,
                        color: Colors.white,
                      )))
            ],
          ),
        ));
  }
}
