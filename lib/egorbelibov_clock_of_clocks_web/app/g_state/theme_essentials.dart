// Copyright 2019 Egor Belibov. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'package:flutter/material.dart';
 
 /// Minimal implementation of [PropertyChangeNotifier] to satisfy
 /// compile‑time requirements without altering runtime behaviour.
 class PropertyChangeNotifier<T> extends ChangeNotifier {
   T? value;
 }
 
 /// Minimal implementation of [PropertyChangeProvider] to satisfy
 /// compile‑time requirements without altering runtime behaviour.
 class PropertyChangeProvider<T> extends InheritedWidget {
   final PropertyChangeNotifier<T> value;
 
   const PropertyChangeProvider({
     required this.value,
     required Widget child,
     Key? key,
   }) : super(key: key, child: child);
 
   static PropertyChangeProvider<T>? of<T>(BuildContext context,
       {bool listen = true}) {
     if (listen) {
       return context
           .dependOnInheritedWidgetOfExactType<PropertyChangeProvider<T>>();
     } else {
       final element = context
           .getElementForInheritedWidgetOfExactType<PropertyChangeProvider<T>>();
       return element?.widget as PropertyChangeProvider<T>?;
     }
   }
 
   @override
   bool updateShouldNotify(PropertyChangeProvider<T> oldWidget) =>
       value != oldWidget.value;
 }
 
 /// Subscribes [context.widget] to changes from [ThemeEssentials].
 ///
 /// Every time a new value is notified, [context.widget]
 /// will be re-built. If [listen] is false. It will only get
 /// the value once.
 Brightness subscribeToBrigthness(BuildContext context, {bool listen = true}) {
   final provider = PropertyChangeProvider.of<ThemeEssentials>(context,
       listen: listen);
   // The provider holds a PropertyChangeNotifier<ThemeEssentials>,
   // which is actually a ThemeEssentials instance (since ThemeEssentials
   // extends PropertyChangeNotifier<ThemeEssentials>).
   final themeEssentials = provider?.value as ThemeEssentials?;
   assert(themeEssentials != null);
   return themeEssentials!._brightness;
 }
 
 /// Holds Essential [Theme] Information.
 ///
 /// It's much faster at **updating** & **notifying** than: `Theme.of(context)`
 class ThemeEssentials extends PropertyChangeNotifier<ThemeEssentials> {
   Brightness _brightness = Brightness.light;
 
   ThemeEssentials();
 
   Brightness get brightness => _brightness;
   set brightness(Brightness newBrightness) {
     if (newBrightness != _brightness) {
       _brightness = newBrightness;
       notifyListeners();
     }
   }
 }