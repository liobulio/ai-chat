import 'package:ai_chat/chat/presentation/chat_bubble.dart';
import 'package:ai_chat/chat/presentation/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //top: chat messages
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  if (chatProvider.messages.isEmpty) {
                    return const Center(
                      child: Text('Start a conversation'),
                    );
                  }
        
                  //displau chat messages
                  return ListView.builder(
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      //get each message
                      final message = chatProvider.messages[index];
        
                      //return messages
                      return ChatBubble(message: message);
                    },
                  );
                },
              ),
            ),

            //loading indicator
            Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.isLoading) {
                  return const CircularProgressIndicator();
                }
                return SizedBox();
              },
            ),
        
            //user input box
            Row(
              children: [
                //left: text field
                Expanded(
                  child: TextField(controller: _controller),
                ),
                //right: send bottom
                IconButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty){
                      final chatProvider = context.read<ChatProvider>();
                      chatProvider.sendMessage(_controller.text);
                      _controller.clear();
                    }
                  }, 
                  icon: const Icon(Icons.send),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}