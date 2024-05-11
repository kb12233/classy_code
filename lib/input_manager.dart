import 'dart:io';
import 'package:classy_code/subsystems/input_management/uploader.dart';
import 'package:classy_code/subsystems/input_management/verifier.dart';

class InputManager {
  final Uploader uploader = Uploader();
  final Verifier verifier = Verifier();

  Future<File?> uploadInput() async {
    return uploader.upload();
  }

  Future<bool> verifyInput(File? classdiagramImage) {
    return verifier.verify(classdiagramImage);
  }
}
