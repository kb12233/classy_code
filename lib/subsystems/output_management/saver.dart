import 'dart:io';
import 'package:classy_code/subsystems/output_management/save_status.dart';
import 'package:file_picker/file_picker.dart';

class CodeSaver {
  Future<SaveStatus> save(String code, String language) async {
    // Determine the file extension
    final extension = getExtension(language.trim());
    print(extension);

    // Show file picker dialog
    String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save your code',
      fileName: 'code.$extension',
      type: FileType.custom,
      allowedExtensions: ['py', 'dart', 'js', 'java', 'txt'],
    );

    if (outputPath == null) {
      return SaveStatus(status: false, outputPath: null);
    }

    outputPath = outputPath + '.$extension';
    print(outputPath);

    // Write the code content to the file
    final file = File(outputPath);
    await file.writeAsString(code);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('File saved: $outputPath')),
    // );
    return SaveStatus(status: true, outputPath: outputPath);
  }

  String getExtension(String language) {
    switch (language) {
      case 'python':
        return 'py';
      case 'dart':
        return 'dart';
      case 'javascript':
        return 'js';
      case 'java':
        return 'java';
      // case 'csharp':
      //   return 'cs';
      // Add more languages and their extensions as needed
      default:
        return 'txt';
    }
  }
}
