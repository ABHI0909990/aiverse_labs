import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../constant/font_family.dart';
import '../../models/chat_history_model.dart';
import '../../models/image_upload_model.dart';
import '../../models/subscription_model.dart';
import '../../services/AIService.dart';

class ChatController extends GetxController {
  final Map<String, dynamic> expert;
  final AIService _aiService = AIService();
  final TextEditingController textController = TextEditingController();
  final ImageUploadModel _imageUploadModel = ImageUploadModel();
  final SubscriptionModel _subscriptionModel = SubscriptionModel();
  final ChatHistoryModel _chatHistoryModel = ChatHistoryModel();
  final ImagePicker _imagePicker = ImagePicker();

  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxInt remainingUploads = 0.obs;
  final RxList<ChatMessage> chatHistory = <ChatMessage>[].obs;

  ChatController({required this.expert}) {
    _addAIMessage(_getGreetingMessage());
    _updateRemainingUploads();
    _loadChatHistory();
  }

  void _updateRemainingUploads() {
    remainingUploads.value = _imageUploadModel.remainingUploads;
  }

  void _loadChatHistory() {
    chatHistory.value =
        _chatHistoryModel.getChatHistory(expert['name']).toList();
  }

  void showChatHistory(BuildContext context) {
    _loadChatHistory();

    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(bottom: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Chat History',
                        style: TextStyle(
                          fontFamily: AppFonts.family2SemiBold,
                          fontSize: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (chatHistory.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 48,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No chat history yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start a conversation with ${expert['name']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    final message = chatHistory[index];
                    final isUser = message.isUser;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser) ...[
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(expert['image'] as String),
                              radius: 16,
                            ),
                            SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Container(
                              padding: message.type == MessageType.image
                                  ? EdgeInsets.all(8)
                                  : EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? theme.colorScheme.primary
                                    : theme.cardColor,
                                borderRadius:
                                    BorderRadius.circular(20).copyWith(
                                  topLeft: isUser
                                      ? Radius.circular(20)
                                      : Radius.circular(4),
                                  topRight: isUser
                                      ? Radius.circular(4)
                                      : Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (message.type == MessageType.image &&
                                      message.imagePath != null) ...[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(message.imagePath!),
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (message.text.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            left: 4,
                                            right: 4,
                                            bottom: 4),
                                        child: Text(
                                          message.text,
                                          style: TextStyle(
                                            color: isUser
                                                ? Colors.white
                                                : theme
                                                    .textTheme.bodyLarge?.color,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                  ] else ...[
                                    Text(
                                      message.text,
                                      style: TextStyle(
                                        color: isUser
                                            ? Colors.white
                                            : theme.textTheme.bodyLarge?.color,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatTime(message.timestamp),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isUser
                                              ? Colors.white.withOpacity(0.7)
                                              : theme
                                                  .textTheme.bodySmall?.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isUser) SizedBox(width: 8),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Close'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showClearHistoryConfirmation(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(color: theme.colorScheme.error),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Clear History'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryConfirmation(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Chat History'),
        content: Text(
            'Are you sure you want to clear your chat history with ${expert['name']}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _chatHistoryModel.clearChatHistory(expert['name']);
              chatHistory.clear();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              Get.snackbar(
                'Chat History Cleared',
                'Your chat history with ${expert["name"]} has been cleared.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                colorText: theme.colorScheme.primary,
                duration: Duration(seconds: 2),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  bool get isProUser => _subscriptionModel.hasProAccess;

  Future<void> pickAndUploadFile() async {
    if (!_imageUploadModel.canUploadImage()) {
      Get.snackbar(
        'Upload Limit Reached',
        'You have reached your daily upload limit. Upgrade to Pro for unlimited uploads.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      return;
    }

    final fileType = await _showFileTypeSelectionDialog();
    if (fileType == null) return;

    XFile? pickedFile;
    MessageType messageType;
    String messageText;

    switch (fileType) {
      case 'image':
        pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
        );
        messageType = MessageType.image;
        messageText = 'Sent an image';
        break;
      case 'video':
        pickedFile = await _imagePicker.pickVideo(
          source: ImageSource.gallery,
        );
        messageType = MessageType.video;
        messageText = 'Sent a video';
        break;
      case 'document':
        pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
        );
        messageType = MessageType.document;
        messageText = 'Sent a document';
        break;
      default:
        pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
        );
        messageType = MessageType.image;
        messageText = 'Sent a file';
    }

    if (pickedFile != null) {
      try {
        isUploading.value = true;
        uploadProgress.value = 0.0;

        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
        final String filePath = '${appDocDir.path}/$fileName';

        final File file = File(pickedFile.path);

        for (int i = 1; i <= 10; i++) {
          await Future.delayed(Duration(milliseconds: 100));
          uploadProgress.value = i / 10;
        }
        await file.copy(filePath);
        _addUserFileMessage(messageText, filePath, messageType);
        if (!isProUser) {
          _imageUploadModel.incrementUploadCount();
          _updateRemainingUploads();
        }
        _getAIResponse('I sent you a file. Please respond to it.');
      } finally {
        isUploading.value = false;
        uploadProgress.value = 0.0;
      }
    }
  }

  Future<String?> _showFileTypeSelectionDialog() async {
    return await Get.dialog<String>(
      AlertDialog(
        title: Text('Select File Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Image'),
              onTap: () => Get.back(result: 'image'),
            ),
            ListTile(
              leading: Icon(Icons.video_file),
              title: Text('Video'),
              onTap: () => Get.back(result: 'video'),
            ),
            ListTile(
              leading: Icon(Icons.insert_drive_file),
              title: Text('Document'),
              onTap: () => Get.back(result: 'document'),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    _addUserMessage(text);
    _getAIResponse(text);
  }

  void _addUserMessage(String text) {
    final ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    _chatHistoryModel.addMessage(expert['name'], message);

    messages.insert(0, {
      'text': text,
      'isUser': true,
      'timestamp': DateTime.now(),
      'type': MessageType.text.index,
      'imagePath': null,
    });
  }

  void _addUserFileMessage(String text, String filePath, MessageType type) {
    final ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      type: type,
      imagePath: filePath,
    );

    _chatHistoryModel.addMessage(expert['name'], message);

    messages.insert(0, {
      'text': text,
      'isUser': true,
      'timestamp': DateTime.now(),
      'type': type.index,
      'imagePath': filePath,
    });
  }

  void _addAIMessage(String text) {
    final ChatMessage message = ChatMessage(
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    );

    _chatHistoryModel.addMessage(expert['name'], message);

    messages.insert(0, {
      'text': text,
      'isUser': false,
      'timestamp': DateTime.now(),
      'type': MessageType.text.index,
      'imagePath': null,
    });
  }

  void _getAIResponse(String userMessage) {
    isLoading.value = true;

    List<Map<String, dynamic>> conversationHistory = [];

    if (messages.length > 1) {
      int historyLength = messages.length > 10 ? 10 : messages.length;
      conversationHistory =
          messages.sublist(1, historyLength).reversed.toList();
    }

    Future.delayed(Duration(seconds: 1), () {
      _aiService
          .getResponse(
        userMessage: userMessage,
        expertName: expert['name'] as String,
        expertise: expert['expertise'] as String,
        conversationHistory:
            conversationHistory.isNotEmpty ? conversationHistory : null,
        useNegativePrompting: isProUser,
      )
          .then((response) {
        // Refine the AI response to make it more user-friendly
        final refinedResponse = _refineAIResponse(response);
        _addAIMessage(refinedResponse);
        isLoading.value = false;
      }).catchError((error) {
        _addAIMessage('Sorry, I encountered an error. Please try again.');
        isLoading.value = false;
      });
    });
  }

  /// Refines the AI response to make it more user-friendly and easier to understand.
  /// This includes formatting, simplifying complex terms, and highlighting key points.
  String _refineAIResponse(String response) {
    if (response.isEmpty) return response;

    // If the response is very short, return it as is
    if (response.length < 100) return response;

    // Split the response into paragraphs
    List<String> paragraphs = response.split('\n\n');
    List<String> refinedParagraphs = [];

    for (String paragraph in paragraphs) {
      // Skip empty paragraphs
      if (paragraph.trim().isEmpty) continue;

      // Format code blocks - preserve them as they are
      if (paragraph.contains('```')) {
        refinedParagraphs.add(paragraph);
        continue;
      }

      // Check if paragraph is a list (starts with - or * or number.)
      if (paragraph.trim().startsWith('-') ||
          paragraph.trim().startsWith('*') ||
          RegExp(r'^\d+\.').hasMatch(paragraph.trim())) {
        refinedParagraphs.add(paragraph);
        continue;
      }

      // For regular paragraphs, add formatting to highlight key points
      String refined = paragraph;

      // Highlight key phrases
      final keyPhrases = [
        'important',
        'key',
        'note',
        'remember',
        'caution',
        'warning',
        'tip',
        'best practice',
        'recommendation'
      ];

      for (final phrase in keyPhrases) {
        if (refined.toLowerCase().contains(phrase)) {
          // Find the sentence containing the key phrase
          final sentences = refined.split('. ');
          for (int i = 0; i < sentences.length; i++) {
            if (sentences[i].toLowerCase().contains(phrase)) {
              // Add emphasis to the sentence
              sentences[i] = '**${sentences[i]}**';
            }
          }
          refined = sentences.join('. ');
        }
      }

      // Add a summary if the paragraph is long (more than 200 characters)
      if (paragraph.length > 200 && !refined.startsWith('**Summary:**')) {
        // Extract key points for a summary
        final sentences = paragraph.split('. ');
        if (sentences.length > 3) {
          String summary = '**Summary:** ';

          // Use the first sentence as part of the summary
          if (sentences[0].length < 100) {
            summary += sentences[0] + '. ';
          }

          // Add a simplified version of the paragraph
          summary += 'This explains ';

          if (paragraph.toLowerCase().contains('how to')) {
            summary += 'how to perform a specific task. ';
          } else if (paragraph.toLowerCase().contains('why')) {
            summary += 'why something works the way it does. ';
          } else if (paragraph.toLowerCase().contains('what')) {
            summary += 'what a concept means. ';
          } else {
            summary += 'important information about this topic. ';
          }

          refined = '$summary\n\n$refined';
        }
      }

      refinedParagraphs.add(refined);
    }

    // Join the paragraphs back together
    String refinedResponse = refinedParagraphs.join('\n\n');

    // Add a "Key Takeaways" section at the end for long responses
    if (response.length > 500 && !refinedResponse.contains('Key Takeaways')) {
      refinedResponse += '\n\n**Key Takeaways:**\n';

      // Extract sentences with important keywords
      final sentences = response.split('. ');
      List<String> keyTakeaways = [];

      final importantKeywords = [
        'important',
        'key',
        'essential',
        'critical',
        'crucial',
        'remember',
        'note',
        'best practice',
        'recommendation'
      ];

      for (final sentence in sentences) {
        for (final keyword in importantKeywords) {
          if (sentence.toLowerCase().contains(keyword) &&
              keyTakeaways.length < 3 &&
              !keyTakeaways.contains(sentence)) {
            keyTakeaways.add('- ' + sentence.trim() + '.');
            break;
          }
        }
      }

      // If we couldn't find sentences with keywords, use the first and last sentences
      if (keyTakeaways.isEmpty && sentences.length > 2) {
        keyTakeaways.add('- ' + sentences.first.trim() + '.');
        keyTakeaways.add('- ' + sentences.last.trim() + '.');
      }

      refinedResponse += keyTakeaways.join('\n');
    }

    return refinedResponse;
  }

  String _getGreetingMessage() {
    final name = expert['name'] as String;
    final expertise = expert['expertise'] as String;

    return 'Hello! I\'m $name, an AI expert in $expertise. How can I help you today?';
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
