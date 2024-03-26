import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedLanguage = 'Select Language';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {}, // Implement user icon button action
            ),
            Text('ClassyCode'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {}, // Implement user icon button action
          ),
          IconButton(
            icon: Icon(Icons.menu),
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
                      items: languages
                          .map((lang) =>
                              DropdownMenuItem(value: lang, child: Text(lang)))
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

class UploadImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {}, // Implement photo upload functionality
        icon: Icon(Icons.upload),
        label: Text('Upload Class Diagram'),
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
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text('Generate'),
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
              Text('Generated Code'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {}, // Implement code copy functionality
                  ),
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {}, // Implement code save functionality
                  ),
                ],
              ),
            ],
          ),
          Text(
            'This section will display the generated code',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Replace with a list of actual supported languages
final languages = ['Select Language', 'Dart', 'Python', 'Java'];
