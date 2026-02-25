import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/home/presentation/screen/home_details_screen.dart';

class HomeRouteNames {
  const HomeRouteNames._();

  static const String details = '/home/details';
}

class HomeRoutes {
  const HomeRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: HomeRouteNames.details,
      builder: (_, __) => const HomeDetailsScreen(),
    ),
  ];
}
