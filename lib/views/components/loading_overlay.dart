import 'package:classy_code/views/components/custom_text.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isUploading;
  final bool isGenerating;
  final bool isSelectingHistoryItem;

  LoadingOverlay(
      {required this.isUploading,
      required this.isGenerating,
      required this.isSelectingHistoryItem});

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
            if (isUploading)
              customText(
                  text: 'Uploading...',
                  fontSize: 20,
                  isBold: false,
                  color: Colors.white),
            if (isGenerating)
              customText(
                  text: 'Generating Code...',
                  fontSize: 20,
                  isBold: false,
                  color: Colors.white),
            if (isSelectingHistoryItem)
              customText(
                  text: 'Loading History...',
                  fontSize: 20,
                  isBold: false,
                  color: Colors.white),
          ],
        ),
      ),
    );
  }
}