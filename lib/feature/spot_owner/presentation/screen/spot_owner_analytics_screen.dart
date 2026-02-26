import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SpotOwnerAnalyticsScreen extends StatelessWidget {
  const SpotOwnerAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_BookingItem> bookings = <_BookingItem>[
      const _BookingItem(
        name: 'Jenny Wilson',
        subtitle: 'Florida, USA  •  Tropical Gardens',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
      ),
      const _BookingItem(
        name: 'Michael Brown',
        subtitle: 'California, USA  •  Mountain Retreat',
        avatarUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
      ),
      const _BookingItem(
        name: 'Emily Davis',
        subtitle: 'New York, USA  •  Urban Oasis',
        avatarUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
      ),
      const _BookingItem(
        name: 'David Smith',
        subtitle: 'Texas, USA  •  Desert Hideaway',
        avatarUrl:
            'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=200&q=80',
      ),
    ];

    return Scaffold(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
                      'Analytics',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 170,
                      color: const Color(0xFFE2E8F1),
                      child: const Icon(Icons.photo, size: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Crystal Lake Sanctuary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: <Widget>[
                    Icon(
                      CupertinoIcons.location_solid,
                      size: 12,
                      color: Color(0xFF3A4A5A),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Montana, USA',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF3A4A5A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Activity',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x140F172A),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const <Widget>[
                      _ActivityIcon(
                        assetPath: 'assets/icons/clipboard-edit.png',
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Available Slots',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6A7B8C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '40',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D2A36),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const <Widget>[
                    Expanded(
                      child: _OverviewCard(
                        assetPath: 'assets/icons/clipboard-check.png',
                        iconBg: Color(0xFFE7F2FF),
                        label: 'Today Booking',
                        value: '30',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _OverviewCard(
                        icon: CupertinoIcons.money_dollar_circle,
                        iconBg: Color(0xFFDFF8E9),
                        iconColor: Color(0xFF26A764),
                        label: 'Today Earning',
                        value: r'$100',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _OverviewCard(
                        assetPath: 'assets/icons/coins.png',
                        iconBg: Color(0xFFDFF8E9),
                        label: 'Total Earning',
                        value: r'$12.26K',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    const Text(
                      'Bookings',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E7CC8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: bookings
                      .map((_BookingItem item) => _BookingRow(item: item))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  final String assetPath;

  const _ActivityIcon({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFE7F2FF),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            CupertinoIcons.ticket,
            color: Color(0xFF1E7CC8),
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData? icon;
  final String? assetPath;
  final String label;
  final String value;

  const _OverviewCard({
    required this.iconBg,
    this.iconColor = const Color(0xFF1E7CC8),
    this.icon,
    this.assetPath,
    required this.label,
    required this.value,
  }) : assert(icon != null || assetPath != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.fromLTRB(8, 9, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(
              child: assetPath != null
                  ? Image.asset(
                      assetPath!,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        icon ?? CupertinoIcons.square_stack_3d_up,
                        color: iconColor,
                        size: 16,
                      ),
                    )
                  : Icon(icon, color: iconColor, size: 24),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF6A7B8C),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D2A36),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingRow extends StatelessWidget {
  final _BookingItem item;

  const _BookingRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 29,
            backgroundImage: NetworkImage(item.avatarUrl),
            backgroundColor: const Color(0xFFE2E8F1),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6A7B8C),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingItem {
  final String name;
  final String subtitle;
  final String avatarUrl;

  const _BookingItem({
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
  });
}
