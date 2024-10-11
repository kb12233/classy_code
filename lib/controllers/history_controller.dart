import 'dart:io';

import 'package:classy_code/models/history_model.dart';
import 'package:classy_code/models/insight_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HistoryController {
  HistoryModel? history;

  static Future<String?> createHistoryItem(String userID, File? code, File? classDiagramImage, InsightsData insightsData, String language) async {
    return await HistoryModel.createHistoryItem(userID, code, classDiagramImage, insightsData, language);
  }

  static Future<List<HistoryModel>> getHistoryList(String userID) async {
    Stream<QuerySnapshot> historyQuery = HistoryModel.getHistoryList(userID);
    return HistoryModel.mapHistoryList(historyQuery);
  }

  static Stream<QuerySnapshot> getHistoryListStream(String userID) {
    return HistoryModel.getHistoryList(userID);
  }

  static List<HistoryModel> mapHistoryStream(QuerySnapshot historyQuery) {
    return HistoryModel.mapHistoryStream(historyQuery);
  }

  static Future<void> deleteHistoryItem(String historyID) async {
    return await HistoryModel.deleteHistoryItem(historyID);
  }

  static Future<DocumentSnapshot?> getHistoryItem(String historyID) {
    return HistoryModel.getHistoryItem(historyID);
  }
}
