class ChatMessageModel {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String type;
  final String? mediaUrl;
  final String? localPath;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.type = 'text',
    this.mediaUrl,
    this.localPath,
  });
}
