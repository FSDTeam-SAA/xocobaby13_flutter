import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/navigation/controller/navigation_controller.dart';
import 'package:xocobaby13/feature/navigation/presentation/routes/navigation_routes.dart';
import 'package:xocobaby13/feature/navigation/presentation/widgets/bottom_navigation_bar_for_baby.dart';
import 'package:xocobaby13/feature/navigation/presentation/widgets/bottom_navigation_bar_for_spot_owner.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isSpotOwner = false;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final authRecord = await Get.find<AuthorizedPigeon>().getCurrentAuthRecord();
    final rawRole = (authRecord?.data['role'] ?? '').toString().trim();
    final normalizedRole =
        rawRole.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (mounted) {
      setState(() => _isSpotOwner = normalizedRole == 'spotowner');
    }
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

  void _handleTabTap(int index) {
    final controller = NavigationController.instance();
    controller.setTabIndex(index);
    final route = _isSpotOwner
        ? NavigationRouteNames.spotOwnerMain
        : NavigationRouteNames.main;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final List<_NotificationItem> items = <_NotificationItem>[
      const _NotificationItem(
        title: 'You have booked Crystal Lake',
        subtitle: 'A new booking has been made for 3 fishers',
        time: 'Just now',
      ),
      const _NotificationItem(
        title: 'John Mitchell is also going',
        subtitle: 'Make more friends',
        time: '5 minutes ago',
      ),
      const _NotificationItem(
        title: 'You gave Montana Lake 5 star',
        subtitle: '5 star reviews',
        time: '10 minutes ago',
      ),
      const _NotificationItem(
        title: 'Event Reminder',
        subtitle: 'Your event has 5 days left',
        time: '15 minutes ago',
      ),
    ];

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: items
                            .map(
                              (_NotificationItem item) => _NotificationCard(
                                item: item,
                                onTap: () => _showMessage(
                                  context,
                                  item.title,
                                ),
                              ),
                            )
                            .toList(),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF9CC8F6), width: 1),
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
                    item.subtitle,
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
  final String title;
  final String subtitle;
  final String time;

  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
  });
}
