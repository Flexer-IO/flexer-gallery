import 'dart:io';

import 'package:flutter/material.dart';

class AppBarScrollHandler extends StatelessWidget {
  final double minExtent;
  final double maxExtent;
  final ScrollController controller;
  final Widget child;

  const AppBarScrollHandler({
    Key? key,
    required this.minExtent,
    required this.maxExtent,
    required this.controller,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This placeholder simply forwards the child.
    // Replace with the actual implementation if available.
    return child;
  }
}

class Iamv4gFlutterMomoSliverAppbarPage extends StatefulWidget {
  const Iamv4gFlutterMomoSliverAppbarPage({super.key});

  @override
  State<Iamv4gFlutterMomoSliverAppbarPage> createState() =>
      _Iamv4gFlutterMomoSliverAppbarPageState();
}

class _Iamv4gFlutterMomoSliverAppbarPageState
    extends State<Iamv4gFlutterMomoSliverAppbarPage> {
  late double _minExtent;
  late double _maxExtent;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _minExtent = kToolbarHeight + MediaQuery.paddingOf(context).top;
    _maxExtent = Platform.isAndroid ? 216 : 256;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: AppBarScrollHandler(
        minExtent: _minExtent,
        maxExtent: _maxExtent,
        controller: _scrollController,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: const <Widget>[],
        ),
      ),
    );
  }
}