class ChatMessageModel {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
