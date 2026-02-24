import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/chat/model/chat_message_model.dart';
import 'package:xocobaby13/feature/chat/model/chat_thread_model.dart';

class ChatSampleData {
  const ChatSampleData._();

  static final List<ChatThreadModel> threads = <ChatThreadModel>[
    ChatThreadModel(
      id: 'thread_1',
      name: 'Spot Owner',
      subtitle: 'Montana',
      lastMessage: "That's great. It's a calm place to hangout with...",
      lastMessageTime: DateTime(2026, 2, 10, 13, 0),
      avatarAssetPath: 'assets/images/chat/chat_avatar_1.png',
      avatarColor: const Color(0xFFF6B26B),
      avatarLabel: 'SO',
    ),
    ChatThreadModel(
      id: 'thread_2',
      name: 'Spot Owner',
      subtitle: 'Montana',
      lastMessage: "That's great. It's a calm place to hangout with...",
      lastMessageTime: DateTime(2026, 2, 10, 13, 0),
      avatarAssetPath: 'assets/images/chat/chat_avatar_2.png',
      avatarColor: const Color(0xFFF4A261),
      avatarLabel: 'SO',
    ),
    ChatThreadModel(
      id: 'thread_3',
      name: 'Spot Owner',
      subtitle: 'Montana',
      lastMessage: "That's great. It's a calm place to hangout with...",
      lastMessageTime: DateTime(2026, 2, 10, 13, 0),
      avatarAssetPath: 'assets/images/chat/chat_avatar_3.png',
      avatarColor: const Color(0xFFB5838D),
      avatarLabel: 'SO',
    ),
    ChatThreadModel(
      id: 'thread_4',
      name: 'Spot Owner',
      subtitle: 'Montana',
      lastMessage: "That's great. It's a calm place to hangout with...",
      lastMessageTime: DateTime(2026, 2, 10, 13, 0),
      avatarAssetPath: 'assets/images/chat/chat_avatar_4.png',
      avatarColor: const Color(0xFF8EC9D0),
      avatarLabel: 'SO',
    ),
    ChatThreadModel(
      id: 'thread_5',
      name: 'Spot Owner',
      subtitle: 'Montana',
      lastMessage: "That's great. It's a calm place to hangout with...",
      lastMessageTime: DateTime(2026, 2, 10, 13, 0),
      avatarAssetPath: 'assets/images/chat/chat_avatar_5.png',
      avatarColor: const Color(0xFF7DB4FF),
      avatarLabel: 'SO',
    ),
    ChatThreadModel(
      id: 'thread_6',
      name: 'Spot Owner',
      subtitle: 'Montana',
      lastMessage: "That's great. It's a calm place to hangout with...",
      lastMessageTime: DateTime(2026, 2, 10, 13, 0),
      avatarAssetPath: 'assets/images/chat/chat_avatar_6.png',
      avatarColor: const Color(0xFF9AD0A6),
      avatarLabel: 'SO',
    ),
    ChatThreadModel(
      id: 'thread_7',
      name: 'Spot Owner',
      subtitle: 'Montana',
      lastMessage: "That's great. It's a calm place to hangout with...",
      lastMessageTime: DateTime(2026, 2, 10, 13, 0),
      avatarAssetPath: 'assets/images/chat/chat_avatar_7.png',
      avatarColor: const Color(0xFFE0C56E),
      avatarLabel: 'SO',
    ),
    ChatThreadModel(
      id: 'thread_8',
      name: 'Spot Owner',
      subtitle: 'Montana',
      lastMessage: "That's great. It's a calm place to hangout with...",
      lastMessageTime: DateTime(2026, 2, 10, 13, 0),
      avatarAssetPath: 'assets/images/chat/chat_avatar_8.png',
      avatarColor: const Color(0xFFB7B7B7),
      avatarLabel: 'SO',
    ),
    ChatThreadModel(
      id: 'thread_9',
      name: 'Spot Owner',
      subtitle: 'Montana',
      lastMessage: "That's great. It's a calm place to hangout with...",
      lastMessageTime: DateTime(2026, 2, 10, 13, 0),
      avatarAssetPath: 'assets/images/chat/chat_avatar_9.png',
      avatarColor: const Color(0xFFB7B7B7),
      avatarLabel: 'SO',
    ),
  ];

  static ChatThreadModel defaultThread() => threads.first;

  static List<ChatMessageModel> messagesForThread(ChatThreadModel thread) {
    return <ChatMessageModel>[
      ChatMessageModel(
        id: '${thread.id}_m1',
        text: 'Hi',
        isMe: false,
        timestamp: DateTime(2026, 2, 10, 1, 0),
      ),
      ChatMessageModel(
        id: '${thread.id}_m2',
        text: 'Hello',
        isMe: true,
        timestamp: DateTime(2026, 2, 10, 1, 1),
      ),
      ChatMessageModel(
        id: '${thread.id}_m3',
        text:
            'I want to do fishing in your pond.\nTell me the facilities about your pond.',
        isMe: false,
        timestamp: DateTime(2026, 2, 10, 1, 2),
      ),
      ChatMessageModel(
        id: '${thread.id}_m4',
        text: "That's great. It's a calm place to hangout with your family.",
        isMe: true,
        timestamp: DateTime(2026, 2, 10, 1, 3),
      ),
      ChatMessageModel(
        id: '${thread.id}_m5',
        text: 'Okay.\nTell me more, I am interested to hear.',
        isMe: false,
        timestamp: DateTime(2026, 2, 10, 1, 4),
      ),
      ChatMessageModel(
        id: '${thread.id}_m6',
        text:
            'There are many types of fish in my pond. You can catch as your wish.',
        isMe: true,
        timestamp: DateTime(2026, 2, 10, 1, 5),
      ),
      ChatMessageModel(
        id: '${thread.id}_m7',
        text: 'Nice.',
        isMe: false,
        timestamp: DateTime(2026, 2, 10, 1, 6),
      ),
      ChatMessageModel(
        id: '${thread.id}_m8',
        text: 'Yes. You can visit anytime.',
        isMe: true,
        timestamp: DateTime(2026, 2, 10, 1, 7),
      ),
    ];
  }
}
