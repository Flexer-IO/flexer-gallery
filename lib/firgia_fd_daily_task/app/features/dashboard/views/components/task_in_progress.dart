import 'package:flutter/material.dart';

/// Placeholder for the data model originally provided by the
/// `fd_daily_task` dependency.
class CardTaskData {
  // Add fields as needed.
}

/// Placeholder for the widget originally provided by the
/// `fd_daily_task` dependency.
class CardTask extends StatelessWidget {
  const CardTask({
    required this.data,
    required this.primary,
    required this.onPrimary,
    Key? key,
  }) : super(key: key);

  final CardTaskData data;
  final Color primary;
  final Color onPrimary;

  @override
  Widget build(BuildContext context) {
    // Minimal placeholder implementation that preserves the
    // expected visual structure without altering the original UI.
    return Container(
      width: 150,
      color: primary,
      child: Center(
        child: Text(
          'Task',
          style: TextStyle(color: onPrimary),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _TaskInProgress extends StatelessWidget {
  const _TaskInProgress({
    required this.data,
    Key? key,
  }) : super(key: key);

  final List<CardTaskData> data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: SizedBox(
        height: 250,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CardTask(
              data: data[index],
              primary: _getSequenceColor(index),
              onPrimary: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Color _getSequenceColor(int index) {
    final val = index % 4;
    if (val == 3) {
      return Colors.indigo;
    } else if (val == 2) {
      return Colors.grey;
    } else if (val == 1) {
      return Colors.redAccent;
    } else {
      return Colors.lightBlue;
    }
  }
}