import 'package:flutter/material.dart';
import 'full_clock_display.dart';

class AdcaineFlutterBinaryClockPage extends StatelessWidget {
  const AdcaineFlutterBinaryClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: StreamBuilder<DateTime>(
            initialData: DateTime.now(),
            stream: Stream.periodic(
              const Duration(milliseconds: 500),
              (_) => DateTime.now(),
            ),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                scrollDirection:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? Axis.horizontal
                        : Axis.vertical,
                child: FullClockDisplay(dateTime: snapshot.data!),
              );
            },
          ),
        ),
      ),
    );
  }
}
