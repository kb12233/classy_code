import 'dart:io';

import 'package:classy_code/models/insight_data.dart';
import 'package:classy_code/subsystems/conversion/code_generator.dart';
import 'package:classy_code/subsystems/conversion/insights_data_retriever.dart';

class ImageToCodeConverter {
  final CodeGenerator codeGenerator = CodeGenerator();
  final InsightsDataRetriever insightsDataRetriever = InsightsDataRetriever();

  Future<String?> convert(File classdiagramImage, String language) {
    return codeGenerator.generate(classdiagramImage, language);
  }

  Future<InsightsData> extractInsights(File classdiagramImage) {
    return InsightsDataRetriever.getInsights(classdiagramImage);
  }
}
