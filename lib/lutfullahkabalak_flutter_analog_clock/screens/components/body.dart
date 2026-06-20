import 'dart:async';
import 'dart:math';

import 'constants.dart';
import 'size_config.dart';
import 'package:flutter/material.dart';
import 'clock.dart';
import 'time_in_hour_and_minute.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "İstanbul, Turkey | IST",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TimeInHourAndMinute(),
          Clock(),
        ],
      ),
    );
  }
}
