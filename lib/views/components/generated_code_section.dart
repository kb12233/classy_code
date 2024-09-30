// ignore_for_file: prefer_const_constructors

import 'package:classy_code/output_manager.dart';
import 'package:classy_code/subsystems/output_management/save_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prism/flutter_prism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

class GeneratedCodeSection extends StatefulWidget {
  final String generatedCode;
  final OutPutManager outPutManager;

  const GeneratedCodeSection(
      {Key? key, required this.generatedCode, required this.outPutManager})
      : super(key: key);

  @override
  _GeneratedCodeSectionState createState() => _GeneratedCodeSectionState();
}

class _GeneratedCodeSectionState extends State<GeneratedCodeSection> {
  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Code Generation Insights',
            style: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              fontSize: screenWidth(context) * 0.013,
            ),
          ),
          SizedBox(
            height: screenHeight(context) * 0.01,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  // for insights ni
                  //height: 160,
                  height: screenHeight(context) * 0.2,
                  width: screenWidth(context) * 0.3,
                  //width: 445,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF202124),
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ),
              SizedBox(width: screenWidth(context) * 0.01),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      // for insights ni
                      //height: 75,
                      height: screenHeight(context) * 0.09,
                      width: double.infinity,
                      //width: 272,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF202124),
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.015,
                    ),
                    SizedBox(
                      // for insights ni
                      height: screenHeight(context) * 0.09,
                      //width: 272,
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF202124),
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight(context) * 0.01),
                child: Text(
                  'Generated Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                    fontSize: screenWidth(context) * 0.013,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight(context) * 0.01),
                    child: IconButton(
                      icon: Icon(Icons.save, color: Colors.white),
                      hoverColor: Colors.white10,
                      iconSize: screenWidth(context) * 0.015,
                      onPressed: () async {
                        await saveCode(context, widget.generatedCode);
                      }, // Implement code save functionality
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: screenHeight(context) * 0.001, // space
          ),
          widget.generatedCode.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    child: MarkdownViewer(
                      widget.generatedCode,
                      enableTaskList: true,
                      enableSuperscript: false,
                      enableSubscript: false,
                      enableFootnote: false,
                      enableImageSize: false,
                      enableKbd: false,
                      highlightBuilder: (text, language, infoString) {
                        final prism = Prism(
                          mouseCursor: SystemMouseCursors.text,
                          style: PrismStyle.dark(),
                        );
                        return prism.render(text, language ?? 'plain');
                      },
                      styleSheet: MarkdownStyle(
                        listItemMarkerTrailingSpace: 12,
                        codeSpan: TextStyle(
                          fontFamily: 'RobotoMono',
                        ),
                        codeBlock: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth(context) * 0.01,
                          letterSpacing: -0.3,
                          fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: Color(0xFF202124),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: SizedBox(
                    //height: 430,
                    height: screenHeight(context) * 0.54,
                    width: screenWidth(context) * 0.9,
                    //width: 900,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF202124),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> saveCode(BuildContext context, code) async {
    // Extract language and code
    final RegExp codeBlockRegExp = RegExp(r'```(\w+)\n([\s\S]*?)```');
    final match = codeBlockRegExp.firstMatch(code);
    if (match == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid code block format')),
      );
      return;
    }

    final language = match.group(1)!;
    print(language);

    final codeContent = match.group(2)!;

    SaveStatus? saveStatus =
        await widget.outPutManager.save(codeContent, language);
    String? outputPath = saveStatus.outputPath;

    if (outputPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File saved: $outputPath')),
      );
    }
  }
}
