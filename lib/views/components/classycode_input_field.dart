import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customInputField({
  required double width,
  required IconData icon,
  required TextEditingController controller,
  required String labelText,
  bool obscureText = false,
  Color iconColor = const Color(0xFFB8DBD9),
  Color fieldColor = const Color(0xFF2F4550),
  Color textColor = Colors.white,
  Color labelColor = const Color(0xFFB8DBD9),
}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: fieldColor,
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.jetBrainsMono(
              color: textColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: labelText,
              labelStyle: GoogleFonts.jetBrainsMono(
                color: labelColor,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
