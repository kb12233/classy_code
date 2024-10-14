// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:classy_code/controllers/forgot_password_controller.dart';
import 'package:classy_code/controllers/login_controller.dart';
import 'package:classy_code/models/user_model.dart';
import 'package:classy_code/views/components/alert_dialog.dart';
import 'package:classy_code/views/components/custom_text.dart';
import 'package:classy_code/views/components/elevated_button.dart';
import 'package:classy_code/views/components/input_field.dart';
import 'package:classy_code/views/components/outlined_button.dart';
import 'package:classy_code/views/components/logo_with_text.dart';
import 'package:classy_code/views/components/reset_password_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final bgColor = const Color(0xFF202124);
  final btnColor = const Color(0xFF2F4550);
  final otherColor = const Color(0xFFB8DBD9);
  final otherColor1 = const Color(0xFF31363F);

  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double screenDiagonal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }

  Future<void> signInUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    //sign in
    String? result = await LoginControl.signIn(
        emailController.text.trim(), passwordController.text.trim());
    if (!mounted) return;
    Navigator.pop(context);
    if (result == 'Success') {
      Navigator.pushNamed(context, '/main');
      final user_auth = FirebaseAuth.instance.currentUser!;
      UserModel? user = await UserModel.getUserData(user_auth.uid);
    }
    if (result != 'Success') {
      // Handle the error. For example, show a dialog with the error message.
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });

            return customAlertDialog(
                context: context,
                title: 'Error!',
                message: result.toString(),
                icon: Icons.error,
                bgColor: bgColor,
                iconColor: otherColor,
                textColor: otherColor);
          });
    }
  }

//forgot when this happens
  void displaySignInError(String errorCode) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(errorCode));
        });
  }

  Future<void> resetPassword() async {
    String email = emailController.text.trim();
    String? result = await ForgotPasswordControl.resetPassword(email);

    if (result != "Password reset email sent") {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });

            return customAlertDialog(
                context: context,
                title: 'Error!',
                message: result.toString(),
                icon: Icons.error,
                bgColor: bgColor,
                iconColor: otherColor,
                textColor: otherColor);
          });
    } else if (result == "Password reset email sent") {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
              Navigator.of(context).pop(true);
            });

            return customAlertDialog(
                context: context,
                title: 'Success!',
                message: 'Password reset email sent.',
                icon: Icons.check,
                bgColor: bgColor,
                iconColor: otherColor,
                textColor: otherColor);
          });
    }
  }

  void resetPasswordDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ResetPasswordDialog(
            emailController: emailController,
            resetPassword: resetPassword,
            bgColor: bgColor,
            btnColor: btnColor,
            otherColor: otherColor,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: bgColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    LogoWithText(
                      imagePath: 'lib/images/logo_dark.png',
                    ),
                    SizedBox(height: screenHeight(context) * 0.15),
                    customText(
                        text: 'Sign in to ClassyCode',
                        fontSize: screenDiagonal(context) * 0.03,
                        isBold: true,
                        color: Colors.white),
                    SizedBox(height: screenHeight(context) * 0.06),
                    customInputField(
                        width: screenDiagonal(context) * 0.3,
                        icon: Icons.email_outlined,
                        controller: emailController,
                        labelText: 'Email'),
                    SizedBox(height: screenHeight(context) * 0.03),
                    customInputField(
                        width: screenDiagonal(context) * 0.3,
                        icon: Icons.lock_outline,
                        controller: passwordController,
                        labelText: 'Password',
                        obscureText: true),
                    SizedBox(height: screenHeight(context) * 0.03),
                    GestureDetector(
                      onTap: () {
                        resetPasswordDialog(context);
                      },
                      child: customText(
                          text: 'Forgot your password?',
                          fontSize: screenDiagonal(context) * 0.008,
                          isBold: false,
                          color: otherColor),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    // Button for signing in
                    customElevatedButton(
                      onPressed: signInUser,
                      text: 'SIGN IN',
                      backgroundColor: btnColor,
                      fixedSize: Size(screenDiagonal(context) * 0.09,
                          screenDiagonal(context) * 0.025),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: otherColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 300.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customText(
                        text: 'Hello Friend!',
                        fontSize: screenDiagonal(context) * 0.03,
                        isBold: true,
                        color: otherColor1),
                    SizedBox(height: screenHeight(context) * 0.03),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, left: 50, right: 50),
                        child: customText(
                            text: 'Create an account and get started!',
                            fontSize: screenDiagonal(context) * 0.01,
                            isBold: false,
                            color: otherColor1),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    customOutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        //minimumSize: Size(150, 50),
                        minimumSize: Size(screenDiagonal(context) * 0.09,
                            screenDiagonal(context) * 0.03),
                        borderColor: otherColor1,
                        text: 'SIGN UP',
                        textColor: otherColor1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
