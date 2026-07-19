import 'dart:math';

import 'package:flutter/material.dart';

/// Minimal placeholder for the `User` model used in this widget.
/// In the real project this would be replaced by the actual implementation.
class User {}

/// Enum representing the direction of rotation.
enum RotationDirection { clockwise, anticlockwise }

extension _RotationDirectionExtension on RotationDirection {
  bool get isClockwise => this == RotationDirection.clockwise;
}

/// Placeholder for the `DottedCircle` widget. It only needs to accept a
/// `height` parameter to satisfy the type checker.
class DottedCircle extends StatelessWidget {
  final double height;

  const DottedCircle({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox();
}

/// Placeholder for the `UserAvatar` widget. It receives a [User] and builds
/// a simple widget; the actual UI is defined elsewhere in the project.
class UserAvatar extends StatelessWidget {
  final User user;

  const UserAvatar({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox();
}

class RotatingDottedCircle extends StatefulWidget {
  final double height;
  final RotationDirection rotationDirection;
  final List<User> users;

  const RotatingDottedCircle({
    Key? key,
    required this.height,
    this.rotationDirection = RotationDirection.clockwise,
    required this.users,
  }) : super(key: key);

  @override
  State<RotatingDottedCircle> createState() => _RotatingDottedCircleState();
}

class _RotatingDottedCircleState extends State<RotatingDottedCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController roatationController;
  late final Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();
    roatationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    rotationAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(roatationController);
    roatationController.repeat(reverse: false);
  }

  @override
  void dispose() {
    roatationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rotationAnimation,
      builder: (_, child) {
        final angle = widget.rotationDirection.isClockwise
            ? rotationAnimation.value
            : -rotationAnimation.value;
        return Transform.rotate(
          angle: angle,
          child: Stack(
            alignment: Alignment.center,
            children: [
              child!,
              ...getUserAvatarWidgetList(angle),
            ],
          ),
        );
      },
      child: IgnorePointer(
        child: DottedCircle(
          height: widget.height,
        ),
      ),
    );
  }

  List<Widget> getUserAvatarWidgetList(double avatarRotationAngle) {
    final List<Offset> offsetList = [];
    final double circleRadius = widget.height / 2;
    final double angle = 2 * pi / widget.users.length;
    for (int userIndex = 0; userIndex < widget.users.length; userIndex++) {
      offsetList.add(Offset(
        circleRadius * sin(userIndex * angle),
        circleRadius * cos(userIndex * angle),
      ));
    }

    return List.generate(widget.users.length, (index) {
      final currentUser = widget.users[index];
      return SizedBox(
        height: MediaQuery.of(context).size.height / 2 + 25,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Transform.translate(
            offset: offsetList[index],
            child: Transform.rotate(
              angle: -avatarRotationAngle,
              child: DraggableUserWidget(
                currentUser: currentUser,
                circleRadius: circleRadius,
                circleRotationAngle: avatarRotationAngle,
              ),
            ),
          ),
        ),
      );
    });
  }
}

class DraggableUserWidget extends StatefulWidget {
  final User currentUser;
  final double circleRadius;
  final double circleRotationAngle;

  const DraggableUserWidget({
    Key? key,
    required this.currentUser,
    required this.circleRadius,
    required this.circleRotationAngle,
  }) : super(key: key);

  @override
  _DraggableUserWidgetState createState() => _DraggableUserWidgetState();
}

class _DraggableUserWidgetState extends State<DraggableUserWidget>
    with SingleTickerProviderStateMixin {
  late Offset _offset;

  late final AnimationController draggablePositionController;
  late Animation<Offset> draggableAnimation;

  @override
  void initState() {
    super.initState();
    _offset = Offset.zero;
    draggablePositionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    draggablePositionController.addListener(() {
      setState(() {
        _offset = draggableAnimation.value;
      });
    });
  }

  void takeUserWidgetBackToItsPosition() {
    final Offset beginFrom = _offset;

    draggableAnimation = Tween<Offset>(begin: beginFrom, end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: draggablePositionController,
        curve: Curves.easeOutCirc,
      ),
    );
    draggablePositionController.reset();
    draggablePositionController.forward();
  }

  @override
  void dispose() {
    draggablePositionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _offset,
      child: Draggable<User>(
        data: widget.currentUser,
        child: UserAvatar(user: widget.currentUser),
        onDragStarted: () {
          // No-op
        },
        onDragUpdate: (details) {
          setState(() {
            _offset += details.delta;
          });
        },
        onDragEnd: (_) {
          takeUserWidgetBackToItsPosition();
        },
        onDraggableCanceled: (velocity, offset) {
          // No-op
        },
        feedback: UserAvatar(user: widget.currentUser).scale(1.1),
        childWhenDragging: const SizedBox(),
      ),
    );
  }
}

extension GD on Widget {
  Widget scale(double scale) => Transform.scale(
        scale: scale,
        child: this,
      );
}