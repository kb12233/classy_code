import 'dart:io';

import 'package:classy_code/models/insight_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HistoryModel {
  final String historyID;
  final String userID;
  final String code;
  final DateTime dateTime;
  final String photoURL;
  final int totalClasses;
  final int totalRelationships;
  final Map<String, double> typesOfRelationships;

  HistoryModel({
    this.historyID = '',
    required this.userID,
    required this.code,
    required this.dateTime,
    this.photoURL = '',
    required this.totalClasses,
    required this.totalRelationships,
    required this.typesOfRelationships
  });

  // TODO implement createHistoryItem
  static Future<String?> createHistoryItem(String userID, String code, File? classDiagramImage, InsightsData insightsData) async {
    try {
      CollectionReference history_table = FirebaseFirestore.instance.collection('history');

      await history_table.add({
        'userID': userID,
        'code': code,
        'dateTime': DateTime.now(),
        'photoURL': '',
        'totalClasses': insightsData.totalClasses,
        'totalRelationships': insightsData.totalRelationships,
        'typesOfRelationships': insightsData.typesOfRelationships
      }).then((new_history) async {
        await _uploadImage(new_history.id, classDiagramImage!);

        String photoURL = await _getUploadedPhotoURL(new_history.id);

        await new_history.update({'photoURL': photoURL});
      });

      return 'Success';
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  static Future<void> _uploadImage(
      String historyID, File image) async {
    try {
      String imagePath = 'history_images/$historyID/class_diagram_$historyID.jpg';
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
      await storageReference.putFile(image);
    } catch (e) {
      print('Error uploading property image: $e');
    }
  }

  static Future<String> _getUploadedPhotoURL(String historyID) async {
    String photoURL = '';

    try {
      String imagePath = 'history_images/$historyID/class_diagram_$historyID.jpg';
        firebase_storage.Reference storageReference =
            firebase_storage.FirebaseStorage.instance.ref().child(imagePath);

        try {
          // Attempt to get the download URL
          photoURL = await storageReference.getDownloadURL();
        } catch (e) {
          // If the image doesn't exist, use a placeholder URL or an empty string
          // photoURLs.add('https://example.com/placeholder.jpg');
          photoURL = '';
        }
    } catch (e) {
      print('Error getting photo URLs: $e');
    }

    return photoURL;
  }

  // TODO implement getHistoryList

  // TODO implement getHistoryItem

  // TODO implement deleteHistoryItem
}