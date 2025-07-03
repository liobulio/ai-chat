import 'package:ai_chat/chat/data/claude_api_service.dart';
import 'package:ai_chat/chat/model/message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ChatProvider with ChangeNotifier{
  //claude api service
  final _apiService = ClaudeApiService(
    apiKey:
        "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",
  );

  //message and loading...
  final List<Message> _messages = [];
  bool _isLoading = false;

  //getters
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  //send messages
  Future<void> sendMessage(String content) async{
    //prevent empty sent
    if (content.trim().isEmpty) return;

  //user message
    final userMessage = Message(
      content: content,
      isUser: true,
      timeStamp: DateTime.now(),
    );

    //add user message to chat
    _messages.add(userMessage);

    //update ui 
    notifyListeners();

    //start loading..
    _isLoading = true;

    //update ui
    notifyListeners();

    //send message and receibe response
    try{
      final response = await _apiService.sendMessage(content);

      //response message from ai
      final responseMessage = Message(
        content: response,
        isUser: false,
        timeStamp: DateTime.now(),
      );

      _messages.add(responseMessage);
    }

    //error...
    catch(e){
      //error message 
      final errorMessage = Message(
        content: "Sorry, I encountered an issue... $e",
        isUser: false,
        timeStamp: DateTime.now(),
      );

      //add message to chat
      _messages.add(errorMessage);

      //finished loading...
      _isLoading = false;

      //update ui
      notifyListeners();
    }
}
}
