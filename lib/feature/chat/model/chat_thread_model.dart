import 'package:flutter/material.dart';

class ChatThreadModel {
  final String id;
  final String name;
  final String subtitle;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String avatarAssetPath;
  final Color avatarColor;
  final String avatarLabel;

  const ChatThreadModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatarAssetPath,
    required this.avatarColor,
    required this.avatarLabel,
  });
}
