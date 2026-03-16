import 'package:xocobaby13/feature/profile/model/activity_status_model.dart';

class ActivityItemModel {
  final String title;
  final String dateLabel;
  final double rating;
  final ActivityStatusModel status;
  final String imagePath;
  final String timeRange;
  final String location;
  final String ownerName;
  final int reviewsCount;
  final int pricePerDay;
  final String? spotId;
  final String? bookingId;
  final String? paymentId;
  final String bookingStatus;

  const ActivityItemModel({
    required this.title,
    required this.dateLabel,
    required this.rating,
    required this.status,
    required this.imagePath,
    required this.timeRange,
    required this.location,
    required this.ownerName,
    required this.reviewsCount,
    required this.pricePerDay,
    this.spotId,
    this.bookingId,
    this.paymentId,
    this.bookingStatus = '',
  });
}
