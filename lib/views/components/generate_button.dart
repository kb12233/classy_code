import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenerateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GenerateButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          'GENERATE',
          style: TextStyle(
            color: Color(0xFF31363F),
            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 50),
          backgroundColor: Color(0xFFB8DBD9),
        ),
      ),
    );
  }
}
