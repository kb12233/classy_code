import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userID;
  String name;
  String email;
  String password;

  UserModel({
    required this.userID,
    required this.name,
    required this.email,
    required this.password,
  });

  static Future<UserModel?> getUserData(String userID) async {
    try {
      CollectionReference user = FirebaseFirestore.instance.collection('user');

      // Use a where clause to filter documents based on the userID field
      QuerySnapshot userQuery =
          await user.where('userID', isEqualTo: userID).get();

      // Check if there is exactly one matching document
      if (userQuery.size == 1) {
        // Map the fields to create a UserModel object
        return UserModel(
          userID: userQuery.docs[0]['userID'],
          email: userQuery.docs[0]['email'],
          name: userQuery.docs[0]['name'],
          password: userQuery.docs[0]['password'],
        );
      } else if (userQuery.size == 0) {
        // User document does not exist
        return null;
      } else {
        // Multiple documents found (unexpected), handle as needed
        print('Unexpected: Multiple documents found for userID: $userID');
        return null;
      }
    } catch (e) {
      // Handle errors, e.g., network issues, etc.
      print('Error getting user data: $e');
      return null;
    }
  }

  // Method to update user data in Firestore
  Future<void> updateUserDataInFirestore(String authUID) async {
    try {
      CollectionReference user = FirebaseFirestore.instance.collection('user');

      // Use a where clause to filter documents based on the userID field
      QuerySnapshot userQuery =
          await user.where('userID', isEqualTo: authUID).get();

      // Check if there is exactly one matching document
      if (userQuery.size == 1) {
        // Update the document with the new user data
        await user.doc(userQuery.docs[0].id).update({
          'name': name
          // Add other fields as needed
        });
      } else if (userQuery.size == 0) {
        // User document does not exist
        print(
            'Error updating user data: User not found for auth UID: $authUID');
      } else {
        // Multiple documents found (unexpected), handle as needed
        print('Unexpected: Multiple documents found for auth UID: $authUID');
      }
    } catch (e) {
      // Handle errors, e.g., network issues, etc.
      print('Error updating user data: $e');
    }
  }
}
