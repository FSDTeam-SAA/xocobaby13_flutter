import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/navigation/presentation/routes/navigation_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/routes/profile_routes.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AuthRouteNames.onboardingSplash,
    routes: <RouteBase>[
      ...AuthRoutes.routes,
      ...NavigationRoutes.routes,
      ...ProfileRoutes.routes,
    ],
  );
}
