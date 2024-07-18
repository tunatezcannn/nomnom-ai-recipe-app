import 'dart:convert';
import 'package:http/http.dart' as http;

class PexelsService {
  static const String _apiKey = 'YOUR-PEXEL-API-KEY';
  static const String _apiUrl = 'https://api.pexels.com/v1/search';

  Future<String?> getImageUrl(String query) async {
    final response = await http.get(
      Uri.parse('$_apiUrl?query=$query&per_page=1'),
      headers: {
        'Authorization': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final photos = jsonData['photos'];
      if (photos.isNotEmpty) {
        return photos[0]['src']['large'];
      }
    }
    return null;
  }
}
