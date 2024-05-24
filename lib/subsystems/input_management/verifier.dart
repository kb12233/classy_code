import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Verifier {
  Future<bool> verify(File? classdiagramImage) async {
    if (classdiagramImage == null) return false;

    String? apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);

    final image = await (File(classdiagramImage.path).readAsBytes());
    final prompt = TextPart(
        "Does the image show a UML class diagram? Answer only with \"true\" or \"false\".");
    final imagePart = [DataPart('image/jpeg', image)];

    final response = await model.generateContent([
      Content.multi([prompt, ...imagePart])
    ]);
    

    if (response.text?.trim() == "true") {
      print(response.text?.trim());
      return true;
    }

    return false;
  }
}
