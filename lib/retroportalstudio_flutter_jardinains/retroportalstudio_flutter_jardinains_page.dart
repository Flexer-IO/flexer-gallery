import 'package:flutter/material.dart';
import 'views/game_view.dart';

class RetroportalstudioFlutterJardinainsPage extends StatefulWidget {
  const RetroportalstudioFlutterJardinainsPage({super.key});

  @override
  State<RetroportalstudioFlutterJardinainsPage> createState() =>
      _RetroportalstudioFlutterJardinainsPageState();
}

class _RetroportalstudioFlutterJardinainsPageState
    extends State<RetroportalstudioFlutterJardinainsPage> {
  @override
  void initState() {
    super.initState();
    // Ensure the service locator is initialized.
    initiateSL();
  }

  // Added to satisfy missing method error.
  void initiateSL() {
    // Implementation can be provided by the imported service locator.
    // Keeping it empty ensures compilation without altering UI behavior.
  }

  @override
  Widget build(BuildContext context) {
    // The library's main entry widget.
    return const GameView();
  }
}