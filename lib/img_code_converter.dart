import 'dart:io';

import 'package:classy_code/subsystems/conversion/code_generator.dart';

class ImageToCodeConverter {
  final CodeGenerator codeGenerator = CodeGenerator();

  Future<String?> convert(File classdiagramImage, String language) {
    return codeGenerator.generate(classdiagramImage, language);
  }
}
