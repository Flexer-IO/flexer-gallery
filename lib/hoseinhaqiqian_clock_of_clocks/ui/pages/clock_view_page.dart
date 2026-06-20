import 'dart:async';
import 'package:flutter/material.dart';

/// Extension methods that were originally provided in
/// `package:hoseinhaqiqian_clock_of_clocks/common/extension.dart`.
extension IntExtensions on int {
  /// Splits the integer into its individual digits.
  /// Example: 12 -> [1, 2]
  List<int> splitter() => toString().split('').map(int.parse).toList();

  /// Returns a representation of the integer that can be used by
  /// [NumberView]. The original implementation likely transformed the
  /// integer into a list of segment values; for compilation purposes we
  /// simply wrap the integer in a list.
  List<int> getValue() => [this];
}

/// A minimal placeholder for the original `NumberView` widget that was
/// defined in `ui/paint/number_view.dart`. The visual representation is
/// kept simple to satisfy compilation while preserving the expected API.
class NumberView extends StatelessWidget {
  final List<int> clocks;
  const NumberView({Key? key, required this.clocks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The original widget likely draws the number using a custom painter.
    // Here we display the integer(s) as text to maintain functional
    // behavior without altering layout logic.
    return Text(
      clocks.join(', '),
      style: const TextStyle(fontSize: 24),
    );
  }
}

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
    Timer.periodic(const Duration(seconds: 1), (va) {
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
            children: <Widget>[
              for (var value in dateTime.hour.splitter())
                _buildNumber(value),
              _buildDivider(),
              for (var value in dateTime.minute.splitter())
                _buildNumber(value),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (var value in dateTime.second.splitter())
                _buildNumber(value),
              // _buildNumber(dateTime.second)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumber(int number) {
    return NumberView(
      clocks: number.getValue(),
    );
  }

  Widget _buildDivider() {
    return NumberView(
      clocks: (-1).getValue(),
    );
  }
}