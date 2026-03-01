import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/home/presentation/routes/home_routes.dart';
import 'package:xocobaby13/feature/notification/presentation/routes/notification_routes.dart';
import 'package:xocobaby13/feature/search/presentation/routes/search_routes.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _liveController;
  bool _isLoadingLive = false;
  String? _liveError;
  List<_LiveEvent> _liveEvents = const <_LiveEvent>[];
  bool _isLoadingNearby = false;
  String? _nearbyError;
  List<_PopularPlace> _popularPlaces = const <_PopularPlace>[];
  bool _isLoadingRecommended = false;
  String? _recommendedError;
  List<_RecommendedPlace> _recommendedPlaces = const <_RecommendedPlace>[];
  bool _isLoadingUnread = false;
  int _unreadCount = 0;
  static const double _defaultNearbyLat = 23.8103;
  static const double _defaultNearbyLng = 90.4125;
  static const double _defaultNearbyDistanceKm = 15;
  final double _nearbyLat = _defaultNearbyLat;
  final double _nearbyLng = _defaultNearbyLng;
  final double _nearbyDistanceKm = _defaultNearbyDistanceKm;
  static const List<String> _defaultAttendees = <String>[
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
  ];
  static const List<String> _monthNames = <String>[
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
  ];

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
    _loadLiveBookings();
    _loadNearbySpots();
    _loadRecommendedSpots();
    _loadUnreadCount();
  }

  @override
  void dispose() {
    _liveController.dispose();
    super.dispose();
  }

  Future<void> _loadLiveBookings() async {
    if (_isLoadingLive) return;
    setState(() {
      _isLoadingLive = true;
      _liveError = null;
    });
    try {
      final response = await Get.find<AuthorizedPigeon>().get(
        ApiEndpoints.getMyBookings,
      );
      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final data = responseBody['data'];
      final List<_LiveEvent> bookings = <_LiveEvent>[];
      if (data is List) {
        for (final item in data) {
          if (item is Map) {
            bookings.add(
              _mapBookingToLiveEvent(Map<String, dynamic>.from(item)),
            );
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _liveEvents = bookings;
        _isLoadingLive = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _liveError = 'Failed to load live bookings';
        _isLoadingLive = false;
      });
    }
  }

  _LiveEvent _mapBookingToLiveEvent(Map<String, dynamic> booking) {
    final Map<String, dynamic> spot = booking['spot'] is Map
        ? Map<String, dynamic>.from(booking['spot'])
        : {};
    final Map<String, dynamic> owner = booking['owner'] is Map
        ? Map<String, dynamic>.from(booking['owner'])
        : {};
    final Map<String, dynamic> slot = booking['slot'] is Map
        ? Map<String, dynamic>.from(booking['slot'])
        : {};
    final String title = _readString(spot['title'], fallback: 'Spot Booking');
    final String location = 'Unknown location';
    final String date = _formatDate(booking['date']?.toString());
    final String time =
        '${_readString(slot['start'], fallback: '00:00')} - ${_readString(slot['end'], fallback: '00:00')}';
    final String hostName = _readString(
      owner['fullName'],
      fallback: 'Spot Owner',
    );
    final String hostAvatarUrl = _defaultAttendees.first;
    final String imageUrl = _pickImageUrl(spot['images']).isEmpty
        ? 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80'
        : _pickImageUrl(spot['images']);

    return _LiveEvent(
      id: booking['_id']?.toString(),
      title: title,
      location: location,
      date: date,
      time: time,
      hostName: hostName,
      rating: 0,
      reviews: 0,
      imageUrl: imageUrl,
      hostAvatarUrl: hostAvatarUrl,
      isArrived: false,
    );
  }

  void _handleLiveStatusTap(int index) {
    setState(() {
      final _LiveEvent event = _liveEvents[index];
      if (!event.isArrived) {
        _liveEvents[index] = event.copyWith(isArrived: true);
      } else {
        _liveEvents = List<_LiveEvent>.from(_liveEvents)..removeAt(index);
      }
    });
  }

  Future<void> _loadNearbySpots() async {
    if (_isLoadingNearby) return;
    setState(() {
      _isLoadingNearby = true;
      _nearbyError = null;
    });
    try {
      final response = await Get.find<AuthorizedPigeon>().get(
        ApiEndpoints.nearbySpots,
        queryParameters: <String, dynamic>{
          'lat': _nearbyLat,
          'lng': _nearbyLng,
          'distanceKm': _nearbyDistanceKm,
        },
      );
      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final data = responseBody['data'];
      final List<_PopularPlace> spots = <_PopularPlace>[];
      if (data is List) {
        for (final item in data) {
          if (item is Map) {
            spots.add(_mapSpotToPopularPlace(Map<String, dynamic>.from(item)));
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _popularPlaces = spots;
        _isLoadingNearby = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _nearbyError = 'Failed to load nearby spots';
        _isLoadingNearby = false;
      });
    }
  }

  Future<void> _loadRecommendedSpots() async {
    if (_isLoadingRecommended) return;
    setState(() {
      _isLoadingRecommended = true;
      _recommendedError = null;
    });
    try {
      final response = await Get.find<AuthorizedPigeon>().get(
        ApiEndpoints.recommendedSpots,
      );
      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final data = responseBody['data'];
      final List<_RecommendedPlace> spots = <_RecommendedPlace>[];
      if (data is List) {
        for (final item in data) {
          if (item is Map) {
            spots.add(
              _mapSpotToRecommendedPlace(Map<String, dynamic>.from(item)),
            );
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _recommendedPlaces = spots;
        _isLoadingRecommended = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _recommendedError = 'Failed to load recommended spots';
        _isLoadingRecommended = false;
      });
    }
  }

  Future<void> _loadUnreadCount() async {
    if (_isLoadingUnread) return;
    setState(() => _isLoadingUnread = true);
    try {
      final response = await Get.find<AuthorizedPigeon>().get(
        ApiEndpoints.getUnreadNotificationCount,
      );
      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final data = responseBody['data'];
      int count = 0;
      if (data is Map) {
        count = _readInt(data['unreadCount']);
      }
      if (!mounted) return;
      setState(() {
        _unreadCount = count;
        _isLoadingUnread = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingUnread = false);
    }
  }

  _PopularPlace _mapSpotToPopularPlace(Map<String, dynamic> spot) {
    final String title = spot['title']?.toString().trim().isNotEmpty == true
        ? spot['title'].toString()
        : 'Untitled Spot';
    final String location = _formatLocation(spot['location']);
    final String date = _formatDate(spot['createdAt']?.toString());
    final double rating = _readDouble(spot['ratingAvg']);
    final int reviews = _readInt(spot['ratingCount']);
    final int pricePerDay = _readInt(spot['price']);
    final String imageUrl = _pickImageUrl(spot['images']);
    final List<String> tags = _readStringList(spot['features']);
    final List<double> coords = _readCoordinates(spot['location']);
    final String? spotId = spot['_id']?.toString();

    return _PopularPlace(
      title: title,
      location: location,
      date: date,
      rating: rating,
      reviews: reviews,
      timeRange: 'All day',
      pricePerDay: pricePerDay,
      imageUrl: imageUrl.isEmpty
          ? 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80'
          : imageUrl,
      tags: tags.isEmpty ? const <String>['Popular'] : tags,
      attendees: _defaultAttendees,
      attendeesLabel: 'Nearby anglers',
      attendeesSubtitle: 'are going in this location',
      lat: coords.isNotEmpty ? coords[0] : null,
      lng: coords.length > 1 ? coords[1] : null,
      id: spotId,
    );
  }

  _RecommendedPlace _mapSpotToRecommendedPlace(Map<String, dynamic> spot) {
    final String title = spot['title']?.toString().trim().isNotEmpty == true
        ? spot['title'].toString()
        : 'Untitled Spot';
    final String location = _formatLocation(spot['location']);
    final String date = _formatDate(spot['createdAt']?.toString());
    final double rating = _readDouble(spot['ratingAvg']);
    final int reviews = _readInt(spot['ratingCount']);
    final String imageUrl = _pickImageUrl(spot['images']);
    final List<double> coords = _readCoordinates(spot['location']);
    final String? spotId = spot['_id']?.toString();

    return _RecommendedPlace(
      title: title,
      location: location,
      date: date,
      rating: rating,
      reviews: reviews,
      timeRange: 'All day',
      imageUrl: imageUrl.isEmpty
          ? 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=600&q=80'
          : imageUrl,
      id: spotId,
      lat: coords.isNotEmpty ? coords[0] : null,
      lng: coords.length > 1 ? coords[1] : null,
    );
  }

  String _formatLocation(dynamic location) {
    if (location is Map) {
      final String address = location['address']?.toString() ?? '';
      final String city = location['city']?.toString() ?? '';
      final String country = location['country']?.toString() ?? '';
      final parts = <String>[
        if (address.isNotEmpty) address,
        if (city.isNotEmpty) city,
        if (country.isNotEmpty) country,
      ];
      if (parts.isNotEmpty) {
        return parts.join(', ');
      }
    }
    return 'Unknown location';
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return 'Available';
    final DateTime? dateTime = DateTime.tryParse(value);
    if (dateTime == null) return 'Available';
    final String month = _monthNames[dateTime.month - 1];
    final String day = dateTime.day.toString().padLeft(2, '0');
    return '$month $day, ${dateTime.year}';
  }

  String _readString(dynamic value, {String fallback = ''}) {
    final String text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  String _pickImageUrl(dynamic images) {
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      if (first is String) return first;
      if (first is Map && first['url'] != null) {
        return first['url'].toString();
      }
    }
    return '';
  }

  List<double> _readCoordinates(dynamic location) {
    if (location is Map) {
      final point = location['point'];
      if (point is Map && point['coordinates'] is List) {
        final List coords = point['coordinates'] as List;
        if (coords.length >= 2) {
          final double lngValue = _readDouble(coords[0]);
          final double latValue = _readDouble(coords[1]);
          return <double>[latValue, lngValue];
        }
      }
    }
    return <double>[];
  }

  List<String> _readStringList(dynamic value) {
    if (value is List) {
      return value
          .where((element) => element != null)
          .map((element) => element.toString())
          .where((element) => element.isNotEmpty)
          .toList();
    }
    return <String>[];
  }

  int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _readDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final List<_PopularPlace> popularPlaces = _popularPlaces;

    final List<_RecommendedPlace> recommendedPlaces = _recommendedPlaces;

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
                  onTap: () async {
                    await context.push(NotificationRouteNames.notifications);
                    if (mounted) {
                      _loadUnreadCount();
                    }
                  },
                  child: _NotificationBell(unreadCount: _unreadCount),
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
              child: _isLoadingLive
                  ? const Center(child: CircularProgressIndicator())
                  : _liveError != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            _liveError!,
                            style: const TextStyle(
                              color: Color(0xFF6A7B8C),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AppTextButton(
                            onPressed: _loadLiveBookings,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _liveEvents.isEmpty
                  ? const Center(
                      child: Text(
                        'No live bookings',
                        style: TextStyle(
                          color: Color(0xFF6A7B8C),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : PageView.builder(
                      controller: _liveController,
                      itemCount: _liveEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimatedBuilder(
                          animation: _liveController,
                          child: _LiveEventCard(
                            data: _liveEvents[index],
                            onStatusTap: () => _handleLiveStatusTap(index),
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
              height: 450,
              child: _isLoadingNearby
                  ? const Center(child: CircularProgressIndicator())
                  : _nearbyError != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            _nearbyError!,
                            style: const TextStyle(
                              color: Color(0xFF6A7B8C),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppTextButton(
                            onPressed: _loadNearbySpots,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : popularPlaces.isEmpty
                  ? const Center(
                      child: Text(
                        'No nearby spots found',
                        style: TextStyle(
                          color: Color(0xFF6A7B8C),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularPlaces.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 18),
                      itemBuilder: (BuildContext context, int index) {
                        final _PopularPlace place = popularPlaces[index];
                        return _PopularCard(
                          data: place,
                          onViewDetails: () {
                            final double lat = place.lat ?? _nearbyLat;
                            final double lng = place.lng ?? _nearbyLng;
                            final query = <String, String>{
                              'lat': lat.toString(),
                              'lng': lng.toString(),
                              'distanceKm': _nearbyDistanceKm.toString(),
                            };
                            if (place.id != null && place.id!.isNotEmpty) {
                              query['id'] = place.id!;
                            }
                            final detailsUri = Uri(
                              path: HomeRouteNames.details,
                              queryParameters: query,
                            );
                            context.push(detailsUri.toString());
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 18),
            _SectionHeader(
              title: 'Recommended',
              actionLabel: 'See all',
              onActionTap: () => context.push(HomeRouteNames.recommended),
            ),
            const SizedBox(height: 14),
            if (_isLoadingRecommended)
              const Center(child: CircularProgressIndicator())
            else if (_recommendedError != null)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _recommendedError!,
                      style: const TextStyle(
                        color: Color(0xFF6A7B8C),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppTextButton(
                      onPressed: _loadRecommendedSpots,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (recommendedPlaces.isEmpty)
              const Center(
                child: Text(
                  'No recommended spots found',
                  style: TextStyle(
                    color: Color(0xFF6A7B8C),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Column(
                children: recommendedPlaces
                    .map(
                      (_RecommendedPlace place) => _RecommendedCard(
                        data: place,
                        onTap: () {
                          final query = <String, String>{};
                          if (place.lat != null && place.lng != null) {
                            query['lat'] = place.lat.toString();
                            query['lng'] = place.lng.toString();
                            query['distanceKm'] = '15';
                          }
                          if (place.id != null && place.id!.isNotEmpty) {
                            query['id'] = place.id!;
                          }
                          final detailsUri = Uri(
                            path: HomeRouteNames.details,
                            queryParameters: query.isEmpty ? null : query,
                          );
                          context.push(detailsUri.toString());
                        },
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
  final int unreadCount;

  const _NotificationBell({this.unreadCount = 0});

  @override
  Widget build(BuildContext context) {
    final String badgeText = unreadCount > 99 ? '99+' : unreadCount.toString();
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
          if (unreadCount > 0)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                height: 16,
                constraints: const BoxConstraints(minWidth: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE23A3A),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
    final String statusLabel = data.isArrived ? 'Check Out' : 'Arrive';
    final Color statusColor = data.isArrived
        ? const Color(0xFF111827)
        : const Color(0xFF1787CF);
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
                            color: statusColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            statusLabel,
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
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
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
                const SizedBox(height: 6),
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
                const SizedBox(height: 6),
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
                const SizedBox(height: 8),
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
                const SizedBox(height: 8),
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
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: AppElevatedButton(
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
  final String? id;
  final String title;
  final String location;
  final String date;
  final String time;
  final String hostName;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String hostAvatarUrl;
  final bool isArrived;

  const _LiveEvent({
    this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.hostName,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.hostAvatarUrl,
    required this.isArrived,
  });

  _LiveEvent copyWith({bool? isArrived}) {
    return _LiveEvent(
      id: id,
      title: title,
      location: location,
      date: date,
      time: time,
      hostName: hostName,
      rating: rating,
      reviews: reviews,
      imageUrl: imageUrl,
      hostAvatarUrl: hostAvatarUrl,
      isArrived: isArrived ?? this.isArrived,
    );
  }
}

class _PopularPlace {
  final String? id;
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
  final double? lat;
  final double? lng;

  const _PopularPlace({
    this.id,
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
    this.lat,
    this.lng,
  });
}

class _RecommendedPlace {
  final String? id;
  final String title;
  final String location;
  final String date;
  final double rating;
  final int reviews;
  final String timeRange;
  final String imageUrl;
  final double? lat;
  final double? lng;

  const _RecommendedPlace({
    this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.rating,
    required this.reviews,
    required this.timeRange,
    required this.imageUrl,
    this.lat,
    this.lng,
  });
}
