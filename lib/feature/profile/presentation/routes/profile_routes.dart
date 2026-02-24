import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/activity_screen.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/edit_profile_screen.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/logout_screen.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/personal_details_screen.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/profile_screen.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/update_password_screen.dart';

class ProfileRouteNames {
  const ProfileRouteNames._();

  static const String home = '/profile';
  static const String editProfile = '/profile/edit';
  static const String personalDetails = '/profile/personal-details';
  static const String activity = '/profile/activity';
  static const String updatePassword = '/profile/update-password';
  static const String logout = '/profile/logout';
}

class ProfileRoutes {
  const ProfileRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: ProfileRouteNames.home,
      builder: (_, _) => const ProfileScreen(),
    ),
    GoRoute(
      path: ProfileRouteNames.editProfile,
      builder: (_, _) => const EditProfileScreen(),
    ),
    GoRoute(
      path: ProfileRouteNames.personalDetails,
      builder: (_, _) => const PersonalDetailsScreen(),
    ),
    GoRoute(
      path: ProfileRouteNames.activity,
      builder: (_, _) => const ActivityScreen(),
    ),
    GoRoute(
      path: ProfileRouteNames.updatePassword,
      builder: (_, _) => const UpdatePasswordScreen(),
    ),
    GoRoute(
      path: ProfileRouteNames.logout,
      builder: (_, _) => const LogoutScreen(),
    ),
  ];
}
