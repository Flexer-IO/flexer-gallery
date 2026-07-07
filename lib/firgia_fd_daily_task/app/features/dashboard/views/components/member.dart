import 'package:flutter/material.dart';
import 'deps/fd_daily_task/simple_user_profile.dart';

class _Member extends StatelessWidget {
  const _Member({
    required this.member,
    Key? key,
  }) : super(key: key);

  final List<String> member;
  static const int maxDisplayPeople = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        (member.length > maxDisplayPeople) ? maxDisplayPeople : member.length,
        (index) => SimpleUserProfile(
          name: member[index],
          onPressed: () {},
        ),
      ),
    );
  }
}