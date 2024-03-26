// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Color(0xFFB8DBD9), // Left color
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: Color(0xFF31363F),
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                        ), // Set font to JetBrains Mono
                      ),
                      const SizedBox(height: 25.0),
                      Text(
                        'Stay in touch! Sign in with your info.',
                        style: TextStyle(
                          color: Color(0xFF31363F),
                          fontSize: 22,
                          fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                        ),
                      ), // New text added
                      const SizedBox(height: 25.0), // Adjust spacing as needed
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                color: Color(0xFF31363F),
                                fontFamily:
                                    GoogleFonts.jetBrainsMono().fontFamily,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(150, 50),
                              side: BorderSide(
                                  color: Color(0xFF31363F)), // Border color
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
              flex: 1,
              child: Container(
                color: Color(0xFF202124), // Right color
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          color: Color(0xFFB8DBD9),
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
                                color: Color(0xFF2F4550),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.person,
                                        color: Color(0xFFB8DBD9)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Name',
                                        labelStyle: TextStyle(
                                          color: Color(0xFFB8DBD9),
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
                                color: Color(0xFF2F4550),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.email,
                                        color: Color(0xFFB8DBD9)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                          color: Color(0xFFB8DBD9),
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
                                color: Color(0xFF2F4550),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.lock,
                                        color: Color(0xFFB8DBD9)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                          color: Color(0xFFB8DBD9),
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
                            onPressed: () {},
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Color(
                                    0xFFB8DBD9), // Set text color to #B8DBD9
                                fontFamily:
                                    GoogleFonts.jetBrainsMono().fontFamily,
                              ), // Set font to JetBrains Mono
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 50),
                              backgroundColor: Color(0xFF2F4550),
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
