import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _useTamil = false;
  bool _firstInteraction = true;
  final FlutterTts _flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  String? _imagePath;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  void _initializeTts() async {
    await _flutterTts.setLanguage(_useTamil ? "ta-IN" : "en-IN");
    await _flutterTts.setSpeechRate(0.4);
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty || _imagePath != null) {
      setState(() {
        if (_firstInteraction) {
          _firstInteraction = false;
        }
        _messages.add({
          "sender": "user",
          "message": _controller.text,
          "isImage": _imagePath != null,
          "imagePath": _imagePath
        });
        _isTyping = true;
        _imagePath = null;
      });

      String userMessage = _controller.text;
      _controller.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      try {
        String botResponse = await _fetchBotResponse(userMessage);
        setState(() {
          _messages.add({
            "sender": "bot",
            "message": botResponse,
            "isImage": false
          });
          _isTyping = false;
        });
      } catch (e) {
        setState(() {
          _messages.add({
            "sender": "bot",
            "message": "Error connecting to the server. Please try again later.",
            "isImage": false
          });
          _isTyping = false;
        });
      }
    }
  }

  Future<String> _fetchBotResponse(String query) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyDQ6xdrvEjzxx2FNhqjHc-Pv1OS3sxpu7E');
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": query +
                  (_useTamil
                      ? " Note: The response should be clear, concise, and understandable by farmers in Tamil, specific to Indian agriculture."
                      : " Note: The response should be clear and concise, specific to Indian agriculture.")
            }
          ]
        }
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String botResponse = "";
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        var candidate = data['candidates'][0];
        if (candidate['content'] != null &&
            candidate['content']['parts'] != null &&
            candidate['content']['parts'].isNotEmpty) {
          botResponse =
              candidate['content']['parts'][0]['text'] ?? "I couldn't find an answer for that.";
        }
      }
      return botResponse;
    } else {
      throw Exception('Failed to fetch data: ${response.reasonPhrase}');
    }
  }

  Future<void> _startRecording() async {
    await Permission.microphone.request();

    setState(() => _isRecording = true);

    await _audioRecorder.startRecorder(
      toFile: 'audio_recording.aac',
      codec: Codec.aacADTS,
      bitRate: 128000,
      sampleRate: 44100,
    );
  }

  Future<void> _stopRecording() async {
    await _audioRecorder.stopRecorder();
    setState(() => _isRecording = false);
    _controller.text = "[Voice message]";
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _controller.text = "[Image attached] ${_controller.text}";
      });
    }
  }

  void _speak(String text) async {
    await _flutterTts.setLanguage(_useTamil ? "ta-IN" : "en-IN");
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          if (!_firstInteraction)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'GAI Bot',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _firstInteraction
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 120,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _useTamil ? "விவசாய உதவியாளர்" : "Agriculture Assistant",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _useTamil ? "தொடங்குவோம்!" : "Let's get started!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(10),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10),
                          Text(
                            _useTamil ? "தட்டச்சு..." : "Typing...",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final message = _messages[index];
                bool isUser = message["sender"] == "user";

                if (message["isImage"] == true && message["imagePath"] != null) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(File(message["imagePath"])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (message["message"] != null && message["message"].isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.blue.shade100 : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(message["message"]),
                          ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue.shade100 : Colors.green.shade100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(isUser ? 12 : 0),
                            bottomRight: Radius.circular(isUser ? 0 : 12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message["sender"] == "bot")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: MarkdownBody(
                                      data: message["message"],
                                      styleSheet: MarkdownStyleSheet(
                                        p: TextStyle(fontSize: 16, color: Colors.black87),
                                        strong: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.volume_up, size: 20),
                                    onPressed: () => _speak(message["message"]),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              )
                            else
                              Text(
                                message["message"],
                                style: TextStyle(fontSize: 16),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    _useTamil ? Icons.language : Icons.language_outlined,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      _useTamil = !_useTamil;
                      _initializeTts();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.image, color: Colors.green),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: _isRecording ? Colors.red : Colors.green,
                  ),
                  onPressed: () async {
                    if (_isRecording) {
                      await _stopRecording();
                    } else {
                      await _startRecording();
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: _useTamil ? "உங்கள் கேள்வியை இங்கே தட்டச்சு செய்க..." : "Type your question here...",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _scrollController.dispose();
    _audioRecorder.closeRecorder();
    super.dispose();
  }
}