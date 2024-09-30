import 'package:classy_code/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginControl {
  static Future<String?> signIn(String email, String password) async {
    try {
      if (email.isEmpty) {
        return 'Please enter your email address.';
      } else if (!email.contains('@') || !email.contains('.')) {
        return 'Please enter a valid email address.';
      } else if (password.isEmpty) {
        return 'Please enter a password.';
      } else if (await UserModel.checkUserExists(email)) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return 'Success';
      } else {
        return 'No user found for that email.';
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
