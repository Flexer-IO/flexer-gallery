import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// Fallback color palette if not provided by the imported constants.
const List<Color> kFontColorPalettes = [
  Colors.black,
  Colors.grey,
  Colors.blue,
];

class TaskProgressData {
  final int totalTask;
  final int totalCompleted;

  const TaskProgressData({
    required this.totalTask,
    required this.totalCompleted,
  });
}

class TaskProgress extends StatelessWidget {
  const TaskProgress({
    required this.data,
    Key? key,
  }) : super(key: key);

  final TaskProgressData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildText(),
        Expanded(child: _buildProgress()),
      ],
    );
  }

  Widget _buildText() {
    return Text(
      "${data.totalCompleted} of ${data.totalTask} completed",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: kFontColorPalettes[2],
        fontSize: 13,
      ),
    );
  }

  Widget _buildProgress() {
    final percent = data.totalTask == 0 ? 0.0 : data.totalCompleted / data.totalTask;
    return LinearPercentIndicator(
      percent: percent,
      progressColor: Colors.blueGrey,
      backgroundColor: Colors.blueGrey[200]!,
    );
  }
}