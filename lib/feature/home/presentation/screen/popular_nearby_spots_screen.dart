import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/core/common/widget/loading/app_shimmer.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:xocobaby13/core/extensions/app_navigation_extension.dart';
import 'package:xocobaby13/feature/home/presentation/routes/home_routes.dart';

class PopularNearbySpotsScreen extends StatefulWidget {
  const PopularNearbySpotsScreen({super.key});

  @override
  State<PopularNearbySpotsScreen> createState() =>
      _PopularNearbySpotsScreenState();
}

class _PopularNearbySpotsScreenState extends State<PopularNearbySpotsScreen> {
  bool _isLoading = false;
  String? _error;
  List<_AllSpotItem> _spots = const <_AllSpotItem>[];
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

  @override
  void initState() {
    super.initState();
    _loadSpots();
  }

  Future<void> _loadSpots() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await Get.find<AuthorizedPigeon>().get(
        ApiEndpoints.allSpots,
        queryParameters: const <String, dynamic>{'limit': 200},
      );
      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final dynamic data = responseBody['data'];
      final List<_AllSpotItem> spots = <_AllSpotItem>[];
      if (data is List) {
        for (final dynamic item in data) {
          if (item is Map) {
            spots.add(_mapSpot(Map<String, dynamic>.from(item)));
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _spots = spots;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load spots';
        _isLoading = false;
      });
    }
  }

  _AllSpotItem _mapSpot(Map<String, dynamic> spot) {
    final String title = spot['title']?.toString().trim().isNotEmpty == true
        ? spot['title'].toString()
        : 'Untitled Spot';
    final List<double> coords = _readCoordinates(spot['location']);

    return _AllSpotItem(
      id: spot['_id']?.toString(),
      title: title,
      location: _formatLocation(spot['location']),
      date: _formatDate(spot['createdAt']?.toString()),
      rating: _readDouble(spot['ratingAvg']),
      reviews: _readInt(spot['ratingCount']),
      imageUrl: _pickImageUrl(spot['images']),
      lat: coords.isNotEmpty ? coords[0] : null,
      lng: coords.length > 1 ? coords[1] : null,
    );
  }

  int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _readDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  List<double> _readCoordinates(dynamic location) {
    if (location is Map) {
      final dynamic point = location['point'];
      if (point is Map) {
        final dynamic coords = point['coordinates'];
        if (coords is List && coords.length >= 2) {
          return <double>[
            double.tryParse(coords[1].toString()) ?? 0,
            double.tryParse(coords[0].toString()) ?? 0,
          ];
        }
      }
    }
    return <double>[];
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
      if (parts.isNotEmpty) return parts.join(', ');
    }
    return 'Unknown location';
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return 'Available';
    final DateTime? dateTime = DateTime.tryParse(value);
    if (dateTime == null) return 'Available';
    final String month = _monthNames[dateTime.month - 1];
    return '$month ${dateTime.day}, ${dateTime.year}';
  }

  String _pickImageUrl(dynamic images) {
    if (images is List && images.isNotEmpty) {
      final dynamic first = images.first;
      if (first is Map && first['url'] != null) {
        return first['url'].toString();
      }
      if (first is String) return first;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => context.safePop(),
                    child: const Icon(
                      CupertinoIcons.back,
                      size: 20,
                      color: Color(0xFF1D2A36),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Popular Nearby',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D2A36),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      itemCount: 6,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) =>
                          const _AllSpotCardSkeleton(),
                    )
                  : _error != null
                  ? Center(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: Color(0xFF6A7B8C),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : _spots.isEmpty
                  ? const Center(
                      child: Text(
                        'No spots found',
                        style: TextStyle(
                          color: Color(0xFF6A7B8C),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      itemCount: _spots.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (BuildContext context, int index) {
                        final _AllSpotItem spot = _spots[index];
                        return _AllSpotCard(
                          data: spot,
                          onTap: () {
                            final query = <String, String>{};
                            if (spot.lat != null && spot.lng != null) {
                              query['lat'] = spot.lat.toString();
                              query['lng'] = spot.lng.toString();
                              query['distanceKm'] = '100';
                            }
                            if (spot.id != null && spot.id!.isNotEmpty) {
                              query['id'] = spot.id!;
                            }
                            final detailsUri = Uri(
                              path: HomeRouteNames.details,
                              queryParameters: query.isEmpty ? null : query,
                            );
                            context.push(detailsUri.toString());
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllSpotCardSkeleton extends StatelessWidget {
  const _AllSpotCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Row(
        children: <Widget>[
          AppShimmerBox(width: 76, height: 76),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppShimmerBox(width: 160, height: 14),
                SizedBox(height: 8),
                AppShimmerBox(width: 220, height: 11),
                SizedBox(height: 8),
                AppShimmerBox(width: 140, height: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllSpotCard extends StatelessWidget {
  final _AllSpotItem data;
  final VoidCallback onTap;

  const _AllSpotCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 76,
                  height: 76,
                  color: const Color(0xFFE2E8F1),
                  child: const Icon(Icons.photo, size: 32),
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
                  Text(
                    data.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6A7B8C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
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
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D2A36),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${data.reviews} reviews)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6A7B8C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1D2A36),
                      fontWeight: FontWeight.w600,
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

class _AllSpotItem {
  final String? id;
  final String title;
  final String location;
  final String date;
  final double rating;
  final int reviews;
  final String imageUrl;
  final double? lat;
  final double? lng;

  const _AllSpotItem({
    this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    this.lat,
    this.lng,
  });
}
