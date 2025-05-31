import 'dart:async';

import 'package:baymax/Globals/fonts.dart';
import 'package:baymax/Globals/intros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaymaxIntro extends StatefulWidget {
  const BaymaxIntro({super.key});

  @override
  State<BaymaxIntro> createState() => _BaymaxIntroState();
}

class _BaymaxIntroState extends State<BaymaxIntro> {
  int currentStep = 0;
  String currentStreamText = '';
  bool aiIsTyping = true;
  bool showFinalButton = false;

  final List<Widget> chatWidgets = [];
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> conversation = baymaxIntroConversation;
  @override
  void initState() {
    super.initState();
    _streamNextMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _streamNextMessage() {
    if (currentStep >= conversation.length) return;
    setState(() {
      aiIsTyping = true;
      currentStreamText = '';
    });

    String rawText = conversation[currentStep]['text'];
    int index = 0;

    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (index < rawText.length) {
        setState(() {
          currentStreamText += rawText[index];
        });
        index++;
        _scrollToBottom();
      } else {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            aiIsTyping = false;
            chatWidgets.add(_buildAIMessage(currentStreamText));
          });

          currentStep++;
          if (currentStep < conversation.length) {
            Future.delayed(
                const Duration(milliseconds: 700), _streamNextMessage);
          } else {
            setState(() => showFinalButton = true);
          }
        });
      }
    });
  }

  Widget _buildAIMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.ash,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message,
            style: AppTextStyles.aiContent.copyWith(fontSize: 12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0, right: 20, left: 20),
          child: Stack(
            children: [
              // 🔽 Scrollable content underneath the image
              Positioned.fill(
                top: 0, // Height of your image area to avoid being covered
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: _scrollController,
                        padding:
                            EdgeInsets.only(top: 60), // Optional spacing at top
                        children: [
                          const SizedBox(height: 80),
                          ...chatWidgets,
                          if (aiIsTyping)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.ash,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(currentStreamText,
                                    style: AppTextStyles.aiContent
                                        .copyWith(fontSize: 12)),
                              ),
                            ),
                          const SizedBox(height: 80), // bottom space
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 🔼 Image on top (floats over list)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/afthab.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),

              // 🔘 Floating Button
              if (showFinalButton)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textash,
                        foregroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Go to Home Page",
                        style: AppTextStyles.medContent
                            .copyWith(color: AppColors.bgcolor),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
