// Copyright 2019 Egor Belibov. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'package:flutter/material.dart';
 
 import '../g_state/theme_essentials.dart';
 import 'colors.dart';
 import 'fonts.dart';
 
 // Returns a ThemeData instance based on the current context.
 // The function is typed explicitly for null‑safety and Dart 3 compatibility.
 final ThemeData Function(BuildContext) appTheme = (BuildContext context) => ThemeData(
       brightness: subscribeToBrigthness(context),
       fontFamily: defaultFontFamily,
       primaryColor: themeBasedColor(
         context,
         PaletteColor.primaryColor,
       ),
       scaffoldBackgroundColor: themeBasedColor(
         context,
         PaletteColor.backgroundColor,
       ),
       // The `backgroundColor` property was removed from ThemeData in newer Flutter
       // versions; its functionality is covered by `scaffoldBackgroundColor`.
     );