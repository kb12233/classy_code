// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:classy_code/controllers/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

            return AlertDialog(
              backgroundColor: bgColor,
              icon: Icon(
                Icons.error,
                color: otherColor,
              ),
              title: Text(
                'Error!',
                style: TextStyle(
                  color: otherColor,
                  fontSize: 20,
                  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                ),
              ),
              content: Text(
                result.toString(),
                style: TextStyle(
                  color: otherColor,
                  fontSize: 20,
                  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                ),
              ),
            );
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
                      Row(
                        children: [
                          Image.asset(
                            'lib/images/logo_light.png',
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(width: 20), // Adjust spacing
                          // App name
                          Text(
                            "ClassyCode",
                            style: GoogleFonts.jetBrainsMono(
                              color: bgColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 250.0),
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: otherColor1,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                        ), // Set font to JetBrains Mono
                      ),
                      SizedBox(height: 50.0),
                      Padding(
                        padding: EdgeInsets.only(left: 90, right: 50),
                        child: Text(
                          'Stay in touch! Sign in with your info.',
                          style: TextStyle(
                            color: otherColor1,
                            fontSize: 22,
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                          ),
                        ),
                      ), // New text added
                      const SizedBox(height: 30.0), // Adjust spacing as needed
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/login'),
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                color: otherColor1,
                                fontFamily:
                                    GoogleFonts.jetBrainsMono().fontFamily,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(150, 50),
                              side: BorderSide(
                                  color: otherColor1), // Border color
                              textStyle: TextStyle(
                                fontFamily:
                                    GoogleFonts.jetBrainsMono().fontFamily,
                              ), // Set font to JetBrains Mono
                            ),
                          ),
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
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.jetBrainsMono()
                              .fontFamily, // Specify the font family name
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 500, // Set the desired width here
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: btnColor,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child:
                                        Icon(Icons.person, color: otherColor),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: nameController,
                                      style: GoogleFonts.jetBrainsMono(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Name',
                                        labelStyle: TextStyle(
                                          color: otherColor,
                                          fontFamily:
                                              GoogleFonts.jetBrainsMono()
                                                  .fontFamily,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 500, // Set the desired width here
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: btnColor,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.email, color: otherColor),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: emailController,
                                      style: GoogleFonts.jetBrainsMono(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                          color: otherColor,
                                          fontFamily:
                                              GoogleFonts.jetBrainsMono()
                                                  .fontFamily,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 500, // Set the desired width here
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: btnColor,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.lock, color: otherColor),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: passwordController,
                                      style: GoogleFonts.jetBrainsMono(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                          color: otherColor,
                                          fontFamily:
                                              GoogleFonts.jetBrainsMono()
                                                  .fontFamily,
                                        ),
                                      ),
                                      obscureText: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              registerUser();
                            },
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Color(
                                    0xFFB8DBD9), // Set text color to #B8DBD9
                                fontFamily:
                                    GoogleFonts.jetBrainsMono().fontFamily,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 50),
                              backgroundColor: btnColor,
                            ),
                          ),
                        ],
                      ),
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
