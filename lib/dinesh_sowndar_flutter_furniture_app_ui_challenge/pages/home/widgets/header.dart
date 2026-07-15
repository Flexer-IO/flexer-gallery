import 'package:flutter/material.dart';
import 'deps/google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: Image.asset(
              "packages/showcase_library/assets/dinesh_sowndar_flutter_furniture_app_ui_challenge/images/user.png",
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Decoration",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  height: 0.8,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "Room",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
