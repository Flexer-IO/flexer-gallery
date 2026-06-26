import 'dart:async';

import 'package:flutter/material.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock({Key? key}) : super(key: key);

  @override
  _DigitalClock createState() => _DigitalClock();
}

class _DigitalClock extends State<DigitalClock> {
  TimeOfDay _timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeOfDay.minute != TimeOfDay.now().minute) {
        setState(() {
          _timeOfDay = TimeOfDay.now();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String minuteTime = _timeOfDay.minute < 10
        ? '0${_timeOfDay.minute}'
        : '${_timeOfDay.minute}';
    final String _period = _timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    late final String hour;
    if (_timeOfDay.hourOfPeriod > 0 && _timeOfDay.hourOfPeriod < 10) {
      hour = '0${_timeOfDay.hourOfPeriod}';
    } else if (_timeOfDay.hourOfPeriod == 0) {
      hour = '12';
    } else {
      hour = '${_timeOfDay.hourOfPeriod}';
    }

    final DateTime dateTime = DateTime.now();
    final String day = dateTime.day < 10 ? '0${dateTime.day}' : '${dateTime.day}';
    final String month = dateTime.month < 10 ? '0${dateTime.month}' : '${dateTime.month}';
    String weekDay = '';
    final int today = dateTime.weekday;
    switch (today) {
      case DateTime.monday:
        weekDay = 'MONDAY';
        break;
      case DateTime.tuesday:
        weekDay = 'TUESDAY';
        break;
      case DateTime.wednesday:
        weekDay = 'WEDNESDAY';
        break;
      case DateTime.thursday:
        weekDay = 'THURSDAY';
        break;
      case DateTime.friday:
        weekDay = 'FRIDAY';
        break;
      case DateTime.saturday:
        weekDay = 'SATURDAY';
        break;
      case DateTime.sunday:
        weekDay = 'SUNDAY';
        break;
      default:
        break;
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(8, 25, 35, 1),
      appBar: AppBar(
        title: const Text('DIGITAL CLOCK'),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: const [
              Icon(Icons.arrow_back),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  // if you use _timeOfDay.hour then it will show 20:10 like that
                  // But we want 8:10
                  '$hour:$minuteTime',
                  style: const TextStyle(color: Colors.white, fontSize: 100),
                ),
                const SizedBox(width: 5),
                const RotatedBox(
                  quarterTurns: 4,
                  child: Text(
                    '',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Text(
                  _period,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            Text(
              '$day-$month-${dateTime.year} ',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              weekDay,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}