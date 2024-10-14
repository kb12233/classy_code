// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:classy_code/views/components/classycode_custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final String imagePath;
  final DateTime dateTime;
  final VoidCallback onDelete;

  HistoryCard({
    required this.imagePath,
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
      padding: EdgeInsets.only(bottom: 5),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: greybg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  height: screenDiagonal(context) * 0.03,
                  width: screenDiagonal(context) * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: customText(
                        text: date,
                        fontSize: screenDiagonal(context) * 0.009,
                        isBold: false,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: customText(
                        text: time,
                        fontSize: screenDiagonal(context) * 0.008,
                        isBold: false,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Delete button on the right
            Padding(
              padding: EdgeInsets.only(bottom: 10), // Align icon vertically
              child: IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
