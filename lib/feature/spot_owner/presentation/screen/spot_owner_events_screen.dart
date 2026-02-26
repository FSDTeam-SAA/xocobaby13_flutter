import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/navigation/controller/navigation_controller.dart';
import 'package:xocobaby13/feature/spot_owner/presentation/routes/spot_owner_routes.dart';

class SpotOwnerEventsScreen extends StatelessWidget {
  const SpotOwnerEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_SpotOwnerEventItem> events = <_SpotOwnerEventItem>[
      const _SpotOwnerEventItem(
        status: 'Running Now',
        statusColor: Color(0xFF27AE60),
        title: 'Crystal Lake Sanctuary',
        location: 'Montana, USA',
        type: 'Private Lake',
        filledSlots: 60,
        totalSlots: 100,
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80',
      ),
      const _SpotOwnerEventItem(
        status: 'Event Ended',
        statusColor: Color(0xFFE74C3C),
        title: 'Crystal Lake Sanctuary',
        location: 'Montana, USA',
        type: 'Private Lake',
        filledSlots: 60,
        totalSlots: 100,
        imageUrl:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=900&q=80',
      ),
      const _SpotOwnerEventItem(
        status: 'Running Now',
        statusColor: Color(0xFF27AE60),
        title: 'Crystal Lake Sanctuary',
        location: 'Montana, USA',
        type: 'Private Lake',
        filledSlots: 60,
        totalSlots: 100,
        imageUrl:
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=900&q=80',
      ),
      const _SpotOwnerEventItem(
        status: 'Event Ended',
        statusColor: Color(0xFFE74C3C),
        title: 'Crystal Lake Sanctuary',
        location: 'Montana, USA',
        type: 'Private Lake',
        filledSlots: 60,
        totalSlots: 100,
        imageUrl:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=900&q=80',
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
                GestureDetector(
                  onTap: () => NavigationController.instance().setTabIndex(0),
                  child: const Icon(
                    CupertinoIcons.back,
                    color: Color(0xFF1D2A36),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D2A36),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2A36),
              ),
            ),
            const SizedBox(height: 14),
            _CreateEventCard(
              onTap: () => context.push(SpotOwnerRouteNames.createSpot),
            ),
            const SizedBox(height: 16),
            Column(
              children: events
                  .map(
                    (_SpotOwnerEventItem event) => _EventCard(
                      data: event,
                      onViewDetails: () =>
                          context.push(SpotOwnerRouteNames.eventDetails),
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

class _CreateEventCard extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateEventCard({required this.onTap});

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
            const Text(
              'Create Event',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2A36),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Schedule a new tournament',
              style: TextStyle(
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

class _EventCard extends StatelessWidget {
  final _SpotOwnerEventItem data;
  final VoidCallback onViewDetails;

  const _EventCard({required this.data, required this.onViewDetails});

  double get _progressValue {
    if (data.totalSlots == 0) return 0;
    return data.filledSlots / data.totalSlots;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  data.imageUrl,
                  width: 150,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 150,
                    height: 100,
                    color: const Color(0xFFE2E8F1),
                    child: const Icon(Icons.photo, size: 32),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: data.statusColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Text(
                    data.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
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
                  '${data.location}  •  ${data.type}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6A7B8C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.filledSlots}/${data.totalSlots} Slots',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A36),
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: _progressValue,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFD9E8F6),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF1E7CC8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: onViewDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1787CF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

class _SpotOwnerEventItem {
  final String status;
  final Color statusColor;
  final String title;
  final String location;
  final String type;
  final int filledSlots;
  final int totalSlots;
  final String imageUrl;

  const _SpotOwnerEventItem({
    required this.status,
    required this.statusColor,
    required this.title,
    required this.location,
    required this.type,
    required this.filledSlots,
    required this.totalSlots,
    required this.imageUrl,
  });
}
