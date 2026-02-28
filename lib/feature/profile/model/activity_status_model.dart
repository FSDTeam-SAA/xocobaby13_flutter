enum ActivityStatusModel { ongoing, upcoming, completed, canceled }

extension ActivityStatusModelLabel on ActivityStatusModel {
  String get label {
    switch (this) {
      case ActivityStatusModel.ongoing:
        return 'Ongoing';
      case ActivityStatusModel.upcoming:
        return 'Upcoming';
      case ActivityStatusModel.completed:
        return 'Completed';
      case ActivityStatusModel.canceled:
        return 'Canceled';
    }
  }
}
