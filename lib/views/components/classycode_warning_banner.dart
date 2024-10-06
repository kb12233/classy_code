import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WarningBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color textColor;
  final double iconSizeFactor;
  final double textSizeFactor;

  // Constructor for the reusable banner
  WarningBanner({
    Key? key,
    this.icon = Icons.error_outline,
    required this.message,
    this.textColor = Colors.white,
    this.iconSizeFactor = 0.009,
    this.textSizeFactor = 0.007,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.025,
        width: MediaQuery.of(context).size.width * 0.250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                icon,
                color: textColor,
                size: MediaQuery.of(context).size.width * iconSizeFactor,
              ),
            ),
            Text(
              message,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * textSizeFactor,
                color: textColor,
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
