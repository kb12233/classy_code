import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoWithText extends StatelessWidget {
  final String imagePath;
  final Color textColor;

  LogoWithText({
    Key? key,
    this.imagePath = 'lib/images/logo_light.png', // Default image path
    this.textColor = Colors.white, // Default text color
  }) : super(key: key);

  double screenDiagonal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: screenDiagonal(context) * 0.055,
          height: screenDiagonal(context) * 0.030,
        ),
        Text(
          "ClassyCode",
          style: GoogleFonts.jetBrainsMono(
            color: textColor,
            fontSize: screenDiagonal(context) * 0.015,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
