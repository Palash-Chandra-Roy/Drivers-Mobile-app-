import 'package:flutter/foundation.dart';
import 'package:yjeek_driver/features/chat/model/chat_message_model.dart';
import 'package:yjeek_driver/features/chat/service/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();

  bool _isLoading = false;
  List<ChatMessageModel> _messages = [];

  bool get isLoading => _isLoading;
  List<ChatMessageModel> get messages => _messages;

  Future<void> loadMessages() async {
    _isLoading = true;
    notifyListeners();
    _messages = await _service.getMessages();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final message = await _service.sendMessage(text.trim());
    _messages = [..._messages, message];
    notifyListeners();
  }
}
