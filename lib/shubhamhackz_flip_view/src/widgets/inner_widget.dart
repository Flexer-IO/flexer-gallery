import 'package:flutter/material.dart';

class InnerWidget extends StatelessWidget {
  const InnerWidget({
    Key? key,
    required this.name,
    required this.tags,
    required this.backgroundColor,
  }) : super(key: key);

  final String name;
  final List<String> tags;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      color: backgroundColor,
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
          Wrap(
            runSpacing: 7.0,
            direction: Axis.horizontal,
            children: List.generate(
              tags.length,
              (index) => TagChip(
                tag: tags[index],
                width: width,
                height: height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  const TagChip({
    Key? key,
    required this.tag,
    required this.width,
    required this.height,
  }) : super(key: key);
  final String tag;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        margin: EdgeInsets.only(right: width * 0.018),
        padding: EdgeInsets.symmetric(
          vertical: height * 0.003,
          horizontal: width * 0.05,
        ),
        alignment: Alignment.center,
        decoration: const ShapeDecoration(
          color: Color(0xFF2a3131),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
        ),
        child: Text(
          tag,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}