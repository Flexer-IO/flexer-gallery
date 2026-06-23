// Copyright 2019 The Chromium Authors. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'dart:io';
 
 import 'package:flutter/foundation.dart';
 import 'package:flutter/material.dart';
 
 import 'analog_clock.dart';
 
 // Stub definitions for the flutter_clock_helper package.
 // These are provided here to satisfy the compiler when the actual
 // package files are not available. They replicate the minimal API
 // used by this application.
 
 /// A minimal model class required by the clock customizer.
 class ClockModel {}
 
 /// Signature for a builder that creates a clock widget given a [ClockModel].
 typedef ClockBuilder = Widget Function(ClockModel model);
 
 /// A simple widget that invokes the provided [ClockBuilder] with a fresh
 /// [ClockModel] instance. In the original package this widget also
 /// supplies configuration and platform‑specific behavior, but for the
 /// purposes of this showcase we only need to forward the builder.
 class ClockCustomizer extends StatelessWidget {
   final ClockBuilder builder;
 
   const ClockCustomizer(this.builder, {Key? key}) : super(key: key);
 
   @override
   Widget build(BuildContext context) {
     // Create a default model and build the clock widget.
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
 
   // This creates a clock that enables you to customize it.
   //
   // The [ClockCustomizer] takes in a [ClockBuilder] that consists of:
   //  - A clock widget (in this case, [AnalogClock])
   //  - A model (provided to you by [ClockModel])
   // For more information, see the flutter_clock_helper package.
   //
   // Your job is to edit [AnalogClock], or replace it with your own clock
   // widget. (Look in analog_clock.dart for more details!)
   runApp(ClockCustomizer((ClockModel model) => AnalogClock()));
 }