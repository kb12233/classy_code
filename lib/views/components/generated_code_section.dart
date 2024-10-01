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
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
              fontSize: 20,
            ),
          ),
          SizedBox(height: 8.0),
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
                          color: Color(0xFF202124),
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
                              color: Color(0xFF202124),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFF202124),
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
                        color: Color(0xFF202124),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: Color(0xFF202124),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: Color(0xFF202124),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Generated Code',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                  fontSize: 20,
                ),
              ),
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
          SizedBox(height: 8.0),
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
                                color: Color(0xFF202124),
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
                              color: Color(0xFF202124),
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
