// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final bgColor = const Color(0xFF333333);
  final btnColor = const Color(0xFF2F4550);
  final otherColor = const Color(0xFFB8DBD9);

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
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and app name in upper left
                    Row(
                      children: [
                        Image.asset(
                          'lib/images/logo_dark.png',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(width: 20), // Adjust spacing
                        // App name
                        Text(
                          "ClassyCode",
                          style: GoogleFonts.jetBrainsMono(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 70), // Adjust spacing
                    // Centered label for signing in
                    Text(
                      "Sign in to ClassyCode",
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 60),
                    // Email input field
                    Container(
                      width: 500, // Adjust width as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xFF2F4550),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.person, color: Color(0xFFB8DBD9)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Email',
                                labelStyle: GoogleFonts.jetBrainsMono(
                                  color: Color(0xFFB8DBD9),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Password input field
                    Container(
                      width: 500, // Adjust width as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xFF2F4550),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.lock, color: Color(0xFFB8DBD9)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Password',
                                labelStyle: GoogleFonts.jetBrainsMono(
                                  color: Color(0xFFB8DBD9),
                                ),
                              ),
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Clickable link for forgot password
                    GestureDetector(
                      onTap: () {
                        // Add your action for forgot password
                      },
                      child: Text(
                        "Forgot your password?",
                        style: GoogleFonts.jetBrainsMono(
                          color: otherColor, // Change color here
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Button for signing in
                    ElevatedButton(
                      onPressed: () {
                        // Add your action for signing in
                        print('Signed In');
                      },
                      child: Text(
                        "SIGN IN",
                        style: GoogleFonts.jetBrainsMono(
                          color: Color(0xFFB8DBD9),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        fixedSize: Size(200, 50),
                      ),
                    ),
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
                padding: const EdgeInsets.only(top: 250.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Hello, Friend!',
                      style: TextStyle(
                        color: Color(0xFF31363F),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                      ),
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'Create an account and get started!',
                        style: TextStyle(
                          color: Color(0xFF31363F),
                          fontSize: 20,
                          fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Placeholder for content in the second container
            ),
          ),
        ],
      ),
    );
  }
}
