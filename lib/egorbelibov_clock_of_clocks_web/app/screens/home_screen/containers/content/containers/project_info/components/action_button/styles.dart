// Copyright 2019 Egor Belibov. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'package:flutter/material.dart';
 
 import '../../../../../../../../g_models/device_type.dart';
 import '../../../../../../../../g_styles/fonts.dart';
 
 TextStyle buttonTextStyle(BuildContext context, DeviceType deviceType) {
   switch (deviceType) {
     case DeviceType.desktopBig:
     case DeviceType.desktop:
     case DeviceType.mobile:
       return const TextStyle(
         fontFamily: defaultFontFamily,
         fontSize: 18,
         fontWeight: FontWeight.w700,
         color: Colors.white,
       );
     case DeviceType.mobileMini:
       return const TextStyle(
         fontFamily: defaultFontFamily,
         fontSize: 14,
         fontWeight: FontWeight.w700,
         color: Colors.white,
       );
   }
 }
 
 double buttonWidth(DeviceType deviceType) {
   switch (deviceType) {
     case DeviceType.mobile:
       return 300;
     case DeviceType.mobileMini:
       return 255;
     case DeviceType.desktop:
     case DeviceType.desktopBig:
       return 0; // Fallback for desktop sizes (should never be used)
   }
 }
 
 BorderRadius buttonBorderRadius(DeviceType deviceType) {
   switch (deviceType) {
     case DeviceType.desktopBig:
     case DeviceType.desktop:
       return const BorderRadius.only(
         topLeft: Radius.circular(5),
         bottomLeft: Radius.circular(5),
       );
     case DeviceType.mobile:
     case DeviceType.mobileMini:
       return const BorderRadius.all(Radius.circular(5));
   }
 }
 
 EdgeInsetsGeometry buttonPadding(DeviceType deviceType) {
   switch (deviceType) {
     case DeviceType.desktopBig:
     case DeviceType.desktop:
     case DeviceType.mobile:
       return const EdgeInsets.symmetric(
         vertical: 0,
         horizontal: 55,
       );
     case DeviceType.mobileMini:
       return const EdgeInsets.symmetric(
         vertical: 0,
         horizontal: 20,
       );
   }
 }