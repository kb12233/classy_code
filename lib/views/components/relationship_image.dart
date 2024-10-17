
import 'package:classy_code/views/components/custom_text.dart';
import 'package:flutter/material.dart';

Widget relationshipImage(String text, String imagePath, bool isContained) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Spread space between text and image
      children: [
        SizedBox(width: 20),
        Expanded(
          child: customText(
            text: "- $text",
            fontSize: 12,
            isBold: false,
            color: isContained ? Colors.white : Colors.white24,
            // style: const TextStyle(
            //   fontSize: 14,
            //   color: Colors.white, // Set the text color to white
            //   fontFamily: 'RobotoMono',
            // ),
          ),
        ),
        Image.asset(
          imagePath,
          width: 100,
        ),
        SizedBox(width: 20),
      ],
    );
  }