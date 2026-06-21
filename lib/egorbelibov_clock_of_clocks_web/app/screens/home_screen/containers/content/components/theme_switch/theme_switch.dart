/*
// Copyright 2019 Egor Belibov. All rights reserved.
// Use of this source code is governed by a BSD-style license that can
// found in the LICENSE file.
*/

import 'dart:math';

import 'package:flutter/material.dart';

// Local dependencies (relative imports)
import '../../../../../../../deps/property_change_notifier/property_change_notifier.dart' as pc;
import '../../../../../../g_state/theme_essentials.dart';
import '../../../../../../g_wrapper/custom_cursor.dart';

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

const lightThemePrimaryColor = Color(0xFF000000);
const darkThemePrimaryColor = Color(0xFFFFFFFF);

class _ThemeSwitchState extends State<ThemeSwitch> {
  late ThemeEssentials _themeState;
  late Brightness _brightness;

  void _updateThemeBrightness() {
    if (_brightness == Brightness.light) {
      setState(() => _brightness = Brightness.dark);
      _themeState.brightness = Brightness.dark;
    } else {
      setState(() => _brightness = Brightness.light);
      _themeState.brightness = Brightness.light;
    }
  }

  @override
  void initState() {
    super.initState();
    // Retrieve the ThemeEssentials model from the PropertyChangeProvider.
    final pc.PropertyChangeModel<dynamic, dynamic>? rawModel =
        pc.PropertyChangeProvider.of(context, listen: false) as pc.PropertyChangeModel<dynamic, dynamic>?;

    final ThemeEssentials? themeEssentials = rawModel?.value as ThemeEssentials?;

    if (themeEssentials == null) {
      throw StateError('ThemeEssentials not found in PropertyChangeProvider');
    }

    _themeState = themeEssentials;
    _brightness = _themeState.brightness;
  }

  @override
  Widget build(BuildContext context) {
    return _buildSwitch();
  }

  Widget _buildSwitch() {
    final primaryColor =
        _brightness == Brightness.light ? lightThemePrimaryColor : darkThemePrimaryColor;

    final rotationAngle = _brightness == Brightness.light ? 0.0 : pi;
    final rotationAngleTween = Tween<double>(
      begin: 0.0,
      end: rotationAngle,
    );

    return Positioned(
      top: 0,
      left: 0,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
        ),
        child: TweenAnimationBuilder(
          tween: rotationAngleTween,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate,
          builder: (_, angle, child) {
            return Transform.rotate(
              angle: angle,
              child: child,
            );
          },
          child: CustomCursor(
            cursorStyle: CustomCursor.pointer,
            child: GestureDetector(
              onTap: () => _updateThemeBrightness(),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  // shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: primaryColor,
                  ),
                ),
                child: _buildHalfCircle(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHalfCircle() {
    return FractionallySizedBox(
      alignment: Alignment.centerRight,
      widthFactor: 0.50,
      child: Container(
        decoration: BoxDecoration(
          // FILED FLUTTER ISSUE: #48631
          // borderRadius: BorderRadius.only(
          //   topRight: Radius.circular(13.5),
          //   bottomRight: Radius.circular(13),
          // ),
          color: const Color(0xFF000000),
        ),
      ),
    );
  }
}