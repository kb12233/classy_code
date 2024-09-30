import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class InsightsDataRetriever {
  
  Future<int> getTotalClasses(File? classdiagramImage) async {
    String? apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    GenerationConfig config = GenerationConfig(
      maxOutputTokens: 1000000000
    );

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey, generationConfig: config);

    final image = await (File(classdiagramImage!.path).readAsBytes());
    final prompt = TextPart('''
        How many classes are there in the given class diagram image? Only provide the number.
        ''');
    final imagePart = [DataPart('image/jpeg', image)];

    final response = await model.generateContent([
      Content.multi([prompt, ...imagePart])
    ]);

    print(response.text);

    return int.parse(response.text ?? '0');
  }

  Future<int> getTotalRelationships(File? classdiagramImage) async {
    String? apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    GenerationConfig config = GenerationConfig(
      maxOutputTokens: 1000000000
    );

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey, generationConfig: config);

    final image = await (File(classdiagramImage!.path).readAsBytes());
    final prompt = TextPart('''
        How many relationships are there in the given class diagram image? Only provide the number.
        ''');
    final imagePart = [DataPart('image/jpeg', image)];

    final response = await model.generateContent([
      Content.multi([prompt, ...imagePart])
    ]);

    print(response.text);

    return int.parse(response.text ?? '0');
  }

  Future<Map<String, double>> getTypesOfRelationships(File? classdiagramImage) async {
    List<String> relationshipTypes = ['association', 'aggregation', 'composition', 'inheritance', 'realization', 'dependency'];
    Map<String, double> typesOfRelationships = {
      'association': 0,
      'aggregation': 0,
      'composition': 0,
      'inheritance': 0,
      'realization': 0,
      'dependency': 0
    };
    
    Map<String, String> relationshipDescriptions = {
      'association': 'Represented by a solid line between two classes. It shows a general relationship where one class can use or interact with another class.',
      'aggregation': 'Represented by a line with a hollow diamond at the end pointing towards the whole class. It represents a "has-a" relationship where one class contains or is a part of another class, but both can exist independently.',
      'composition': 'Represented by a line with a filled diamond at the end pointing towards the whole class. It also represents a "has-a" relationship, but here the contained class cannot exist independently of the whole.',
      'inheritance': 'Represented by lines with open arrowheads pointing towards the superclass. It shows that a subclass inherits the properties and behaviors of a superclass.',
      'realization': 'Represented by a dashed line with an open arrowhead pointing towards the interface. It indicates that a class implements an interface.',
      'dependency': 'Represented by a dashed line with an arrow pointing towards the class being depended on. It shows that one class depends on another class, usually for the execution of some operation.'
    };

    String? apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    GenerationConfig config = GenerationConfig(
      maxOutputTokens: 1000000000
    );

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey, generationConfig: config);

    final image = await (File(classdiagramImage!.path).readAsBytes());

    for (int i = 0; i < relationshipTypes.length; i++) {
      final prompt = TextPart('''
          How many ${relationshipTypes[i]} relationship lines (${relationshipDescriptions[relationshipTypes[i]]}) are there in the given class diagram image? Only provide the number.
          ''');
      final imagePart = [DataPart('image/jpeg', image)];

      final response = await model.generateContent([
        Content.multi([prompt, ...imagePart])
      ]);

      print(response.text);
      typesOfRelationships[relationshipTypes[i]] = double.parse(response.text ?? '0');
    }

    return typesOfRelationships;
  }
}
