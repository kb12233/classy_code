// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:math';

import 'package:classy_code/controllers/registration_controller.dart';
import 'package:classy_code/views/components/classycode_alert_dialog.dart';
import 'package:classy_code/views/components/classycode_custom_text.dart';
import 'package:classy_code/views/components/classycode_elevated_button.dart';
import 'package:classy_code/views/components/classycode_input_field.dart';
import 'package:classy_code/views/components/classycode_outlined_button.dart';
import 'package:classy_code/views/components/logo_with_text.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final nameController = TextEditingController();
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

  Future<void> registerUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    String? result = await RegistrationController.registerUser(
        name: name, email: email, password: password);
    if (result == 'Success') {
      Navigator.pushNamed(context, '/login');
    } else if (result != 'Success') {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 1), () {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: otherColor, // Left color
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LogoWithText(
                        imagePath: 'lib/images/logo_light.png',
                        textColor: otherColor1,
                      ),
                      SizedBox(height: screenHeight(context) * 0.3),
                      customText(
                          text: 'Welcome Back!',
                          fontSize: screenDiagonal(context) * 0.03,
                          isBold: true,
                          color: otherColor1),
                      SizedBox(height: screenHeight(context) * 0.03),
                      Padding(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: customText(
                            text: 'Stay in touch! Sign in with your info.',
                            fontSize: screenDiagonal(context) * 0.01,
                            isBold: false,
                            color: otherColor1),
                      ),
                      SizedBox(height: screenHeight(context) * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          customOutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              minimumSize: Size(screenDiagonal(context) * 0.09,
                                  screenDiagonal(context) * 0.03),
                              borderColor: otherColor1,
                              text: 'SIGN IN',
                              textColor: otherColor1),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: bgColor, // Right color
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      customText(
                          text: 'Create Account',
                          fontSize: screenDiagonal(context) * 0.03,
                          isBold: true,
                          color: Colors.white),
                      SizedBox(height: screenHeight(context) * 0.06),
                      customInputField(
                          width: screenDiagonal(context) * 0.3,
                          icon: Icons.person,
                          controller: nameController,
                          labelText: 'Name'),
                      SizedBox(height: screenHeight(context) * 0.03),
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
                          labelText: 'Password'),
                      SizedBox(height: screenHeight(context) * 0.03),
                      customElevatedButton(
                        onPressed: registerUser,
                        text: 'SIGN UP',
                        backgroundColor: btnColor,
                        fixedSize: Size(screenDiagonal(context) * 0.09,
                            screenDiagonal(context) * 0.025),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
