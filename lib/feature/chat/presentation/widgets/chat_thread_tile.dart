import 'package:flutter/material.dart';
import 'package:xocobaby13/core/helpers/extensions.dart';
import 'package:xocobaby13/feature/chat/model/chat_thread_model.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_style.dart';

class ChatThreadTile extends StatelessWidget {
  final ChatThreadModel thread;
  final VoidCallback? onTap;

  const ChatThreadTile({super.key, required this.thread, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 22,
              backgroundColor: thread.avatarColor,
              backgroundImage: thread.avatarUrl.isNotEmpty
                  ? NetworkImage(thread.avatarUrl)
                  : thread.avatarAssetPath.isNotEmpty
                  ? AssetImage(thread.avatarAssetPath)
                  : null,
              child: thread.avatarUrl.isEmpty && thread.avatarAssetPath.isEmpty
                  ? Text(
                      thread.avatarLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    thread.name,
                    style: const TextStyle(
                      color: ChatPalette.titleText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    thread.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ChatPalette.subtitleText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              thread.lastMessageTime.toChatTimeString().toLowerCase(),
              style: const TextStyle(
                color: ChatPalette.subtitleText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
