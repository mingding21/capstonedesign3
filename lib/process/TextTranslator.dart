import 'dart:convert';
import 'package:http/http.dart' as http;

class TextTranslator {
  static const String _apiKey = 'AIzaSyD5Q9Tih2Jj0oFIDlOvOgEWpo9F3LDxNWg'; // 여기에 실제 API 키를 입력하세요

  static Future<String> translateText(String text, String targetLanguage) async {
    final String _url = 'https://translation.googleapis.com/language/translate/v2?key=AIzaSyD5Q9Tih2Jj0oFIDlOvOgEWpo9F3LDxNWg';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'q': text,
          'target': targetLanguage,
          'format': 'text', // format 추가
          'key': _apiKey,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final translatedText = data['data']['translations'][0]['translatedText'];
        return translatedText;
      } else {
        print('번역 오류: ${response.statusCode}');
        print('Response body: ${response.body}');
        return '번역 오류: ${response.statusCode}';
      }
    } catch (e) {
      print('번역 오류: $e');
      return '번역 오류: $e';
    }
  }
}
