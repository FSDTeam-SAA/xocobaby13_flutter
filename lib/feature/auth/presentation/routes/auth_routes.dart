import 'package:get/get.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/auth_home_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/forgot_password_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/login_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/otp_verify_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/reset_password_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/signup_screen.dart';

class AuthRouteNames {
  const AuthRouteNames._();

  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String otpVerify = '/auth/otp-verify';
  static const String resetPassword = '/auth/reset-password';
  static const String home = '/auth/home';
}

class AuthRoutes {
  const AuthRoutes._();

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AuthRouteNames.login,
      page: () => const LoginScreen(),
    ),
    GetPage<dynamic>(
      name: AuthRouteNames.signup,
      page: () => const SignupScreen(),
    ),
    GetPage<dynamic>(
      name: AuthRouteNames.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage<dynamic>(
      name: AuthRouteNames.otpVerify,
      page: () => const OtpVerifyScreen(),
    ),
    GetPage<dynamic>(
      name: AuthRouteNames.resetPassword,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage<dynamic>(
      name: AuthRouteNames.home,
      page: () => const AuthHomeScreen(),
    ),
  ];
}
