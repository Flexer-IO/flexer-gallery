import 'item.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({
    required this.isInTabletLayout,
    this.item,
    super.key,
  });

  final bool isInTabletLayout;
  final Item? item;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item?.title ?? 'No item selected!',
          style: textTheme.headlineSmall,
        ),
        Text(
          item?.subtitle ?? 'Please select one on the left.',
          style: textTheme.titleMedium,
        ),
      ],
    );

    if (isInTabletLayout) {
      return Center(child: content);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(item?.title ?? ''),
      ),
      body: Center(child: content),
    );
  }
}