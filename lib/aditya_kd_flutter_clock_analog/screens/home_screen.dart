import 'package:flutter/material.dart';
import 'screens/components/body.dart';
import 'deps/flutter_svg/flutter_svg.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset(
          'packages/showcase_library/assets/aditya_kd_flutter_clock_analog/icons/Settings.svg',
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () {},
      ),
     
    );
  }
}