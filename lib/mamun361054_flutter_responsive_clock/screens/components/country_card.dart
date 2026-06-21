import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A simple utility class to provide responsive sizing based on the current
/// [MediaQuery] dimensions. It mimics the original `SizeConfig` that was
/// expected to be imported from the project. Call `SizeConfig.init(context)`
/// early in the widget tree (e.g., in the root widget's `build` method) to
/// populate the static fields.
class SizeConfig {
  static bool isPortrait = true;
  static double blockWidth = 0;
  static double blockHeight = 0;

  static void init(BuildContext context) {
    final media = MediaQuery.of(context);
    isPortrait = media.orientation == Orientation.portrait;
    final size = media.size;
    blockWidth = size.width / 100;
    blockHeight = size.height / 100;
  }
}

class CountryCard extends StatelessWidget {
  final String country;
  final String timeZone;
  final String iconSrc;
  final String time;
  final String period;

  const CountryCard({
    Key? key,
    required this.country,
    required this.timeZone,
    required this.iconSrc,
    required this.time,
    required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure SizeConfig is initialized. This call is cheap after the first
    // initialization because it only recomputes the same values.
    SizeConfig.init(context);

    return Container(
      width: SizeConfig.isPortrait
          ? SizeConfig.blockWidth * 60
          : SizeConfig.blockWidth * 100,
      height: SizeConfig.isPortrait
          ? SizeConfig.blockHeight * 20
          : SizeConfig.blockHeight * 15,
      padding: EdgeInsets.only(left: SizeConfig.blockWidth * 3),
      margin: EdgeInsets.only(bottom: SizeConfig.blockHeight),
      child: Container(
        padding: EdgeInsets.all(
          SizeConfig.isPortrait
              ? SizeConfig.blockHeight * 3
              : SizeConfig.blockHeight,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Theme.of(context).primaryIconTheme.color!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              country,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: SizeConfig.isPortrait
                        ? SizeConfig.blockHeight * 2.5
                        : SizeConfig.blockHeight * 1.5,
                  ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(timeZone),
            const Spacer(),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  iconSrc,
                  width: SizeConfig.isPortrait
                      ? SizeConfig.blockHeight * 4
                      : SizeConfig.blockHeight * 2,
                ),
                const Spacer(),
                Text(
                  time,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: SizeConfig.isPortrait
                            ? SizeConfig.blockHeight * 5
                            : SizeConfig.blockHeight * 3,
                      ),
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(period),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}