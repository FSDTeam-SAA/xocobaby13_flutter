import 'package:xocobaby13/feature/home/presentation/screen/direction_map_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/home/presentation/screen/home_details_screen.dart';
import 'package:xocobaby13/feature/home/presentation/screen/payment_screen.dart';
import 'package:xocobaby13/feature/home/presentation/screen/payment_success_screen.dart';
import 'package:xocobaby13/feature/home/presentation/screen/refund_request_screen.dart';

class HomeRouteNames {
  const HomeRouteNames._();

  static const String details = '/home/details';
  static const String direction = '/home/direction';
  static const String payment = '/home/payment';
  static const String paymentSuccess = '/home/payment/success';
  static const String refundRequest = '/home/refund-request';
}

class HomeRoutes {
  const HomeRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: HomeRouteNames.details,
      builder: (context, state) {
        final bool isBooked =
            state.uri.queryParameters['booked']?.toLowerCase() == '1';
        return HomeDetailsScreen(isBooked: isBooked);
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
  ];
}
