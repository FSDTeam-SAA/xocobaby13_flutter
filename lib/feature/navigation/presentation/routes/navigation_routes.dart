import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/navigation/presentation/screen/main_navigation_screen.dart';

class NavigationRouteNames {
  const NavigationRouteNames._();

  static const String main = '/navigation/main';
}

class NavigationRoutes {
  const NavigationRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: NavigationRouteNames.main,
      builder: (_, _) => const MainNavigationScreen(),
    ),
  ];
}
