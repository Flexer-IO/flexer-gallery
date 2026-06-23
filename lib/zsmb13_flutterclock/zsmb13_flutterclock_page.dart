import 'dart:async';
import 'package:flutter/material.dart';
import 'clock.dart';

class Zsmb13FlutterclockPage extends StatefulWidget {
  const Zsmb13FlutterclockPage({super.key});

  @override
  State<Zsmb13FlutterclockPage> createState() => _Zsmb13FlutterclockPageState();
}

class _Zsmb13FlutterclockPageState extends State<Zsmb13FlutterclockPage> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Clock(now: _now),
      ),
    );
  }
}