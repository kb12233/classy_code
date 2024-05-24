import 'dart:io';

import 'package:classy_code/img_code_converter.dart';
import 'package:classy_code/input_manager.dart';
import 'package:classy_code/output_manager.dart';
import 'package:classy_code/subsystems/output_management/save_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prism/flutter_prism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLanguage = 'Select Language';
  final InputManager inputManager = InputManager();
  final ImageToCodeConverter converter = ImageToCodeConverter();
  final OutPutManager outPutManager = OutPutManager();
  File? _selectedFile;
  String generatedCode = "";
  bool _isUploading = false;
  bool _isGenerating = false;
  String userEmail = '';
  bool _isHovering = false;
  bool _isHoveringLogout = false;

  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  void getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? '';
      });
    }
  }

  void _pickFile() async {
    File? file = await inputManager.uploadInput();

    if (file != null) {
      setState(() {
        _isUploading = true;
      });

      bool isValid = await inputManager.verifyInput(file);

      setState(() {
        _isUploading = false;
      });

      if (!isValid) {
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
    }
  }

  void generate() async {
    if (selectedLanguage != "Select Language") {
      setState(() {
        _isGenerating = true;
      });
      String? code;
      try {
        code = await converter.convert(_selectedFile!, selectedLanguage);
      } on Exception catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('CodeGenerationError'),
              content: Text(
                  'Oops! Encountered during code generation. Please try again. :)'),
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

      setState(() {
        generatedCode = code ?? '';
        _isGenerating = false;
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Adjust the height as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.black,
              leading: Padding(
                padding: const EdgeInsets.only(top: 15),
              ),
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.asset(
                      'lib/images/logo_dark.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  SizedBox(
                      width: 10), // Optional: add space between logo and text
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'ClassyCode',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHoveringLogout = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHoveringLogout = false;
                    });
                  },
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.account_circle,
                        color: _isHovering || _isHoveringLogout
                            ? Colors.grey
                            : Colors.white),
                    iconSize: 30,
                    color: Colors.black12,
                    onSelected: (String result) {
                      if (result == 'logout') {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value:
                            'user_email', // Changed value for the email entry
                        child: ListTile(
                          title: Text(
                            userEmail,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily:
                                  GoogleFonts.jetBrainsMono().fontFamily,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        mouseCursor: SystemMouseCursors.click,
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: _isHoveringLogout
                                ? Colors.white
                                : Colors
                                    .grey, // Change color when hovered or clicked
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 10.0, // Adjust the height of the bottom margin as needed
              color: Colors.black, // Same color as the AppBar to blend in
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 17.0,
                          top: 20.0,
                        ),
                        child: Text(
                          'Class Diagram',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              11.0 // Add some spacing between the header and the content
                          ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 17.0,
                          right: 15.0,
                        ),
                        child: SizedBox(
                          height: 650,
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
                                    child: InteractiveViewer(
                                      minScale: 0.5,
                                      maxScale: 10.0,
                                      child: Image.file(
                                        _selectedFile!,
                                        fit: BoxFit.contain,
                                      ),
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
                              if (_selectedFile == null && !_isUploading)
                                Positioned(
                                  top: 420.0,
                                  child: Text(
                                    'Upload Class Diagram',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB8DBD9),
                                      fontFamily: GoogleFonts.jetBrainsMono()
                                          .fontFamily,
                                    ),
                                  ),
                                ),
                            ],
                          ),
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
                            dropdownColor:
                                const Color.fromARGB(255, 28, 28, 28),
                            items: languages
                                .map((lang) => DropdownMenuItem(
                                      value: lang,
                                      child: Text(
                                        lang,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily:
                                              GoogleFonts.jetBrainsMono()
                                                  .fontFamily,
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
              ),
              VerticalDivider(
                thickness: 1,
                color: Colors.black,
              ),
              Expanded(
                child: GeneratedCodeSection(
                  generatedCode: generatedCode,
                  outPutManager: outPutManager,
                ),
              ),
            ],
          ),
          if (_isUploading || _isGenerating)
            LoadingOverlay(
                isUploading: _isUploading, isGenerating: _isGenerating),
        ],
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isUploading;
  final bool isGenerating;

  LoadingOverlay({required this.isUploading, required this.isGenerating});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 39, 211, 188)),
            ),
            SizedBox(height: 20),
            Text(
              isUploading
                  ? 'Uploading...'
                  : isGenerating
                      ? 'Generating code...'
                      : '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              ),
            ),
          ],
        ),
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
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    icon: Icon(Icons.save, color: Colors.white),
                    hoverColor: Colors.white10,
                    onPressed: () async {
                      await saveCode(context, widget.generatedCode);
                    }, // Implement code save functionality
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
              height: 8.0 // Add some spacing between the header and the content
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
              : SingleChildScrollView(
                  child: SizedBox(
                    height: 650,
                    width: 900,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF202124),
                          borderRadius: BorderRadius.circular(8.0)),
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

// Replace with a list of actual supported languages
final languages = ['Select Language', 'Dart', 'Python', 'Java', 'JavaScript'];
