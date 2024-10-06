import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordDialog extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback resetPassword;
  final Color bgColor;
  final Color btnColor;
  final Color otherColor;

  const ResetPasswordDialog({
    Key? key,
    required this.emailController,
    required this.resetPassword,
    required this.bgColor,
    required this.btnColor,
    required this.otherColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: bgColor.withOpacity(0),
        ),
      ),
      AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: otherColor,
              width: 2,
            )),
        contentPadding: EdgeInsets.fromLTRB(50, 20, 50, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              color: otherColor,
              size: 70,
            ),
            SizedBox(height: 10),
            Text(
              'Reset Password',
              style: TextStyle(
                color: otherColor,
                fontSize: 30,
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please enter email address to receive password reset link.',
              style: TextStyle(
                color: otherColor,
                fontSize: 20,
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xFF2F4550).withOpacity(0.5),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: emailController,
                      style: GoogleFonts.jetBrainsMono(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Email address',
                        labelStyle: TextStyle(
                          color: Color(0xFFB8DBD9),
                          fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
            ),
            onPressed: resetPassword,
            child: Text(
              'Send Email',
              style: TextStyle(
                color: otherColor,
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: btnColor,
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
