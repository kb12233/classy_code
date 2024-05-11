import 'dart:io';
import 'package:classy_code/subsystems/input_management/uploader.dart';

class InputManager {
  final Uploader uploader = Uploader();

  Future<File?> uploadInput() async {
    return uploader.upload();
  }
}
