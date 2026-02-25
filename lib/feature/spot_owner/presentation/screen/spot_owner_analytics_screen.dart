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
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: const Color(0xFFE2E8F1),
                      child: const Icon(Icons.photo, size: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Crystal Lake Sanctuary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 6),
                const Row(
                  children: <Widget>[
                    Icon(
                      CupertinoIcons.location_solid,
                      size: 13,
                      color: Color(0xFF3A4A5A),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Montana, USA',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF3A4A5A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Activity',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                      _ActivityIcon(),
                      SizedBox(height: 6),
                      Text(
                        'Available Slots',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6A7B8C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '40',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D2A36),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const <Widget>[
                    Expanded(
                      child: _OverviewCard(
                        icon: CupertinoIcons.calendar,
                        iconBg: Color(0xFFE7F2FF),
                        iconColor: Color(0xFF1E7CC8),
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
                        icon: CupertinoIcons.money_dollar,
                        iconBg: Color(0xFFDFF8E9),
                        iconColor: Color(0xFF26A764),
                        label: 'Total Earning',
                        value: r'$12.26K',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    const Text(
                      'Bookings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 12,
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
                      .map(
                        (_BookingItem item) => _BookingRow(item: item),
                      )
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
  const _ActivityIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFE7F2FF),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          CupertinoIcons.ticket,
          color: Color(0xFF1E7CC8),
          size: 20,
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;

  const _OverviewCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF6A7B8C),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 20,
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
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A36),
                  ),
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
