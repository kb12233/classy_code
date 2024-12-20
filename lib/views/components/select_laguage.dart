import 'dart:math';

import 'package:classy_code/state_manager/state_controller.dart';
import 'package:classy_code/views/components/custom_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectLanguage extends StatefulWidget {
  final String selectedLanguage;
  final List<String> languages;
  final Function(String?) onLanguageChanged;

  const SelectLanguage({
    Key? key,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  final bgColor = const Color(0xFF202124);

  double screenDiagonal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<StateController>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Container(
        width: screenDiagonal(context) * 0.15,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              hint: customText(
                  text: 'Select Language',
                  fontSize: screenDiagonal(context) * 0.011,
                  isBold: false,
                  color: Colors.white),
              dropdownStyleData: DropdownStyleData(
                padding: const EdgeInsets.only(left: 15, right: 20),
                maxHeight: screenDiagonal(context) * 0.2,
                width: screenDiagonal(context) * 0.15,
                offset: const Offset(-10, 300),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              value: notifier.selectedLanguage,
              isExpanded: true,
              items: notifier.selectedFile != null 
                ? widget.languages
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: customText(
                            text: lang,
                            fontSize: screenDiagonal(context) * 0.011,
                            isBold: false,
                            color: Colors.white),
                      ))
                  .toList()
                : [],
              onChanged: (value) => widget.onLanguageChanged(value),
            ),
          ),
        ),
      ),
    );
  }
}
