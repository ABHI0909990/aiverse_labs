import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/chat_history_model.dart';
import 'package:aiverse_labs/services/AIService.dart';

class ChatController extends GetxController {
  final Map<String, dynamic> expert;
  ChatController({required this.expert});

  final TextEditingController textController = TextEditingController();
  final TextEditingController negativePromptController =
      TextEditingController();
  final ScrollController scrollController = ScrollController();
  final AIService _aiService = AIService();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isProUser = true.obs; // Make this dynamic later

  @override
  void onInit() {
    super.onInit();
    // Initial message from the expert
    messages.add(ChatMessage(
      text:
          "Hello! I'm ${expert['name']}, an expert in ${expert['expertise']}. How can I assist you today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void sendMessage() async {
    final text = textController.text;
    if (text.isEmpty) return;

    // Add user message to chat
    messages
        .add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
    textController.clear();
    isLoading.value = true;
    _scrollToBottom();

    // Get AI response
    final response = await _aiService.getAIResponse(
      text,
      negativePrompt: isProUser.value ? negativePromptController.text : null,
    );

    // Add AI response to chat
    messages.add(
        ChatMessage(text: response, isUser: false, timestamp: DateTime.now()));
    isLoading.value = false;
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
