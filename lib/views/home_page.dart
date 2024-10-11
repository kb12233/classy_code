// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:classy_code/controllers/history_controller.dart';
import 'package:classy_code/img_code_converter.dart';
import 'package:classy_code/input_manager.dart';
import 'package:classy_code/models/history_model.dart';
import 'package:classy_code/models/insight_data.dart';
import 'package:classy_code/output_manager.dart';
import 'package:classy_code/views/components/appbar.dart';
import 'package:classy_code/views/components/classycode_warning_banner.dart';
import 'package:classy_code/views/components/generate_button.dart';
import 'package:classy_code/views/components/generated_code_section.dart';
import 'package:classy_code/views/components/loading_overlay.dart';
import 'package:classy_code/views/components/select_laguage.dart';
import 'package:classy_code/views/components/upload_classdiagram_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  // states
  File? _selectedFile;
  String generatedCode = "";
  int totalClasses = 0;
  int totalRelationships = 0;
  List<String> typesOfRelationships = [];
  bool _isUploading = false;
  bool _isGenerating = false;
  String userEmail = '';
  bool _isHovering = false;
  bool _isHoveringLogout = false;
  String? selectedValue;
  Stream<QuerySnapshot>? historyListStream;
  List<HistoryModel> historyList = [];

  final languages = ['Select Language', 'Dart', 'Python', 'Java', 'JavaScript'];
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

  @override
  void initState() {
    super.initState();
    getUserEmail();
    getHistoryList();
  }

  @override
  void dispose() {
    super.dispose();
    // check if firebase user is logged in, then log out
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
    }
  }

  void getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? '';
      });
    }
  }

  void getHistoryList() async {
    Stream<QuerySnapshot> historyItemList = HistoryController.getHistoryListStream(
        FirebaseAuth.instance.currentUser!.uid);

    if (await historyItemList.isEmpty) {
      debugPrint('No history items found');
    } else {
      debugPrint('History items found');
      await for (var historySnapshot in historyItemList) {
        for (var historyItem in historySnapshot.docs) {
          debugPrint(historyItem['dateTime'].toDate().toString());
        }
      }
    }

    QuerySnapshot historyItemListSnapshot = await historyItemList.first;

    List<HistoryModel> hList = HistoryController.mapHistoryStream(historyItemListSnapshot);

    if (hList.isEmpty) {
      debugPrint('Mapping history items failed');
    } else {
      debugPrint('Mapping history items successful');
      for (var historyItem in hList) {
        debugPrint(historyItem.photoURL);
      }
    }
    
    setState(() {
      historyListStream = historyItemList;
      historyList = hList;
    });
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
      appBar: CustomAppBar(
        userEmail: userEmail,
        isHovering: _isHovering,
        isHoveringLogout: _isHoveringLogout,
        setHoveringLogout: (bool hover) {
          setState(() {
            _isHoveringLogout = hover;
          });
        },
        historyItems: historyItems,
        selectedValue: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
          });
        },
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UploadClassDiagramSection(
                      selectedFile: _selectedFile,
                      isUploading: _isUploading,
                      pickFile: _pickFile,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GenerateButton(onPressed: generate),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.001,
                        ),
                        SelectLanguage(
                          selectedLanguage: selectedLanguage,
                          languages: languages,
                          onLanguageChanged: (value) {
                            setState(() {
                              selectedLanguage = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.001,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 17.0,
                        right: 15.0,
                      ),
                      child: WarningBanner(
                          message:
                              'ClassyCode can make mistakes. Check important info.'),
                      // child: Center(
                      //   child: Container(
                      //     height: MediaQuery.of(context).size.height * 0.025,
                      //     width: MediaQuery.of(context).size.width * 0.250,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.only(right: 5),
                      //           child: Icon(
                      //             Icons.error_outline,
                      //             color: Colors.white,
                      //             size:
                      //                 MediaQuery.of(context).size.width * 0.009,
                      //           ),
                      //         ),
                      //         Text(
                      //           'ClassyCode can make mistakes. Check important info.',
                      //           style: TextStyle(
                      //             fontSize:
                      //                 MediaQuery.of(context).size.width * 0.007,
                      //             color: Colors.white,
                      //             fontFamily:
                      //                 GoogleFonts.jetBrainsMono().fontFamily,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
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
