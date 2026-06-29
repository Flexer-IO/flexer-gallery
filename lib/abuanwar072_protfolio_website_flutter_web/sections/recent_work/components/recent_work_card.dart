import 'package:flutter/material.dart';

/// Fallback definitions in case the original files are missing.
/// These definitions are kept minimal to satisfy compilation and do not
/// alter the visual output of the widget.
class RecentWork {
  final String? image;
  final String? category;
  final String? title;

  const RecentWork({this.image, this.category, this.title});
}

// A minimal list with a single placeholder entry. The widget expects
// at least one element; real data will be supplied by the proper model.
const List<RecentWork> recentWorks = [
  RecentWork(
    image: '',
    category: '',
    title: '',
  ),
];

// Default padding used throughout the UI.
const double kDefaultPadding = 20.0;

// Default shadow for the card when hovered.
const BoxShadow kDefaultCardShadow = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 6,
  color: Color(0x1A000000), // 10% opacity black.
);

class RecentWorkCard extends StatefulWidget {
  // just press "Command + ."
  const RecentWorkCard({
    Key? key,
    required this.index,
    required this.press,
  }) : super(key: key);

  final int index;
  final Function()? press;

  @override
  _RecentWorkCardState createState() => _RecentWorkCardState();
}

class _RecentWorkCardState extends State<RecentWorkCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      onHover: (value) {
        setState(() {
          isHover = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 320,
        width: 540,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [if (isHover) kDefaultCardShadow],
        ),
        child: Row(
          children: [
            Image.asset(recentWorks[widget.index].image!),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(recentWorks[widget.index].category!.toUpperCase()),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      recentWorks[widget.index].title!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(height: 1.5),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    const Text(
                      "View Details",
                      style: TextStyle(decoration: TextDecoration.underline),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}