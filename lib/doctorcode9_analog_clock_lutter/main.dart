import 'dart:async';

import 'components/clock_view.dart';
import 'ui/colors.dart';
import 'package:flutter/material.dart';
import 'deps/timer_builder/timer_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now = DateTime.now();
  Timer? _everySec;

  Future<DateTime> fetchClock() async {
    now = DateTime.now();
    return now;
  }

  @override
  void initState() {
    super.initState();

    _everySec = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _everySec?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* getting time */

    return Scaffold(
      backgroundColor: const Color(0xFFfafafa),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TimerBuilder.periodic(
                const Duration(seconds: 1),
                builder: (context) {
                  //getting the time
                  String minute = DateTime.now().minute < 10
                      ? "0${DateTime.now().minute}"
                      : DateTime.now().minute.toString();
                  String hour = DateTime.now().hour < 10
                      ? "0${DateTime.now().hour}"
                      : DateTime.now().hour.toString();
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today",
                            style: AppStyle.mainTextThin,
                          ),
                          Text(
                            "${hour}:${minute}",
                            style: AppStyle.maintext,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      ClockView(DateTime.now()),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}