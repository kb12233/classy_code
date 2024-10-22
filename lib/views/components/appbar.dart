// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:classy_code/controllers/history_controller.dart';
import 'package:classy_code/models/history_model.dart';
import 'package:classy_code/state_manager/state_controller.dart';
import 'package:classy_code/views/components/custom_text.dart';
import 'package:classy_code/views/components/history_card.dart';
import 'package:classy_code/views/components/history_dropdown.dart';
import 'package:classy_code/views/components/logo_with_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userEmail;
  final bool isHovering;
  final bool isHoveringLogout;
  final Function(bool) setHoveringLogout;
  final String? selectedValue;
  final Function(HistoryModel?) onChanged;
  final Function() resetComponents;
  final greybg = Color(0xFF202124);
  final otherColor = const Color(0xFFB8DBD9);

  CustomAppBar({
    required this.userEmail,
    required this.isHovering,
    required this.isHoveringLogout,
    required this.setHoveringLogout,
    required this.selectedValue,
    required this.onChanged,
    required this.resetComponents,
  });

  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double screenDiagonal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }

  @override
  Size get preferredSize => Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<StateController>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          backgroundColor: Colors.black,
          leading: Padding(
            padding: const EdgeInsets.only(top: 5),
          ),
          title: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 13.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: screenDiagonal(context) * 0.09,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: greybg,
                        ),
                        child: HistoryDropDown(
                          onChanged: onChanged,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 13.0, left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: screenDiagonal(context) * 0.08,
                      ),
                      notifier.selectedFile != null
                          ? ElevatedButton(
                              onPressed: resetComponents,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(greybg),
                                foregroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                surfaceTintColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                elevation: MaterialStateProperty.all(0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 1, right: 1),
                                child: Icon(
                                  Icons.restart_alt,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            )
                          : OutlinedButton(
                              onPressed: null,
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Colors.white54,
                                    width: 1.0,
                                    style: BorderStyle.solid)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                elevation: MaterialStateProperty.all(0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 1, right: 1),
                                child: Icon(
                                  Icons.restart_alt,
                                  color: Colors.white54,
                                  size: 30,
                                ),
                              ),
                            ),
                      SizedBox(
                        width: 15,
                      ),
                      notifier.selectedHistoryItem != null
                          ? customText(
                              text: notifier.selectedHistoryItem!.fileName
                                          .length <=
                                      26
                                  ? notifier.selectedHistoryItem!.fileName
                                  : "${notifier.selectedHistoryItem!.fileName.substring(0, 23)}...",
                              fontSize: screenDiagonal(context) * 0.008,
                              isBold: false,
                              color: otherColor)
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: LogoWithText(
                        imagePath: 'lib/images/logo_dark.png',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            MouseRegion(
              onEnter: (_) => setHoveringLogout(true),
              onExit: (_) => setHoveringLogout(false),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: PopupMenuButton<String>(
                  elevation: 0,
                  offset: Offset(0, 60),
                  icon: Icon(
                    Icons.account_circle,
                    color: isHovering || isHoveringLogout
                        ? Colors.grey
                        : Colors.white,
                  ),
                  iconSize: 45,
                  color: Colors.grey[850],
                  onSelected: (String result) {
                    if (result == 'logout') {
                      FirebaseAuth.instance.signOut();
                      debugPrint('User logged out.');
                      notifier.resetStates();
                      Navigator.of(context).pop();
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'user_email',
                      child: ListTile(
                        title: customText(
                            text: userEmail,
                            fontSize: screenDiagonal(context) * 0.01,
                            isBold: false,
                            color: Colors.white),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: customText(
                          text: 'Logout',
                          fontSize: screenDiagonal(context) * 0.01,
                          isBold: false,
                          color: isHoveringLogout ? Colors.red : Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
