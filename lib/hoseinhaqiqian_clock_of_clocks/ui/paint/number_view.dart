import 'package:flutter/material.dart';
import '../utils/clock_tween.dart';
import '../../models/tiny_clock.dart';
import 'number_view_painter.dart' as painter;

class NumberView extends StatelessWidget {
  final List<TinyClock> clocks;

  NumberView({Key? key, required this.clocks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < clocks.length ~/ 6; i++)
          Row(
            children: [
              for (int j = i * 6; j < (i * 6) + 6; j++)
                _buildNumber(context, clocks[j])
            ],
          )
      ],
    );
  }

  Widget _buildNumber(BuildContext context, TinyClock tinyClock) {
    return TweenAnimationBuilder<TinyClock?>(
      tween: ClockTween(begin: null, end: tinyClock),
      duration: const Duration(milliseconds: 500),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 30,
        height: MediaQuery.of(context).size.width / 30,
      ),
      builder: (context, value, child) {
        return CustomPaint(
          painter: painter.ClockViewPainter(tinyClock: value ?? tinyClock),
          child: child,
        );
      },
    );
  }
}