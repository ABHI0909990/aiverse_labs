import 'dart:io';
import 'dart:math' show sin, pi;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constant/font_family.dart';
import '../../customWIdgets/GradientAppBar.dart';
import 'ChatController.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, dynamic> expert;

  const ChatScreen({Key? key, required this.expert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(
      ChatController(expert: expert),
      tag: expert['name'] as String,
    );

    final theme = Theme.of(context);

    return Scaffold(
      appBar: GradientAppBar(
        title: expert['name'] as String,
        titleStyle: TextStyle(
          fontFamily: AppFonts.family2SemiBold,
          fontSize: 18.sp,
          color: theme.textTheme.titleLarge?.color,
        ),
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.history,
              color: theme.iconTheme.color,
            ),
            tooltip: 'Chat History',
            onPressed: () => chatController.showChatHistory(context),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage(expert['image'] as String),
              radius: 16,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            if (!chatController.isProUser &&
                chatController.remainingUploads.value > 0) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Uploads remaining: ${chatController.remainingUploads.value}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Spacer(),
                    if (!chatController.isProUser)
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Upgrade to Pro'),
                              content: Text(
                                  'Get unlimited uploads and enhanced AI responses with Pro!'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Later'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Upgrade'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          'Upgrade',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
          Obx(() {
            if (chatController.isUploading.value) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cloud_upload,
                            size: 16, color: theme.colorScheme.primary),
                        SizedBox(width: 8),
                        Text(
                          'Uploading file...',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${(chatController.uploadProgress.value * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: chatController.uploadProgress.value,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 48,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Start a conversation with ${expert['name']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ask a question or upload a file',
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
                itemCount: chatController.messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isUser = message['isUser'] as bool;
                  final messageType = message['type'] as int? ?? 0;
                  final imagePath = message['imagePath'] as String?;
                  final timestamp =
                      message['timestamp'] as DateTime? ?? DateTime.now();
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
                            padding: messageType == 1
                                ? EdgeInsets.all(8)
                                : EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? theme.colorScheme.primary
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(20).copyWith(
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
                                if (messageType == 1 && imagePath != null) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(imagePath),
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (message['text'] != null &&
                                      (message['text'] as String).isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, left: 4, right: 4, bottom: 4),
                                      child: Text(
                                        message['text'] as String,
                                        style: TextStyle(
                                          color: isUser
                                              ? Colors.white
                                              : theme
                                                  .textTheme.bodyLarge?.color,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                ] else if (isUser) ...[
                                  // User messages use regular Text widget
                                  Text(
                                    message['text'] as String,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ] else ...[
                                  // AI messages use Markdown widget for formatted text
                                  MarkdownBody(
                                    data: message['text'] as String,
                                    styleSheet: MarkdownStyleSheet(
                                      p: TextStyle(
                                        color: theme.textTheme.bodyLarge?.color,
                                        fontSize: 14,
                                      ),
                                      strong: TextStyle(
                                        color: theme.textTheme.bodyLarge?.color,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      h1: TextStyle(
                                        color:
                                            theme.textTheme.titleLarge?.color,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      h2: TextStyle(
                                        color:
                                            theme.textTheme.titleMedium?.color,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      h3: TextStyle(
                                        color:
                                            theme.textTheme.titleSmall?.color,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      listBullet: TextStyle(
                                        color: theme.textTheme.bodyLarge?.color,
                                        fontSize: 14,
                                      ),
                                      code: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontSize: 13,
                                        fontFamily: 'monospace',
                                        backgroundColor:
                                            theme.colorScheme.surface,
                                      ),
                                      codeblockDecoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    selectable: true,
                                  ),
                                ],
                                SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      _formatTime(timestamp),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isUser
                                            ? Colors.white.withOpacity(0.7)
                                            : theme.textTheme.bodySmall?.color,
                                      ),
                                    ),
                                    if (isUser) ...[
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ],
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
          Obx(() {
            if (chatController.isLoading.value) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(expert['image'] as String),
                      radius: 16,
                    ),
                    SizedBox(width: 8),
                    _buildTypingIndicator(theme),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
            child: SafeArea(
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => chatController.pickAndUploadFile(),
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.attach_file,
                          color: theme.iconTheme.color,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: chatController.textController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: theme.inputDecorationTheme.fillColor ??
                            theme.cardColor.withOpacity(0.5),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Material(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap: () {
                        if (chatController.textController.text
                            .trim()
                            .isNotEmpty) {
                          chatController
                              .sendMessage(chatController.textController.text);
                          chatController.textController.clear();
                        }
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Row(
      children: [
        for (int i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.only(right: 2),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600 + (i * 200)),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, -3 * sin(value * pi)),
                  child: child,
                );
              },
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        SizedBox(width: 8),
        Text(
          'Typing...',
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
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
}
