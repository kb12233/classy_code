import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customText({
  required String text,
  required double fontSize,
  required bool isBold,
  required Color color,
}) {
  return Text(
    text,
    style: GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color,
    ),
  );
}
