// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:classy_code/controllers/history_controller.dart';
import 'package:classy_code/img_code_converter.dart';
import 'package:classy_code/input_manager.dart';
import 'package:classy_code/models/history_model.dart';
import 'package:classy_code/models/insight_data.dart';
import 'package:classy_code/output_manager.dart';
import 'package:classy_code/state_manager/state_controller.dart';
import 'package:classy_code/views/components/appbar.dart';
import 'package:classy_code/views/components/warning_banner.dart';
import 'package:classy_code/views/components/generate_button.dart';
import 'package:classy_code/views/components/generated_code_section.dart';
import 'package:classy_code/views/components/loading_overlay.dart';
import 'package:classy_code/views/components/select_laguage.dart';
import 'package:classy_code/views/components/upload_classdiagram_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InputManager inputManager = InputManager();
  final ImageToCodeConverter converter = ImageToCodeConverter();
  final OutPutManager outPutManager = OutPutManager();
  final HistoryController historyController = HistoryController();

  // states
  String? selectedValue;
  String selectedLanguage = 'Select Language';
  File? _selectedFile;
  HistoryModel? selectedHistoryItem;
  String generatedCode = "";
  int totalClasses = 0;
  int totalRelationships = 0;
  List<String> typesOfRelationships = [];
  bool _isUploading = false;
  bool _isGenerating = false;
  String userEmail = '';
  bool _isHovering = false;
  bool _isHoveringLogout = false;
  Stream<QuerySnapshot>? historyListStream;
  List<HistoryModel> historyList = [];

  final languages = ['Select Language', 'Dart', 'Python', 'Java', 'JavaScript'];

  @override
  void initState() {
    super.initState();
    getUserEmail();
    getHistoryList();

    // This is for testing functionality of getHistoryList() and mapHistoryList()
    // HistoryController.triggerHistoryListUpdate(FirebaseAuth.instance.currentUser!.uid);
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
    Stream<QuerySnapshot> historyItemList =
        HistoryController.getHistoryListStream(
            FirebaseAuth.instance.currentUser!.uid);

    historyItemList.listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) {
        debugPrint('No history items found \n');
      } else {
        debugPrint('History items found \n');
        int count = 0;
        for (var historyItem in snapshot.docs) {
          debugPrint('History snapshot $count');
          count++;
          debugPrint('${historyItem['dateTime'].toDate().toString()} \n');
        }
      }

      // Update state after processing stream
      // setState(() {
      //   historyListStream = historyItemList;
      //   // historyList = hList;
      // });
      Provider.of<StateController>(context, listen: false)
          .setHistoryListStream(historyItemList);
    }, onError: (error) {
      debugPrint('Error fetching history: $error');
    });

    List<HistoryModel> hList =
        await HistoryController.mapHistoryListStream(historyItemList);

    // setState(() {
    //   historyList = hList;
    // });
    Provider.of<StateController>(context, listen: false).setHistoryList(hList);
  }

  void _pickFile() async {
    File? file = await inputManager.uploadInput();

    if (file != null) {
      // setState(() {
      //   _isUploading = true;
      // });
      Provider.of<StateController>(context, listen: false).setIsUploading(true);

      bool isValid = await inputManager.verifyInput(file);

      // setState(() {
      //   _isUploading = false;
      // });
      Provider.of<StateController>(context, listen: false)
          .setIsUploading(false);

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
        // setState(() {
        //   _selectedFile = file;
        // });
        Provider.of<StateController>(context, listen: false)
            .setSelectedFile(file);
      }
    }
  }

  void generate() async {
    final notifier = Provider.of<StateController>(context, listen: false);
    if (notifier.selectedLanguage != "Select Language") {
      // setState(() {
      //   _isGenerating = true;
      // });

      notifier.setIsGenerating(true);
      String? code;
      try {
        // code = await converter.convert(_selectedFile!, selectedLanguage);
        code = await converter.convert(
            notifier.selectedFile!, notifier.selectedLanguage);
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
          await converter.extractInsights(notifier.selectedFile!);

      try {
        String? result = await HistoryController.createHistoryItem(
            FirebaseAuth.instance.currentUser!.uid,
            codeFile,
            notifier.selectedFile,
            insightsData,
            language);
      } on Exception catch (e) {
        print('Error creating history item: $e');
      }

      if (await codeFile.exists()) {
        await codeFile.delete();
      }

      // setState(() {
      //   generatedCode = code ?? '';
      //   totalClasses = insightsData.totalClasses;
      //   totalRelationships = insightsData.totalRelationships;
      //   typesOfRelationships = insightsData.typesOfRelationships;
      //   _isGenerating = false;
      // });
      Provider.of<StateController>(context, listen: false)
          .setGeneratedCode(code ?? '');
      Provider.of<StateController>(context, listen: false)
          .setTotalClasses(insightsData.totalClasses);
      Provider.of<StateController>(context, listen: false)
          .setTotalRelationships(insightsData.totalRelationships);
      Provider.of<StateController>(context, listen: false)
          .setTypesOfRelationships(insightsData.typesOfRelationships);
      Provider.of<StateController>(context, listen: false)
          .setIsGenerating(false);
      getHistoryList();
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
    final notifier = Provider.of<StateController>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        userEmail: userEmail,
        // userEmail: notifier.userEmail,
        // userEmail: notifier.userEmail,
        // isHovering: _isHovering,
        isHovering: notifier.isHovering,
        // isHoveringLogout: _isHoveringLogout,
        isHoveringLogout: notifier.isHoveringLogout,
        setHoveringLogout: (bool hover) {
          // setState(() {
          //   _isHoveringLogout = hover;
          // });
          notifier.setIsHoveringLogout(hover);
        },
        // historyItems: historyList,
        historyItems: notifier.historyList,
        selectedValue: selectedValue,
        onChanged: (HistoryModel? value) {
          // setState(() {
          //   selectedHistoryItem = value;
          //   debugPrint('Selected value: ${selectedHistoryItem?.dateTime}');
          // });
          notifier.setSelectedHistoryItem(value);
          debugPrint('Selected history item: ${notifier.selectedHistoryItem?.dateTime}');
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
                      // selectedFile: _selectedFile,
                      selectedFile: notifier.selectedFile,
                      // isUploading: _isUploading,
                      isUploading: notifier.isUploading,
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
                          selectedLanguage: notifier.selectedLanguage,
                          languages: languages,
                          onLanguageChanged: (value) {
                            // setState(() {
                            //   selectedLanguage = value!;
                            // });
                            notifier.setSelectedLanguage(value!);
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
                  // generatedCode: generatedCode,
                  generatedCode: notifier.generatedCode,
                  outPutManager: outPutManager,
                ),
              ),
            ],
          ),
          // if (_isUploading || _isGenerating)
          if (notifier.isUploading || notifier.isGenerating)
            LoadingOverlay(
                isUploading: notifier.isUploading,
                isGenerating: notifier.isGenerating),
        ],
      ),
    );
  }
}
