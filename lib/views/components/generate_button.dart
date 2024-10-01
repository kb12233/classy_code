import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenerateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GenerateButton({Key? key, required this.onPressed}) : super(key: key);

  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          //minimumSize: Size(150, 50),
          minimumSize:
              Size(screenWidth(context) * 0.15, screenHeight(context) * 0.05),
          backgroundColor: Color(0xFFB8DBD9),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        ),
        child: Text(
          'GENERATE',
          style: TextStyle(
            color: Color(0xFF31363F),
            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
