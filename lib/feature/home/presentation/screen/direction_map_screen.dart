import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  bool _isResolvingLocation = true;
  String? _locationError;

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
      _updateCamera();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isResolvingLocation = false;
        _locationError = 'Unable to detect your current location';
      });
      _updateCamera();
    }
  }

  LatLngBounds _boundsFromPoints(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final LatLng point in points.skip(1)) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _updateCamera() {
    final GoogleMapController? controller = _mapController;
    final LatLng? destination = _destination;
    if (controller == null || destination == null) return;

    final LatLng? currentLocation = _currentLocation;
    if (currentLocation == null) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(destination, 15));
      return;
    }

    final double meters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      destination.latitude,
      destination.longitude,
    );

    if (meters > 50000) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(destination, 15));
      return;
    }

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        _boundsFromPoints(<LatLng>[currentLocation, destination]),
        56,
      ),
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
    final CameraPosition initialCameraPosition = CameraPosition(
      target: destination ?? const LatLng(23.8103, 90.4125),
      zoom: destination == null ? 9 : 15,
    );

    final Set<Marker> markers = <Marker>{
      if (destination != null)
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          infoWindow: InfoWindow(title: _title),
        ),
      if (_currentLocation != null)
        Marker(
          markerId: const MarkerId('current'),
          position: _currentLocation!,
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
    };
    final Set<Polyline> polylines = <Polyline>{
      if (_currentLocation != null && destination != null)
        Polyline(
          polylineId: const PolylineId('preview_line'),
          color: const Color(0xFF1787CF),
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
          points: <LatLng>[_currentLocation!, destination],
        ),
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _updateCamera();
              },
              mapType: MapType.normal,
              myLocationEnabled: _currentLocation != null,
              myLocationButtonEnabled: _currentLocation != null,
              buildingsEnabled: true,
              trafficEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              markers: markers,
              polylines: polylines,
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
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: _DirectionInfo(
                            title: 'ETA',
                            value: 'Open in Maps',
                          ),
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
