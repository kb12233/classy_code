import 'dart:math';

import 'package:classy_code/views/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryBottom extends StatelessWidget {
  final DateTime dateGenerated;
  final DateTime timeGenerated;
  final String? language;
  final Color bgColor;

  const HistoryBottom({
    Key? key,
    required this.dateGenerated,
    required this.timeGenerated,
    required this.language,
    required this.bgColor,
  }) : super(key: key);

  double screenDiagonal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }

  @override
  Widget build(BuildContext context) {
    final String date = DateFormat('MM-dd-yy').format(dateGenerated);
    final String time = DateFormat('h:mm a').format(timeGenerated);
    final otherColor = const Color(0xFFB8DBD9);

    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0, top: 30.0),
      width: screenDiagonal(context) *  0.8,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SizedBox(width: 40),
          Row(
            children: [
              SizedBox(width: 10),
              customText(
              text: 'Date Generated: ',
              fontSize: 12,
              isBold: false,
              color: Colors.white,
              ),
              customText(
                text: date ?? 'N/A',
                fontSize: 12,
                isBold: false,
                color: otherColor,
              )
            ],
          ),
          // SizedBox(width: 70),
          Row(
            children: [
              customText(
                text: 'Time Generated: ',
                fontSize: 12,
                isBold: false,
                color: Colors.white,
              ),
              customText(
                text: time ?? 'N/A',
                fontSize: 12,
                isBold: false,
                color: otherColor,
              ),
            ],
          ),
          // SizedBox(width: 70),
          Row(
            children: [
              customText(
                text: 'Language used: ',
                fontSize: 12,
                isBold: false,
                color: Colors.white,
              ),
              customText(
                text: '${language?[0].toUpperCase()}${language?.substring(1)}' ?? 'N/A',
                fontSize: 12,
                isBold: false,
                color: otherColor,
              ),
              SizedBox(width: 10),
            ],
          ),
          // SizedBox(width: 50),
        ],
      ),
    );
  }
}
