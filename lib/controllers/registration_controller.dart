import 'package:classy_code/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationController {
  static Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (name.isEmpty) {
        return 'Please enter your name.';
      } else if (email.isEmpty) {
        return 'Please enter your email address.';
      } else if (!email.contains('@') || !email.contains('.com')) {
        return 'Please enter a valid email address.';
      } else if (password.isEmpty) {
        return 'Please enter a password.';
      } else if (await UserModel.checkUserExists(email)) {
        return 'User already exists.';
      } else {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('user')
              .doc(user.uid)
              .set({
            'userID': user.uid,
            'name': name,
            'email': email,
            'password': password,
          });
        }

        return 'Success';
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
