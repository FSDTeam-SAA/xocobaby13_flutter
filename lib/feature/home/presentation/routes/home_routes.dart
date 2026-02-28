import 'package:xocobaby13/feature/home/presentation/screen/direction_map_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/home/presentation/screen/home_details_screen.dart';
import 'package:xocobaby13/feature/home/presentation/screen/payment_screen.dart';
import 'package:xocobaby13/feature/home/presentation/screen/payment_success_screen.dart';
import 'package:xocobaby13/feature/home/presentation/screen/recommended_spots_screen.dart';
import 'package:xocobaby13/feature/home/presentation/screen/refund_request_screen.dart';

class HomeRouteNames {
  const HomeRouteNames._();

  static const String details = '/home/details';
  static const String direction = '/home/direction';
  static const String payment = '/home/payment';
  static const String paymentSuccess = '/home/payment/success';
  static const String refundRequest = '/home/refund-request';
  static const String recommended = '/home/recommended';
}

class HomeRoutes {
  const HomeRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: HomeRouteNames.details,
      builder: (context, state) {
        final bool isBooked =
            state.uri.queryParameters['booked']?.toLowerCase() == '1';
        final String? spotId = state.uri.queryParameters['id'];
        double? readDouble(String key) {
          final raw = state.uri.queryParameters[key];
          if (raw == null) return null;
          return double.tryParse(raw);
        }

        return HomeDetailsScreen(
          isBooked: isBooked,
          lat: readDouble('lat'),
          lng: readDouble('lng'),
          distanceKm: readDouble('distanceKm'),
          spotId: spotId,
        );
      },
    ),
    GoRoute(
      path: HomeRouteNames.direction,
      builder: (context, state) => const DirectionMapScreen(),
    ),
    GoRoute(
      path: HomeRouteNames.payment,
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: HomeRouteNames.paymentSuccess,
      builder: (context, state) => const PaymentSuccessScreen(),
    ),
    GoRoute(
      path: HomeRouteNames.refundRequest,
      builder: (context, state) => const RefundRequestScreen(),
    ),
    GoRoute(
      path: HomeRouteNames.recommended,
      builder: (context, state) => const RecommendedSpotsScreen(),
    ),
  ];
}
