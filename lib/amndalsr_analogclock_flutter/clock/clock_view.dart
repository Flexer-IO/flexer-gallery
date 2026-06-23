import 'analogic_circle.dart';
import 'hour_pointer.dart';
import 'minute_pointer.dart';
import 'second_pointer.dart';
import 'package:flutter/material.dart';

class ClockView extends StatelessWidget {
  const ClockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(
        const Duration(seconds: 1),
      ),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const AnalogicCircle(),
                  const HourPointer(),
                  const MinutePointer(),
                  const SecondPointer(),
                  Container(
                    height: 15,
                    width: 15,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}