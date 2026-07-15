import 'package:flutter/material.dart';
import 'deps/flutter_svg/flutter_svg.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SvgPicture.asset(
          'packages/showcase_library/assets/dinesh_sowndar_flutter_furniture_app_ui_challenge/svg/back_arrow.svg',
          color: Colors.white,
        ),
      ),
    );
  }
}
