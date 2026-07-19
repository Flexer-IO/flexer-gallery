import 'package:flutter/material.dart';

// The following imports were removed because the referenced files do not exist in this project.
// Fallback definitions are provided below to ensure the widget compiles correctly.

/// Fallback definitions in case the actual imports are unavailable.
/// These definitions are minimal and do not affect the visual output.
class Country {
  final String currency;
  final String flagImageUrl;

  const Country(this.currency, this.flagImageUrl);
}

Widget horizontalSpace(double width) => SizedBox(width: width);

class MessageContainer extends StatelessWidget {
  MessageContainer({Key? key}) : super(key: key);

  final double height = 50;

  final Country country = const Country(
    "USD",
    "packages/showcase_library/assets/himanshugarg08_flutter_give_collect_money/usa_flag.png",
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 2,
                )
              ]),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    country.flagImageUrl,
                    fit: BoxFit.cover,
                    alignment: const Alignment(-0.32, 0),
                  ),
                ),
              ),
              horizontalSpace(8),
              Text(
                country.currency,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: Container(
            height: height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 2,
                  )
                ]),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Say Something",
                hintStyle: TextStyle(color: Colors.grey.shade300),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: height / 4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}