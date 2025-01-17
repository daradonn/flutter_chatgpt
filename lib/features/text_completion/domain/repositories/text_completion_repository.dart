import 'package:flutter_chatgpt/features/text_completion/data/model/text_completion_model.dart';

import '../../data/model/turbo_data.dart';

abstract class TextCompletionRepository {
  Future<TextCompletionModel> getTextCompletion(String query);

  Future<TextCompletionModelTurbo> getTextCompletionTurbo(
      String query, String role);
}
