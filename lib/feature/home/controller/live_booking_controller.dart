import 'package:app_pigeon/app_pigeon.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';

class LiveBookingController extends GetxController {
  final AuthorizedPigeon _appPigeon = Get.find<AuthorizedPigeon>();
  static const String _defaultSpotImage =
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80';
  static const String _defaultHostAvatar =
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80';

  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final RxList<LiveBookingItem> events = <LiveBookingItem>[].obs;
  final RxSet<String> actionLoadingIds = <String>{}.obs;

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

  bool _isFetching = false;
  bool _queuedReload = false;

  Future<void> loadLiveBookings() async {
    if (_isFetching) {
      _queuedReload = true;
      return;
    }

    _isFetching = true;
    isLoading.value = true;
    error.value = null;

    try {
      final response = await _appPigeon.get(
        ApiEndpoints.getLiveBookings,
        queryParameters: const <String, dynamic>{'limit': 100},
      );
      final List<LiveBookingItem> bookings = _extractLiveEvents(
        response.data,
        isUpcomingFallback: false,
      );

      if (bookings.isNotEmpty) {
        events.assignAll(bookings);
      } else {
        await _loadUpcomingFallbackBookings();
      }
    } catch (_) {
      error.value = 'Failed to load live bookings';
    } finally {
      isLoading.value = false;
      _isFetching = false;

      if (_queuedReload) {
        _queuedReload = false;
        Future<void>.microtask(loadLiveBookings);
      }
    }
  }

  Future<void> toggleArrivalAt(int index) async {
    if (index < 0 || index >= events.length) {
      return;
    }

    final LiveBookingItem event = events[index];
    final String bookingId = event.id?.trim() ?? '';
    if (bookingId.isEmpty) {
      error.value = 'Booking id is missing';
      return;
    }
    if (!event.canUpdateAttendance) {
      return;
    }
    if (actionLoadingIds.contains(bookingId)) {
      return;
    }

    actionLoadingIds.add(bookingId);
    actionLoadingIds.refresh();

    try {
      if (!event.isArrived) {
        await _appPigeon.patch(ApiEndpoints.bookingArrived(bookingId));
        events[index] = event.copyWith(
          isArrived: true,
          statusLabel: 'Check Out',
        );
      } else {
        await _appPigeon.patch(ApiEndpoints.bookingCheckout(bookingId));
        events.removeAt(index);
      }
    } catch (_) {
      error.value = event.isArrived
          ? 'Failed to check out booking'
          : 'Failed to mark booking as arrived';
    } finally {
      actionLoadingIds.remove(bookingId);
      actionLoadingIds.refresh();
    }
  }

  bool _isLiveBooking(Map<String, dynamic> booking) {
    final String status = _readString(booking['status']).toLowerCase();
    final String paymentStatus = _readString(
      booking['paymentStatus'],
    ).toLowerCase();

    if (status == 'cancelled' ||
        status == 'canceled' ||
        status == 'completed') {
      return false;
    }

    if (paymentStatus == 'refunded' ||
        paymentStatus == 'failed' ||
        paymentStatus == 'cancelled' ||
        paymentStatus == 'canceled') {
      return false;
    }

    final String paymentId =
        _readObjectId(booking['paymentId']) ??
        _readObjectId(booking['payment']) ??
        '';
    return paymentId.isNotEmpty;
  }

  bool _isDisplayableFallbackBooking(Map<String, dynamic> booking) {
    final String status = _readString(booking['status']).toLowerCase();
    final String paymentStatus = _readString(
      booking['paymentStatus'],
    ).toLowerCase();

    if (status == 'cancelled' ||
        status == 'canceled' ||
        status == 'completed') {
      return false;
    }

    if (paymentStatus == 'refunded' ||
        paymentStatus == 'failed' ||
        paymentStatus == 'cancelled' ||
        paymentStatus == 'canceled') {
      return false;
    }

    if (status != 'confirmed' && status != 'pending') {
      return false;
    }

    final DateTime? bookingDate = _parseDate(booking['date']);
    if (bookingDate == null) {
      return false;
    }

    return !bookingDate.isBefore(_startOfToday());
  }

  Future<void> _loadUpcomingFallbackBookings() async {
    final response = await _appPigeon.get(
      ApiEndpoints.getMyBookings,
      queryParameters: const <String, dynamic>{'limit': 100},
    );

    final List<Map<String, dynamic>> upcomingBookings =
        _extractBookingMaps(
            response.data,
          ).where(_isDisplayableFallbackBooking).toList(growable: false)
          ..sort((Map<String, dynamic> a, Map<String, dynamic> b) {
            final DateTime? first = _parseDate(a['date']);
            final DateTime? second = _parseDate(b['date']);
            if (first == null && second == null) {
              return 0;
            }
            if (first == null) {
              return 1;
            }
            if (second == null) {
              return -1;
            }
            return first.compareTo(second);
          });

    final List<LiveBookingItem> fallbackEvents = upcomingBookings
        .map(
          (Map<String, dynamic> booking) =>
              _mapBookingToLiveEvent(booking, isUpcomingFallback: true),
        )
        .toList(growable: false);

    events.assignAll(fallbackEvents);
  }

  List<LiveBookingItem> _extractLiveEvents(
    dynamic rawResponse, {
    required bool isUpcomingFallback,
  }) {
    final List<LiveBookingItem> bookings = <LiveBookingItem>[];

    for (final Map<String, dynamic> booking in _extractBookingMaps(
      rawResponse,
    )) {
      if (!_isLiveBooking(booking)) {
        continue;
      }
      bookings.add(
        _mapBookingToLiveEvent(booking, isUpcomingFallback: isUpcomingFallback),
      );
    }

    return bookings;
  }

