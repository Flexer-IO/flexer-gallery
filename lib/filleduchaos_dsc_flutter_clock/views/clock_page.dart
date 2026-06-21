import 'package:flutter/material.dart';
import '../widgets/clock.dart';
import '../widgets/themed_container.dart';

class ClockPage extends StatelessWidget {
  Widget buildPage(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.background;
    final TextStyle textStyle =
        Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final double padding = MediaQuery.of(context).size.width / 10;

    return Container(
      color: color,
      padding: EdgeInsets.all(padding),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Clock(),
              ),
            ),
            Text(
              'Tap the screen to switch themes',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedContainer(
      padding: EdgeInsets.zero,
      builder: buildPage,
    );
  }
}