import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

class DirectionMapScreen extends StatelessWidget {
  const DirectionMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const LatLng source = LatLng(45.0150, -93.1020);
    const LatLng destination = LatLng(46.8797, -110.3626);

    const List<LatLng> routePoints = <LatLng>[
      LatLng(45.0150, -93.1020),
      LatLng(45.7000, -96.4200),
      LatLng(46.1200, -100.3500),
      LatLng(46.5000, -104.8200),
      LatLng(46.8797, -110.3626),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(46.0500, -102.4000),
                zoom: 4.1,
              ),
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              compassEnabled: false,
              markers: <Marker>{
                Marker(
                  markerId: const MarkerId('source'),
                  position: source,
                  infoWindow: const InfoWindow(title: 'Your Location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                ),
                const Marker(
                  markerId: MarkerId('destination'),
                  position: destination,
                  infoWindow: InfoWindow(title: 'Crystal Lake Sanctuary'),
                ),
              },
              polylines: <Polyline>{
                const Polyline(
                  polylineId: PolylineId('route'),
                  color: Color(0xFF1787CF),
                  width: 5,
                  points: routePoints,
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
                      onTap: () => context.pop(),
                      child: const Icon(
                        CupertinoIcons.back,
                        size: 20,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Direction',
                      style: TextStyle(
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
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
                    const Text(
                      'Crystal Lake Sanctuary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Montana, USA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6A7B8C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: <Widget>[
                        _DirectionInfo(title: 'ETA', value: '2h 40m'),
                        SizedBox(width: 18),
                        _DirectionInfo(title: 'Distance', value: '186 mi'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: AppElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navigation started'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
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
