import 'package:flutter/material.dart';
import '../../components/section_title.dart';
import '../../constants.dart';
import 'package:abuanwar072_protfolio_website_flutter_web/models/service.dart';
import 'package:abuanwar072_protfolio_website_flutter_web/data/services.dart';
import 'components/service_card.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding * 2),
      constraints: const BoxConstraints(maxWidth: 1110),
      child: Column(
        children: [
          SectionTitle(
            color: const Color(0xFFFF0000),
            title: "Service Offerings",
            subTitle: "My Strong Arenas",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                services.length, (index) => ServiceCard(index: index)),
          )
        ],
      ),
    );
  }
}