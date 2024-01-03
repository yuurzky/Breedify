import 'package:flutter/material.dart';
import 'package:googleai_dart/googleai_dart.dart';

class AskChat extends StatefulWidget {
  const AskChat({Key? key}) : super(key: key);

  @override
  State createState() => AskChatState();
}

class AskChatState extends State<AskChat> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  final _chatModel = GoogleAIClient(apiKey: 'AIzaSyAyS5kd3SdJwAAeC6W4kd6nAbFpAsviHHE');

  @override
  void initState() {
    super.initState();
    _addBotMessage("Hi there! How can I help you today?");
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
    );
    _addUserMessage(message);
    final res = await _chatModel.generateContent(
      modelId: 'gemini-pro',
      request: GenerateContentRequest(contents: [
        Content(parts: [
          const Part(text: 'Explain me everything about cats that i tell you, respond only single conversation line 40 words minimum and be expressive like you talking with cat lovers!'),
          Part(text: message.text),
        ])
      ]),
    );
    final botResponse = res.candidates?.first.content?.parts?.first.text ?? "I'm sorry, I couldn't understand that.";
    _addBotMessage(botResponse);
  }

  void _addUserMessage(ChatMessage message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _addBotMessage(String text) {
    ChatMessage botMessage = ChatMessage(
      text: text,
      isUser: false,
    );
    _addUserMessage(botMessage);
  }

  Widget _buildTextComposer() {
    return Container(
      color: const Color(0xffE3D26F),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                isCollapsed: true,
                filled: true,
                fillColor: Colors.white,
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0), // Add spacing here
          Container(
            width: 40.0,
            height: 40.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2F1B25),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Breedify',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'BalsamiqSans',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(24.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({super.key, required this.text, this.isUser = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isUser
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Image.asset(
                    'assets/ai.png',
                    width: 42,
                  ),
                ),
          Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                isUser ? 'You' : 'MeowAI',
                style: TextStyle(
                  color: isUser ? Colors.black : null,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 240.0,
                ),
                decoration: BoxDecoration(
                  color: isUser ? Colors.grey[100] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Text(
                  text,
                  textAlign: isUser ? TextAlign.end : TextAlign.start,
                  style: TextStyle(
                    color: isUser ? Colors.black : null,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          isUser
              ? Container(
                  margin: const EdgeInsets.only(left: 12.0),
                  child: CircleAvatar(
                    child: Image.asset('assets/user.png'),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
