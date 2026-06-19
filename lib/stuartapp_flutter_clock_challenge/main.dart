// Copyright 2020 Stuart Delivery Limited. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'dart:io';
 
 import 'package:flutter/foundation.dart';
 import 'package:flutter/material.dart';
 
 // Import the ClockModel from the local flutter_clock_helper package.
 // ignore: uri_does_not_exist
 import '../../deps/flutter_clock_helper/lib/clock.dart';
 
 import 'widgets/ants_clock.dart';
 
 /// A simple wrapper that mimics the behaviour of the original
 /// `ClockCustomizer`. It builds the provided widget using a fresh
 /// [ClockModel] instance from the imported `ants_clock.dart`.
 class ClockCustomizer extends StatelessWidget {
   final Widget Function(ClockModel) builder;
 
   const ClockCustomizer(this.builder, {super.key});
 
   @override
   Widget build(BuildContext context) {
     // In the original helper, the model is supplied by the clock framework.
     // Here we instantiate a fresh model for compatibility.
     return builder(ClockModel());
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
 
   runApp(ClockCustomizer((ClockModel model) {
     return AntsClock(model);
   }));
 }