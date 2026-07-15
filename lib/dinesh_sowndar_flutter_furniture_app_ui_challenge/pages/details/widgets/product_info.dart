
import 'package:flutter/material.dart';
import 'deps/google_fonts/google_fonts.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text(
          "Bosnas Posna",
          style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
        Text(
          "Footstool with storage, Ransta",
          style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: 10,
        ),
         Text(
          "\$124",
          style: GoogleFonts.poppins(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
