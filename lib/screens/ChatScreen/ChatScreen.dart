import 'package:aiverse_labs/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constant/font_family.dart';
import 'ChatController.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, dynamic> expert;

  ChatScreen({Key? key, required this.expert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController(expert: expert));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(context, theme),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return _buildMessageBubble(message, theme, context);
                  },
                )),
          ),
          if (controller.isLoading.value)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          _buildMessageInput(controller, theme),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: _getExpertImage(),
            radius: 20,
            onBackgroundImageError: (exception, stackTrace) {
              // Handle image loading error
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expert['name'] as String? ?? 'Unknown Expert',
                  style: TextStyle(
                    fontFamily: AppFonts.family2SemiBold,
                    fontSize: 16.sp,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.green,
                        fontFamily: AppFonts.family2Regular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Add menu functionality
          },
          icon: const Icon(Icons.more_vert),
          tooltip: 'More options',
        ),
      ],
    );
  }

  ImageProvider _getExpertImage() {
    final imageUrl = expert['image'] as String? ?? '';
    if (imageUrl.startsWith('resources/assets/')) {
      return AssetImage(imageUrl);
    } else {
      return NetworkImage(imageUrl);
    }
  }

  Widget _buildMessageBubble(
      dynamic message, ThemeData theme, BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(20).copyWith(
            topLeft: isUser ? const Radius.circular(20) : Radius.zero,
            topRight: isUser ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: MarkdownBody(
          data: message.text,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
              fontFamily: AppFonts.family2Regular,
              fontSize: 14.sp,
            ),
            h1: TextStyle(
              color:
                  isUser ? Colors.white : theme.textTheme.headlineLarge?.color,
              fontFamily: AppFonts.family2Bold,
              fontSize: 18.sp,
            ),
            h2: TextStyle(
              color:
                  isUser ? Colors.white : theme.textTheme.headlineMedium?.color,
              fontFamily: AppFonts.family2SemiBold,
              fontSize: 16.sp,
            ),
            h3: TextStyle(
              color:
                  isUser ? Colors.white : theme.textTheme.headlineSmall?.color,
              fontFamily: AppFonts.family2SemiBold,
              fontSize: 15.sp,
            ),
            code: TextStyle(
              color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
              fontFamily: 'monospace',
              fontSize: 13.sp,
              backgroundColor: isUser
                  ? Colors.white.withOpacity(0.2)
                  : theme.colorScheme.primary.withOpacity(0.1),
            ),
            codeblockDecoration: BoxDecoration(
              color: isUser
                  ? Colors.white.withOpacity(0.2)
                  : theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(ChatController controller, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            if (controller.isProUser.value)
              _buildNegativePromptInput(controller, theme),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.scaffoldBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      hintStyle: TextStyle(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                        fontFamily: AppFonts.family2Regular,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => controller.sendMessage(),
                  child: const Icon(Icons.send),
                  mini: true,
                  tooltip: 'Send message',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNegativePromptInput(ChatController controller, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.negativePromptController,
              decoration: InputDecoration(
                hintText: 'Negative prompt (Pro feature)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                prefixIcon: Icon(Icons.remove_circle_outline,
                    size: 20, color: theme.iconTheme.color?.withOpacity(0.6)),
                hintStyle: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  fontFamily: AppFonts.family2Regular,
                ),
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('PRO',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.family2SemiBold,
                    fontSize: 12)),
          )
        ],
      ),
    );
  }
}
