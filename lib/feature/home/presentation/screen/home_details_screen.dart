import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xocobaby13/feature/home/presentation/routes/home_routes.dart';

class HomeDetailsScreen extends StatefulWidget {
  final bool isBooked;
  final bool showBookingButton;

  const HomeDetailsScreen({
    super.key,
    this.isBooked = false,
    this.showBookingButton = true,
  });

  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  late bool _isBooked;

  @override
  void initState() {
    super.initState();
    _isBooked = widget.isBooked;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  void _openCancellationSheet() {
    String? selectedReason;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9E3EE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Cancellation',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE23A3A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1787CF)),
                      ),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80',
                              width: 72,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 72,
                                height: 56,
                                color: const Color(0xFFE2E8F1),
                                child: const Icon(Icons.photo, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text(
                                  'Crystal Lake Sanctuary',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1D2A36),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '7:00 AM - 5:00 PM',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: Color(0xFF6A7B8C),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Montana, USA   •   Feb 05, 2026',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: Color(0xFF6A7B8C),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            children: const <Widget>[
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                r'$120',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E7CC8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Reason for Cancellation',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedReason,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Select a reason',
                        hintStyle: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6A7B8C),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFD2DEE9)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF1787CF),
                          ),
                        ),
                      ),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          value: 'Bad Weather',
                          child: Text('Bad Weather'),
                        ),
                        DropdownMenuItem(
                          value: 'Wrong Spot',
                          child: Text('Wrong Spot'),
                        ),
                        DropdownMenuItem(
                          value: 'Emergency',
                          child: Text('Emergency'),
                        ),
                        DropdownMenuItem(
                          value: 'Others',
                          child: Text('Others'),
                        ),
                      ],
                      onChanged: (String? value) {
                        setSheetState(() => selectedReason = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: selectedReason == null
                            ? null
                            : () {
                                Navigator.of(sheetContext).pop();
                                context.push(HomeRouteNames.refundRequest);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1787CF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Request For Refund',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> photos = <String>[
      'https://images.unsplash.com/photo-1482192596544-9eb780fc7f66?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80',
    ];

    const String title = 'Crystal Lake Sanctuary';
    const LatLng mapCenter = LatLng(39.8283, -98.5795);
    final CameraPosition mapCamera = CameraPosition(
      target: mapCenter,
      zoom: 3.6,
    );
    final Set<Marker> mapMarkers = <Marker>{
      Marker(
        markerId: const MarkerId('spot'),
        position: const LatLng(46.8797, -110.3626),
      ),
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 112),
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
                          'View Details',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1D2A36),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
                        height: 310,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 250,
                          color: const Color(0xFFE2E8F1),
                          child: const Icon(Icons.photo, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'More Photos',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 62,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: photos.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  photos[index],
                                  width: 62,
                                  height: 62,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 62,
                                    height: 62,
                                    color: const Color(0xFFE2E8F1),
                                    child: const Icon(Icons.photo, size: 24),
                                  ),
                                ),
                              ),
                              if (index == 0)
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE23A3A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      '6+',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D2A36),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7F2FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: RichText(
                            text: const TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: r'$120',
                                  style: TextStyle(
                                    color: Color(0xFF1E7CC8),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: '/day',
                                  style: TextStyle(
                                    color: Color(0xFF1D2A36),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const <Widget>[
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
                        SizedBox(width: 12),
                        Icon(
                          CupertinoIcons.calendar,
                          size: 13,
                          color: Color(0xFF3A4A5A),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Feb 10, 2026',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF3A4A5A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _DetailStatLabel(label: 'Rating'),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: _DetailStatLabel(label: 'Time'),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _DetailStatLabel(label: 'Date'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                CupertinoIcons.star_fill,
                                size: 12,
                                color: Color(0xFFF2B01E),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '4.5',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D2A36),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '7:00 AM - 5:00 PM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D2A36),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'FEB 10',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D2A36),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _DetailStatLabel(label: 'Max Guests'),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _DetailStatLabel(label: 'Available Slots'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        Expanded(
                          child: Text(
                            '2 Person',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D2A36),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '60/100 Slots',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E7CC8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Facilities',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _TagWrap(
                      tags: <String>[
                        'Dock',
                        'Kayak',
                        'Rods',
                        'Catfish',
                        'Life Jacket',
                        'License',
                        'Guide',
                        'Parking',
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Restriction',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _TagWrap(
                      tags: <String>[
                        'Dock',
                        'Kayak',
                        'Rods',
                        'Catfish',
                        'Life Jacket',
                        'License',
                        'Guide',
                        'Parking',
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.',
                      style: TextStyle(
                        height: 1.4,
                        fontSize: 11,
                        color: Color(0xFF3A4A5A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Host Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        const CircleAvatar(
                          radius: 17,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
                          ),
                          backgroundColor: Color(0xFFE2E8F1),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'John Mitchell',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D2A36),
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    CupertinoIcons.star_fill,
                                    size: 11,
                                    color: Color(0xFFF2B01E),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.5 (18 Reviews)',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF6A7B8C),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () =>
                                _showMessage(context, 'Start Chat'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1787CF),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: const Text(
                              'Start Chat',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            height: 240,
                            width: double.infinity,
                            child: GoogleMap(
                              initialCameraPosition: mapCamera,
                              mapType: MapType.normal,
                              myLocationEnabled: false,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              markers: mapMarkers,
                              gestureRecognizers:
                                  <Factory<OneSequenceGestureRecognizer>>{
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => context.push(HomeRouteNames.direction),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Color(0x22000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    'Get Direction',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1D2A36),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(
                                    CupertinoIcons.location_solid,
                                    color: Color(0xFF1E7CC8),
                                    size: 13,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 12,
                          top: 70,
                          child: _MapPriceTag(label: r'$95'),
                        ),
                        const Positioned(
                          right: 18,
                          top: 120,
                          child: _MapPriceTag(label: r'$150'),
                        ),
                        const Positioned(
                          right: 8,
                          bottom: 28,
                          child: _MapPriceTag(label: r'$450'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (widget.showBookingButton)
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  color: const Color(0xFFF2F9FF),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isBooked
                          ? _openCancellationSheet
                          : () => context.push(HomeRouteNames.payment),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1787CF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _isBooked ? 'Cancel & Refund' : 'Book Now',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailStatLabel extends StatelessWidget {
  final String label;

  const _DetailStatLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFF6A7B8C),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TagWrap extends StatelessWidget {
  final List<String> tags;

  const _TagWrap({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (String tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF1D2A36),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MapPriceTag extends StatelessWidget {
  final String label;

  const _MapPriceTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E7CC8),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
