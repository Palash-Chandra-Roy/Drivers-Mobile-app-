import 'package:yjeek_driver/features/chat/model/chat_message_model.dart';

class ChatService {
  Future<List<ChatMessageModel>> getMessages() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();
    return [
      ChatMessageModel(
        id: '1',
        message: 'Hi, you have a new order assigned.',
        sender: 'Dispatch',
        createdAt: now.subtract(const Duration(minutes: 10)),
      ),
      ChatMessageModel(
        id: '2',
        message: 'On my way to pickup.',
        sender: 'Me',
        createdAt: now.subtract(const Duration(minutes: 8)),
        isMe: true,
      ),
      ChatMessageModel(
        id: '3',
        message: 'Great! Customer is waiting.',
        sender: 'Dispatch',
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  Future<ChatMessageModel> sendMessage(String message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      sender: 'Me',
      createdAt: DateTime.now(),
      isMe: true,
    );
  }
}
