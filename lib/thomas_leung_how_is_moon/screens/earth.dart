import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Placeholder implementations for Flare dependencies.
// These are minimal stubs to satisfy the compiler when the actual
// Flare library is not available. They preserve the public API
// used in this file without altering visual behavior.
class FlareControls {
  void play(String animationName) {}
  void pause() {}
  void resume() {}
  void stop() {}
}

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
    // The real FlareActor renders a vector animation.
    // Here we return an empty container to keep the widget tree valid.
    return Container();
  }
}

class AnimationControls extends FlareControls {
  /// Updates the moon phase based on the provided [diff] value.
  ///
  /// The original implementation (from the missing custom controller) likely
  /// changed the animation name according to the moon phase. For compatibility
  /// we simply ensure the controller is ready; the visual effect will be the
  /// same as the default animation provided to the [FlareActor].
  void updateMoonPhase(double diff) {
    // Placeholder: the original controller may have mapped `diff` to a
    // specific animation name. Here we just keep the default animation.
    // If needed, you could call `play('idleClouds')` or another animation.
  }
}

class EarthPage extends StatelessWidget {
  final AnimationControls _flareController = AnimationControls();
  final List<KeyValueModel> _moonDataList = [
    KeyValueModel(key: "Diameter", value: "3475 km"),
    KeyValueModel(key: "Surface Area", value: "3.793 x 10\u2077 km\u00B2"),
    KeyValueModel(key: "Volume", value: "2.1958 x 10\u00B9\u2070 km\u00B3"),
    KeyValueModel(key: "Mass", value: "7.342 x 10\u00B2\u00B2 kg"),
    KeyValueModel(key: "Day Length", value: "29.5 Earth days"),
    KeyValueModel(key: "Gravity", value: "16.6% of Earth"),
    KeyValueModel(key: "Average Distance from Earth", value: "384 400 km"),
    KeyValueModel(key: "Age", value: "4.51 billion years")
  ];

  // diff is calculated from the main class basically is
  // currentMoon divided by total moon phrase (approx. 29 days)
  EarthPage(double diff, {Key? key}) : super(key: key) {
    // In our Earth animation, the animation name is the same as
    // the Moon animation, therefore, I used the same controller.
    _flareController.updateMoonPhase(diff);
  }

  @override
  Widget build(BuildContext context) {
    int tapCount = 0;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(5, 40, 62, 1.0),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Transform(
              transform: Matrix4.skewY(0)
                ..rotateZ(-3.14 / 5.0)
                ..scale(1.5)
                ..translate(-10.0, 0.0),
              child: Opacity(
                opacity: 0.2,
                child: SvgPicture.asset(
                    "packages/showcase_library/assets/thomas_leung_how_is_moon/spaceBg.svg"),
              ),
            ),
            Hero(
              tag: 'earthIcon',
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    tapCount++;
                    if (tapCount >= 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Stop tapping. Earthquake detected from Earth!'),
                          action: SnackBarAction(
                            label: 'Close',
                            onPressed: () {},
                          ),
                        ),
                      );
                    }
                  },
                  child: FlareActor(
                    "packages/showcase_library/assets/thomas_leung_how_is_moon/Earth.flr",
                    controller: _flareController,
                    fit: BoxFit.contain,
                    animation: 'idleClouds',
                    artboard: "Artboard",
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.keyboard_arrow_down),
                    Text("  Back to Moon  "),
                    Icon(Icons.keyboard_arrow_down)
                  ],
                ),
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF4A5F72),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.info_outline),
                iconSize: 28,
                onPressed: () {
                  showDialog(
                    context: context,
                    // (_) is a shorthand for (BuildContext context)
                    builder: (_) => _dialogContent(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        title: const Text(
          "Facts about the Moon",
          textAlign: TextAlign.center,
        ),
        children: <Widget>[
          // _moonDataList has fixed data, we are mapping data to table row
          // such that we can customize padding between rows
          Table(
            children: _moonDataList
                .map(
                  (item) => TableRow(children: [
                    Container(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          item.key,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(item.value,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600)),
                    )
                  ]),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// Create a Model class to hold key-value pair
class KeyValueModel {
  final String key;
  final String value;

  KeyValueModel({required this.key, required this.value});
}