import 'dart:io';
import 'package:classy_code/models/history_model.dart';
import 'package:classy_code/models/insight_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class InsightsDataRetriever {
  static Future<int> getTotalClasses(File? classdiagramImage) async {
    String? apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    GenerationConfig config = GenerationConfig(maxOutputTokens: 1000000000);

    final model = GenerativeModel(
        model: 'gemini-1.5-flash', apiKey: apiKey, generationConfig: config);

    final image = await (File(classdiagramImage!.path).readAsBytes());
    final prompt = TextPart('''
        How many classifiers (e.g. classes, interfaces, and enumerations) are there in the given class diagram image? Only provide the number.
        ''');
    final imagePart = [DataPart('image/jpeg', image)];

    final response = await model.generateContent([
      Content.multi([prompt, ...imagePart])
    ]);

    print(response.text);

    // remove period at the end of the response if it exists
    if (response.text!.endsWith('.')) {
      String responseCopy =
          response.text!.substring(0, response.text!.length - 1);
      return int.parse(responseCopy);
    }

    return int.parse(response.text ?? '0');
  }

  static Future<int> getTotalRelationships(File? classdiagramImage) async {
    String? apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    GenerationConfig config = GenerationConfig(maxOutputTokens: 1000000000);

    final model = GenerativeModel(
        model: 'gemini-1.5-flash', apiKey: apiKey, generationConfig: config);

    final image = await (File(classdiagramImage!.path).readAsBytes());
    final prompt = TextPart('''
        How many relationships are there in the given class diagram image? Only provide the number.
        ''');
    final imagePart = [DataPart('image/jpeg', image)];

    final response = await model.generateContent([
      Content.multi([prompt, ...imagePart])
    ]);

    print(response.text);

    // remove period at the end of the response if it exists
    if (response.text!.endsWith('.')) {
      String responseCopy =
          response.text!.substring(0, response.text!.length - 1);
      return int.parse(responseCopy);
    }

    return int.parse(response.text ?? '0');
  }

  static Future<List<String>> getTypesOfRelationships(
      File? classdiagramImage) async {
    String? apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    GenerationConfig config = GenerationConfig(maxOutputTokens: 1000000000);

    final model = GenerativeModel(
        model: 'gemini-1.5-flash', apiKey: apiKey, generationConfig: config);

    final image = await (File(classdiagramImage!.path).readAsBytes());

    final prompt = TextPart('''
      Analyze the UML class diagram in the provided image. Detect the types of relationships present among the classes. The types of relationships you should detect include:

      - Association
      - Aggregation
      - Composition
      - Dependency
      - Inheritance
      - Realization

      Based on your analysis of the diagram, return a list of all the relationship types present, using the following format:

      [relationship_type_1, relationship_type_2, ...]

      For example, if the diagram contains both inheritance and association relationships, the response should be: [association, inheritance]. Please ensure that the list is accurate and includes only the relationship types detected in the diagram.
    ''');
    final imagePart = [DataPart('image/jpeg', image)];
    final response = await model.generateContent([
      Content.multi([prompt, ...imagePart])
    ]);
    print(response.text); // v -> "['association', 'inheritance']"

    String cleanedResponse =
        response.text!.replaceAll(RegExp(r'[\[\]]'), '').trim();
    print("Cleaned response: " + cleanedResponse);

    List<String> relationshipTypes =
        cleanedResponse.split(',').map((type) => type.trim()).toList();

    // remove quotes from each relationship type in the list
    for (int i = 0; i < relationshipTypes.length; i++) {
      if ((relationshipTypes[i].startsWith('"') ||
              relationshipTypes[i].startsWith('\'')) &&
          (relationshipTypes[i].endsWith('"') ||
              relationshipTypes[i].endsWith('\''))) {
        relationshipTypes[i] =
            relationshipTypes[i].substring(1, relationshipTypes[i].length - 1);
      }
    }

    List<String> dumList = ['haha', 'hoho', 'hihi'];

    print(relationshipTypes);
    print(dumList);

    return relationshipTypes;
  }

  static Future<InsightsData> getInsights(File? classdiagramImage) async {
    int totalClasses = await getTotalClasses(classdiagramImage);
    int totalRelationships = await getTotalRelationships(classdiagramImage);
    List<String> typesOfRelationships =
        await getTypesOfRelationships(classdiagramImage);

    InsightsData insightsData = InsightsData(
        totalClasses: totalClasses,
        totalRelationships: totalRelationships,
        typesOfRelationships: typesOfRelationships);

    return insightsData;
  }
}
