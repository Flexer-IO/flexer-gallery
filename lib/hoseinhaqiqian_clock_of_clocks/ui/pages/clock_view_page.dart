import 'dart:async';
import 'package:flutter/material.dart';
import '../paint/number_view.dart';
import '../../common/extension.dart';

class ClockViewPage extends StatefulWidget {
  const ClockViewPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ClockViewPage> createState() => _ClockViewPageState();
}

class _ClockViewPageState extends State<ClockViewPage> {
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        dateTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var value in dateTime.hour.splitter()) _buildNumber(value),
              _buildDivider(),
              for (var value in dateTime.minute.splitter()) _buildNumber(value),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var value in dateTime.second.splitter()) _buildNumber(value),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumber(int number) {
    return NumberView(clocks: number.getValue());
  }

  Widget _buildDivider() {
    return NumberView(clocks: (-1).getValue());
  }
}