  List<Map<String, dynamic>> _extractBookingMaps(dynamic rawResponse) {
    final Map<String, dynamic> responseBody = rawResponse is Map
        ? Map<String, dynamic>.from(rawResponse)
        : <String, dynamic>{};
    final dynamic data = responseBody['data'];
    final List<Map<String, dynamic>> bookings = <Map<String, dynamic>>[];

    if (data is! List) {
      return bookings;
    }

    for (final dynamic item in data) {
      if (item is! Map) {
        continue;
      }
      bookings.add(Map<String, dynamic>.from(item));
    }

    return bookings;
  }

  LiveBookingItem _mapBookingToLiveEvent(
    Map<String, dynamic> booking, {
    bool isUpcomingFallback = false,
  }) {
    final Map<String, dynamic> spot = booking['spot'] is Map
        ? Map<String, dynamic>.from(booking['spot'])
        : <String, dynamic>{};
    final Map<String, dynamic> owner = booking['owner'] is Map
        ? Map<String, dynamic>.from(booking['owner'])
        : <String, dynamic>{};
    final Map<String, dynamic> slot = booking['slot'] is Map
        ? Map<String, dynamic>.from(booking['slot'])
        : <String, dynamic>{};
    final bool isArrived =
        _readString(booking['attendanceStatus']).toLowerCase() == 'arrived';
    final String bookingStatus = _readString(booking['status']).toLowerCase();

    return LiveBookingItem(
      id: booking['_id']?.toString(),
      title: _readString(spot['title'], fallback: 'Spot Booking'),
      location: _readLocation(spot),
      date: _formatDate(booking['date']?.toString()),
      time:
          '${_readString(slot['start'], fallback: '00:00')} - ${_readString(slot['end'], fallback: '00:00')}',
      hostName: _readString(owner['fullName'], fallback: 'Spot Owner'),
      rating: _readDouble(spot['ratingAvg']),
      reviews: _readInt(spot['ratingCount']),
      imageUrl: _resolveImageUrl(spot['images'], fallback: _defaultSpotImage),
      hostAvatarUrl: _resolveImageUrl(
        owner['avatar'],
        fallback: _defaultHostAvatar,
      ),
      statusLabel: isUpcomingFallback
          ? bookingStatus == 'pending'
                ? 'Pending'
                : 'Upcoming'
          : isArrived
          ? 'Check Out'
          : 'Arrive',
      canUpdateAttendance: !isUpcomingFallback,
      isArrived: isArrived,
    );
  }

  DateTime _startOfToday() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime? _parseDate(dynamic rawDate) {
    final String date = _readString(rawDate);
    if (date.isEmpty) {
      return null;
    }
    final DateTime? parsed = DateTime.tryParse(date);
    if (parsed == null) {
      return null;
    }
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  String _resolveImageUrl(dynamic rawImage, {required String fallback}) {
    if (rawImage is List) {
      for (final dynamic item in rawImage) {
        final String image = _readString(item);
        if (image.isNotEmpty) {
          return image;
        }
      }
    }

    final String singleImage = _readString(rawImage);
    if (singleImage.isNotEmpty) {
      return singleImage;
    }

    return fallback;
  }

  String _readLocation(Map<String, dynamic> spot) {
    final dynamic location = spot['location'];
    if (location is Map) {
      final String area = _readString(location['area']);
      final String address = _readString(location['address']);
      final String city = _readString(location['city']);
      final List<String> parts = <String>[
        if (area.isNotEmpty) area,
        if (address.isNotEmpty) address,
        if (city.isNotEmpty) city,
      ];
      if (parts.isNotEmpty) {
        return parts.join(', ');
      }
    }

    final String address = _readString(spot['address']);
    return address.isEmpty ? 'Unknown location' : address;
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return 'TBD';
    }

    final DateTime? parsed = DateTime.tryParse(rawDate);
    if (parsed == null) {
      return rawDate;
    }

    return '${parsed.day} ${_monthNames[parsed.month - 1]} ${parsed.year}';
  }

  String _readString(dynamic value, {String fallback = ''}) {
    if (value == null) {
      return fallback;
    }
    final String normalized = value.toString().trim();
    return normalized.isEmpty ? fallback : normalized;
  }

  int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.round();
    }
    return int.tryParse(_readString(value)) ?? 0;
  }

  double _readDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(_readString(value)) ?? 0;
  }

  String? _readObjectId(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Map) {
      final String nestedId =
          value['_id']?.toString().trim() ??
          value['id']?.toString().trim() ??
          '';
      return nestedId.isEmpty ? null : nestedId;
    }
    final String rawId = value.toString().trim();
    return rawId.isEmpty ? null : rawId;
  }

  static LiveBookingController instance() {
    if (Get.isRegistered<LiveBookingController>()) {
      return Get.find<LiveBookingController>();
    }
    return Get.put<LiveBookingController>(LiveBookingController());
  }
}

class LiveBookingItem {
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
  final String statusLabel;
  final bool canUpdateAttendance;

  const LiveBookingItem({
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
    required this.statusLabel,
    required this.canUpdateAttendance,
  });

  LiveBookingItem copyWith({bool? isArrived, String? statusLabel}) {
    return LiveBookingItem(
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
      statusLabel: statusLabel ?? this.statusLabel,
      canUpdateAttendance: canUpdateAttendance,
    );
  }
}
