import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenerateButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;

  const GenerateButton({Key? key, required this.onPressed, this.isEnabled = true}) : super(key: key);

  final otherColor = const Color(0xFFB8DBD9);
  final otherColor1 = const Color(0xFF31363F);
  
  final otherColorDisabled = const Color.fromARGB(255, 134, 150, 150);
  final otherColor1Disabled = const Color.fromARGB(255, 118, 118, 118);

  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double screenDiagonal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenDiagonal(context) * 0.15,
      padding: EdgeInsets.all(20.0),
      child: AbsorbPointer(
        absorbing: !isEnabled,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : () {},
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            minimumSize:
                Size(screenWidth(context) * 0.15, screenHeight(context) * 0.05),
            backgroundColor: isEnabled ? otherColor : otherColorDisabled,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'GENERATE',
              style: TextStyle(
                color: isEnabled ? otherColor1 : otherColor1Disabled,
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                fontSize: screenDiagonal(context) * 0.013,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
