import 'dart:async';
import 'package:baymax/Globals/convostarters.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:baymax/services/groqAI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AIPage extends StatefulWidget {
  @override
  _AIPageState createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  String? _starter;

  List<Map<String, dynamic>> _messages = [];
  String currentStreamText = '';
  bool aiIsTyping = false;
  @override
  void initState() {
    super.initState();
    _starter = (conversationStarters..shuffle()).first;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String prompt = _controller.text.trim();

    setState(() {
      _messages.add({'type': 'user', 'message': prompt});
      _controller.clear();
      _loading = true;
      _starter = null; // hide starter
    });
    FocusScope.of(context).unfocus();
    try {
      final response = await GroqAIService.processPrompt(prompt);
      String aiResponse = response['response'] ?? "";

      setState(() {
        _loading = false;
        aiIsTyping = true;
        currentStreamText = '';
      });

      _streamAIResponse(aiResponse);
    } catch (e) {
      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _streamAIResponse(String fullMessage) {
    int index = 0;

    Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (index < fullMessage.length) {
        setState(() {
          currentStreamText += fullMessage[index];
        });
        index++;
        _scrollToBottom();
      } else {
        timer.cancel();
        setState(() {
          _messages.add({'type': 'ai', 'message': currentStreamText});
          aiIsTyping = false;
        });
        currentStreamText = '';
        _scrollToBottom();
      }
    });
  }

  Widget buildMessageBubble(Map<String, dynamic> message) {
    bool isUser = message['type'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isUser ? AppColors.blue : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isUser ? Radius.circular(15) : Radius.circular(0),
            bottomRight: isUser ? Radius.circular(0) : Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // So the row shrinks to fit content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              CircleAvatar(
                radius: 22.r,
                backgroundColor: Colors.transparent, // Customize color
                backgroundImage: AssetImage('assets/afthab.png'),
              ),
              SizedBox(width: 8.w), // Add spacing between avatar and text
            ],
            Flexible(
              child: Text(
                message['message'] ?? '',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: isUser ? 16 : 14,
                  fontFamily: isUser ? 'Newsreader' : 'Silkscreen',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStreamingBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: 6, horizontal: 5), // light margin for spacing
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16.r,
              backgroundColor: Colors.transparent, // Customize color
              backgroundImage: AssetImage('assets/afthab.png'),
            ),
            SizedBox(width: 8.w), // Spacing between avatar and text
            Flexible(
              child: Text(
                text,
                style: AppTextStyles.aiContent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Stack(
        children: [
          Column(
            children: [
              // Starter should appear *inside* the scrollable area
              Expanded(
                child: _messages.isEmpty && _starter != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Ensures the column centers tightly
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Align text to left

                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/afthab.png',
                                    height: 50.h,
                                  ),
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        const Color.fromARGB(255, 3, 205, 205),
                                        Colors.teal,
                                        AppColors.blue,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: Text(
                                      'BAYMAX',
                                      style: AppTextStyles.aiContent.copyWith(
                                        fontSize: 52,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 8,
                                runSpacing: 8,
                                children: conversationStarters.map((starter) {
                                  return GestureDetector(
                                    onTap: () {
                                      _controller.text = starter;
                                      sendMessage();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: AppColors.ash,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        starter,
                                        style: AppTextStyles.aiContent
                                            .copyWith(fontSize: 12),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length + (aiIsTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < _messages.length) {
                            return buildMessageBubble(_messages[index]);
                          } else if (aiIsTyping) {
                            return buildStreamingBubble(currentStreamText);
                          }
                          return SizedBox.shrink();
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: !aiIsTyping
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Ask something...',
                                hintStyle: AppTextStyles.medContent
                                    .copyWith(color: AppColors.ash),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                filled: true,
                                fillColor: AppColors.textash,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: sendMessage,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.ash,
                              child: Icon(Icons.send, color: AppColors.blue),
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ash,
                elevation: 5,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
              child: Icon(Icons.arrow_back, color: AppColors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
