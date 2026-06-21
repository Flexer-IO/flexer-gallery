// Copyright 2019 Egor Belibov. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'dart:io' show Platform;
 
 import 'package:flutter/foundation.dart'
     show kIsWeb, debugDefaultTargetPlatformOverride;
 import 'package:flutter/material.dart';
 import 'deps/property_change_notifier/property_change_notifier.dart' as pc;
 
 import 'app/app.dart';
 import 'app/g_state/device.dart';
 import 'app/g_state/theme_essentials.dart' hide PropertyChangeProvider;
 
 // Helper notifiers that satisfy the generic bounds of PropertyChangeProvider.
 class _ThemeEssentialsNotifier extends pc.PropertyChangeNotifier<ThemeEssentials> {
   late ThemeEssentials value;
   _ThemeEssentialsNotifier() : super() {
     value = ThemeEssentials();
   }
 }
 
 class _DeviceNotifier extends pc.PropertyChangeNotifier<Device> {
   late Device value;
   _DeviceNotifier() : super() {
     value = Device();
   }
 }
 
 void main() {
   _setOverrideForDesktop();
   runApp(
     pc.PropertyChangeProvider<_ThemeEssentialsNotifier, ThemeEssentials>(
       value: _ThemeEssentialsNotifier(),
       child: pc.PropertyChangeProvider<_DeviceNotifier, Device>(
         value: _DeviceNotifier(),
         child: App(),
       ),
     ),
   );
 }
 
 void _setOverrideForDesktop() {
   if (kIsWeb) return;
 
   if (Platform.isMacOS) {
     debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
   } else if (Platform.isLinux || Platform.isWindows) {
     debugDefaultTargetPlatformOverride = TargetPlatform.android;
   } else if (Platform.isFuchsia) {
     debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
   }
 }