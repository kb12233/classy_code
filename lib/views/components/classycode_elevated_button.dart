import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customElevatedButton({
  required VoidCallback onPressed,
  required String text,
  required Color backgroundColor,
  required Size fixedSize,
  Color textColor = const Color(0xFFB8DBD9),
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      fixedSize: fixedSize,
    ),
    child: Text(
      text,
      style: GoogleFonts.jetBrainsMono(
        color: textColor,
      ),
    ),
  );
}
