import 'package:dio/dio.dart';

class ChatGptService {
  final Dio _dio = Dio();
  final String _apiKey = 'API-KEY'; // Replace with your actual API key
  final String _baseUrl = 'https://api.openai.com/v1';

  Future<Map<String, dynamic>?> sendGPTMessage(String prompt) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        data: {
          "model": "gpt-3.5-turbo",
          "messages": [{"role": "user", "content": prompt}]
        },
        options: Options(headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error sending GPT message: $e');
      return null;
    }
  }
}
