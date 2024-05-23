import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class CodeGenerator {
  Future<String?> generate(File? classdiagramImage, String language) async {
    String? apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);

    final image = await (File(classdiagramImage!.path).readAsBytes());
    final prompt = TextPart(
        '''
        Generate $language code from the given class diagram image.
        Only provide the code (wrapped in a Markdown code block).
        Don't put comments.You don't need to bother with the implementation of some methods.
        Just focus on depicting the correct structure of the classes as well as representing 
        the correct relationships/association.
        '''        
      );
    final imagePart = [DataPart('image/jpeg', image)];

    final response = await model.generateContent([
      Content.multi([prompt, ...imagePart])
    ]);

    print(response.text);

    return response.text;
  }
}
