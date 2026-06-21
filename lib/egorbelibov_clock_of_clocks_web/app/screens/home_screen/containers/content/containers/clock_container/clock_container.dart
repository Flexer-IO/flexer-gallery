import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'styles.dart';
import '../../../../../../g_models/device_type.dart';

class ClockContainer extends StatefulWidget {
  const ClockContainer({Key? key}) : super(key: key);

  @override
  _ClockContainerState createState() => _ClockContainerState();
}

class _ClockContainerState extends State<ClockContainer> {
  ClockOfClocks? _clock;
  ClockLauncher? _clockLauncher;
  bool _launcherIsLoading = true;

  late DeviceType _deviceType;
  late double _deviceWidth;
  late double _deviceHeight;

  @override
  void initState() {
    super.initState();
    _updateDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return _buildClockContainer();
  }

  void _updateDeviceInfo() {
    _deviceType = _detectDeviceType();
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
  }

  DeviceType _detectDeviceType() {
    final width = MediaQuery.of(context).size.width;
    // Fallback logic; adjust thresholds as needed.
    if (width >= 1024) {
      return DeviceType.desktop;
    } else if (width >= 600) {
      // Tablet size not defined in DeviceType; treat as desktop.
      return DeviceType.desktop;
    } else {
      return DeviceType.mobile;
    }
  }

  Widget _buildClockContainer() {
    _clock ??= const ClockOfClocks();
    _clockLauncher ??= ClockLauncher(
      onFinished: () => setState(() => _launcherIsLoading = false),
    );

    return _transformedContainer(
      child: _decoratedScreenContainer(
        backgroundColor: const Color(0xFF000000),
        child: _animatedWidgetSwitcher(
          condition: _launcherIsLoading,
          from: _clockLauncher!,
          to: _clock!,
        ),
      ),
    );
  }

  Widget _animatedWidgetSwitcher({
    required bool condition,
    required Widget from,
    required Widget to,
  }) {
    assert(condition);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          child: child,
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutSine,
            ),
          ),
        );
      },
      child: condition ? from : to,
    );
  }

  Widget _decoratedScreenContainer({
    required Color backgroundColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: AspectRatio(
        aspectRatio: 5 / 3,
        child: child,
      ),
    );
  }

  Widget _transformedContainer({required Widget child}) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: clockContainerPadding(_deviceType),
        width: clockContainerWidth(_deviceType, _deviceWidth),
        height: clockContainerHeight(_deviceType, _deviceHeight),
        child: FittedBox(
          alignment: Alignment.bottomLeft,
          fit: BoxFit.contain,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 2000,
              height: 1439,
              padding: const EdgeInsets.only(
                left: 575,
                top: 315,
                bottom: 335,
                right: 185,
              ),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.skew(0.23, 0.20)
                  ..add(Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(-0.20)
                    ..rotateY(-0.25)
                    ..rotateZ(-0.25)),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder implementations for missing widgets.

class ClockOfClocks extends StatelessWidget {
  const ClockOfClocks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox();
}

class ClockLauncher extends StatelessWidget {
  final VoidCallback onFinished;

  const ClockLauncher({Key? key, required this.onFinished}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox();
}