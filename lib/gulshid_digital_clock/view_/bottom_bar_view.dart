import 'deps/curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'view_/Clock_view1.dart';
import 'view_/Clock_view2.dart';
import 'view_/drawar_view.dart';
import 'view_Model/Digital_Provider.dart';
import 'view_Model/switch_provider.dart';
import 'deps/flutter_screenutil/flutter_screenutil.dart';
import 'deps/provider/provider.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<DigitalProvider>(context);
    final provi = Provider.of<SwitchProvider>(context);
    List Pages = [DigitalClock(), AnalogeClock()];
    return Scaffold(
      backgroundColor: provi.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: provi.isDarkMode? Colors.black: Colors.teal,
      ),
      drawer: Clock_Drawar(),
      body: Pages[pro.index],

      bottomNavigationBar: CurvedNavigationBar(
        height: 45.h,
        animationDuration: Duration(milliseconds: 300),
        color: Colors.deepPurple,
        backgroundColor: Colors.blueAccent,
        onTap: (index) {
          pro.set_currentIndex(index);
        },
        items: [
          Icon(Icons.lock_clock, size: 30.sp, color: Colors.white),
          Icon(Icons.punch_clock, size: 30.sp, color: Colors.white),
        ],
      ),
    );
  }
}
