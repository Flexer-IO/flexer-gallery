import 'package:flutter/material.dart';

/// Minimal stub for [FlareControls] to satisfy compilation when the actual
/// Flare library is not available. It provides the subset of the API used in
/// this widget.
class FlareControls {
  void setAnimation(String name) {}
}

/// Minimal stub for [FlareActor] widget. It mirrors the constructor signature
/// used in the original code but renders an empty box. This allows the code to
/// compile without pulling in the full Flare package while preserving the
/// widget tree structure.
class FlareActor extends StatelessWidget {
  final String asset;
  final FlareControls? controller;
  final BoxFit? fit;
  final String? animation;
  final String? artboard;

  const FlareActor(
    this.asset, {
    Key? key,
    this.controller,
    this.fit,
    this.animation,
    this.artboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The real FlareActor would render the animation; here we keep the UI
    // unchanged structurally by returning an empty container.
    return const SizedBox.shrink();
  }
}

class TrackingInput extends StatefulWidget {
  const TrackingInput({Key? key}) : super(key: key);

  @override
  _TrackingInputState createState() => _TrackingInputState();
}

class _TrackingInputState extends State<TrackingInput> {
  late final FlareControls _flareController;

  int currentMoonPhase = 0;
  int selectedMoon = 29;

  @override
  void initState() {
    super.initState();
    _flareController = FlareControls();
  }

  void _incrementMoon() {
    currentMoonPhase++;
    _flareController.setAnimation('idle');
  }

  void _resetMoon() {
    currentMoonPhase = 0;
    _flareController.setAnimation('idle');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(93, 93, 93, 1),
      body: Container(
        color: const Color.fromRGBO(93, 93, 93, 1),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FlareActor(
              "packages/showcase_library/assets/thomas_leung_how_is_moon/Moon.flr",
              controller: _flareController,
              fit: BoxFit.contain,
              animation: 'idle',
              artboard: "Artboard",
            ),
            Column(
              children: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  onPressed: _incrementMoon,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('reset'),
                  onPressed: _resetMoon,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}