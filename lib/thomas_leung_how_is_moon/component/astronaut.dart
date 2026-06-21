import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Stub implementation for FlareActor to replace missing package import.
class FlareActor extends StatelessWidget {
  final String asset;
  final BoxFit? fit;
  final String? animation;

  const FlareActor(
    this.asset, {
    Key? key,
    this.fit,
    this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder widget; the original visual behavior is not replicated here.
    return Container();
  }
}

class Astronaut extends StatefulWidget {
  final String astAnime;
  Astronaut(this.astAnime, {Key? key}) : super(key: key);

  @override
  _AstronautState createState() => _AstronautState();
}

class _AstronautState extends State<Astronaut> {
  bool _animating = false;
  Timer? _timer;
  final Map<String, int> _astAnimeTime = {
    "flash": 1,
    "float": 30,
    "phone": 20,
    "walk": 16,
  };

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    int _start = _astAnimeTime[widget.astAnime] ?? 1;
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (_start < 1) {
          _animating = false;
          timer.cancel();
        } else {
          _start--;
        }
      }),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return IgnorePointer(
      ignoring: _animating,
      child: Container(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            HapticFeedback.mediumImpact();
            setState(() {
              _animating = true;
              startTimer();
            });
          },
          child: FlareActor(
            'packages/showcase_library/assets/thomas_leung_how_is_moon/Astronaut.flr',
            fit: width > height ? BoxFit.contain : BoxFit.fitWidth,
            animation: _animating ? widget.astAnime : "idle",
          ),
        ),
      ),
    );
  }
}