import 'dart:async';

import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:xocobaby13/feature/home/presentation/routes/home_routes.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

class FishermanSearchScreen extends StatefulWidget {
  const FishermanSearchScreen({super.key});

  @override
  State<FishermanSearchScreen> createState() => _FishermanSearchScreenState();
}

class _FishermanSearchScreenState extends State<FishermanSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_SpotSearchResult> _results = <_SpotSearchResult>[];
  Timer? _debounce;

  String _query = '';
  bool _isLoading = false;
  String? _error;

  static const String _defaultCity = 'Dhaka';
  static const int _defaultMinPrice = 500;
  static const int _defaultMaxPrice = 2000;
  static const List<String> _defaultFeatures = <String>['fishing', 'parking'];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    final next = value.trim();
    setState(() => _query = next);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _searchSpots);
  }

  Future<void> _searchSpots() async {
    if (_query.isEmpty) {
      setState(() {
        _results.clear();
        _error = null;
        _isLoading = false;
      });
      return;
    }
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final Map<String, dynamic> queryParams = <String, dynamic>{'q': _query};
      if (_defaultCity.isNotEmpty) {
        queryParams['city'] = _defaultCity;
      }
      if (_defaultMinPrice > 0) {
        queryParams['minPrice'] = _defaultMinPrice;
      }
      if (_defaultMaxPrice > 0) {
        queryParams['maxPrice'] = _defaultMaxPrice;
      }
      if (_defaultFeatures.isNotEmpty) {
        queryParams['features'] = _defaultFeatures.join(',');
      }
      final response = await Get.find<AuthorizedPigeon>().get(
        ApiEndpoints.searchSpots,
        queryParameters: queryParams,
      );
      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final data = responseBody['data'];
      final List<_SpotSearchResult> nextResults = <_SpotSearchResult>[];
      if (data is List) {
        for (final item in data) {
          if (item is Map) {
            nextResults.add(
              _SpotSearchResult.fromMap(Map<String, dynamic>.from(item)),
            );
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _results
          ..clear()
          ..addAll(nextResults);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to fetch search results';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: <Widget>[
                _SearchBar(
                  controller: _controller,
                  hintText: 'Search for areas',
                  onChanged: _onQueryChanged,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                _error!,
                                style: const TextStyle(
                                  color: Color(0xFF6A7B8C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AppTextButton(
                                onPressed: _searchSpots,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _results.isEmpty
                      ? const Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(
                              color: Color(0xFF6A7B8C),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _results.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (BuildContext context, int index) {
                            final _SpotSearchResult spot = _results[index];
                            return _SearchResultRow(
                              title: spot.title,
                              subtitle: spot.location,
                              price: spot.price,
                              onTap: () {
                                final query = <String, String>{
                                  'lat': spot.lat.toString(),
                                  'lng': spot.lng.toString(),
                                  'distanceKm': '15',
                                  'id': spot.id,
                                };
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

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
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            CupertinoIcons.search,
            color: Color(0xFF1E7CC8),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF1E7CC8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        style: const TextStyle(color: Color(0xFF1D2A36), fontSize: 14),
      ),
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final int price;
  final VoidCallback onTap;

  const _SearchResultRow({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D2A36),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6A7B8C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '\$$price',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1787CF),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: Color(0xFF6A7B8C),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotSearchResult {
  final String id;
  final String title;
  final String location;
  final int price;
  final double lat;
  final double lng;

  const _SpotSearchResult({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.lat,
    required this.lng,
  });

  factory _SpotSearchResult.fromMap(Map<String, dynamic> map) {
    String readString(dynamic value, {String fallback = ''}) {
      final String text = value?.toString().trim() ?? '';
      return text.isEmpty ? fallback : text;
    }

    int readInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.round();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    double readDouble(dynamic value) {
      if (value is double) return value;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }

    String formatLocation(dynamic location) {
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

    List<double> readCoordinates(dynamic location) {
      if (location is Map) {
        final point = location['point'];
        if (point is Map && point['coordinates'] is List) {
          final List coords = point['coordinates'] as List;
          if (coords.length >= 2) {
            final double lngValue = readDouble(coords[0]);
            final double latValue = readDouble(coords[1]);
            return <double>[latValue, lngValue];
          }
        }
      }
      return <double>[0, 0];
    }

    final List<double> coords = readCoordinates(map['location']);

    return _SpotSearchResult(
      id: readString(map['_id'], fallback: ''),
      title: readString(map['title'], fallback: 'Untitled Spot'),
      location: formatLocation(map['location']),
      price: readInt(map['price']),
      lat: coords[0],
      lng: coords[1],
    );
  }
}
