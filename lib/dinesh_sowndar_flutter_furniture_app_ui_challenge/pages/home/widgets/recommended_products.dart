import 'package:flutter/material.dart';
import 'deps/flutter_svg/flutter_svg.dart';
import 'data.dart';
import 'pages/home/widgets/product_card.dart';
import 'deps/google_fonts/google_fonts.dart';

class RecommendedProducts extends StatelessWidget {
  const RecommendedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recommend",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              SvgPicture.asset(
                'packages/showcase_library/assets/dinesh_sowndar_flutter_furniture_app_ui_challenge/svg/right_arrow.svg',
                height: 18,
              )
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: recommendations.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return ProductCard(
                product: recommendations[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
