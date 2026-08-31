import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';
import 'package:xocobaby13/core/extensions/app_navigation_extension.dart';

class DirectionMapScreen extends StatefulWidget {
  const DirectionMapScreen({
    super.key,
    required this.title,
    required this.address,
    required this.lat,
    required this.lng,
  });

  final String title;
  final String address;
  final double? lat;
  final double? lng;

  @override
  State<DirectionMapScreen> createState() => _DirectionMapScreenState();
}

class _DirectionMapScreenState extends State<DirectionMapScreen> {
  gmap.GoogleMapController? _mapController;
  LatLng? _currentLocation;
  bool _isResolvingLocation = true;
  String? _locationError;
  bool _isLoadingRoute = false;
  String? _routeError;
  List<LatLng> _routePoints = const <LatLng>[];
  String? _routeDistanceText;
  String? _routeDurationText;

  LatLng? get _destination {
    final double? lat = widget.lat;
    final double? lng = widget.lng;
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  String get _title {
    final String title = widget.title.trim();
    return title.isEmpty ? 'Spot Direction' : title;
  }

  String get _address {
    final String address = widget.address.trim();
    return address.isEmpty ? 'Destination address unavailable' : address;
  }

  String get _distanceLabel {
    if (_routeDistanceText != null && _routeDistanceText!.isNotEmpty) {
      return _routeDistanceText!;
    }

    final LatLng? destination = _destination;
    final LatLng? currentLocation = _currentLocation;
    if (destination == null || currentLocation == null) return '--';

    final double meters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      destination.latitude,
      destination.longitude,
    );
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    final double kilometers = meters / 1000;
    return kilometers >= 10
        ? '${kilometers.toStringAsFixed(0)} km'
        : '${kilometers.toStringAsFixed(1)} km';
  }

  String get _etaLabel {
    if (_routeDurationText != null && _routeDurationText!.isNotEmpty) {
      return _routeDurationText!;
    }
    if (_isLoadingRoute) return 'Loading...';
    return 'Open in Maps';
  }

  LatLng get _initialCenter => _destination ?? const LatLng(23.8103, 90.4125);

  @override
  void initState() {
    super.initState();
    _resolveCurrentLocation();
  }

