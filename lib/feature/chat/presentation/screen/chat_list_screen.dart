import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/chat/model/chat_sample_data.dart';
import 'package:xocobaby13/feature/chat/model/chat_thread_model.dart';
import 'package:xocobaby13/feature/chat/presentation/routes/chat_routes.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_search_field.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_style.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_thread_tile.dart';

class ChatListScreen extends StatefulWidget {
  final Color backgroundColor;
  final bool safeAreaBottom;

  const ChatListScreen({
    super.key,
    this.backgroundColor = ChatPalette.surface,
    this.safeAreaBottom = true,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final List<ChatThreadModel> _threads;

  @override
  void initState() {
    super.initState();
    _threads = ChatSampleData.threads;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<ChatThreadModel> get _filteredThreads {
    final String query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _threads;
    }
    return _threads
        .where(
          (ChatThreadModel thread) =>
              thread.name.toLowerCase().contains(query) ||
              thread.lastMessage.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        bottom: widget.safeAreaBottom,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ChatLayout.maxWidth),
            child: Padding(
              padding: ChatLayout.horizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 14,
                          color: ChatPalette.titleText,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Chat',
                        style: TextStyle(
                          color: ChatPalette.titleText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ChatSearchField(controller: _searchController),
                  const SizedBox(height: 14),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: _filteredThreads.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final ChatThreadModel thread = _filteredThreads[index];
                        return ChatThreadTile(
                          thread: thread,
                          onTap: () => context.push(
                            ChatRouteNames.detail,
                            extra: thread,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
