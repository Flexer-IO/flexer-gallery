import 'package:flutter/material.dart';
import 'deps/flutter_svg/flutter_svg.dart';

class TimeAndTemp extends StatelessWidget {
  const TimeAndTemp({
    Key? key,
    required this.constraints,
  }) : super(key: key);

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: constraints.maxWidth * 0.21,
      height: constraints.maxHeight * 0.11,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleMedium!,
        child: Row(
          children: [
            const Text("05:21 PM"),
            const Spacer(),
            SvgPicture.asset(
              "packages/showcase_library/assets/abuanwar072_ev_car_dashboard_flutter/icons/sun.svg",
              height: 32,
            ),
            const SizedBox(width: 4),
            const Text("18 °C"),
          ],
        ),
      ),
    );
  }
}
