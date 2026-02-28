import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = false;
  bool _isUpdatingAll = false;
  String? _loadError;
  List<_NotificationItem> _items = const <_NotificationItem>[];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  Future<void> _loadNotifications({bool showLoader = true}) async {
    if (_isLoading) return;
    if (showLoader) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    } else {
      setState(() => _loadError = null);
    }
    try {
      final response = await Get.find<AuthorizedPigeon>().get(
        ApiEndpoints.getAllNotifications,
      );
      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final data = responseBody['data'];
      final List<_NotificationItem> notifications = <_NotificationItem>[];
      if (data is List) {
        for (final item in data) {
          if (item is Map) {
            notifications.add(
              _NotificationItem.fromMap(Map<String, dynamic>.from(item)),
            );
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _items = notifications;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Failed to load notifications';
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllAsRead() async {
    if (_isUpdatingAll) return;
    setState(() => _isUpdatingAll = true);
    try {
      await Get.find<AuthorizedPigeon>().patch(
        ApiEndpoints.readAllNotifications,
      );
      if (!mounted) return;
      setState(() {
        _items = _items
            .map((_NotificationItem item) => item.copyWith(isRead: true))
            .toList(growable: false);
      });
      _showMessage(context, 'All notifications marked as read');
    } catch (e) {
      if (!mounted) return;
      _showMessage(context, 'Failed to mark all as read');
    } finally {
      if (mounted) {
        setState(() => _isUpdatingAll = false);
      }
    }
  }

  Future<void> _markNotificationAsRead(_NotificationItem item) async {
    if (item.isRead || item.id.isEmpty) return;
    try {
      await Get.find<AuthorizedPigeon>().patch(
        ApiEndpoints.markNotificationAsRead(notificationId: item.id),
      );
      if (!mounted) return;
      setState(() {
        _items = _items
            .map(
              (_NotificationItem current) =>
                  current.id == item.id ? current.copyWith(isRead: true) : current,
            )
            .toList(growable: false);
      });
    } catch (e) {
      if (!mounted) return;
      _showMessage(context, 'Failed to mark as read');
    }
  }

  Future<void> _deleteNotification(_NotificationItem item) async {
    if (item.id.isEmpty) return;
    final int existingIndex =
        _items.indexWhere((_NotificationItem current) => current.id == item.id);
    if (existingIndex == -1) return;
    final List<_NotificationItem> updated =
        List<_NotificationItem>.from(_items)
          ..removeAt(existingIndex);
    setState(() => _items = updated);
    try {
      await Get.find<AuthorizedPigeon>().delete(
        ApiEndpoints.deleteNotification(notificationId: item.id),
      );
      if (!mounted) return;
      _showMessage(context, 'Notification deleted');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        final List<_NotificationItem> reverted =
            List<_NotificationItem>.from(_items);
        reverted.insert(existingIndex, item);
        _items = reverted;
      });
      _showMessage(context, 'Failed to delete notification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFD7E7F7), Color(0xFFE2E8F1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _loadNotifications(showLoader: false),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: const Icon(
                              CupertinoIcons.back,
                              size: 20,
                              color: Color(0xFF1D2A36),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1D2A36),
                            ),
                          ),
                          const Spacer(),
                          if (_items.any(
                            (_NotificationItem item) => !item.isRead,
                          ))
                            TextButton(
                              onPressed: _isUpdatingAll ? null : _markAllAsRead,
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF1787CF),
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: _isUpdatingAll
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF1787CF),
                                      ),
                                    )
                                  : const Text('Mark all read'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_loadError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Center(
                            child: Text(
                              _loadError ?? 'Failed to load notifications',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6A7B8C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      else if (_items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Center(
                            child: Text(
                              'No notifications yet',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6A7B8C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      else
                        ..._items.map(
                          (_NotificationItem item) {
                            final Widget card = _NotificationCard(
                              item: item,
                              onTap: () {
                                _markNotificationAsRead(item);
                                _showMessage(context, item.title);
                              },
                            );
                            if (item.id.isEmpty) {
                              return card;
                            }
                            return Dismissible(
                              key: ValueKey<String>(item.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE23A3A),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  CupertinoIcons.delete,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              onDismissed: (_) => _deleteNotification(item),
                              child: card,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        item.isRead ? const Color(0xFFE2E8F1) : const Color(0xFF9CC8F6);
    final Color cardColor =
        item.isRead ? Colors.white : const Color(0xFFF3F8FF);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x140F172A),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFD7EEFF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.bell,
                  color: Color(0xFF1D2A36),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D2A36),
                          ),
                        ),
                      ),
                      if (!item.isRead) ...<Widget>[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1787CF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6A7B8C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6A7B8C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final DateTime? createdAt;

  const _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.createdAt,
  });

  _NotificationItem copyWith({bool? isRead}) {
    return _NotificationItem(
      id: id,
      title: title,
      message: message,
      time: time,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  static _NotificationItem fromMap(Map<String, dynamic> map) {
    String readString(dynamic value, {String fallback = ''}) {
      final String text = value?.toString().trim() ?? '';
      return text.isEmpty ? fallback : text;
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      final String raw = value.toString();
      return DateTime.tryParse(raw);
    }

    String formatTimeAgo(DateTime? value) {
      if (value == null) return 'Just now';
      final DateTime now = DateTime.now();
      final Duration diff = now.difference(value);
      if (diff.isNegative) return 'Just now';
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
      if (diff.inHours < 24) return '${diff.inHours} hours ago';
      if (diff.inDays < 7) return '${diff.inDays} days ago';
      final int month = value.month;
      final int day = value.day;
      final String monthText = <String>[
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][month - 1];
      return '$monthText $day';
    }

    final String id = readString(map['_id'] ?? map['id']);
    final String title = readString(map['title'], fallback: 'Notification');
    final String message = readString(
      map['message'] ?? map['body'] ?? map['subtitle'],
      fallback: 'Tap to view details',
    );
    final DateTime? createdAt = parseDate(
      map['createdAt'] ?? map['created_at'] ?? map['time'],
    );
    final bool isRead = map['isRead'] == true;

    return _NotificationItem(
      id: id,
      title: title,
      message: message,
      time: formatTimeAgo(createdAt),
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
