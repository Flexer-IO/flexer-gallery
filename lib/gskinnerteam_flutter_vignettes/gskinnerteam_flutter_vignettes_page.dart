// ignore_for_file: avoid_print, avoid_positional_boolean_parameters, avoid_types_as_parameter_names, duplicate_ignore, unnecessary_null_aware_calls, unnecessary_null_in_if_null_coalescing

import 'package:flutter/material.dart';

class GskinnerteamFlutterVignettesPage extends StatefulWidget {
  const GskinnerteamFlutterVignettesPage({super.key});

  @override
  State<GskinnerteamFlutterVignettesPage> createState() => _GskinnerteamFlutterVignettesPageState();
}

class _GskinnerteamFlutterVignettesPageState extends State<GskinnerteamFlutterVignettesPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade800,
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Tap to change animation',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_animationController.status == AnimationStatus.forward) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}