import 'package:flutter/material.dart';
import 'package:abuanwar072_protfolio_website_flutter_web/components/section_title.dart';
import 'package:abuanwar072_protfolio_website_flutter_web/constants.dart';
import 'package:abuanwar072_protfolio_website_flutter_web/models/feedback.dart';
import 'package:abuanwar072_protfolio_website_flutter_web/components/feedback_card.dart';

class FeedbackSection extends StatelessWidget {
  const FeedbackSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding * 2.5),
      constraints: const BoxConstraints(maxWidth: 1110),
      child: Column(
        children: [
          SectionTitle(
            title: "Feedback Received",
            subTitle: "Client’s testimonials that inspired me a lot",
            color: const Color(0xFF00B1FF),
          ),
          const SizedBox(height: kDefaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              feedbacks.length,
              (index) => FeedbackCard(index: index),
            ),
          ),
        ],
      ),
    );
  }
}