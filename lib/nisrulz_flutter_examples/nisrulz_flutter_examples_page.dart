// Source: https://github.com/nisrulz/flutter-examples
import 'package:flutter/material.dart';
class NisrulzFlutterExamplesPage extends StatelessWidget {
  const NisrulzFlutterExamplesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: manual integration needed
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Examples'),
            Text('Source: https://github.com/nisrulz/flutter-examples')
          ],
        ),
      ),
    );
  }
}