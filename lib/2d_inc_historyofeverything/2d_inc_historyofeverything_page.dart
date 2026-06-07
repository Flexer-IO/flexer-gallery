// Source: https://github.com/2d-inc/HistoryOfEverything
import 'package:flutter/material.dart';

class TwoDIncHistoryOfEverythingPage extends StatelessWidget {
  const TwoDIncHistoryOfEverythingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: manual integration needed
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('HistoryOfEverything'),
            Text('Source: https://github.com/2d-inc/HistoryOfEverything')
          ],
        ),
      ),
    );
  }
}