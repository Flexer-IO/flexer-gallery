import 'package:flutter/material.dart';
import '../models/user.dart';
import 'rotating_dotted_circle.dart' as rotating;

final GlobalKey revolvingWidgetKey = GlobalKey();

class RevolvingUserWidget extends StatefulWidget {
  const RevolvingUserWidget({Key? key}) : super(key: key);

  @override
  _RevolvingUserWidgetState createState() => _RevolvingUserWidgetState();
}

class _RevolvingUserWidgetState extends State<RevolvingUserWidget> {
  final double distanceBetweenDottedCircle = 140;
  final double smallestCircleHeight = 80;
  final double delta = 20;

  @override
  Widget build(BuildContext context) {
    final List<User> userList = UserList.users;
    return Stack(
      key: revolvingWidgetKey,
      alignment: Alignment.center,
      children: [
        rotating.RotatingDottedCircle(
          height: smallestCircleHeight +
              2 * delta +
              2 * distanceBetweenDottedCircle,
          users: userList.sublist(0, 4).cast<rotating.User>(),
        ),
        rotating.RotatingDottedCircle(
          height: smallestCircleHeight + delta + distanceBetweenDottedCircle,
          rotationDirection: rotating.RotationDirection.values[1],
          users: userList.sublist(4).cast<rotating.User>(),
        ),
        rotating.RotatingDottedCircle(
          height: smallestCircleHeight,
          users: const [],
        ),
      ],
    );
  }
}