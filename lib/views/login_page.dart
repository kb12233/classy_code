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

  final bgColor = const Color(0xFF202124);
  final btnColor = const Color(0xFF2F4550);
  final otherColor = const Color(0xFFB8DBD9);
  final otherColor1 = const Color(0xFF31363F);

  void resetPasswordDialog(BuildContext context) {
    TextEditingController newPass = TextEditingController();
    TextEditingController confirmPass = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: bgColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: otherColor,
                  width: 2,
                )),
            contentPadding: EdgeInsets.fromLTRB(50, 20, 50, 20),
            // title: Text('Reset Password',
            //     style: TextStyle(
            //       color: otherColor,
            //     )),
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
                SizedBox(height: 30),
                Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF2F4550).withOpacity(0.5),
                  ),
                  child: Row(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 8.0),
                      //   child: Icon(Icons.person, color: Color(0xFFB8DBD9)),
                      // ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'New Password',
                            labelStyle: TextStyle(
                              color: Color(0xFFB8DBD9),
                              fontFamily:
                                  GoogleFonts.jetBrainsMono().fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF2F4550).withOpacity(0.5),
                  ),
                  child: Row(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 8.0),
                      //   child: Icon(Icons.person, color: Color(0xFFB8DBD9)),
                      // ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(
                              color: Color(0xFFB8DBD9),
                              fontFamily:
                                  GoogleFonts.jetBrainsMono().fontFamily,
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
                onPressed: () {
                  //here ang pag reset
                  print('The button is clicked!');
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: otherColor,
                    fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //here ang pag cancel
                  print('The button is clicked!');
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
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.email_outlined,
                                color: Color(0xFFB8DBD9)),
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
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.lock_outline,
                                color: Color(0xFFB8DBD9)),
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
                        resetPasswordDialog(context);
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
                    SizedBox(height: 30),
                    Center(
                      child: Padding(
                        padding:
                          EdgeInsets.only(top: 5, left: 90, right: 50),
                        child: Text(
                          'Create an account and get started!',
                          style: TextStyle(
                            color: Color(0xFF31363F),
                            fontSize: 20,
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Color(0xFF31363F),
                          fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        side: BorderSide(color: otherColor1), // Border color
                        textStyle: TextStyle(
                          fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                        ),
                      ),
                    )
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
