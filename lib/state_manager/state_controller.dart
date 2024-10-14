import 'dart:io';

import 'package:classy_code/controllers/history_controller.dart';
import 'package:classy_code/models/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class StateController extends ChangeNotifier {  
  // selectedLanguage state
  String _selectedLanguage = 'Select Language';
  String get selectedLanguage => _selectedLanguage;

  void setSelectedLanguage(String value) {
    _selectedLanguage = value;
    notifyListeners();
  }

  
  // selectedFile state
  File? _selectedFile;
  File? get selectedFile => _selectedFile;

  void setSelectedFile(File? value) {
    _selectedFile = value;
    notifyListeners();
  }

  
  // selectedHistoryItem state
  HistoryModel? _selectedHistoryItem;
  HistoryModel? get selectedHistoryItem => _selectedHistoryItem;

  void setSelectedHistoryItem(HistoryModel? value) {
    _selectedHistoryItem = value;
    notifyListeners();
  }

  
  // generatedCode state
  String _generatedCode = "";
  String get generatedCode => _generatedCode;

  void setGeneratedCode(String value) {
    _generatedCode = value;
    notifyListeners();
  }

  
  // totalClasses state
  int _totalClasses = 0;
  int get totalClasses => _totalClasses;

  void setTotalClasses(int value) {
    _totalClasses = value;
    notifyListeners();
  }

  
  // totalRelationships state
  int _totalRelationships = 0;
  int get totalRelationships => _totalRelationships;

  void setTotalRelationships(int value) {
    _totalRelationships = value;
    notifyListeners();
  }

  
  // typesOfRelationships state
  List<String> _typesOfRelationships = [];
  List<String> get typesOfRelationships => _typesOfRelationships;

  void setTypesOfRelationships(List<String> value) {
    _typesOfRelationships = value;
    notifyListeners();
  }

  
  // isUploading state
  bool _isUploading = false;
  bool get isUploading => _isUploading;

  void setIsUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  
  // isGenerating state
  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

  void setIsGenerating(bool value) {
    _isGenerating = value;
    notifyListeners();
  }

  
  // userEmail state
  String _userEmail = '';
  String get userEmail => _userEmail;

  void setUserEmail(String value) {
    _userEmail = value;
    notifyListeners();
  }

  
  // isHovering state
  bool _isHovering = false;
  bool get isHovering => _isHovering;

  void setIsHovering(bool value) {
    _isHovering = value;
    notifyListeners();
  }

  
  // isHoveringLogout state
  bool _isHoveringLogout = false;
  bool get isHoveringLogout => _isHoveringLogout;

  void setIsHoveringLogout(bool value) {
    _isHoveringLogout = value;
    notifyListeners();
  }

  
  // historyListStream state
  Stream<QuerySnapshot>? _historyListStream;
  Stream<QuerySnapshot>? get historyListStream => _historyListStream;

  void setHistoryListStream(Stream<QuerySnapshot>? value) {
    _historyListStream = value;
    notifyListeners();
  }

  
  // historyList state
  List<HistoryModel> _historyList = [];
  List<HistoryModel> get historyList => _historyList;

  void setHistoryList(List<HistoryModel> value) {
    _historyList = value;
    notifyListeners();
  }

  void deleteHistoryItem(HistoryModel historyModel) async {
    await HistoryController.deleteHistoryItem(historyModel.historyID);
    _historyList = _historyList.where((element) => element.historyID != historyModel.historyID).toList();
    _historyListStream = HistoryController.getHistoryListStream(historyModel.userID);
    notifyListeners();
  }

  void resetStates() {
    _selectedLanguage = 'Select Language';
    _selectedFile = null;
    _selectedHistoryItem = null;
    _generatedCode = "";
    _totalClasses = 0;
    _totalRelationships = 0;
    _typesOfRelationships = [];
    _isUploading = false;
    _isGenerating = false;
    _userEmail = '';
    _isHovering = false;
    _isHoveringLogout = false;
    _historyList = [];
    _historyListStream = null;
    notifyListeners();
  }
}