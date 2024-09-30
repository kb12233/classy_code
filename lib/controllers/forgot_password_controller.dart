// ignore_for_file: unrelated_type_equality_checks

import 'package:classy_code/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordControl {
  static Future<String> resetPassword(String email) async {
    try {
      if (email.isEmpty) {
        return 'Please enter an email address.';
      } else if (!email.contains('@') || !email.contains('.')) {
        return 'Please enter a valid email address.';
      } else if (await UserModel.checkUserExists(email)) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        return 'Password reset email sent';
      } else {
        return 'No user found for that email.';
      }
    } on FirebaseAuthException catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
