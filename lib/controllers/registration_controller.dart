import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationController {
  static Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // User registration successful
      User? user = userCredential.user;
      if (user != null) {
        // Store additional user data in Firestore
        await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
          'userID': user.uid,
          'name': name,
          'email': email,
          'password': password,
        });
      }
    } catch (e) {
      // Handle registration errors here
      print("Error registering user: $e");
      throw e; // Rethrow the exception for handling in UI
    }
  }
}
