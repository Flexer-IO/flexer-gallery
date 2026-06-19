import 'package:flutter/material.dart';
import '../math_utils.dart';

/// Minimal definition of weather conditions needed for this widget.
/// The full definition lives in the shared model, but to keep this file
/// self‑contained and avoid import errors we provide only the values we
/// actually use.
enum WeatherCondition {
  foggy,
  // Other conditions can be added here if needed.
}

class Fog extends StatefulWidget {
  final WeatherCondition weatherCondition;
  final bool isDarkMode;

  const Fog({
    Key? key,
    required this.weatherCondition,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  _FogState createState() => _FogState();
}

class _FogState extends State<Fog> with SingleTickerProviderStateMixin {
  static const _slideRange = 0.10;
  static const _slideDuration = 5000;

  late final AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _slideDuration),
    );

    // Initialize with a stopped animation so that _animation.value is valid
    _animation = const AlwaysStoppedAnimation<Offset>(Offset.zero);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animation = _createAnimation();
        _animationController.forward(from: 0.0);
      }
    });

    _animation = _createAnimation();

    if (_isActive()) {
      _animationController.forward();
    }
  }

  Animation<Offset> _createAnimation() {
    final begin = _animation.value;
    return Tween<Offset>(
      begin: begin,
      end: Offset(
        randomDouble(-_slideRange, _slideRange),
        randomDouble(-_slideRange, _slideRange),
      ),
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Fog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weatherCondition != oldWidget.weatherCondition ||
        widget.isDarkMode != oldWidget.isDarkMode) {
      if (_isActive()) {
        _animationController.forward();
      } else {
        _animationController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isActive()) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Center(
            child: SlideTransition(
              position: _animation,
              child: child,
            ),
          );
        },
        child: Image.asset('assets/fog.png'),
      );
    } else {
      return Container();
    }
  }

  bool _isActive() {
    return widget.weatherCondition == WeatherCondition.foggy && !widget.isDarkMode;
  }
}