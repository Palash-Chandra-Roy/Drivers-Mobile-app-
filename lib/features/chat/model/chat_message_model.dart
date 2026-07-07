class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.message,
    required this.sender,
    required this.createdAt,
    this.isMe = false,
  });

  final String id;
  final String message;
  final String sender;
  final DateTime createdAt;
  final bool isMe;
}
