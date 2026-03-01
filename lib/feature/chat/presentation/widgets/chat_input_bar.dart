import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_style.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttach;
  final List<String> attachmentPaths;
  final ValueChanged<int>? onRemoveAttachment;
  final bool isSending;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttach,
    this.attachmentPaths = const <String>[],
    this.onRemoveAttachment,
    this.isSending = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _showEmoji = false;

  static const List<String> _emojis = <String>[
    '😀',
    '😁',
    '😂',
    '🤣',
    '😊',
    '😍',
    '😘',
    '😇',
    '🙂',
    '😉',
    '😌',
    '😋',
    '😜',
    '🤪',
    '🤗',
    '🤔',
    '😎',
    '🥳',
    '😴',
    '😡',
    '👍',
    '🙏',
    '👏',
    '🔥',
    '❤️',
    '💯',
    '🎉',
    '🥺',
    '😱',
    '😢',
  ];

  void _toggleEmoji() {
    setState(() => _showEmoji = !_showEmoji);
    if (_showEmoji) {
      FocusScope.of(context).unfocus();
    }
  }

  void _insertEmoji(String emoji) {
    final String text = widget.controller.text;
    widget.controller.text = '$text$emoji';
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.attachmentPaths.isNotEmpty)
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.attachmentPaths.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int index) {
                  final String path = widget.attachmentPaths[index];
                  return Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(path),
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: widget.onRemoveAttachment == null
                              ? null
                              : () => widget.onRemoveAttachment!(index),
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ChatPalette.inputBorder),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: _toggleEmoji,
                        child: const Icon(
                          Icons.sentiment_satisfied_alt_outlined,
                          size: 16,
                          color: ChatPalette.subtitleText,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => widget.onSend(),
                          style: const TextStyle(
                            color: ChatPalette.titleText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Type your response',
                            hintStyle: TextStyle(
                              color: ChatPalette.searchHint,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: widget.onAttach,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ChatPalette.actionBlue,
                      width: 1.4,
                    ),
                  ),
                  child: const Icon(
                    Icons.attach_file,
                    size: 16,
                    color: ChatPalette.actionBlue,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AppIconButton(
                onPressed: widget.onSend,
                isLoading: widget.isSending,
                loadingColor: Colors.white,
                icon: const Icon(
                  Icons.arrow_upward,
                  size: 16,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: ChatPalette.actionBlue,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
                constraints: const BoxConstraints.tightFor(
                  width: 32,
                  height: 32,
                ),
              ),
            ],
          ),
          if (_showEmoji) ...<Widget>[
            const SizedBox(height: 10),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ChatPalette.inputBorder),
              ),
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: _emojis.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final String emoji = _emojis[index];
                  return GestureDetector(
                    onTap: () => _insertEmoji(emoji),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 18)),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
