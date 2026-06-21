import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/body.dart';
import '../size_config.dart';

/// Extension to provide the missing proportionate width method.
extension SizeConfigExtension on SizeConfig {
  /// Returns a width that is proportionate to the screen width.
  /// Uses a base width of 375.0 (common design reference).
  double getProportionateScreenWidth(double inputWidth) {
    // If SizeConfig defines a static screenWidth, use it; otherwise fall back
    // to MediaQuery via the WidgetsBinding instance.
    final double screenWidth = SizeConfig.screenWidth ??
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
    return (inputWidth / 375.0) * screenWidth;
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset(
          'packages/showcase_library/assets/mamun361054_flutter_responsive_clock/icons/Settings.svg',
        ),
        color: Theme.of(context).iconTheme.color,
        onPressed: () {},
      ),
      actions: <Widget>[buildAddButton(context)],
    );
  }

  Widget buildAddButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig().getProportionateScreenWidth(10.0),
      ),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: SizeConfig().getProportionateScreenWidth(32.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}