// Copyright 2019 Egor Belibov. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'package:flutter/material.dart' show Brightness, Scaffold;
 import 'package:flutter/widgets.dart';
 import '../../../deps/property_change_notifier/property_change_notifier.dart' as pc;
 
 import '../../g_extensions/apt_brightness.dart';
 import '../../g_state/device.dart';
 import '../../g_state/theme_essentials.dart';
 import '../../g_styles/colors.dart';
 import 'containers/content/content.dart';
 import 'containers/footer/footer.dart';
 
 class HomeScreen extends StatefulWidget {
   @override
   _HomeScreenState createState() => _HomeScreenState();
 }
 
 class _HomeScreenState extends State<HomeScreen> {
   late Device _device;
   Widget? _lightHomeScreen;
   Widget? _darkHomeScreen;
 
   @override
   void initState() {
     super.initState();
     // Retrieve the Device instance from the PropertyChangeProvider.
     // The provider returns a PropertyChangeModel; extract the value.
     final pc.PropertyChangeModel<dynamic, dynamic>? model =
         pc.PropertyChangeProvider.of(context, listen: false);
     if (model == null) {
       throw StateError('Device not found in PropertyChangeProvider');
     }
     final Device? device = model.value as Device?;
     if (device == null) {
       throw StateError('Device not found in PropertyChangeProvider');
     }
     _device = device;
   }
 
   @override
   void didChangeDependencies() {
     super.didChangeDependencies();
     // Execute asynchronously at the end of frame.
     final deviceSize = MediaQuery.of(context).size;
     Future.microtask(() {
       _device.deviceWidth = deviceSize.width;
       _device.deviceHeight = deviceSize.height;
     });
   }
 
   @override
   Widget build(BuildContext context) {
     final Brightness brightness = subscribeToBrigthness(context);
     if (brightness.isLight()) {
       return _lightHomeScreen ??= _buildWidget(context);
     } else {
       return _darkHomeScreen ??= _buildWidget(context);
     }
   }
 
   Widget _buildWidget(BuildContext context) {
     return WillPopScope(
       onWillPop: () async => false,
       child: Scaffold(
         backgroundColor: themeBasedColor(
           context,
           PaletteColor.backgroundColor,
           listen: false,
         ),
         resizeToAvoidBottomInset: false,
         body: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Content(),
             Footer(),
           ],
         ),
       ),
     );
   }
 }