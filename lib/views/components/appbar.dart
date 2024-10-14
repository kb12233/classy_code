// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:classy_code/models/history_model.dart';
import 'package:classy_code/views/components/classycode_custom_text.dart';
import 'package:classy_code/views/components/classycode_historycard.dart';
import 'package:classy_code/views/components/logo_with_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userEmail;
  final bool isHovering;
  final bool isHoveringLogout;
  final Function(bool) setHoveringLogout;
  final List<HistoryModel> historyItems;
  final String? selectedValue;
  final Function(HistoryModel?) onChanged;
  final greybg = Color(0xFF202124);

  CustomAppBar({
    required this.userEmail,
    required this.isHovering,
    required this.isHoveringLogout,
    required this.setHoveringLogout,
    required this.historyItems,
    required this.selectedValue,
    required this.onChanged,
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<HistoryModel>(
                            isExpanded: true,
                            hint: customText(
                                text: 'History',
                                fontSize: screenDiagonal(context) * 0.01,
                                isBold: false,
                                color: Colors.white),
                            items: historyItems
                                .map((HistoryModel value) =>
                                    DropdownMenuItem<HistoryModel>(
                                      value: value,
                                      child: HistoryCard(
                                        language: value.language,
                                        dateTime: value.dateTime,
                                        onDelete: () {
                                          debugPrint(
                                              "Delete item ${value.dateTime}");
                                        },
                                      ),
                                    ))
                                .toList(),
                            onChanged: onChanged,
                            dropdownStyleData: DropdownStyleData(
                                maxHeight: screenDiagonal(context) * 0.25,
                                width: screenDiagonal(context) * 0.15,
                                offset: Offset(0, -8),
                                scrollbarTheme: ScrollbarThemeData(
                                    thickness: MaterialStateProperty.all(4),
                                    radius: Radius.circular(8),
                                    thumbColor: MaterialStateProperty.all(
                                        Colors.white30),
                                    trackColor: MaterialStateProperty.all(
                                        Colors.grey[850])),
                                decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(8.0),
                                )),
                            buttonStyleData: ButtonStyleData(
                              height: 46,
                              padding: EdgeInsets.only(left: 15, right: 15),
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: screenDiagonal(context) * 0.05,
                              overlayColor: MaterialStateProperty.all(
                                Colors.grey[850],
                              ),
                            ),
                          ),
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
                      ElevatedButton(
                        onPressed: () {
                          print('hello');
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(greybg),
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
