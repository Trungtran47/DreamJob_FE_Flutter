import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  final GenerativeModel _model;

  ChatService()
      : _model = GenerativeModel(
          model: 'models/gemini-1.5-flash',
          apiKey: dotenv.env['GOOGLE_API_KEY']!,
        );

  Future<String> callGeminiModel(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'No response';
    } catch (e) {
      print('Error: $e');
      return 'Error: $e';
    }
  }
}
