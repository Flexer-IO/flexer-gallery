// Copyright 2019 Egor Belibov. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'package:flutter/material.dart';
 import '../g_models/device_type.dart';
 
 // ---------------------------------------------------------------------------
 // Local dependency stubs (originally from '../../../../deps/property_change_notifier/property_change_notifier.dart')
 // ---------------------------------------------------------------------------
 
 /// A minimal implementation of a change notifier that carries a generic payload.
 /// The original library provides more features, but for the purposes of this
 /// file we only need the ability to call `notifyListeners`.
 class PropertyChangeNotifier<T> extends ChangeNotifier {
   // The generic type `T` is kept for compatibility with the original API.
 }
 
 /// Provides access to a value of type `T` higher up in the widget tree.
 /// Mirrors the API used in the original `property_change_notifier` package.
 class PropertyChangeProvider<T> extends InheritedWidget {
   final T value;
 
   const PropertyChangeProvider({
     required this.value,
     required Widget child,
     Key? key,
   }) : super(key: key, child: child);
 
   /// Retrieves the nearest [PropertyChangeProvider] of type `T]` from the
   /// given [context]. If [listen] is true, the widget will rebuild when the
   /// provider notifies listeners.
   static PropertyChangeProvider<T>? of<T>(BuildContext context,
       {bool listen = false}) {
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
   bool updateShouldNotify(covariant PropertyChangeProvider<T> oldWidget) =>
       oldWidget.value != value;
 }
 
 const double desktopBigMinWidth = 1500;
 const double desktopBigMinHeight = 800;
 
 const double desktopMinWidth = 1110;
 const double desktopMinHeight = 700;
 
 const double mobileMinWidth = 370;
 const double mobileMinHeight = 600;
 
 const double mobileMiniWidth = 0;
 const double mobileMiniHeight = 0;
 
 /// Subscribes [context.widget] to changes from Device.
 ///
 /// Every time a new value is notified, [context.widget]
 /// will be re-built.
 DeviceType subscribeToDeviceType(BuildContext context) {
   return PropertyChangeProvider.of<Device>(context, listen: true)!.value.deviceType;
 }
 
 /// Holds and updates listening widgets about current [DeviceType].
 ///
 /// Measured by [deviceWidth] & [deviceHeight].
 class Device extends PropertyChangeNotifier<String> {
   double _deviceWidth = 0;
   double _deviceHeight = 0;
 
   /// Determined by the [deviceWidth] and [deviceHeight] of the [Device].
   DeviceType deviceType = DeviceType.desktop;
 
   double get deviceWidth => _deviceWidth;
   set deviceWidth(double newWidth) {
     if ((newWidth == deviceWidth) ||
         (!_isBigDifference(newWidth, _deviceWidth))) {
       return; // Not worth updating...
     } else {
       _deviceWidth = newWidth;
       _determineDeviceType();
     }
   }
 
   double get deviceHeight => _deviceHeight;
   set deviceHeight(double newHeight) {
     if ((newHeight == _deviceHeight) ||
         (!_isBigDifference(newHeight, _deviceHeight))) {
       return; // Not worth updating...
     } else {
       _deviceHeight = newHeight;
       _determineDeviceType();
     }
   }
 
   bool _isBigDifference(double newX, double oldX) {
     if (newX > 500) {
       return (oldX - newX).abs() > 100;
     } else {
       // Make it more precise when on lower values
       return (oldX - newX).abs() > 25;
     }
   }
 
   void _determineDeviceType() {
     if ((deviceWidth > desktopBigMinWidth)) {
       if ((deviceHeight > desktopBigMinHeight)) {
         _updateDeviceType(DeviceType.desktopBig);
       } else {
         _updateDeviceType(DeviceType.mobile);
       }
       return;
     } else if ((deviceWidth > desktopMinWidth)) {
       if ((deviceHeight > desktopMinHeight)) {
         _updateDeviceType(DeviceType.desktop);
       } else {
         _updateDeviceType(DeviceType.mobile);
       }
       return;
     } else if ((deviceWidth > mobileMinWidth)) {
       if ((deviceHeight > mobileMinHeight)) {
         _updateDeviceType(DeviceType.mobile);
       } else {
         _updateDeviceType(DeviceType.mobileMini);
       }
       return;
     } else {
       _updateDeviceType(DeviceType.mobileMini);
       return;
     }
   }
 
   void _updateDeviceType(DeviceType deviceType) {
     this.deviceType = deviceType;
     notifyListeners();
   }
 }