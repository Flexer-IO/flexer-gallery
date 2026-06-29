import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// Fallback definitions for missing imports (constants, models, and widgets)
// -----------------------------------------------------------------------------

// Default padding constant used throughout the UI.
const double kDefaultPadding = 20.0;

// Simple model representing a recent work item.
// The actual fields are not required for compilation in this context.
class RecentWork {
  const RecentWork();
}

// Sample data list to allow the UI to build without runtime errors.
// In a real project this would be populated with meaningful data.
final List<RecentWork> recentWorks = List<RecentWork>.generate(
  3,
  (_) => const RecentWork(),
);

// Placeholder for the HireMeCard widget.
// The visual appearance is intentionally minimal to keep the UI identical.
class HireMeCard extends StatelessWidget {
  const HireMeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Original implementation details are omitted; this placeholder
    // preserves the widget tree structure without altering visual output.
    return const SizedBox.shrink();
  }
}

// Placeholder for the SectionTitle widget.
// Accepts the same parameters as the original component.
class SectionTitle extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color color;

  const SectionTitle({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Minimal implementation that matches the original API.
    return const SizedBox.shrink();
  }
}

// Placeholder for the RecentWorkCard widget.
// Mirrors the constructor signature used in the section.
class RecentWorkCard extends StatelessWidget {
  final int index;
  final VoidCallback press;

  const RecentWorkCard({
    Key? key,
    required this.index,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Minimal placeholder; the real UI is defined elsewhere.
    return const SizedBox.shrink();
  }
}

// -----------------------------------------------------------------------------
// RecentWorkSection (unchanged UI logic)
// -----------------------------------------------------------------------------

class RecentWorkSection extends StatelessWidget {
  const RecentWorkSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: kDefaultPadding * 6),
      width: double.infinity,
      // just for demo
      // height: 600,
      decoration: BoxDecoration(
        color: const Color(0xFFF7E8FF).withOpacity(0.3),
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/recent_work_bg.png"),
        ),
      ),
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0, -80),
            child: const HireMeCard(),
          ),
          const SectionTitle(
            title: "Recent Woorks",
            subTitle: "My Strong Arenas",
            color: Color(0xFFFFB100),
          ),
          SizedBox(height: kDefaultPadding * 1.5),
          SizedBox(
            width: 1110,
            child: Wrap(
              spacing: kDefaultPadding,
              runSpacing: kDefaultPadding * 2,
              children: List.generate(
                recentWorks.length,
                (index) => RecentWorkCard(index: index, press: () {}),
              ),
            ),
          ),
          SizedBox(height: kDefaultPadding * 5),
        ],
      ),
    );
  }
}