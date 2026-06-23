import 'package:flutter/material.dart';
import 'clock/view/recursive_clock.dart';
import 'info/view/info_panel.dart';

/// A widget that handles the layout of an [InfoPanel] and a [RecursiveClock].
class ClockInfoLayout extends StatelessWidget {
  const ClockInfoLayout({this.infoPanel, this.clock});

  final Widget infoPanel;
  final Widget clock;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (infoPanel != null) infoPanel,
            if (clock != null) clock,
          ],
        ),
      );
}
