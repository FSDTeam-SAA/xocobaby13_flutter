import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/search/presentation/screen/fisherman_search_screen.dart';

class SearchRouteNames {
  const SearchRouteNames._();

  static const String fishermanSearch = '/search/areas';
}

class SearchRoutes {
  const SearchRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: SearchRouteNames.fishermanSearch,
      builder: (_, __) => const FishermanSearchScreen(),
    ),
  ];
}
