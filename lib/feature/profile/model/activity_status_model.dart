enum ActivityStatusModel { ongoing, upcoming, completed }

extension ActivityStatusModelLabel on ActivityStatusModel {
  String get label {
    switch (this) {
      case ActivityStatusModel.ongoing:
        return 'Ongoing';
      case ActivityStatusModel.upcoming:
        return 'Upcoming';
      case ActivityStatusModel.completed:
        return 'Completed';
    }
  }
}
