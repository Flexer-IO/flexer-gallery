import 'package:flutter/material.dart';
import '../../../../../../../deps/fd_daily_task/widgets/simple_selection_button.dart';

class _TaskMenu extends StatelessWidget {
  const _TaskMenu({
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final void Function(int index, String label) onSelected;

  @override
  Widget build(BuildContext context) {
    return SimpleSelectionButton(
      data: const [
        "Directory",
        "Onboarding",
        "Offboarding",
        "Time-off",
      ],
      onSelected: onSelected,
    );
  }
}