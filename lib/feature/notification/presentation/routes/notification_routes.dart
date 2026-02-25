import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/notification/presentation/screen/notification_screen.dart';

class NotificationRouteNames {
  const NotificationRouteNames._();

  static const String notifications = '/notifications';
}

class NotificationRoutes {
  const NotificationRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: NotificationRouteNames.notifications,
      builder: (_, __) => const NotificationScreen(),
    ),
  ];
}
