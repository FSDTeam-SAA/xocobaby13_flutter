import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/home/presentation/routes/home_routes.dart';
import 'package:xocobaby13/feature/notification/presentation/routes/notification_routes.dart';
import 'package:xocobaby13/feature/search/presentation/routes/search_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _liveController;

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
  void initState() {
    super.initState();
    _liveController = PageController();
  }

  @override
  void dispose() {
    _liveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<_LiveEvent> liveEvents = <_LiveEvent>[
      const _LiveEvent(
        title: 'Crystal Lake Sanctuary',
        location: 'Montana, USA',
        date: 'Feb 05, 2026',
        time: '7:00 AM - 5:00 PM',
        hostName: 'John Mitchell',
        rating: 4.5,
        reviews: 18,
        statusLabel: 'Arrived',
        statusColor: Color(0xFF1787CF),
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80',
        hostAvatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
      ),
      const _LiveEvent(
        title: 'Crystal Lake Sanctuary',
        location: 'Montana, USA',
        date: 'Feb 05, 2026',
        time: '7:00 AM - 5:00 PM',
        hostName: 'John Mitchell',
        rating: 4.6,
        reviews: 18,
        statusLabel: 'Check Out',
        statusColor: Color(0xFF111827),
        imageUrl:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=900&q=80',
        hostAvatarUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
      ),
    ];

    final List<_PopularPlace> popularPlaces = <_PopularPlace>[
      const _PopularPlace(
        title: 'Crystal Lake Sanctuary',
        location: 'Montana, USA',
        date: 'Feb 10, 2026',
        rating: 4.5,
        reviews: 18,
        timeRange: '7:00 AM - 5:00 PM',
        pricePerDay: 120,
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
        tags: <String>['Freshwater', 'Catfish', 'Kayak', '2+ more'],
        attendees: <String>[
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
        ],
        attendeesLabel: 'Mr. Mike & 4 Others',
        attendeesSubtitle: 'are going in this location',
      ),
      const _PopularPlace(
        title: 'Crystal Lake Sanctuary',
        location: 'Montana, USA',
        date: 'Feb 10, 2026',
        rating: 4.5,
        reviews: 18,
        timeRange: '7:00 AM - 5:00 PM',
        pricePerDay: 120,
        imageUrl:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1200&q=80',
        tags: <String>['Freshwater', 'Catfish'],
        attendees: <String>[
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
        ],
        attendeesLabel: 'Mr. Mike & 4 Others',
        attendeesSubtitle: 'are going in this location',
      ),
    ];

    const List<_RecommendedPlace> recommendedPlaces = <_RecommendedPlace>[
      _RecommendedPlace(
        title: 'Crystal Lake Sanctuary',
        location: 'Montana, USA',
        date: 'Feb 10, 2026',
        rating: 4.5,
        reviews: 18,
        timeRange: '7:00 AM - 5:00 PM',
        imageUrl:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=600&q=80',
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
                const _ProfileAvatar(
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
                  onTap: () => context.push(
                    NotificationRouteNames.notifications,
                  ),
                  child: const _NotificationBell(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Ready to fish today?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2A36),
              ),
            ),
            const SizedBox(height: 16),
            _SearchField(
              onTap: () => context.push(SearchRouteNames.fishermanSearch),
              onSubmitted: (String value) =>
                  _showMessage(context, 'Searching for "$value"'),
            ),
            const SizedBox(height: 22),
            _SectionHeader(
              title: 'Live',
              actionLabel: 'See all',
              onActionTap: () => _showMessage(context, 'Live'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 126,
              child: PageView.builder(
                controller: _liveController,
                itemCount: liveEvents.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimatedBuilder(
                    animation: _liveController,
                    child: _LiveEventCard(
                      data: liveEvents[index],
                      onStatusTap: () =>
                          _showMessage(context, liveEvents[index].statusLabel),
                    ),
                    builder: (BuildContext context, Widget? child) {
                      double scale = 1;
                      double translate = 0;
                      if (_liveController.hasClients) {
                        final double page =
                            _liveController.page ??
                            _liveController.initialPage.toDouble();
                        final double delta = (page - index).abs();
                        scale = (1 - (delta * 0.05)).clamp(0.95, 1.0);
                        translate = (delta * 6).clamp(0.0, 6.0);
                      }
                      return Transform.translate(
                        offset: Offset(translate, 0),
                        child: Transform.scale(
                          scale: scale,
                          alignment: Alignment.center,
                          child: child,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            _SectionHeader(
              title: 'Popular Nearby',
              actionLabel: 'See all',
              onActionTap: () => _showMessage(context, 'Popular Nearby'),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 560,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: popularPlaces.length,
                separatorBuilder: (_, __) => const SizedBox(width: 18),
                itemBuilder: (BuildContext context, int index) {
                  return _PopularCard(
                    data: popularPlaces[index],
                    onViewDetails: () =>
                        context.push(HomeRouteNames.details),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            _SectionHeader(
              title: 'Recommended',
              actionLabel: 'See all',
              onActionTap: () => _showMessage(context, 'Recommended'),
            ),
            const SizedBox(height: 14),
            Column(
              children: recommendedPlaces
                  .map(
                    (_RecommendedPlace place) => _RecommendedCard(
                      data: place,
                      onTap: () => context.push(HomeRouteNames.details),
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

class _ProfileAvatar extends StatelessWidget {
  final String imageUrl;

  const _ProfileAvatar({required this.imageUrl});

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

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

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

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onSubmitted;
  final VoidCallback? onTap;

  const _SearchField({required this.onSubmitted, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1A0F172A),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        onSubmitted: onSubmitted,
        onTap: onTap,
        readOnly: onTap != null,
        decoration: const InputDecoration(
          prefixIcon: Icon(CupertinoIcons.search, color: Color(0xFF1E7CC8)),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Color(0xFF1E7CC8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        style: const TextStyle(color: Color(0xFF1D2A36), fontSize: 14),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D2A36),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6A7B8C),
            ),
          ),
        ),
      ],
    );
  }
}

class _LiveEventCard extends StatelessWidget {
  final _LiveEvent data;
  final VoidCallback onStatusTap;

  const _LiveEventCard({required this.data, required this.onStatusTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 118,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1787CF), width: 1.4),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            child: Image.network(
              data.imageUrl,
              width: 125,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 98,
                height: double.infinity,
                color: const Color(0xFFE2E8F1),
                child: const Icon(Icons.photo, size: 28),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D2A36),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _LiveMetaRow(icon: CupertinoIcons.time, text: data.time),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _LiveMetaRow(
                          icon: CupertinoIcons.location_solid,
                          text: data.location,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _LiveMetaRow(
                          icon: CupertinoIcons.calendar,
                          text: data.date,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(data.hostAvatarUrl),
                        backgroundColor: const Color(0xFFE2E8F1),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data.hostName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D2A36),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  CupertinoIcons.star_fill,
                                  size: 11,
                                  color: Color(0xFFF2B01E),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    '${data.rating} (${data.reviews} Reviews)',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF6A7B8C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onStatusTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: data.statusColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            data.statusLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveMetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _LiveMetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 11, color: const Color(0xFF6A7B8C)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF6A7B8C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _PopularCard extends StatelessWidget {
  final _PopularPlace data;
  final VoidCallback onViewDetails;

  const _PopularCard({required this.data, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1A0F172A),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              data.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: const Color(0xFFE2E8F1),
                child: const Icon(Icons.photo, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D2A36),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '\$${data.pricePerDay}',
                              style: const TextStyle(
                                color: Color(0xFF1787CF),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(
                              text: '/day',
                              style: TextStyle(
                                color: Color(0xFF1D2A36),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          CupertinoIcons.location_solid,
                          size: 16,
                          color: Color(0xFF3A4A5A),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          data.location,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3A4A5A),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          CupertinoIcons.calendar,
                          size: 16,
                          color: Color(0xFF3A4A5A),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          data.date,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3A4A5A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          CupertinoIcons.star_fill,
                          size: 16,
                          color: Color(0xFFF2B01E),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${data.rating}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D2A36),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${data.reviews} Reviews)',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6A7B8C),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          CupertinoIcons.time,
                          size: 16,
                          color: Color(0xFF1D2A36),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          data.timeRange,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1D2A36),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: data.tags
                      .map(
                        (String tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F3F7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF39424E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    _AvatarStack(avatars: data.attendees),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            data.attendeesLabel,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFF1D2A36),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.attendeesSubtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6A7B8C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: onViewDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1787CF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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

class _AvatarStack extends StatelessWidget {
  final List<String> avatars;

  const _AvatarStack({required this.avatars});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 36,
      child: Stack(
        children: <Widget>[
          for (int index = 0; index < avatars.length; index++)
            Positioned(
              left: index * 20,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(avatars[index]),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  ),
                ),
              ),
            ),
          Positioned(
            left: avatars.length * 20,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFDCEAF8),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Text(
                '4+',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D2A36),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final _RecommendedPlace data;
  final VoidCallback onTap;

  const _RecommendedCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x140F172A),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                data.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: const Color(0xFFE2E8F1),
                  child: const Icon(Icons.photo, size: 30),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D2A36),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            CupertinoIcons.location_solid,
                            size: 14,
                            color: Color(0xFF3A4A5A),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF3A4A5A),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            CupertinoIcons.calendar,
                            size: 14,
                            color: Color(0xFF3A4A5A),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF3A4A5A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            CupertinoIcons.star_fill,
                            size: 14,
                            color: Color(0xFFF2B01E),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${data.rating}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D2A36),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${data.reviews} Reviews)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6A7B8C),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            CupertinoIcons.time,
                            size: 14,
                            color: Color(0xFF1D2A36),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.timeRange,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1D2A36),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _LiveEvent {
  final String title;
  final String location;
  final String date;
  final String time;
  final String hostName;
  final double rating;
  final int reviews;
  final String statusLabel;
  final Color statusColor;
  final String imageUrl;
  final String hostAvatarUrl;

  const _LiveEvent({
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.hostName,
    required this.rating,
    required this.reviews,
    required this.statusLabel,
    required this.statusColor,
    required this.imageUrl,
    required this.hostAvatarUrl,
  });
}

class _PopularPlace {
  final String title;
  final String location;
  final String date;
  final double rating;
  final int reviews;
  final String timeRange;
  final int pricePerDay;
  final String imageUrl;
  final List<String> tags;
  final List<String> attendees;
  final String attendeesLabel;
  final String attendeesSubtitle;

  const _PopularPlace({
    required this.title,
    required this.location,
    required this.date,
    required this.rating,
    required this.reviews,
    required this.timeRange,
    required this.pricePerDay,
    required this.imageUrl,
    required this.tags,
    required this.attendees,
    required this.attendeesLabel,
    required this.attendeesSubtitle,
  });
}

class _RecommendedPlace {
  final String title;
  final String location;
  final String date;
  final double rating;
  final int reviews;
  final String timeRange;
  final String imageUrl;

  const _RecommendedPlace({
    required this.title,
    required this.location,
    required this.date,
    required this.rating,
    required this.reviews,
    required this.timeRange,
    required this.imageUrl,
  });
}
