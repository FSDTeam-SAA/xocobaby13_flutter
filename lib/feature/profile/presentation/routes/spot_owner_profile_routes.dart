import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/spot_owner_bank_account_success_screen.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/spot_owner_earnings_screen.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/spot_owner_link_bank_account_screen.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/spot_owner_profile_screen.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/spot_owner_stripe_connect_screen.dart';
import '../screen/update_password_screen.dart';
import '../screen/personal_details_screen.dart';

class SpotOwnerProfileRouteNames {
  const SpotOwnerProfileRouteNames._();

  static const String home = '/spot-owner/profile';
  static const String personalDetails = '/spot-owner/profile/personal-details';
  static const String linkBankAccount = '/spot-owner/profile/link-bank-account';
  static const String linkBankAccountForm =
      '/spot-owner/profile/link-bank-account/form';
  static const String bankAccountSuccess =
      '/spot-owner/profile/bank-account-success';
  static const String earnings = '/spot-owner/profile/earnings';
  static const String updatePassword = '/spot-owner/profile/update-password';
}

class SpotOwnerProfileRoutes {
  const SpotOwnerProfileRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: SpotOwnerProfileRouteNames.home,
      builder: (_, _) => const SpotOwnerProfileScreen(),
    ),
    GoRoute(
      path: SpotOwnerProfileRouteNames.personalDetails,
      builder: (_, _) => const PersonalDetailsScreen(),
    ),
    GoRoute(
      path: SpotOwnerProfileRouteNames.linkBankAccount,
      builder: (_, _) => const SpotOwnerStripeConnectScreen(),
    ),
    GoRoute(
      path: SpotOwnerProfileRouteNames.linkBankAccountForm,
      builder: (_, GoRouterState state) => SpotOwnerLinkBankAccountScreen(
        initialAccountNumber:
            state.uri.queryParameters['accountNumber']?.trim() ?? '',
      ),
    ),
    GoRoute(
      path: SpotOwnerProfileRouteNames.bankAccountSuccess,
      builder: (_, _) => const SpotOwnerBankAccountSuccessScreen(),
    ),
    GoRoute(
      path: SpotOwnerProfileRouteNames.earnings,
      builder: (_, _) => const SpotOwnerEarningsScreen(),
    ),
    GoRoute(
      path: SpotOwnerProfileRouteNames.updatePassword,
      builder: (_, _) => const UpdatePasswordScreen(),
    ),
  ];
}
