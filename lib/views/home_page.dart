import 'dart:io';
import 'package:classy_code/img_code_converter.dart';
import 'package:classy_code/input_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_viewer/markdown_viewer.dart';
import 'package:flutter_prism/flutter_prism.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLanguage = 'Select Language';
  final InputManager inputManager = InputManager();
  final ImageToCodeConverter converter = ImageToCodeConverter();
  File? _selectedFile;
  String generatedCode = "";

  void _pickFile() async {
    File? file = await inputManager.uploadInput();
    bool isValid = await inputManager.verifyInput(file);

    if (file != null) {
      if (isValid == false) {
        // show an alert dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid File'),
              content: Text('The selected file is not a class diagram.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          _selectedFile = file;
        });
      }

      // Upload the selected file
    } else {
      // User canceled the file picking
    }
  }

  void generate() async {
    if (selectedLanguage != "Select Language") {
      String? code = await converter.convert(_selectedFile!, selectedLanguage);
      print(code ?? '');
      setState(() {
        generatedCode = code!;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Language'),
            content: Text('Please select a language first.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {}, // Implement user icon button action
            ),
            Text(
              'ClassyCode',
              style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {}, // Implement user icon button action
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {}, // Implement menu icon button action
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 700,
                  width: 900,
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
                      if (_selectedFile != null)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              _selectedFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: _selectedFile != null ? 20.0 : null,
                        right: _selectedFile != null ? 20.0 : null,
                        child: Material(
                          color: Color(0xFF31363F),
                          borderRadius: BorderRadius.circular(50),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: _pickFile,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Icon(
                                Icons.add,
                                size: 60,
                                color: Color(0xFFB8DBD9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_selectedFile == null)
                        Positioned(
                          top: 420.0,
                          child: Text(
                            'Upload Class Diagram',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB8DBD9),
                              fontFamily:
                                  GoogleFonts.jetBrainsMono().fontFamily,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GenerateButton(onPressed: generate),
                    ),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedLanguage,
                      dropdownColor: const Color.fromARGB(255, 28, 28, 28),
                      items: languages
                          .map((lang) => DropdownMenuItem(
                                value: lang,
                                child: Text(
                                  lang,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.jetBrainsMono().fontFamily,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedLanguage = value!),
                    ),
                  ],
                ),
              ],
            ),
          ),
          VerticalDivider(thickness: 1),
          Expanded(
            child: GeneratedCodeSection(generatedCode: generatedCode,),
          ),
        ],
      ),
    );
  }
}

class GenerateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GenerateButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          'GENERATE',
          style: TextStyle(
            color: Color(0xFF31363F),
            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 50),
          backgroundColor: Color(0xFFB8DBD9),
        ),
      ),
    );
  }
}

class GeneratedCodeSection extends StatefulWidget {
  final String generatedCode;

  const GeneratedCodeSection({Key? key, required this.generatedCode}) : super(key: key);

  @override
  _GeneratedCodeSectionState createState() => _GeneratedCodeSectionState();
}

class _GeneratedCodeSectionState extends State<GeneratedCodeSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
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
                    icon: Icon(Icons.copy, color: Colors.white),
                    onPressed: () {}, // Implement code copy functionality
                  ),
                  IconButton(
                    icon: Icon(Icons.save, color: Colors.white),
                    onPressed: () {}, // Implement code save functionality
                  ),
                ],
              ),
            ],
          ),
          widget.generatedCode != ""
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
                        fontSize: 14,
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
              : Text(
                  'This section will display the generated code',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                  ),
                ),
        ],
      ),
    );
  }
}

// Replace with a list of actual supported languages
final languages = ['Select Language', 'Dart', 'Python', 'Java'];
