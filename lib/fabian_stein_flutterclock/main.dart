// Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'dart:io';
 
 import 'package:flutter/foundation.dart';
 import 'package:flutter/material.dart';
 
 import 'digital_clock.dart';
 
 /// Signature for a function that builds a clock widget given a [ClockModel].
 typedef ClockBuilder = Widget Function(ClockModel model);
 
 /// A simple widget that mimics the behavior of the original
 /// `ClockCustomizer`. It creates a [MaterialApp] and uses the provided
 /// builder to construct the clock widget.
 class ClockCustomizer extends StatelessWidget {
   final ClockBuilder _builder;
 
   const ClockCustomizer(this._builder, {Key? key}) : super(key: key);
 
   @override
   Widget build(BuildContext context) {
     // In the original helper package, additional customization UI may be
     // provided. For compatibility, we simply instantiate a [ClockModel] and
     // pass it to the builder, embedding the result in a basic MaterialApp.
     final ClockModel model = ClockModel();
     return MaterialApp(
       home: Scaffold(
         body: _builder(model),
       ),
     );
   }
 }
 
 void main() {
   // A temporary measure until Platform supports web and TargetPlatform supports
   // macOS.
   if (!kIsWeb && Platform.isMacOS) {
     // TODO(gspencergoog): Update this when TargetPlatform includes macOS.
     // https://github.com/flutter/flutter/issues/31366
     // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override.
     debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
   }
 
   // This creates a clock that enables you to customize it.
   //
   // The [ClockCustomizer] takes in a [ClockBuilder] that consists of:
   //  - A clock widget (in this case, [DigitalClock])
   //  - A model (provided to you by [ClockModel])
   // For more information, see the flutter_clock_helper package.
   //
   // Your job is to edit [DigitalClock], or replace it with your
   // own clock widget. (Look in digital_clock.dart for more details!)
   runApp(ClockCustomizer((ClockModel model) => DigitalClock(model)));
 }