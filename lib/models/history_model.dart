import 'dart:io';

import 'package:classy_code/models/insight_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class HistoryModel {
  final String historyID;
  final String userID;
  final DateTime dateTime;
  final String codeURL;
  final String photoURL;
  final int totalClasses;
  final int totalRelationships;
  final List<String> typesOfRelationships;
  final String language;
  final String fileName;

  HistoryModel(
      {this.historyID = '',
      required this.userID,
      this.codeURL = '',
      required this.dateTime,
      this.photoURL = '',
      required this.totalClasses,
      required this.totalRelationships,
      required this.typesOfRelationships,
      this.language = '',
      this.fileName = ''});

  // TODO implement createHistoryItem
  static Future<String?> createHistoryItem(
      String userID,
      File? code,
      File? classDiagramImage,
      InsightsData insightsData,
      String language,
      String fileName) async {
    try {
      CollectionReference history_table =
          FirebaseFirestore.instance.collection('history');

      await history_table.add({
        'userID': userID,
        'dateTime': DateTime.now(),
        'codeURL': '',
        'photoURL': '',
        'totalClasses': insightsData.totalClasses,
        'totalRelationships': insightsData.totalRelationships,
        'typesOfRelationships': insightsData.typesOfRelationships,
        'language': language,
        'fileName': fileName,
      }).then((new_history) async {
        await _uploadImage(new_history.id, classDiagramImage!, fileName);
        String photoURL = await _getUploadedPhotoURL(new_history.id, fileName);
        await new_history.update({'photoURL': photoURL});

        await _uploadCodeFile(new_history.id, code!, language);
        String codeURL = await _getUploadedCodeURL(new_history.id, language);
        await new_history.update({'codeURL': codeURL});
      });

      return 'Success';
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  static Future<void> _uploadImage(String historyID, File image, String fileName) async {
    try {
      String imagePath =
          'history_images/$historyID/$fileName';
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
      await storageReference.putFile(image);
    } catch (e) {
      print('Error uploading property image: $e');
    }
  }

  static Future<String> _getUploadedPhotoURL(String historyID, String fileName) async {
    String photoURL = '';

    try {
      String imagePath =
          'history_images/$historyID/$fileName';
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

  static Future<void> _uploadCodeFile(
      String historyID, File codeFile, String language) async {
    String extension = '';

    switch (language) {
      case 'python':
        extension = 'py';
        break;
      case 'dart':
        extension = 'dart';
        break;
      case 'javascript':
        extension = 'js';
        break;
      case 'java':
        extension = 'java';
        break;
      // case 'csharp':
      //   return 'cs';
      // Add more languages and their extensions as needed
      default:
        extension = 'txt';
        break;
    }

    print('printing extension from history_model.dart: $extension');

    try {
      String codePath = 'history_code/$historyID/code_$historyID.$extension';
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(codePath);
      await storageReference.putFile(codeFile);
    } catch (e) {
      print('Error uploading code file: $e');
    }
  }

  static Future<String> _getUploadedCodeURL(
      String historyID, String language) async {
    String codeURL = '';

    String extension = '';

    switch (language) {
      case 'python':
        extension = 'py';
        break;
      case 'dart':
        extension = 'dart';
        break;
      case 'javascript':
        extension = 'js';
        break;
      case 'java':
        extension = 'java';
        break;
      // case 'csharp':
      //   return 'cs';
      // Add more languages and their extensions as needed
      default:
        extension = 'txt';
        break;
    }

    try {
      String codePath = 'history_code/$historyID/code_$historyID.$extension';
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(codePath);

      try {
        // Attempt to get the download URL
        codeURL = await storageReference.getDownloadURL();
      } catch (e) {
        // If the code file doesn't exist, use an empty string
        codeURL = '';
      }
    } catch (e) {
      print('Error getting code URLs: $e');
    }

    return codeURL;
  }

  // TODO implement getHistoryList
  // static List<HistoryModel> getHistoryList(String userID) {
  //   Stream<QuerySnapshot> history = FirebaseFirestore.instance
  //       .collection('history')
  //       .where('userID', isEqualTo: userID)
  //       .orderBy('dateTime', descending: true)
  //       .snapshots();

  //   List<HistoryModel> historyList = [];
  //   history.listen((snapshot) {
  //     for (var doc in snapshot.docs) {
  //       historyList.add(HistoryModel(
  //         historyID: doc.id,
  //         userID: doc['userID'],
  //         code: doc['code'],
  //         dateTime: (doc['dateTime'] as Timestamp).toDate(),
  //         photoURL: doc['photoURL'],
  //         totalClasses: doc['totalClasses'],
  //         totalRelationships: doc['totalRelationships'],
  //         typesOfRelationships: Map<String, double>.from(doc['typesOfRelationships'])
  //       ));
  //     }
  //   });

  //   return historyList;
  // }
  static Stream<QuerySnapshot> getHistoryList(String userID) {
    Stream<QuerySnapshot> history = FirebaseFirestore.instance
        .collection('history')
        .where('userID', isEqualTo: userID)
        .orderBy('dateTime', descending: true)
        .snapshots();

    return history;
  }

  static Future<List<HistoryModel>> mapHistoryList(
      Stream<QuerySnapshot> historyItemList) async {
    List<HistoryModel> historyList = [];

    await for (QuerySnapshot snapshot in historyItemList) {
      if (snapshot.docs.isEmpty) {
        debugPrint('mapHistoryList: No history items found \n');
      } else {
        debugPrint('mapHistoryList: History items found \n');

        for (var historyItem in snapshot.docs) {
          HistoryModel h = HistoryModel(
            historyID: historyItem.id,
            userID: historyItem['userID'],
            dateTime: (historyItem['dateTime'] as Timestamp).toDate(),
            codeURL: historyItem['codeURL'],
            photoURL: historyItem['photoURL'],
            totalClasses: historyItem['totalClasses'],
            totalRelationships: historyItem['totalRelationships'],
            typesOfRelationships:
                List<String>.from(historyItem['typesOfRelationships']),
            language: historyItem['language'],
            fileName: historyItem['fileName'],
          );
          debugPrint('mapHistoryList: History item added -> ${h.dateTime}');
          historyList.add(h);
        }

        debugPrint('mapHistoryList: Completed processing stream \n');
        return historyList;
      }
    }

    debugPrint('mapHistoryList: Completed processing stream \n');
    return historyList;
  }

  static List<HistoryModel> mapHistorySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;

      return HistoryModel(
        historyID: doc.id,
        userID: data['userID'],
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        codeURL: data['codeURL'],
        photoURL: data['photoURL'],
        totalClasses: data['totalClasses'],
        totalRelationships: data['totalRelationships'],
        typesOfRelationships: List<String>.from(data['typesOfRelationships']),
        language: data['language'],
      );
    }).toList();
  }

  static void triggerHistoryListUpdate(String userID) async {
    debugPrint('triggerHistoryListUpdate: just entered ${DateTime.now()}');
    var history = getHistoryList(userID);
    var historyList = await mapHistoryList(history);

    debugPrint('triggerHistoryListUpdate: mapHistoryList completed \n');
    var b = printHistoryList(historyList);
    debugPrint('triggerHistoryListUpdate: $b');
  }

  static bool printHistoryList(List<HistoryModel> historyList) {
    bool isHistoryListNotEmpty = false;
    if (historyList.isNotEmpty) {
      isHistoryListNotEmpty = true;
      debugPrint('printHistoryList: History items found');
      for (var historyItem in historyList) {
        debugPrint('historyItem: ${historyItem.dateTime}');
      }
    } else {
      debugPrint('printHistoryList: No history items found');
    }
    debugPrint('printHistoryList: Completed \n');
    return isHistoryListNotEmpty;
  }

  static void deleteHistoryImage(String historyID, String fileName) {
    try {
      String imagePath =
          'history_images/$historyID/$fileName';
      firebase_storage.FirebaseStorage.instance.ref().child(imagePath).delete();
    } catch (e) {
      debugPrint('Error deleting history image: $e');
    }
  }

  static void deleteHistoryCode(String historyID, String language) {
    try {
      String extension = '';

      switch (language) {
        case 'python':
          extension = 'py';
          break;
        case 'dart':
          extension = 'dart';
          break;
        case 'javascript':
          extension = 'js';
          break;
        case 'java':
          extension = 'java';
          break;
        // case 'csharp':
        //   return 'cs';
        // Add more languages and their extensions as needed
        default:
          extension = 'txt';
          break;
      }

      String codePath = 'history_code/$historyID/code_$historyID.$extension';
      firebase_storage.FirebaseStorage.instance.ref().child(codePath).delete();
    } catch (e) {
      debugPrint('Error deleting history image: $e');
    }
  }

  // TODO implement deleteHistoryItem
  static Future<void> deleteHistoryItem(HistoryModel history) async {
    try {
      CollectionReference historyTable =
          FirebaseFirestore.instance.collection('history');

      await historyTable.doc(history.historyID).delete();
      deleteHistoryImage(history.historyID, history.fileName);
      deleteHistoryCode(history.historyID, history.language);
    } on FirebaseException catch (e) {
      debugPrint('Error deleting history item: $e');
    }
  }

  static Future<DocumentSnapshot?> getHistoryItem(String historyID) async {
    try {
      CollectionReference history_table =
          FirebaseFirestore.instance.collection('history');

      return await history_table.doc(historyID).get();
    } on FirebaseException catch (e) {
      debugPrint('Error getting history item: $e');
      return null;
    }
  }
}
