import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  required IconData icon,
  required Color bgColor,
  required Color iconColor,
  required Color textColor,
}) {
  return AlertDialog(
    backgroundColor: bgColor,
    icon: Icon(
      icon,
      color: iconColor,
    ),
    title: Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: 20,
        fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
      ),
    ),
    content: Text(
      message,
      style: TextStyle(
        color: textColor,
        fontSize: 20,
        fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
      ),
    ),
  );
}
