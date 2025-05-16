import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum MessageType {
  text,
  image,
  document,
  audio,
  video,
  file, 
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final String? imagePath;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type.index,
      'imagePath': imagePath,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isUser: json['isUser'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      type: MessageType.values[json['type'] ?? 0],
      imagePath: json['imagePath'],
    );
  }
}

class ChatHistoryModel {
  final GetStorage _storage = GetStorage();
  static const String _chatHistoryKey = 'chat_history';

  final RxMap<String, RxList<ChatMessage>> _chatHistory =
      RxMap<String, RxList<ChatMessage>>();

  static final ChatHistoryModel _instance = ChatHistoryModel._internal();

  factory ChatHistoryModel() {
    return _instance;
  }

  ChatHistoryModel._internal() {
    _loadChatHistory();
  }

  void _loadChatHistory() {
    final Map<String, dynamic>? storedHistory = _storage.read(_chatHistoryKey);

    if (storedHistory != null) {
      storedHistory.forEach((expertId, messages) {
        final List<dynamic> messagesList = messages as List<dynamic>;
        _chatHistory[expertId] = RxList<ChatMessage>(
          messagesList.map((msg) => ChatMessage.fromJson(msg)).toList(),
        );
      });
    }
  }

  void _saveChatHistory() {
    final Map<String, dynamic> historyToSave = {};

    _chatHistory.forEach((expertId, messages) {
      historyToSave[expertId] = messages.map((msg) => msg.toJson()).toList();
    });

    _storage.write(_chatHistoryKey, historyToSave);
  }

  RxList<ChatMessage> getChatHistory(String expertId) {
    if (!_chatHistory.containsKey(expertId)) {
      _chatHistory[expertId] = RxList<ChatMessage>([]);
    }
    return _chatHistory[expertId]!;
  }

  void addMessage(String expertId, ChatMessage message) {
    if (!_chatHistory.containsKey(expertId)) {
      _chatHistory[expertId] = RxList<ChatMessage>([]);
    }

    _chatHistory[expertId]!.add(message);
    _saveChatHistory();
  }

  void clearChatHistory(String expertId) {
    if (_chatHistory.containsKey(expertId)) {
      _chatHistory[expertId]!.clear();
      _saveChatHistory();
    }
  }

  void clearAllChatHistory() {
    _chatHistory.clear();
    _storage.remove(_chatHistoryKey);
  }
}
