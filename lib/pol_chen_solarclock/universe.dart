import 'dart:math';

import 'package:flutter/material.dart';

class _Twinkle {
  const _Twinkle({required this.left, required this.top, required this.type});
  final double left;
  final double top;
  final int type;
}

class Universe extends StatefulWidget {
  const Universe({super.key, required this.size});
  final Size size;

  @override
  State<Universe> createState() => _UniverseState();
}

class _UniverseState extends State<Universe> with TickerProviderStateMixin {
  static const _twinkleCount = 80;

  late final List<_Twinkle> _twinkleList;
  late final AnimationController _twinkleController;
  late final AnimationController _backgroundController;
  late final List<Animation<double>> _fadeAnimations;
  late final Animation<double> _sizeAnimation;
  late final Animation<Color?> _colorStart;
  late final Animation<Color?> _colorEnd;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _twinkleList = List.generate(
      _twinkleCount,
      (_) => _Twinkle(
        left: rng.nextDouble() * widget.size.width,
        top: rng.nextDouble() * widget.size.height,
        type: rng.nextInt(4),
      ),
    );

    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    final tweens = [0.0, 1.0];
    final intervals = [const Interval(0.0, 0.5), const Interval(0.5, 1.0)];
    _fadeAnimations = List.generate(4, (i) {
      final anim =
          Tween<double>(
            begin: tweens[i ~/ 2],
            end: tweens[(4 - i - 1) ~/ 2],
          ).animate(
            CurvedAnimation(
              parent: _twinkleController,
              curve: intervals[i % 2],
            ),
          );
      anim.addListener(() => setState(() {}));
      return anim;
    });
    _sizeAnimation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(
        parent: _twinkleController,
        curve: const Interval(0, 0.5),
      ),
    )..addListener(() => setState(() {}));
    _twinkleController.addStatusListener((s) {
      if (s == AnimationStatus.completed) _twinkleController.reverse();
      if (s == AnimationStatus.dismissed) _twinkleController.forward();
    });

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _colorStart = ColorTween(
      begin: const Color(0xFF33597A),
      end: const Color(0xFF2B669B),
    ).animate(_backgroundController);
    _colorEnd = ColorTween(
      begin: const Color(0xFF152440),
      end: const Color(0xFF081F4A),
    ).animate(_backgroundController);
    _backgroundController.addStatusListener((s) {
      if (s == AnimationStatus.completed) _backgroundController.reverse();
      if (s == AnimationStatus.dismissed) _backgroundController.forward();
    });

    _twinkleController.forward();
    _backgroundController.forward();
  }

  @override
  void dispose() {
    _twinkleController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, _) => Container(
        width: widget.size.width,
        height: widget.size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_colorStart.value!, _colorEnd.value!],
            begin: const FractionalOffset(0, 0.5),
            end: const FractionalOffset(0.5, 1),
          ),
        ),
        child: Stack(
          children: [
            for (final t in _twinkleList)
              Positioned(
                left: t.left,
                top: t.top,
                child: SizedBox(
                  width: 10,
                  height: 10,
                  child: Opacity(
                    opacity: _fadeAnimations[t.type].value,
                    child: Icon(
                      Icons.lens,
                      color: Colors.white,
                      size: _sizeAnimation.value,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
