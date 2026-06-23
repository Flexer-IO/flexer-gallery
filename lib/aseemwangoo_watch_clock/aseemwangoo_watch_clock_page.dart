import 'package:flutter/material.dart';
import '../clock/hour_face.dart';
import '../clock/minute_face.dart';
import '../clock/second_face.dart';
import '../models/time.dart';
import '../shared/widgets/change_notifier.dart';
import '../shared/widgets/time_text.dart';

class AseemwangooWatchClockPage extends StatelessWidget {
  const AseemwangooWatchClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Widget> _clock = [
      TimeText(timeDisplay: TimeDisplay.hour),
      HourFace(),
      SecondFace(),
      TimeText(timeDisplay: TimeDisplay.minute),
      MinuteFace(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 5 / 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChangeNotifierWidget<TimeModel>(
                model: TimeModel(),
                child: ExcludeSemantics(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: _clock,
                  ),
                ),
                builder: (context, model, child) => child!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
