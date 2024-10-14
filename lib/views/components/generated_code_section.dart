import 'dart:math';

import 'package:classy_code/output_manager.dart';
import 'package:classy_code/subsystems/output_management/save_status.dart';
import 'package:classy_code/views/components/custom_text.dart';
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

final bgColor = const Color(0xFF202124);

class _GeneratedCodeSectionState extends State<GeneratedCodeSection> {
  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double screenDiagonal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(right: 15.0, bottom: 15.0, top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
              text: 'Code Generation Insights',
              fontSize: screenDiagonal(context) * 0.011,
              isBold: false,
              color: Colors.white),
          SizedBox(height: screenHeight(context) * 0.008),
          LayoutBuilder(
            builder: (context, constraints) {
              // Adjust layout based on screen size
              if (screenWidth > 800) {
                // Wide layout for larger screens
                return Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Stacked layout for smaller screens
                return Column(
                  children: [
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: screenHeight(context) * 0.008),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                  text: 'Generated Code',
                  fontSize: screenDiagonal(context) * 0.011,
                  isBold: false,
                  color: Colors.white),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.save, color: Colors.white),
                    hoverColor: Colors.white10,
                    onPressed: () async {
                      await saveCode(context, widget.generatedCode);
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight(context) * 0.008),
          widget.generatedCode.isNotEmpty
              ? Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
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
                                fontSize: 14,
                                letterSpacing: -0.3,
                                fontFamily:
                                    GoogleFonts.jetBrainsMono().fontFamily,
                              ),
                              codeblockDecoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Container(
                            height: 430,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      );
                    },
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
