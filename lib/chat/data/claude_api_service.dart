import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/*
Service class to handle all Claude API stuff...
*/

class ClaudeApiService {
  //API constants 
  static const String _baseUrl = "https://api.anthropic.com/v1/messages";
  static const String _apiVersion = '2023-06-01';
  static const String _model = 'claude-3-opus-20240229';
  static const int _maxTokens = 1024;

  //Store the API key securely
  final String _apiKey;

  //require api key
  ClaudeApiService({required String apiKey}) : _apiKey = apiKey;

  //Send a message to claude api and return the response

  Future<String> sendMessage(String content) async {
    try{
      //make post request to api
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _getHeaders(),
        body: _getRequestBody(content),
      );

       //check if the request is successful
       if (response.statusCode == 200){
        final data = jsonDecode(response.body); //parse json response
        return data['content'][0]['text']; //extract claude's response text
       }

       //handle unsuccessful response
       else {
        throw Exception(
          'Failed to get response from Claude: ${response.statusCode}',
        );
      }
    }
   
    catch(e) {
      //handle any errors during api call
      throw Exception('API Error $e');

    }
  }

  //create required headers for claude api
  Map<String, String> _getHeaders() => {
    'Content-Type': 'application/json',
    'x-api-key': _apiKey,
    'anthropic-version': _apiVersion,
  };

  //for mat request body according to claude api specs
  String _getRequestBody(String content) => jsonEncode({
    'model': _model,
    'messages': [
      //format message in claude's required structure
      {'role': 'user', 'content': content},
    ],
    'max_tokens': _maxTokens,
  });
}
