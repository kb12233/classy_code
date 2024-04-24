import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedLanguage = 'Select Language';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {}, // Implement user icon button action
            ),
            Text(
              'ClassyCode',
              style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {}, // Implement user icon button action
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {}, // Implement menu icon button action
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                UploadImageSection(),
                Row(
                  children: [
                    Expanded(
                      child: GenerateButton(onPressed: () {}),
                    ),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedLanguage,
                      dropdownColor: const Color.fromARGB(
                          255, 28, 28, 28), // Set background color to black
                      items: languages
                          .map((lang) => DropdownMenuItem(
                                value: lang,
                                child: Text(
                                  lang,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.jetBrainsMono().fontFamily,
                                  ), // Set text color to white
                                ),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedLanguage = value!),
                    ),
                  ],
                ),
              ],
            ),
          ),
          VerticalDivider(thickness: 1),
          Expanded(
            child: GeneratedCodeSection(),
          ),
        ],
      ),
    );
  }
}

class UploadImageSection extends StatefulWidget {
  @override
  _UploadImageSectionState createState() => _UploadImageSectionState();
}

class _UploadImageSectionState extends State<UploadImageSection> {
  File? _selectedFile;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {
      // User canceled the file picking
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700, // Adjust the height as needed
      width: 900,
      child: Stack(
        alignment: Alignment.center, // Center the contents of the stack
        children: [
          // Background Box
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF202124),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          // Display selected image if any
          if (_selectedFile != null)
            Positioned.fill(
              child: ClipRRect(
                // ClipRRect to match the border radius of the container
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  _selectedFile!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // Round button
          Positioned(
            bottom: _selectedFile != null ? 20.0 : null,
            right: _selectedFile != null ? 20.0 : null,
            child: Material(
              color: Color(0xFF31363F),
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: _pickFile,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Icon(
                    Icons.add,
                    size: 60,
                    color: Color(0xFFB8DBD9),
                  ),
                ),
              ),
            ),
          ),
          // Text

          if (_selectedFile == null)
            Positioned(
              top: 420.0,
              child: Text(
                'Upload Class Diagram',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB8DBD9),
                  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class GenerateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GenerateButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          'GENERATE',
          style: TextStyle(
            color: Color(0xFF31363F), // Set text color to #B8DBD9
            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ), // Set font to JetBrains Mono
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 50),
          backgroundColor: Color(0xFFB8DBD9),
        ),
      ),
    );
  }
}

class GeneratedCodeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Generated Code',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                  fontSize: 20,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.white),
                    onPressed: () {}, // Implement code copy functionality
                  ),
                  IconButton(
                    icon: Icon(Icons.save, color: Colors.white),
                    onPressed: () {}, // Implement code save functionality
                  ),
                ],
              ),
            ],
          ),
          Text(
            'This section will display the generated code',
            style: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

// Replace with a list of actual supported languages
final languages = ['Select Language', 'Dart', 'Python', 'Java'];
