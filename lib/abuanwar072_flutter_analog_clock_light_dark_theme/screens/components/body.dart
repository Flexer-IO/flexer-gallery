import 'package:flutter/material.dart';

import 'clock.dart';
import 'country_card.dart';
import 'time_in_hour_and_minute.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              "Newport Beach, USA | PST",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const TimeInHourAndMinute(),
            const Spacer(),
            const Clock(),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CountryCard(
                      country: "New York, USA",
                      timeZone: "+3 HRS | EST",
                      iconSrc: "packages/showcase_library/assets/abuanwar072_flutter_analog_clock_light_dark_theme/icons/Liberty.svg",
                      time: "9:20",
                      period: "PM",
                    ),
                    CountryCard(
                      country: "Sydney, AU",
                      timeZone: "+19 HRS | AEST",
                      iconSrc: "packages/showcase_library/assets/abuanwar072_flutter_analog_clock_light_dark_theme/icons/Sydney.svg",
                      time: "1:20",
                      period: "AM",
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
