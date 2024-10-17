import 'dart:math';

import 'package:classy_code/output_manager.dart';
import 'package:classy_code/subsystems/output_management/save_status.dart';
import 'package:classy_code/views/components/custom_text.dart';
import 'package:classy_code/views/components/logo_with_text.dart';
import 'package:classy_code/views/components/relationship_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prism/flutter_prism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

class GeneratedCodeSection extends StatefulWidget {
  final String generatedCode;
  final OutPutManager outPutManager;
  final String numberOfClasses;
  final String numberOfRelationships;
  final List<String> typeOfRelationships;

  const GeneratedCodeSection(
      {Key? key,
      required this.generatedCode,
      required this.outPutManager,
      required this.numberOfClasses,
      required this.numberOfRelationships,
      required this.typeOfRelationships})
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
                  //relationships
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 8, right: 25, left: 25),
                        height: 200,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.start, // Align items at the top
                          children: [
                            const SizedBox(height: 3.5),
                            Align(
                              alignment: Alignment
                                  .centerLeft, // Align the text to the left
                              child: customText(
                                text: 'Relationships detected',
                                fontSize: 16,
                                color: Colors.white,
                                isBold: false,
                                // style: const TextStyle(
                                //   fontSize: 18,
                                //   color: Colors.white,
                                //   fontFamily: 'RobotoMono',
                                // ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            widget.typeOfRelationships.contains('inheritance')
                                ? relationshipImage('Inheritance',
                                    'lib/images/light_inheritance.png', true)
                                : relationshipImage('Inheritance',
                                    'lib/images/dark_inheritance.png', false),
                            const SizedBox(height: 5),
                            widget.typeOfRelationships.contains('aggregation')
                                ? relationshipImage('Aggregation',
                                    'lib/images/light_aggregation.png', true)
                                : relationshipImage('Aggregation',
                                    'lib/images/dark_aggregation.png', false),
                            const SizedBox(height: 5),
                            widget.typeOfRelationships.contains('composition')
                                ? relationshipImage('Composition',
                                    'lib/images/light_composition.png', true)
                                : relationshipImage('Composition',
                                    'lib/images/dark_composition.png', false),
                            const SizedBox(height: 5),
                            widget.typeOfRelationships.contains('association')
                                ? relationshipImage('Association',
                                    'lib/images/light_association.png', true)
                                : relationshipImage('Association',
                                    'lib/images/dark_association.png', false),
                            const SizedBox(height: 5),
                            widget.typeOfRelationships.contains('dependency')
                                ? relationshipImage('Dependency',
                                    'lib/images/light_dependency.png', true)
                                : relationshipImage('Dependency',
                                    'lib/images/dark_dependency.png', false),
                            const SizedBox(height: 5),
                            widget.typeOfRelationships.contains('realization')
                                ? relationshipImage('Realization',
                                    'lib/images/light_realization.png', true)
                                : relationshipImage('Realization',
                                    'lib/images/dark_realization.png', false),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          // First Container
                          Container(
                            padding: const EdgeInsets.only(
                                top: 15, right: 25, left: 25),
                            height: 95,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: customText(
                                    text: 'No. of Classes detected',
                                    fontSize: 14,
                                    color: Colors.white,
                                    isBold: false,
                                    // style: const TextStyle(
                                    //   fontSize: 18,
                                    //   color: Colors.white,
                                    //   fontFamily: 'RobotoMono',
                                    // ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text next to the class diagram icon
                                    customText(
                                      text: widget.numberOfClasses,
                                      fontSize: 35,
                                      color: Color(0xFFB8DBD9),
                                      isBold: true,
                                      // style: const TextStyle(
                                      //   fontSize: 35,
                                      //   color: Color(0xFFB8DBD9),
                                      //   fontFamily: 'RobotoMono',
                                      //   fontWeight: FontWeight.bold,
                                      // ),
                                    ),
                                    Image.asset(
                                      'lib/images/class_diagram_icon.png',
                                      height: 35,
                                      width: 35,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          // Second Container
                          Container(
                            padding: const EdgeInsets.only(
                                top: 15, right: 25, left: 25),
                            height: 95,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: customText(
                                    text: 'No. of Relationships',
                                    fontSize: 14,
                                    color: Colors.white,
                                    isBold: false,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    customText(
                                      text: widget.numberOfRelationships,
                                      fontSize: 35,
                                      color: Color(0xFFB8DBD9),
                                      isBold: true,
                                      // style: const TextStyle(
                                      //   fontSize: 35,
                                      //   color: Color(0xFFB8DBD9),
                                      //   fontFamily: 'RobotoMono',
                                      //   fontWeight: FontWeight.bold,
                                      // ),
                                    ),
                                    // Class diagram icon
                                    Image.asset(
                                      'lib/images/relationship_icon.png',
                                      height: 35,
                                      width: 35,
                                    ),
                                  ],
                                ),
                              ],
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
