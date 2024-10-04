// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:classy_code/controllers/history_controller.dart';
import 'package:classy_code/img_code_converter.dart';
import 'package:classy_code/input_manager.dart';
import 'package:classy_code/models/insight_data.dart';
import 'package:classy_code/output_manager.dart';
import 'package:classy_code/views/components/generate_button.dart';
import 'package:classy_code/views/components/generated_code_section.dart';
import 'package:classy_code/views/components/loading_overlay.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  final HistoryController historyController = HistoryController();
  File? _selectedFile;
  String generatedCode = "";
  int totalClasses = 0;
  int totalRelationships = 0;
  Map<String, double> typesOfRelationships = {};
  bool _isUploading = false;
  bool _isGenerating = false;
  String userEmail = '';
  bool _isHovering = false;
  bool _isHoveringLogout = false;
  final List<String> historyItems = [
    'ashley moriah',
    'mikka ellazxczxcZxczxczxc Zxc ZxdvasdvSzdvs',
    'kb',
    'ashley moriah',
    'mikka ella',
    'kb',
    'ashley moriah',
    'mikka ella',
    'kb',
  ];

  String? selectedValue;

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

      final RegExp codeBlockRegExp = RegExp(r'```(\w+)\n([\s\S]*?)```');
      final match = codeBlockRegExp.firstMatch(code!);
      if (match == null) {
        print('Invalid code block format');
        return;
      }

      String language = match.group(1)!;
      language = language.trim();
      print(language);

      String codeContent = code!;
      List<String> codeLines = codeContent.split('\n');

      if (codeLines.length > 2) {
        codeLines.removeAt(0);
        codeLines.removeAt(codeLines.length - 1);
      }

      codeContent = codeLines.join('\n');

      print('printing from generate: ');
      print(codeContent);

      String extension = '';

      switch (language) {
        case 'python':
          extension = 'py';
        case 'dart':
          extension = 'dart';
        case 'javascript':
          extension = 'js';
        case 'java':
          extension = 'java';
        // case 'csharp':
        //   return 'cs';
        // Add more languages and their extensions as needed
        default:
          extension = 'txt';
      }

      print('Extension: $extension');

      String codeFileName = 'code.$extension';
      File codeFile = File(codeFileName);
      await codeFile.writeAsString(codeContent);
      print('File created: ${codeFile.path}');

      InsightsData insightsData =
          await converter.extractInsights(_selectedFile!);

      try {
        String? result = await HistoryController.createHistoryItem(
            FirebaseAuth.instance.currentUser!.uid,
            codeFile,
            _selectedFile,
            insightsData,
            language);
      } on Exception catch (e) {
        print('Error creating history item: $e');
      }

      if (await codeFile.exists()) {
        await codeFile.delete();
      }

      setState(() {
        generatedCode = code ?? '';
        totalClasses = insightsData.totalClasses;
        totalRelationships = insightsData.totalRelationships;
        typesOfRelationships = insightsData.typesOfRelationships;
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
              title: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Color(0xFF202124),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'History',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.jetBrainsMono().fontFamily,
                                    fontSize: 20,
                                  ),
                                ),
                                items: historyItems
                                    .map((String value) =>
                                        DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily:
                                                  GoogleFonts.jetBrainsMono()
                                                      .fontFamily,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    //selectedValue = value;
                                  });
                                },
                                dropdownStyleData: DropdownStyleData(
                                    maxHeight: 300,
                                    width: 300,
                                    offset: Offset(0, -8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[850],
                                      borderRadius: BorderRadius.circular(8.0),
                                    )),
                                buttonStyleData: ButtonStyleData(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 150,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print('hello');
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF202124)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              elevation: MaterialStateProperty.all(0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 1, right: 1),
                              child: Icon(
                                Icons.restart_alt,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          )
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
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.asset(
                            'lib/images/logo_dark.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'ClassyCode',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily:
                                  GoogleFonts.jetBrainsMono().fontFamily,
                              fontSize: 25,
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: PopupMenuButton<String>(
                      elevation: 0,
                      offset: Offset(0, 60),
                      icon: Icon(Icons.account_circle,
                          color: _isHovering || _isHoveringLogout
                              ? Colors.grey
                              : Colors.white),
                      iconSize: 45,
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
                                  ? Colors.red
                                  : Colors
                                      .grey, // Change color when hovered or clicked
                              fontFamily:
                                  GoogleFonts.jetBrainsMono().fontFamily,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 17.0,
                        right: 15.0,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.7, // Responsive height
                        width: MediaQuery.of(context).size.width *
                            0.8, // Responsive width
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
                                top: MediaQuery.of(context).size.height * 0.42,
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
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GenerateButton(onPressed: generate),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.001,
                        ),
                        SizedBox(
                          width: 200,
                          child: DropdownButton<String>(
                            value: selectedLanguage,
                            isExpanded: true,
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
                        ),
                      ],
                    ),
                  ],
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
