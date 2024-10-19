// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:classy_code/views/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final String fileName;
  final String language;
  final DateTime dateTime;
  final VoidCallback onDelete;
  final Map<String, String> languageIconPaths = {
    'dart': 'lib/images/dart_logo.png',
    'java': 'lib/images/java_logo.png',
    'javascript': 'lib/images/javascript_logo.png',
    'python': 'lib/images/python_logo.png'
  };

  HistoryCard({
    super.key, 
    required this.fileName,
    required this.language,
    required this.dateTime,
    required this.onDelete,
  });

  double screenDiagonal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }

  final greybg = Color(0xFF202124);

  @override
  Widget build(BuildContext context) {
    final String date = DateFormat('MM-dd-yy').format(dateTime);
    final String time = DateFormat('h:mm a').format(dateTime);

    return Container(
      height: screenDiagonal(context) * 0.5,
      padding: EdgeInsets.only(top: 5, bottom: 5),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Image.asset(
                    languageIconPaths[language]!,
                    height: screenDiagonal(context) * 0.03,
                    width: screenDiagonal(context) * 0.03,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                        fileName.length <= 12 ? fileName : "${fileName.substring(0, 9)}...",
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: screenDiagonal(context) * 0.007,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: customText(
                          text: date,
                          fontSize: screenDiagonal(context) * 0.006,
                          isBold: false,
                          color: Colors.white54,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: customText(
                          text: time,
                          fontSize: screenDiagonal(context) * 0.006,
                          isBold: false,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Delete button on the right
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  //size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
