import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isUploading;
  final bool isGenerating;

  LoadingOverlay(
      {required this.isUploading, required this.isGenerating});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 39, 211, 188)),
            ),
            SizedBox(height: 20),
            Text(
              isUploading
                  ? 'Uploading...'
                  : isGenerating
                      ? 'Generating code...'
                      : '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
