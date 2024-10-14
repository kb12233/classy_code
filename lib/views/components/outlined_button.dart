import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customOutlinedButton({
  required VoidCallback onPressed,
  required Size minimumSize,
  required Color borderColor,
  required String text,
  required Color textColor,
}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: minimumSize,
      side: BorderSide(color: borderColor),
      textStyle: TextStyle(
        fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
      ),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
      ),
    ),
  );
}
