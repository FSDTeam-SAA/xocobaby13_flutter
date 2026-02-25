import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/notification/presentation/routes/notification_routes.dart';
import 'package:xocobaby13/feature/spot_owner/presentation/routes/spot_owner_routes.dart';

class SpotOwnerHomeScreen extends StatelessWidget {
  const SpotOwnerHomeScreen({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<_SpotOwnerEvent> runningEvents = <_SpotOwnerEvent>[
      const _SpotOwnerEvent(
        title: 'Crystal Lake Sanctuary',
        location: 'Montana, USA',
        type: 'Private Lake',
        slotsFilled: 60,
        slotsTotal: 100,
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80',
      ),
      const _SpotOwnerEvent(
        title: 'Serenity Bay Retreat',
        location: 'Maine, USA',
        type: 'Oceanfront',
        slotsFilled: 80,
        slotsTotal: 120,
        imageUrl:
            'https://images.unsplash.com/photo-1434725039720-aaad6dd32dfe?auto=format&fit=crop&w=900&q=80',
      ),
      const _SpotOwnerEvent(
        title: 'Whispering Pines Lodge',
        location: 'Colorado, USA',
        type: 'Mountain Cabin',
        slotsFilled: 40,
        slotsTotal: 75,
        imageUrl:
            'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=900&q=80',
      ),
    ];

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const _SpotOwnerAvatar(
                  imageUrl:
                      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Good Morning',
                      style: TextStyle(fontSize: 14, color: Color(0xFF3A4A5A)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Hello, Mack',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () =>
                      context.push(NotificationRouteNames.notifications),
                  child: const _SpotOwnerNotificationBell(),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _SpotOwnerSummaryCard(
              title: 'Total Earnings',
              value: r'$128.7k',
              changeText: '+ 36% ',
            ),
            const SizedBox(height: 22),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2A36),
              ),
            ),
            const SizedBox(height: 14),
            _SpotOwnerActionCard(
              title: 'Create Event',
              subtitle: 'Schedule a new tournament',
              onTap: () => context.push(SpotOwnerRouteNames.createSpot),
            ),
            const SizedBox(height: 22),
            const Text(
              'Running Events',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2A36),
              ),
            ),
            const SizedBox(height: 14),
            Column(
              children: runningEvents
                  .map(
                    (_SpotOwnerEvent event) => _SpotOwnerEventCard(
                      data: event,
                      onAnalytics: () =>
                          context.push(SpotOwnerRouteNames.analytics),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotOwnerAvatar extends StatelessWidget {
  final String imageUrl;

  const _SpotOwnerAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
    );
  }
}

class _SpotOwnerNotificationBell extends StatelessWidget {
  const _SpotOwnerNotificationBell();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          const Center(
            child: Icon(
              CupertinoIcons.bell_fill,
              color: Color(0xFF1787CF),
              size: 22,
            ),
          ),
          Positioned(
            top: 10,
            right: 12,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: const Color(0xFFE23A3A),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotOwnerSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String changeText;

  const _SpotOwnerSummaryCard({
    required this.title,
    required this.value,
    required this.changeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1787CF), width: 1.4),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6A7B8C),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D2A36),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: <Widget>[
              Text(
                changeText,
                style: const TextStyle(
                  color: Color(0xFF2FB25D),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(
                CupertinoIcons.arrow_up,
                color: Color(0xFF2FB25D),
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpotOwnerActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SpotOwnerActionCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF1787CF), width: 1.3),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x140F172A),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x150F172A),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.plus,
                  color: Color(0xFF1787CF),
                  size: 26,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2A36),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6A7B8C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotOwnerEventCard extends StatelessWidget {
  final _SpotOwnerEvent data;
  final VoidCallback onAnalytics;

  const _SpotOwnerEventCard({required this.data, required this.onAnalytics});

  double get _progressValue {
    if (data.slotsTotal == 0) return 0;
    return data.slotsFilled / data.slotsTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1787CF), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              data.imageUrl,
              width: 150,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 92,
                height: 92,
                color: const Color(0xFFE2E8F1),
                child: const Icon(Icons.photo, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${data.location} - ${data.type}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6A7B8C),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${data.slotsFilled}/${data.slotsTotal} Slots',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: _progressValue,
                    backgroundColor: const Color(0xFFE8EFF7),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF1787CF),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onAnalytics,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1787CF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Analytics',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotOwnerEvent {
  final String title;
  final String location;
  final String type;
  final int slotsFilled;
  final int slotsTotal;
  final String imageUrl;

  const _SpotOwnerEvent({
    required this.title,
    required this.location,
    required this.type,
    required this.slotsFilled,
    required this.slotsTotal,
    required this.imageUrl,
  });
}
