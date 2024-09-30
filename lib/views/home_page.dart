// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:classy_code/img_code_converter.dart';
import 'package:classy_code/input_manager.dart';
import 'package:classy_code/output_manager.dart';
import 'package:classy_code/views/components/generate_button.dart';
import 'package:classy_code/views/components/generated_code_section.dart';
import 'package:classy_code/views/components/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

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
        //preferredSize: Size.fromHeight(70.0), // Adjust the height as needed
        preferredSize: Size.fromHeight(screenHeight(context) * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.black,
              leading: Padding(
                padding: EdgeInsets.only(top: screenHeight(context) * 0.02),
              ),
              title: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: screenHeight(context) * 0.025),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // PopupMenuButton for History
                          PopupMenuButton<String>(
                            icon: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Keep the row tight around its content
                              children: [
                                Text(
                                  'History',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.jetBrainsMono().fontFamily,
                                    fontSize: screenWidth(context) * 0.01,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left:
                                          4.0), // Add space between text and icon
                                  child: Icon(
                                    Icons.arrow_drop_down, // Dropdown icon
                                    color: Colors.white,
                                    size: screenWidth(context) * 0.015,
                                  ),
                                ),
                              ],
                            ),
                            iconSize: 30,
                            color: Colors.grey[850],
                            onSelected: (String result) {
                              // Define what happens when a history item is selected
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              // Example history items
                              PopupMenuItem<String>(
                                value: 'History Item 1',
                                child: Text(
                                  'History Item 1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.jetBrainsMono().fontFamily,
                                  ),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'History Item 2',
                                child: Text(
                                  'History Item 2',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.jetBrainsMono().fontFamily,
                                  ),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'History Item 3',
                                child: Text(
                                  'History Item 3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.jetBrainsMono().fontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize
                          .min, // Keeps Row tight around its content
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight(context) * 0.02,
                              bottom: screenHeight(context) * 0.02),
                          child: Image.asset(
                            'lib/images/logo_dark.png',
                            width: screenWidth(context) * 0.08,
                            height: screenHeight(context) * 0.06,
                          ),
                        ),
                        // SizedBox(
                        //     width: screenWidth(context) *
                        //         0.0), // Optional: add space between logo and text
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'ClassyCode',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth(context) * 0.015,
                              fontFamily:
                                  GoogleFonts.jetBrainsMono().fontFamily,
                            ),
                          ),
                        ),
                      ],
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
                    icon: Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight(context) * 0.005,
                      ),
                      child: Icon(Icons.account_circle,
                          color: _isHovering || _isHoveringLogout
                              ? Colors.grey
                              : Colors.white),
                    ),
                    //iconSize: 30,
                    iconSize: screenWidth(context) * 0.025,
                    color: Colors.grey[850],
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
                              fontSize: screenWidth(context) * 0.01,
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
                                ? Colors.red
                                : Colors
                                    .grey, // Change color when hovered or clicked
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                            fontSize: screenWidth(context) * 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Container(
            //   height: 10.0, // Adjust the height of the bottom margin as needed
            //   color: Colors.white, // Same color as the AppBar to blend in
            // ),
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
                        padding: EdgeInsets.only(
                          //left: 17.0,
                          left: screenWidth(context) * 0.01,
                          top: screenHeight(context) * 0.02,
                          //top: 20.0,
                        ),
                        child: Text(
                          'Class Diagram',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                            fontSize: screenWidth(context) * 0.013,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth(context) * 0.01,
                        ),
                        child: SizedBox(
                          //height: 650,
                          height: screenHeight(context) * 0.8,
                          width: screenWidth(context) * 0.9,
                          //width: 900,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                //width: double.infinity,
                                width: screenWidth(context) * 0.65,
                                height: screenHeight(context) * 0.8,
                                //height: double.infinity,
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
                                bottom: _selectedFile != null
                                    ? screenHeight(context) * 0.01
                                    : null,
                                right: _selectedFile != null
                                    ? screenWidth(context) * 0.01
                                    : null,
                                child: Material(
                                  color: Color(0xFF31363F),
                                  borderRadius: BorderRadius.circular(50),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: _pickFile,
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          screenWidth(context) * 0.01),
                                      child: Icon(
                                        Icons.add,
                                        size: screenWidth(context) * 0.03,
                                        color: Color(0xFFB8DBD9),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (_selectedFile == null && !_isUploading)
                                Positioned(
                                  //top: 420.0,
                                  top: screenHeight(context) * 0.47,
                                  child: Text(
                                    'Upload Class Diagram',
                                    style: TextStyle(
                                      fontSize: screenWidth(context) * 0.01,
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

// Replace with a list of actual supported languages
final languages = ['Select Language', 'Dart', 'Python', 'Java', 'JavaScript'];
