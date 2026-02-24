import 'package:go_router/go_router.dart';
import 'package:xocobaby13/app/splash_view.dart';
import 'package:xocobaby13/feature/auth/onboarding/onboarding_1.dart';
import 'package:xocobaby13/feature/auth/onboarding/onboarding_2.dart';
import 'package:xocobaby13/feature/auth/onboarding/onboarding_3.dart';
import 'package:xocobaby13/feature/auth/onboarding/onboarding_4.dart';
import 'package:xocobaby13/feature/auth/onboarding/onboarding_splash_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/forgot_password_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/login_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/otp_verify_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/reset_password_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/signup_screen.dart';

class AuthRouteNames {
  const AuthRouteNames._();

  static const String onboardingSplash = '/';
  static const String splashView = '/app/splash';
  static const String onboarding1 = '/onboarding/1';
  static const String onboarding2 = '/onboarding/2';
  static const String onboarding3 = '/onboarding/3';
  static const String onboarding4 = '/onboarding/4';

  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String otpVerify = '/auth/otp-verify';
  static const String resetPassword = '/auth/reset-password';
}

class AuthRoutes {
  const AuthRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: AuthRouteNames.onboardingSplash,
      builder: (_, _) => const OnboardingSplashScreen(),
    ),
    GoRoute(
      path: AuthRouteNames.splashView,
      builder: (_, _) => const SplashView(),
    ),
    GoRoute(
      path: AuthRouteNames.onboarding1,
      builder: (_, _) => const Onboarding1Screen(),
    ),
    GoRoute(
      path: AuthRouteNames.onboarding2,
      builder: (_, _) => const Onboarding2Screen(),
    ),
    GoRoute(
      path: AuthRouteNames.onboarding3,
      builder: (_, _) => const Onboarding3Screen(),
    ),
    GoRoute(
      path: AuthRouteNames.onboarding4,
      builder: (_, _) => const Onboarding4Screen(),
    ),
    GoRoute(path: AuthRouteNames.login, builder: (_, _) => const LoginScreen()),
    GoRoute(
      path: AuthRouteNames.signup,
      builder: (_, _) => const SignupScreen(),
    ),
    GoRoute(
      path: AuthRouteNames.forgotPassword,
      builder: (_, _) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AuthRouteNames.otpVerify,
      builder: (_, GoRouterState state) {
        final Map<String, dynamic> data = state.extra is Map<String, dynamic>
            ? state.extra! as Map<String, dynamic>
            : <String, dynamic>{};
        return OtpVerifyScreen(email: (data['email'] ?? '').toString());
      },
    ),
    GoRoute(
      path: AuthRouteNames.resetPassword,
      builder: (_, GoRouterState state) {
        final Map<String, dynamic> data = state.extra is Map<String, dynamic>
            ? state.extra! as Map<String, dynamic>
            : <String, dynamic>{};
        return ResetPasswordScreen(
          email: (data['email'] ?? '').toString(),
          otp: (data['otp'] ?? '').toString(),
        );
      },
    ),
  ];
}
