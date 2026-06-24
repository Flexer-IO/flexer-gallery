import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

import '../binaryclock.dart';
import '../xbinaryclock.dart';

class DaftspanielDartbinaryclockPage extends StatefulWidget {
  const DaftspanielDartbinaryclockPage({super.key});

  @override
  State<DaftspanielDartbinaryclockPage> createState() =>
      _DaftspanielDartbinaryclockPageState();
}

class _DaftspanielDartbinaryclockPageState
    extends State<DaftspanielDartbinaryclockPage> {
  late final html.Element _binaryClockElement;

  @override
  void initState() {
    super.initState();

    // Create the custom element defined by the library.
    _binaryClockElement = html.Element.tag('x-binaryclock');

    // Register the element as a platform view so it can be embedded in Flutter.
    // ignore: undefined_identifier
    ui.platformViewRegistry.registerViewFactory(
      'binaryclock-html',
      (int viewId) => _binaryClockElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: HtmlElementView(viewType: 'binaryclock-html'),
      ),
    );
  }
}
