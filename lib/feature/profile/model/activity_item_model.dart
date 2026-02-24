import 'package:xocobaby13/feature/profile/model/activity_status_model.dart';

class ActivityItemModel {
  final String title;
  final String dateLabel;
  final String reviewer;
  final double rating;
  final ActivityStatusModel status;
  final String imagePath;

  const ActivityItemModel({
    required this.title,
    required this.dateLabel,
    required this.reviewer,
    required this.rating,
    required this.status,
    required this.imagePath,
  });
}
