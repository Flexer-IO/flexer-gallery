import 'dart:io';

import 'package:flutter/material.dart';
import '../video_editor.dart';

class LegoffmaelVideoEditorPage extends StatefulWidget {
  const LegoffmaelVideoEditorPage({super.key});

  @override
  State<LegoffmaelVideoEditorPage> createState() =>
      _LegoffmaelVideoEditorPageState();
}

class _LegoffmaelVideoEditorPageState extends State<LegoffmaelVideoEditorPage> {
  late final VideoEditorController _controller;

  @override
  void initState() {
    super.initState();
    // NOTE: Replace the empty string with a valid video file path.
    final file = File('');
    _controller = VideoEditorController.file(
      file,
      // You can customize the controller parameters here if needed.
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoEditor(
        controller: _controller,
      ),
    );
  }
}
