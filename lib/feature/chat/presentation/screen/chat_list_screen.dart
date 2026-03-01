import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:xocobaby13/feature/chat/model/chat_api_mapper.dart';
import 'package:xocobaby13/feature/chat/model/chat_thread_model.dart';
import 'package:xocobaby13/feature/chat/presentation/routes/chat_routes.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_search_field.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_style.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_thread_tile.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

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
  List<ChatThreadModel> _threads = <ChatThreadModel>[];
  bool _isLoading = false;
  String? _loadError;
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadThreads();
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

  Future<void> _loadThreads() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      _currentUserId = await _resolveCurrentUserId();
      final response = await Get.find<AuthorizedPigeon>().get(
        ApiEndpoints.getAllChat,
      );
      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final data = responseBody['data'];
      final List<ChatThreadModel> threads = <ChatThreadModel>[];
      if (data is List) {
        for (final dynamic item in data) {
          if (item is Map) {
            threads.add(
              ChatApiMapper.threadFromChatListItem(
                Map<String, dynamic>.from(item),
                _currentUserId,
              ),
            );
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _threads = threads;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Failed to load chats';
        _isLoading = false;
      });
    }
  }

  Future<String> _resolveCurrentUserId() async {
    try {
      final authRecord = await Get.find<AuthorizedPigeon>()
          .getCurrentAuthRecord();
      final Map<String, dynamic> data = authRecord?.data is Map
          ? Map<String, dynamic>.from(authRecord!.data as Map)
          : <String, dynamic>{};
      final dynamic raw = authRecord?.toJson();
      final Map<String, dynamic> record = raw is Map
          ? Map<String, dynamic>.from(raw as Map)
          : <String, dynamic>{};
      return _pickFirstString(<dynamic>[
        data['id'],
        data['_id'],
        data['userId'],
        record['uid'],
        record['userId'],
        record['user_id'],
        record['id'],
        record['_id'],
      ]);
    } catch (_) {
      return '';
    }
  }

  String _pickFirstString(List<dynamic> values) {
    for (final dynamic value in values) {
      final String text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
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
                      AppIconButton(
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
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _loadError != null
                        ? Center(
                            child: Text(
                              _loadError ?? 'Failed to load chats',
                              style: const TextStyle(
                                color: ChatPalette.subtitleText,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : _filteredThreads.isEmpty
                        ? const Center(
                            child: Text(
                              'No chats yet',
                              style: TextStyle(
                                color: ChatPalette.subtitleText,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 120),
                            itemCount: _filteredThreads.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (BuildContext context, int index) {
                              final ChatThreadModel thread =
                                  _filteredThreads[index];
                              return ChatThreadTile(
                                thread: thread,
                                onTap: () async {
                                  await context.push(
                                    ChatRouteNames.detail,
                                    extra: thread,
                                  );
                                  if (mounted) {
                                    _loadThreads();
                                  }
                                },
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
