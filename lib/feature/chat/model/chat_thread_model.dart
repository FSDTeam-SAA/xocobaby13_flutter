import 'package:flutter/material.dart';

class ChatThreadModel {
  final String id;
  final String name;
  final String subtitle;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String avatarAssetPath;
  final String avatarUrl;
  final Color avatarColor;
  final String avatarLabel;
  final String otherUserId;

  const ChatThreadModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatarAssetPath,
    this.avatarUrl = '',
    required this.avatarColor,
    required this.avatarLabel,
    this.otherUserId = '',
  });
}