  Future<void> _resolveCurrentLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isResolvingLocation = false;
          _locationError = 'Location service is turned off';
        });
        _updateCamera();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _isResolvingLocation = false;
          _locationError = 'Location permission was not granted';
        });
        _updateCamera();
        return;
      }

      final Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isResolvingLocation = false;
        _locationError = null;
      });
      await _loadRoutePreview();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isResolvingLocation = false;
        _locationError = 'Unable to detect your current location';
      });
      _updateCamera();
    }
  }

  Future<void> _loadRoutePreview() async {
    final LatLng? destination = _destination;
    final LatLng? currentLocation = _currentLocation;
    if (destination == null || currentLocation == null) {
      _updateCamera();
      return;
    }

    setState(() {
      _isLoadingRoute = true;
      _routeError = null;
      _routePoints = const <LatLng>[];
      _routeDistanceText = null;
      _routeDurationText = null;
    });

    try {
      final Response<dynamic> response = await Dio().get(
        'https://router.project-osrm.org/route/v1/driving/'
        '${currentLocation.longitude},${currentLocation.latitude};'
        '${destination.longitude},${destination.latitude}',
        queryParameters: <String, dynamic>{
          'overview': 'full',
          'geometries': 'geojson',
          'steps': false,
        },
      );

      final Map<String, dynamic> data = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final List<dynamic> routes = data['routes'] is List
          ? List<dynamic>.from(data['routes'] as List)
          : const <dynamic>[];

      if (routes.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isLoadingRoute = false;
          _routeError = 'Road route preview is unavailable right now';
        });
        _updateCamera();
        return;
      }

      final Map<String, dynamic> route = Map<String, dynamic>.from(
        routes.first as Map,
      );
      final Map<String, dynamic> geometry = route['geometry'] is Map
          ? Map<String, dynamic>.from(route['geometry'] as Map)
          : <String, dynamic>{};
      final List<dynamic> coordinates = geometry['coordinates'] is List
          ? List<dynamic>.from(geometry['coordinates'] as List)
          : const <dynamic>[];

      final List<LatLng> routePoints = <LatLng>[];
      for (final dynamic coordinate in coordinates) {
        if (coordinate is List && coordinate.length >= 2) {
          final double? longitude = double.tryParse(coordinate[0].toString());
          final double? latitude = double.tryParse(coordinate[1].toString());
          if (latitude != null && longitude != null) {
            routePoints.add(LatLng(latitude, longitude));
          }
        }
      }

      final double distanceMeters = _readDouble(route['distance']);
      final double durationSeconds = _readDouble(route['duration']);

      if (!mounted) return;
      setState(() {
        _isLoadingRoute = false;
        _routePoints = routePoints;
        _routeDistanceText = _formatDistance(distanceMeters);
        _routeDurationText = _formatDuration(durationSeconds);
        _routeError = routePoints.length >= 2
            ? null
            : 'Road route preview is unavailable right now';
      });
      _updateCamera();
    } on DioException catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingRoute = false;
        _routeError = 'Unable to load road route preview';
      });
      _updateCamera();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingRoute = false;
        _routeError = 'Unable to load road route preview';
      });
      _updateCamera();
    }
  }

  double _readDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _formatDistance(double meters) {
    if (meters <= 0) return '--';
    if (meters < 1000) return '${meters.round()} m';
    final double kilometers = meters / 1000;
    return kilometers >= 10
        ? '${kilometers.toStringAsFixed(0)} km'
        : '${kilometers.toStringAsFixed(1)} km';
  }

  String _formatDuration(double seconds) {
    if (seconds <= 0) return 'Open in Maps';
    final Duration duration = Duration(seconds: seconds.round());
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} min';
    }
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  gmap.LatLng _toGmapLatLng(LatLng point) {
    return gmap.LatLng(point.latitude, point.longitude);
  }

  gmap.LatLngBounds _boundsFromPoints(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final LatLng point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    return gmap.LatLngBounds(
      southwest: gmap.LatLng(minLat, minLng),
      northeast: gmap.LatLng(maxLat, maxLng),
    );
  }

  void _updateCamera() {
    final gmap.GoogleMapController? controller = _mapController;
    if (controller == null) return;

    final LatLng? destination = _destination;
    if (destination == null) return;

    if (_routePoints.length >= 2) {
      final gmap.LatLngBounds bounds = _boundsFromPoints(_routePoints);
      controller.animateCamera(gmap.CameraUpdate.newLatLngBounds(bounds, 80));
      return;
    }

    final LatLng? currentLocation = _currentLocation;
    if (currentLocation == null) {
      controller.animateCamera(
        gmap.CameraUpdate.newLatLngZoom(_toGmapLatLng(destination), 15),
      );
      return;
    }

    final double meters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      destination.latitude,
      destination.longitude,
    );
    if (meters > 50000) {
      controller.animateCamera(
        gmap.CameraUpdate.newLatLngZoom(_toGmapLatLng(destination), 15),
      );
      return;
    }

    final LatLng center = LatLng(
      (currentLocation.latitude + destination.latitude) / 2,
      (currentLocation.longitude + destination.longitude) / 2,
    );
    final double zoom = meters > 15000
        ? 10.5
        : meters > 7000
        ? 11.5
        : meters > 3000
        ? 12.5
        : meters > 1500
        ? 13.5
        : 14.5;
    controller.animateCamera(
      gmap.CameraUpdate.newLatLngZoom(_toGmapLatLng(center), zoom),
    );
  }

  Future<void> _startNavigation() async {
    final LatLng? destination = _destination;
    if (destination == null) {
      _showMessage('Destination location is unavailable');
      return;
    }

    final Map<String, String> queryParameters = <String, String>{
      'api': '1',
      'destination': '${destination.latitude},${destination.longitude}',
      'travelmode': 'driving',
    };

    if (_currentLocation != null) {
      queryParameters['origin'] =
          '${_currentLocation!.latitude},${_currentLocation!.longitude}';
    }

    final Uri mapsUri = Uri.https(
      'www.google.com',
      '/maps/dir/',
      queryParameters,
    );

    final bool launched = await launchUrl(
      mapsUri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      _showMessage('Unable to open navigation');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LatLng? destination = _destination;
    final List<LatLng> linePoints = _routePoints.isNotEmpty
        ? _routePoints
        : <LatLng>[
            if (_currentLocation case final LatLng currentLocationPoint)
              currentLocationPoint,
            if (destination case final LatLng destinationPoint)
              destinationPoint,
          ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            gmap.GoogleMap(
              initialCameraPosition: gmap.CameraPosition(
                target: _toGmapLatLng(_initialCenter),
                zoom: destination == null ? 9 : 15,
              ),
              onMapCreated: (gmap.GoogleMapController controller) {
                _mapController = controller;
                _updateCamera();
              },
              minMaxZoomPreference: const gmap.MinMaxZoomPreference(null, 15),
              myLocationEnabled: _currentLocation != null,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              polylines: <gmap.Polyline>{
                if (linePoints.length >= 2)
                  gmap.Polyline(
                    polylineId: const gmap.PolylineId('route'),
                    points: linePoints.map(_toGmapLatLng).toList(),
                    width: 5,
                    color: const Color(0xFF1787CF),
                  ),
              },
              markers: <gmap.Marker>{
                if (destination case final LatLng destinationPoint)
                  gmap.Marker(
                    markerId: const gmap.MarkerId('destination'),
                    position: _toGmapLatLng(destinationPoint),
                    icon: gmap.BitmapDescriptor.defaultMarkerWithHue(
                      gmap.BitmapDescriptor.hueRed,
                    ),
                  ),
              },
            ),
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
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
                    Text(
                      destination == null
                          ? 'Location Unavailable'
                          : 'Direction',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _address,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6A7B8C),
                      ),
                    ),
                    if (_routeError != null) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        _routeError!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFE23A3A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _DirectionInfo(title: 'ETA', value: _etaLabel),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: _DirectionInfo(
                            title: 'Distance',
                            value: _distanceLabel,
                          ),
                        ),
                      ],
                    ),
                    if (_isResolvingLocation ||
                        _locationError != null) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        _isResolvingLocation
                            ? 'Detecting your current location...'
                            : (_locationError ?? ''),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6A7B8C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: AppElevatedButton(
                        onPressed: _startNavigation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1787CF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Start Navigation',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionInfo extends StatelessWidget {
  final String title;
  final String value;

  const _DirectionInfo({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF6A7B8C),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1D2A36),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
