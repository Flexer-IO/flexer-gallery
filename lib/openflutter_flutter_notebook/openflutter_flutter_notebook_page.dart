// Source: https://github.com/OpenFlutter/Flutter-Notebook
import 'package:flutter/material.dart';
class OpenflutterFlutterNotebookPage extends StatelessWidget {
  const OpenflutterFlutterNotebookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: manual integration needed
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Notebook'),
            Text('Source: https://github.com/OpenFlutter/Flutter-Notebook')
          ],
        ),
      ),
    );
  }
}