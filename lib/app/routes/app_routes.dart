import 'package:app_pigeon/app_pigeon.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/app/routes/auth_router_notifier.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/chat/presentation/routes/chat_routes.dart';
import 'package:xocobaby13/feature/navigation/presentation/routes/navigation_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/routes/profile_routes.dart';

class AppRouter {
  const AppRouter._();

  static final AuthRouterNotifier _authNotifier = AuthRouterNotifier(
    Get.find<AuthorizedPigeon>(),
  );

  static final GoRouter router = GoRouter(
    initialLocation: AuthRouteNames.onboardingSplash,
    refreshListenable: _authNotifier,
    redirect: (context, state) {
      final AuthStatus authStatus = _authNotifier.status;
      if (authStatus is AuthLoading) {
        return null;
      }

      final String location = state.uri.path;
      final bool isPublicRoute = _isPublicRoute(location);
      final bool isAuthed = authStatus is Authenticated;

      if (isAuthed) {
        final String targetNav =
            _navRouteForRole((authStatus as Authenticated).auth.data['role']);
        if (location == NavigationRouteNames.main &&
            targetNav == NavigationRouteNames.spotOwnerMain) {
          return targetNav;
        }
        if (location == NavigationRouteNames.spotOwnerMain &&
            targetNav == NavigationRouteNames.main) {
          return targetNav;
        }
        if (isPublicRoute) {
          return targetNav;
        }
        return null;
      }

      if (isPublicRoute) {
        return null;
      }

      return AuthRouteNames.login;
    },
    routes: <RouteBase>[
      ...AuthRoutes.routes,
      ...ChatRoutes.routes,
      ...NavigationRoutes.routes,
      ...ProfileRoutes.routes,
    ],
  );

  static bool _isPublicRoute(String location) {
    const Set<String> publicRoutes = <String>{
      AuthRouteNames.onboardingSplash,
      AuthRouteNames.splashView,
      AuthRouteNames.onboarding1,
      AuthRouteNames.onboarding2,
      AuthRouteNames.onboarding3,
      AuthRouteNames.onboarding4,
      AuthRouteNames.login,
      AuthRouteNames.signup,
      AuthRouteNames.forgotPassword,
      AuthRouteNames.otpVerify,
      AuthRouteNames.resetPassword,
    };
    return publicRoutes.contains(location);
  }

  static String _navRouteForRole(dynamic rawRole) {
    final String normalizedRole = (rawRole ?? '')
        .toString()
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z]'), '');
    if (normalizedRole == 'spotowner') {
      return NavigationRouteNames.spotOwnerMain;
    }
    return NavigationRouteNames.main;
  }
}
