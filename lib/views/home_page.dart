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
import 'package:classy_code/views/components/info_bottom.dart';
import 'package:classy_code/views/components/warning_banner.dart';
import 'package:classy_code/views/components/generate_button.dart';
import 'package:classy_code/views/components/generated_code_section.dart';
import 'package:classy_code/views/components/loading_overlay.dart';
import 'package:classy_code/views/components/select_laguage.dart';
import 'package:classy_code/views/components/upload_classdiagram_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/painting.dart';
import 'package:path/path.dart' as p;


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
  bool isSelectingHistory = false;
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
    // getHistoryList();
  }

  @override
  void dispose() async {
    super.dispose();

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/downloaded_image.png';

    // check if file already exists
    if (await File(filePath).exists()) {
      await File(filePath).delete();
    }

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

    Provider.of<StateController>(context, listen: false)
          .setHistoryListStream(historyItemList);

    List<HistoryModel> hList =
        await HistoryController.mapHistoryListStream(historyItemList);

    Provider.of<StateController>(context, listen: false).setHistoryList(hList);
  }

  void _pickFile() async {
    File? file = await inputManager.uploadInput();

    if (file != null) {
      Provider.of<StateController>(context, listen: false).setIsUploading(true);

      bool isValid = await inputManager.verifyInput(file);

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
        Provider.of<StateController>(context, listen: false)
            .setSelectedFile(file);
      }
    }
  }

  void generate() async {
    final notifier = Provider.of<StateController>(context, listen: false);
    
    if (notifier.selectedLanguage != "Select Language") {
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
      
      String fileName = p.basename(notifier.selectedFile!.path);

      try {
        String? result = await HistoryController.createHistoryItem(
            FirebaseAuth.instance.currentUser!.uid,
            codeFile,
            notifier.selectedFile,
            insightsData,
            language,
            fileName);
      } on Exception catch (e) {
        print('Error creating history item: $e');
      }

      if (await codeFile.exists()) {
        await codeFile.delete();
      }

      notifier.setGeneratedCode(code ?? '');
      notifier.setTotalClasses(insightsData.totalClasses);
      notifier.setTotalRelationships(insightsData.totalRelationships);
      notifier.setTypesOfRelationships(insightsData.typesOfRelationships);
      notifier.setIsGenerating(false);
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

  void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  void resetComponents(StateController notifier) async {
    // Clear selected language
    notifier.setSelectedLanguage('Select Language');
    debugPrint('Cleared selected language.');
    
    // Clear image data
    notifier.setSelectedFile(null);
    debugPrint('Cleared selected image file.');

    // Clear code content
    notifier.setGeneratedCode('');
    debugPrint('Cleared generated code content.');

    // Reset other fields
    notifier.setTotalClasses(0);
    notifier.setTotalRelationships(0);
    notifier.setTypesOfRelationships([]);

    // Optionally, clear the selected history item itself
    notifier.setSelectedHistoryItem(null);
    debugPrint('Cleared selected history item data.');

    // Clear any cached image if needed
    clearImageCache();
    debugPrint('Image cache cleared.');
  }

  void displaySelectedHistoryItem(StateController notifier) async {
    notifier.setIsSelectingHistory(true);

    var response =
        await http.get(Uri.parse(notifier.selectedHistoryItem!.photoURL));

    if (response.statusCode == 200) {
      // store image in a file
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/downloaded_image.png';
      debugPrint('File Path: $filePath');

      clearImageCache();

      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      notifier.setSelectedFile(file);
      debugPrint('Image saved to: $filePath');
    } else {
      debugPrint(
          'Failed to download image. Status code: ${response.statusCode}');
    }

    var codeResponse =
        await http.get(Uri.parse(notifier.selectedHistoryItem!.codeURL));
    if (codeResponse.statusCode == 200) {
      // store content of code file in string
      String codeContent =
          "```${notifier.selectedHistoryItem!.language}\n${codeResponse.body}\n```";
      notifier.setGeneratedCode(codeContent);

      debugPrint('Downloaded Code Content: $codeContent');
    }

    notifier.setTotalClasses(notifier.selectedHistoryItem!.totalClasses);
    notifier.setTotalRelationships(
        notifier.selectedHistoryItem!.totalRelationships);
    notifier.setTypesOfRelationships(
        notifier.selectedHistoryItem!.typesOfRelationships);

    Provider.of<StateController>(context, listen: false)
        .setIsSelectingHistory(false);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<StateController>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
          userEmail: userEmail,
          isHovering: notifier.isHovering,
          isHoveringLogout: notifier.isHoveringLogout,
          setHoveringLogout: (bool hover) {
            notifier.setIsHoveringLogout(hover);
          },
          selectedValue: selectedValue,
          onChanged: (HistoryModel? value) {
            notifier.setSelectedHistoryItem(value);
            debugPrint(
                'Selected history item: ${notifier.selectedHistoryItem?.dateTime}');

            displaySelectedHistoryItem(notifier);
          },
          resetComponents: () {
            resetComponents(notifier);
          }),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UploadClassDiagramSection(
                      selectedFile: notifier.selectedFile,
                      isUploading: notifier.isUploading,
                      pickFile: _pickFile,
                    ),
                    notifier.selectedHistoryItem == null
                        ? Row(
                            children: [
                              Expanded(
                                child: GenerateButton(
                                  onPressed: generate,
                                  isEnabled: notifier.selectedFile != null,
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.001,
                              ),
                              // notifier.selectedFile != null
                              //   ? SelectLanguage(
                              //       selectedLanguage: notifier.selectedLanguage,
                              //       languages: languages,
                              //       onLanguageChanged: (value) {
                              //         notifier.setSelectedLanguage(value!);
                              //       },
                              //     )
                              //   : SizedBox(),
                              SelectLanguage(
                                    selectedLanguage: notifier.selectedLanguage,
                                    languages: languages,
                                    onLanguageChanged: (value) {
                                      notifier.setSelectedLanguage(value!);
                                    },
                                  )
                            ],
                          )
                        : HistoryBottom(
                            dateGenerated:
                                notifier.selectedHistoryItem?.dateTime ??
                                    DateTime.now(),
                            timeGenerated:
                                notifier.selectedHistoryItem?.dateTime ??
                                    DateTime.now(),
                            language: notifier.selectedHistoryItem?.language,
                            bgColor: bgColor),
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
                  generatedCode: notifier.generatedCode,
                  outPutManager: outPutManager,
                  numberOfRelationships: notifier.totalRelationships.toString(),
                  numberOfClasses: notifier.totalClasses.toString(),
                  typeOfRelationships: notifier.typesOfRelationships,
                ),
              ),
            ],
          ),
          if (notifier.isUploading ||
              notifier.isGenerating ||
              notifier.isSelectingHistory)
            LoadingOverlay(
              isUploading: notifier.isUploading,
              isGenerating: notifier.isGenerating,
              isSelectingHistoryItem: notifier.isSelectingHistory,
            ),
        ],
      ),
    );
  }
}
