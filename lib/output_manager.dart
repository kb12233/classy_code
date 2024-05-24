import 'dart:io';

import 'package:classy_code/subsystems/output_management/save_status.dart';
import 'package:classy_code/subsystems/output_management/saver.dart';

class OutPutManager {
  CodeSaver codeSaver = CodeSaver();

  Future<SaveStatus> save(String code, String language) {
    return codeSaver.save(code, language);
  }
}
