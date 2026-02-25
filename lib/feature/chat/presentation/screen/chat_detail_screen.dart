import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:xocobaby13/feature/chat/model/chat_message_model.dart';
import 'package:xocobaby13/feature/chat/model/chat_sample_data.dart';
import 'package:xocobaby13/feature/chat/model/chat_thread_model.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_bubble.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_dialogs.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_input_bar.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_style.dart';

enum _ChatMenuAction { report, block }

class ChatDetailScreen extends StatefulWidget {
  final ChatThreadModel thread;

  const ChatDetailScreen({super.key, required this.thread});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _composerController = TextEditingController();
  late List<ChatMessageModel> _messages;

  @override
  void initState() {
    super.initState();
    _messages = ChatSampleData.messagesForThread(widget.thread);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _composerController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final String text = _composerController.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _messages = <ChatMessageModel>[
        ..._messages,
        ChatMessageModel(
          id: 'local_${DateTime.now().millisecondsSinceEpoch}',
          text: text,
          isMe: true,
          timestamp: DateTime.now(),
        ),
      ];
    });
    _composerController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleMenuAction(_ChatMenuAction action) async {
    switch (action) {
      case _ChatMenuAction.report:
        await ChatDialogs.showReportReasonSheet(
          context: context,
          onReasonSelected: (_) async {
            await ChatDialogs.showReportDoneDialog(
              context: context,
              onReportSpotOwner: () async {
                await ChatDialogs.showReportCompletedDialog(context: context);
              },
            );
          },
        );
        return;
      case _ChatMenuAction.block:
        final bool? confirmed = await ChatDialogs.showBlockConfirmDialog(
          context: context,
        );
        if (confirmed == true && mounted) {
          await ChatDialogs.showBlockDoneDialog(context: context);
        }
        return;
    }
  }

  Widget _buildMessageRow(ChatMessageModel message) {
    if (message.isMe) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(child: ChatBubble(text: message.text, isMe: true)),
          const SizedBox(width: 6),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: ChatPalette.statusDot,
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        CircleAvatar(
          radius: 8,
          backgroundColor: widget.thread.avatarColor,
          backgroundImage: widget.thread.avatarAssetPath.isNotEmpty
              ? AssetImage(widget.thread.avatarAssetPath)
              : null,
          child: widget.thread.avatarAssetPath.isEmpty
              ? Text(
                  widget.thread.avatarLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 6),
        Flexible(child: ChatBubble(text: message.text, isMe: false)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatPalette.surface,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: ChatPalette.titleText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: widget.thread.avatarColor,
                    backgroundImage: widget.thread.avatarAssetPath.isNotEmpty
                        ? AssetImage(widget.thread.avatarAssetPath)
                        : null,
                    child: widget.thread.avatarAssetPath.isEmpty
                        ? Text(
                            widget.thread.avatarLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
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
                          widget.thread.name,
                          style: const TextStyle(
                            color: ChatPalette.titleText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.thread.subtitle,
                          style: const TextStyle(
                            color: ChatPalette.subtitleText,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<_ChatMenuAction>(
                    onSelected: _handleMenuAction,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    offset: const Offset(0, 36),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<_ChatMenuAction>>[
                          const PopupMenuItem<_ChatMenuAction>(
                            height: 32,
                            value: _ChatMenuAction.report,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.flag_outlined, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Report',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem<_ChatMenuAction>(
                            height: 32,
                            value: _ChatMenuAction.block,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.block, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Block',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                    icon: const Icon(
                      Symbols.more_vert,
                      color: ChatPalette.titleText,
                      size: 26,
                      weight: 300,
                      grade: -25,
                      opticalSize: 20,
                      fill: 0,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: ChatPalette.divider),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final ChatMessageModel message = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildMessageRow(message),
                  );
                },
              ),
            ),
            ChatInputBar(
              controller: _composerController,
              onSend: _sendMessage,
              onAttach: () {},
            ),
          ],
        ),
      ),
    );
  }
}
