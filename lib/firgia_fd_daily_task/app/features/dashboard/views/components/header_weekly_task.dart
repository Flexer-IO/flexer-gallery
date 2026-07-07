import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default styling; adjust as needed to match original implementation.
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class HeaderWeeklyTask extends StatelessWidget {
  const HeaderWeeklyTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HeaderText("Weekly Task"),
        const Spacer(),
        _buildArchive(),
        const SizedBox(width: 10),
        _buildAddNewButton(),
      ],
    );
  }

  Widget _buildAddNewButton() {
    return ElevatedButton.icon(
      icon: const Icon(
        EvaIcons.plus,
        size: 16,
      ),
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      label: const Text("New"),
    );
  }

  Widget _buildArchive() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      child: const Text("Archive"),
    );
  }
}