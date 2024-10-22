import 'dart:io';
import 'dart:math';

import 'package:classy_code/controllers/history_controller.dart';
import 'package:classy_code/models/history_model.dart';
import 'package:classy_code/state_manager/state_controller.dart';
import 'package:classy_code/views/components/custom_text.dart';
import 'package:classy_code/views/components/history_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/painting.dart';

class HistoryDropDown extends StatefulWidget {
  late Function(HistoryModel?) onChanged;

  HistoryDropDown({required this.onChanged});
  
  @override
  _HistoryDropDownState createState() => _HistoryDropDownState();
}

class _HistoryDropDownState extends State<HistoryDropDown> {
  bool _isHistoryVisible = false;
  OverlayEntry? _overlayEntry;
  final greybg = Color(0xFF202124);

  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double screenDiagonal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return sqrt(size.width * size.width + size.height * size.height);
  }

  @override
  void dispose() {
    if (_isHistoryVisible) {
      _removeHistoryOverlayWithoutSetState();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: greybg,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        fixedSize: const Size(40, 46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        if (_isHistoryVisible) {
          _removeHistoryOverlay();
        } else {
          _showHistoryOverlay(context);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'History',
            style: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
            ),
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  void _showHistoryOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context)?.insert(_overlayEntry!);
    setState(() {
      _isHistoryVisible = true;
    });
  }

  void _removeHistoryOverlay() {
    _overlayEntry?.remove();
    setState(() {
      _isHistoryVisible = false;
    });
  }

  void _removeHistoryOverlayWithoutSetState() {
    _overlayEntry?.remove();
  }

  void onDelete(HistoryModel history) async {
    HistoryController.deleteHistoryItem(history);
    debugPrint('Deleted ${history.fileName}');
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox appBarRenderBox = context.findRenderObject() as RenderBox;
    final Offset offset = appBarRenderBox.localToGlobal(Offset.zero);
    final notifier = Provider.of<StateController>(context, listen: false);
    notifier.setHistoryListStream(
        HistoryController.getHistoryListStream(FirebaseAuth.instance.currentUser!.uid));

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + appBarRenderBox.size.height + 10.0,
        left: offset.dx,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 252,
            height: 400,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[850],
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: notifier.historyListStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final documents = snapshot.data!.docs;
                List<HistoryModel> historyList =
                    HistoryController.mapHistoryList(snapshot.data!);

                if (historyList.isEmpty) {
                  return Center(
                    child: customText(
                      text: 'No history available',
                      isBold: false,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  );
                }
                return Theme(
                  data: Theme.of(context).copyWith(
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: MaterialStateProperty.all(Colors.white30),
                      trackColor: MaterialStateProperty.all(Colors.grey[850]),
                      thickness: MaterialStateProperty.all(7),
                      radius: const Radius.circular(8),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          child: HistoryCard(
                              fileName: historyList[index].fileName,
                              language: historyList[index].language,
                              dateTime: historyList[index].dateTime,
                              onDelete: () {
                                onDelete(historyList[index]);
                              }),
                          onTap: () {
                            widget.onChanged(historyList[index]);
                            _removeHistoryOverlay();
                          });
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
