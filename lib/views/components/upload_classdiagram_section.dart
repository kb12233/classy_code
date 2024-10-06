import 'dart:io';
import 'dart:math';

import 'package:classy_code/views/components/classycode_custom_text.dart';
import 'package:flutter/material.dart';

class UploadClassDiagramSection extends StatelessWidget {
  final File? selectedFile;
  final bool isUploading;
  final Function pickFile;

  final bgColor = const Color(0xFF202124);
  final btnColor = const Color(0xFF2F4550);
  final otherColor = const Color(0xFFB8DBD9);
  final otherColor1 = const Color(0xFF31363F);

  const UploadClassDiagramSection({
    Key? key,
    required this.selectedFile,
    required this.isUploading,
    required this.pickFile,
  }) : super(key: key);

  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double screenDiagonal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 17.0,
            top: 15.0,
          ),
          child: customText(
              text: 'Class Diagram',
              fontSize: screenDiagonal(context) * 0.011,
              isBold: false,
              color: Colors.white),
        ),
        SizedBox(height: screenHeight(context) * 0.008),
        Padding(
          padding: const EdgeInsets.only(
            left: 17.0,
            right: 15.0,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF202124),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                if (selectedFile != null)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 10.0,
                        child: Image.file(
                          selectedFile!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: selectedFile != null ? 20.0 : null,
                  right: selectedFile != null ? 20.0 : null,
                  child: Material(
                    color: Color(0xFF31363F),
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => pickFile(),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          Icons.add,
                          size: screenDiagonal(context) * 0.025,
                          color: otherColor,
                        ),
                      ),
                    ),
                  ),
                ),
                if (selectedFile == null && !isUploading)
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.42,
                    child: customText(
                        text: 'Upload a Class Diagram',
                        fontSize: screenDiagonal(context) * 0.01,
                        isBold: false,
                        color: otherColor),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
