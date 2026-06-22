// Copyright 2019 The Chromium Authors. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'package:flutter/material.dart';
 import 'countdown_clock.dart';
 
 // Minimal stub definitions to replace missing dependencies.
 class ClockModel {
   // Add fields if needed in the future.
 }
 
 Widget ClockCustomizer(Widget Function(ClockModel) builder) => builder(ClockModel());
 
 void main() {
   runApp(ClockCustomizer((ClockModel model) => const CountdownClock()));
 }