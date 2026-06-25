import 'package:flutter/material.dart';
import 'match.dart' as match;
import 'match_clock_widget.dart' as clock_widget;

class MikolajlenMatchesClockPage extends StatelessWidget {
  const MikolajlenMatchesClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final creator = match.MatchesCreator()
      ..calculateMatchesSize(MediaQuery.of(context).size);
    return Scaffold(
      body: clock_widget.MatchClockWidget(
        creator: creator as clock_widget.MatchesCreator,
      ),
    );
  }
}