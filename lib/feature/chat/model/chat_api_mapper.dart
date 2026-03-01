import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/chat/model/chat_message_model.dart';
import 'package:xocobaby13/feature/chat/model/chat_thread_model.dart';

class ChatApiMapper {
  const ChatApiMapper._();

  static ChatThreadModel threadFromChatListItem(
    Map<String, dynamic> chat,
    String currentUserId,
  ) {
    final String chatId = _readString(chat['_id'] ?? chat['id']);
    final Map<String, dynamic>? otherUser = _extractOtherUser(
      chat,
      currentUserId,
    );
    final String name = _readString(otherUser?['fullName'], fallback: 'Chat');
    final String roleRaw = _readString(otherUser?['role'], fallback: 'User');
    final String subtitle = _roleLabel(roleRaw);
    final Map<String, dynamic>? avatar = _asMap(otherUser?['avatar']);
    final String avatarUrl = _readString(avatar?['url']);
    final String avatarLabel = _initials(name);
    final String otherUserId = _readString(otherUser?['_id']);
    final String seed = '${_readString(otherUser?['_id'])}$name$roleRaw$chatId';
    final Color avatarColor = _colorFromSeed(seed);

    final Map<String, dynamic>? lastMessage = _extractLastMessage(
      chat['messages'],
    );
    final String lastMessageText = _messagePreview(lastMessage);
    final DateTime lastMessageTime =
        _parseDateTime(lastMessage?['createdAt']) ??
        _parseDateTime(chat['updatedAt']) ??
        _parseDateTime(chat['createdAt']) ??
        DateTime.now();

    return ChatThreadModel(
      id: chatId,
      name: name,
      subtitle: subtitle,
      lastMessage: lastMessageText,
      lastMessageTime: lastMessageTime,
      avatarAssetPath: '',
      avatarUrl: avatarUrl,
      avatarColor: avatarColor,
      avatarLabel: avatarLabel,
      otherUserId: otherUserId,
    );
  }

  static List<ChatMessageModel> messagesFromChat(
    Map<String, dynamic> chat,
    String currentUserId,
  ) {
    final dynamic rawMessages = chat['messages'];
    if (rawMessages is! List) {
      return <ChatMessageModel>[];
    }
    return messagesFromList(rawMessages, currentUserId);
  }

  static List<ChatMessageModel> messagesFromList(
    List<dynamic> rawMessages,
    String currentUserId,
  ) {
    final List<ChatMessageModel> messages = <ChatMessageModel>[];
    for (final dynamic item in rawMessages) {
      if (item is! Map) continue;
      messages.add(
        messageFromMap(Map<String, dynamic>.from(item), currentUserId),
      );
    }
    return messages;
  }

  static ChatMessageModel messageFromMap(
    Map<String, dynamic> message,
    String currentUserId,
  ) {
    final String messageId = _readString(message['_id'] ?? message['id']);
    final String type = _readString(message['type'], fallback: 'text');
    final String text = _messageText(message);
    final dynamic senderRaw = message['sender'];
    final Map<String, dynamic>? sender = _asMap(senderRaw);
    final String senderId = _readString(sender?['_id'] ?? senderRaw);
    final bool isMe = currentUserId.isNotEmpty && senderId == currentUserId;
    final DateTime timestamp =
        _parseDateTime(message['createdAt']) ?? DateTime.now();
    final String? mediaUrl = _readMediaUrl(message['mediaUrl']);
    return ChatMessageModel(
      id: messageId,
      text: text,
      isMe: isMe,
      timestamp: timestamp,
      type: type,
      mediaUrl: mediaUrl,
      localPath: null,
    );
  }

  static String otherUserIdFromChat(
    Map<String, dynamic> chat,
    String currentUserId,
  ) {
    final Map<String, dynamic>? otherUser = _extractOtherUser(
      chat,
      currentUserId,
    );
    return _readString(otherUser?['_id']);
  }

  static Map<String, dynamic>? _extractOtherUser(
    Map<String, dynamic> chat,
    String currentUserId,
  ) {
    final Map<String, dynamic>? otherUser = _asMap(chat['otherUser']);
    if (otherUser != null) {
      return otherUser;
    }

    final Map<String, dynamic>? spotOwner = _asMap(chat['spotOwner']);
    final Map<String, dynamic>? fisherman = _asMap(chat['fisherman']);
    final String spotOwnerId = _readString(spotOwner?['_id']);
    final String fishermanId = _readString(fisherman?['_id']);

    if (currentUserId.isNotEmpty) {
      if (spotOwnerId == currentUserId) {
        return fisherman;
      }
      if (fishermanId == currentUserId) {
        return spotOwner;
      }
    }

    return spotOwner ?? fisherman;
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static String _readString(dynamic value, {String fallback = ''}) {
    final String text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  static String? _readMediaUrl(dynamic value) {
    if (value is Map) {
      final Map<String, dynamic> media = Map<String, dynamic>.from(value);
      final String url = _readString(media['url']);
      return url.isEmpty ? null : url;
    }
    if (value is String) {
      final String url = value.trim();
      return url.isEmpty ? null : url;
    }
    return null;
  }

  static Map<String, dynamic>? _extractLastMessage(dynamic messages) {
    if (messages is List && messages.isNotEmpty) {
      final dynamic last = messages.first;
      if (last is Map) {
        return Map<String, dynamic>.from(last);
      }
    }
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final String raw = value.toString();
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  static String _messagePreview(Map<String, dynamic>? message) {
    if (message == null) {
      return 'No messages yet';
    }
    return _messageText(message);
  }

  static String _messageText(Map<String, dynamic> message) {
    final String text = _readString(message['text']);
    if (text.isNotEmpty) {
      return text;
    }
    final String type = _readString(message['type']);
    switch (type) {
      case 'image':
        return 'Sent a photo';
      case 'video':
        return 'Sent a video';
      case 'audio':
        return 'Sent an audio';
      case 'file':
        return 'Sent a file';
      default:
        return 'Sent a message';
    }
  }

  static String _roleLabel(String roleRaw) {
    final String normalized = roleRaw.toLowerCase().replaceAll(
      RegExp(r'[^a-z]'),
      '',
    );
    if (normalized == 'spotowner') {
      return 'Spot Owner';
    }
    if (normalized == 'fisherman') {
      return 'Fisherman';
    }
    if (roleRaw.trim().isEmpty) {
      return 'User';
    }
    return roleRaw;
  }

  static String _initials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'U';
    final String first = parts.first[0].toUpperCase();
    if (parts.length == 1) {
      return first;
    }
    final String second = parts[1][0].toUpperCase();
    return '$first$second';
  }

  static Color _colorFromSeed(String seed) {
    const List<Color> palette = <Color>[
      Color(0xFFF6B26B),
      Color(0xFFF4A261),
      Color(0xFFB5838D),
      Color(0xFF8EC9D0),
      Color(0xFF7DB4FF),
      Color(0xFF9AD0A6),
      Color(0xFFE0C56E),
      Color(0xFFB7B7B7),
    ];
    if (seed.isEmpty) {
      return palette.first;
    }
    int hash = 0;
    for (final int codeUnit in seed.codeUnits) {
      hash = (hash + codeUnit) % 100000;
    }
    return palette[hash % palette.length];
  }
}
