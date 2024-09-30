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
  
  // TODO implement getHistoryList

  // TODO implement getHistoryItem

  // TODO implement deleteHistoryItem
}
