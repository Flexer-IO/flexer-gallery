import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../size_config_two.dart';
import 'clock_painter.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfigTwo.blockWidth * 5),
          child: Container(
            width: SizeConfigTwo.isPortrait
                ? SizeConfigTwo.blockWidth * 80
                : SizeConfigTwo.blockWidth * 40,
            height: SizeConfigTwo.isPortrait
                ? SizeConfigTwo.blocHeight * 50
                : SizeConfigTwo.blocHeight * 20,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0.0, 0.0),
                  color: kShadowColor.withOpacity(0.14),
                  blurRadius: 64,
                )
              ],
            ),
            child: Transform.rotate(
              angle: -pi / 2,
              child: CustomPaint(
                painter: ClockPainter(context: context, dateTime: _dateTime),
              ),
            ),
          ),
        ),
        Positioned(
          top: 80.0,
          left: 0.0,
          right: 0.0,
          child: Consumer<dynamic>(
            builder: (context, theme, child) {
              return GestureDetector(
                onTap: () => theme.changeTheme(),
                child: SvgPicture.asset(
                  theme.isLightTheme
                      ? 'packages/showcase_library/assets/mamun361054_flutter_responsive_clock/icons/Sun.svg'
                      : 'packages/showcase_library/assets/mamun361054_flutter_responsive_clock/icons/Moon.svg',
                  height: 24.0,
                  width: 24.0,
                  color: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}