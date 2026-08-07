import 'package:flutter/material.dart';
import 'deps/flutter_svg/flutter_svg.dart';

class CarIndicators extends StatelessWidget {
  const CarIndicators({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          child: SvgPicture.asset(
            "packages/showcase_library/assets/abuanwar072_ev_car_dashboard_flutter/icons/left_indicator.svg",
            height: 32,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: SvgPicture.asset(
            "packages/showcase_library/assets/abuanwar072_ev_car_dashboard_flutter/icons/head_light.svg",
            height: 32,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: SvgPicture.asset(
            "packages/showcase_library/assets/abuanwar072_ev_car_dashboard_flutter/icons/dipper.svg",
            height: 32,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: SvgPicture.asset(
            "packages/showcase_library/assets/abuanwar072_ev_car_dashboard_flutter/icons/right_indicator.svg",
            height: 32,
          ),
        ),
      ],
    );
  }
}
