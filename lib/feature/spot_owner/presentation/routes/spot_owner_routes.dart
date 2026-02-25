import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/spot_owner/presentation/screen/spot_owner_create_spot_screen.dart';
import 'package:xocobaby13/feature/spot_owner/presentation/screen/spot_owner_analytics_screen.dart';

class SpotOwnerRouteNames {
  const SpotOwnerRouteNames._();

  static const String createSpot = '/spot-owner/create-spot';
  static const String analytics = '/spot-owner/analytics';
}

class SpotOwnerRoutes {
  const SpotOwnerRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: SpotOwnerRouteNames.createSpot,
      builder: (_, __) => const SpotOwnerCreateSpotScreen(),
    ),
    GoRoute(
      path: SpotOwnerRouteNames.analytics,
      builder: (_, __) => const SpotOwnerAnalyticsScreen(),
    ),
  ];
}
