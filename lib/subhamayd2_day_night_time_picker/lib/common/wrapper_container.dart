import 'package:flutter/material.dart';
import '../state/state_container.dart';

/// Just a simple [Container] with common styling
class WrapperContainer extends StatelessWidget {
  /// The child [Widget] to render
  final Widget child;

  /// Constructor for the [Widget]
  const WrapperContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final double height = timeState.widget.height;
    final Color backgroundColor = timeState.widget.backgroundColor;
    return Expanded(
      child: Container(
        height: height,
        color: backgroundColor,
        padding: timeState.widget.contentPadding,
        child: child,
      ),
    );
  }
}