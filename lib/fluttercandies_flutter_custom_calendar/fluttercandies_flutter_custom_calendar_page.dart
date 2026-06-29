import 'package:flutter/material.dart';
import '../flutter_custom_calendar.dart';

class FluttercandiesFlutterCustomCalendarPage extends StatelessWidget {
  const FluttercandiesFlutterCustomCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Calendar'),
      ),
      body: const CalendarView(),
    );
  }
}
