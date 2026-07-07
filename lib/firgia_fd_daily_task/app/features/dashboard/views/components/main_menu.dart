import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

/// Data model for a selection button.
class SelectionButtonData {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  final int? totalNotif;

  const SelectionButtonData({
    required this.activeIcon,
    required this.icon,
    required this.label,
    this.totalNotif,
  });
}

/// Simple placeholder widget for the selection button UI.
/// It renders a vertical list of tiles; tapping a tile triggers [onSelected].
class SelectionButton extends StatelessWidget {
  final List<SelectionButtonData> data;
  final void Function(int index, SelectionButtonData value) onSelected;

  const SelectionButton({
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return ListTile(
          leading: Icon(item.icon),
          title: Text(item.label),
          onTap: () => onSelected(index, item),
        );
      }).toList(),
    );
  }
}

// ignore: unused_element
class _MainMenu extends StatelessWidget {
  const _MainMenu({
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final void Function(int index, SelectionButtonData value) onSelected;

  @override
  Widget build(BuildContext context) {
    return SelectionButton(
      data: const [
        SelectionButtonData(
          activeIcon: EvaIcons.home,
          icon: EvaIcons.homeOutline,
          label: "Home",
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.bell,
          icon: EvaIcons.bellOutline,
          label: "Notifications",
          totalNotif: 100,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.checkmarkCircle2,
          icon: EvaIcons.checkmarkCircle,
          label: "Task",
          totalNotif: 20,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.settings,
          icon: EvaIcons.settingsOutline,
          label: "Settings",
        ),
      ],
      onSelected: onSelected,
    );
  }
}