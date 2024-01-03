import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class IdentifyChat extends StatefulWidget {
  const IdentifyChat({Key? key}) : super(key: key);

  @override
  State createState() => IdentifyChatState();
}

class IdentifyChatState extends State<IdentifyChat> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  File? _selectedImage;
  final client = GoogleAIClient(apiKey: 'AIzaSyAyS5kd3SdJwAAeC6W4kd6nAbFpAsviHHE');

  @override
  void initState() {
    super.initState();
    _addBotMessage("Hi there! How can I help you today?");
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isNotEmpty && _selectedImage != null) {
      _textController.clear();
      ChatMessage message = ChatMessage(text: text, isUser: true, image: _selectedImage);
      setState(() {
        _selectedImage = null;
      });
      _addUserMessage(message);
      final resizedImage = await _resizeImage(message.image!, maxSize: 4 * 1024 * 1024);
      final res = await client.generateContent(
        modelId: 'gemini-pro-vision',
        request: GenerateContentRequest(contents: [
          Content(parts: [
            const Part(text: 'Explain me about breed of cat and its features.'),
            Part(text: message.text),
            Part(
              inlineData: Blob(
                mimeType: 'image/png',
                data: base64.encode(
                  resizedImage.readAsBytesSync(),
                ),
              ),
            ),
          ])
        ]),
      );
      final botResponse = res.candidates?.first.content?.parts?.first.text ?? "I'm sorry, I couldn't understand that.";
      _addBotMessage(botResponse);
    }
  }

  Future<File> _resizeImage(File imageFile, {required int maxSize}) async {
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(Uint8List.fromList(imageBytes));
    final resizedImage = img.copyResize(image!, width: 800);

    final resizedBytes = img.encodePng(resizedImage);

    if (resizedBytes.length > maxSize) {
      throw Exception('Resized image exceeds the maximum file size of 4MB.');
    }

    final resizedImageFile = File('${imageFile.parent.path}/resized_${imageFile.uri.pathSegments.last}');
    await resizedImageFile.writeAsBytes(resizedBytes);

    return resizedImageFile;
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

  Future<File?> _getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }

  Widget _buildTextComposer() {
    return Column(
      children: [
        _selectedImage != null
            ? Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(), // Display nothing if no image is selected
        Container(
          color: const Color(0xFF2F1B25),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          // decoration: const BoxDecoration(
          //   borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          // ),
          child: Row(
            children: <Widget>[
              Container(
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffca895f),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    File? image = await _getImage();
                    setState(() {
                      _selectedImage = image;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16.0), // Add spacing here
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
                  color: Color(0xffE3D26F),
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
        ),
      ],
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
            )),
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
  final File? image;

  const ChatMessage({super.key, required this.text, this.isUser = false, this.image});

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
                  )),
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
              const SizedBox(height: 6), // Added space between name and message
              // Display the image if available
              if (image != null)
                Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Adjust the top padding as needed
                    child: InkWell(
                      onTap: () {
                        _showImagePopup(context, image!);
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: FileImage(image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ))
              else // Display nothing if no image is available
                Container(),
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

  void _showImagePopup(BuildContext context, File image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFFFF),
          content: Container(
            width: 300.0,
            height: 300.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: FileImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
