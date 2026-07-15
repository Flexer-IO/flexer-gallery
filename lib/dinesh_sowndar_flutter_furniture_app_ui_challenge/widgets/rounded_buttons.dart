import 'package:flutter/material.dart';
import 'deps/google_fonts/google_fonts.dart';

class RoundedButtons extends StatelessWidget {
  const RoundedButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(110, 38),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              elevation: 0.5),
          onPressed: () {},
          child:  Text(
            'Add to Cart',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(110, 38),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              elevation: 0.5),
          onPressed: () {},
          child:  Text(
            'Buy Now',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
