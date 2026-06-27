import 'dart:math';

import 'package:flutter/material.dart';

class _Twinkle {
  const _Twinkle({required this.left, required this.top, required this.type});
  final double left;
  final double top;
  final int type;
}

class Universe extends StatefulWidget {
  const Universe({super.key, required this.bgStart, required this.bgEnd});

  final Color bgStart;
  final Color bgEnd;

  @override
  State<Universe> createState() => _UniverseState();
}

class _UniverseState extends State<Universe> with TickerProviderStateMixin {
  static const _twinkleCount = 120;

  List<_Twinkle>? _twinkleList;
  Size? _lastSize;

  late final AnimationController _twinkleController;
  late final AnimationController _backgroundController;
  late final List<Animation<double>> _fadeAnimations;
  late final Animation<double> _sizeAnimation;

  late Animation<Color?> _colorStart;
  late Animation<Color?> _colorEnd;

  @override
  void initState() {
    super.initState();

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
    _sizeAnimation = Tween<double>(begin: 0.5, end: 3.0).animate(
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
      duration: const Duration(milliseconds: 5000),
    );
    _rebuildBackgroundAnim();
    _backgroundController.addStatusListener((s) {
      if (s == AnimationStatus.completed) _backgroundController.reverse();
      if (s == AnimationStatus.dismissed) _backgroundController.forward();
    });

    _twinkleController.forward();
    _backgroundController.forward();
  }

  void _rebuildBackgroundAnim() {
    _colorStart = ColorTween(
      begin: widget.bgStart,
      end: Color.lerp(widget.bgStart, Colors.white, 0.08)!,
    ).animate(_backgroundController);
    _colorEnd = ColorTween(
      begin: widget.bgEnd,
      end: Color.lerp(widget.bgEnd, Colors.white, 0.06)!,
    ).animate(_backgroundController);
  }

  @override
  void didUpdateWidget(Universe old) {
    super.didUpdateWidget(old);
    if (old.bgStart != widget.bgStart || old.bgEnd != widget.bgEnd) {
      _rebuildBackgroundAnim();
    }
  }

  @override
  void dispose() {
    _twinkleController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  List<_Twinkle> _buildTwinkles(Size size) {
    final rng = Random();
    return List.generate(
      _twinkleCount,
      (_) => _Twinkle(
        left: rng.nextDouble() * size.width,
        top: rng.nextDouble() * size.height,
        type: rng.nextInt(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (_twinkleList == null || _lastSize != size) {
          _lastSize = size;
          _twinkleList = _buildTwinkles(size);
        }
        final twinkles = _twinkleList!;

        return AnimatedBuilder(
          animation: Listenable.merge([
            _backgroundController,
            _twinkleController,
          ]),
          builder: (context, _) => Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_colorStart.value!, _colorEnd.value!],
                begin: const FractionalOffset(0, 0.5),
                end: const FractionalOffset(0.5, 1),
              ),
            ),
            child: Stack(
              children: [
                for (final t in twinkles)
                  Positioned(
                    left: t.left,
                    top: t.top,
                    child: Opacity(
                      opacity: _fadeAnimations[t.type].value,
                      child: Container(
                        width: _sizeAnimation.value,
                        height: _sizeAnimation.value,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
