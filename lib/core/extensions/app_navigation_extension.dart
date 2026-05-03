import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/navigation/presentation/routes/navigation_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/routes/profile_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/routes/spot_owner_profile_routes.dart';

extension AppNavigationExtension on BuildContext {
  void safePop<T extends Object?>([T? result]) {
    final GoRouter router = GoRouter.of(this);
    if (router.canPop()) {
      router.pop(result);
      return;
    }
    go(_fallbackLocation);
  }

  String get _fallbackLocation {
    final String location = GoRouterState.of(this).uri.path;

    if (location.startsWith(SpotOwnerProfileRouteNames.home)) {
      return SpotOwnerProfileRouteNames.home;
    }
    if (location.startsWith('/spot-owner')) {
      return NavigationRouteNames.spotOwnerMain;
    }
    if (location.startsWith(ProfileRouteNames.home)) {
      return ProfileRouteNames.home;
    }
    return NavigationRouteNames.main;
  }
}
