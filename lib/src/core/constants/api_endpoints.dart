import 'package:flutter/foundation.dart';

base class ApiEndpoints {
  static const String socketUrl = _LocalHostWifi.socketUrl;

  static const String baseUrl = _LocalHostWifi.baseUrl;

  // ---------------------- AUTH -----------------------------
  static const String login = _Auth.login;
  static const String signup = _Auth.signup;
  static const String forgetPassword = _Auth.forgetPassword;
  static const String verifyEmail = _Auth.verifyEmail;
  static const String resetPassword = _Auth.resetPassword;
  static const String refreshToken = _Auth.refreshToken;
  static const String changePassword = _Auth.changePassword;
  static const String logout = _Auth.logout;
}

class _RemoteServer {
  static const String socketUrl =
      'https://williamharri-backend-anlh.onrender.com'
      '';

  static const String baseUrl =
      'https://williamharri-backend-anlh.onrender.com/api'
      '';

  // static const String baseUrl =
  //     'http://10.10.5.89:8001/api'
  //     ;
}

class _LocalHostWifi {
  static const String socketUrl = 'http://localhost:5000';

  static const String baseUrl = 'http://localhost:5000/api/v1';
}

class _Auth {
  @protected
  static const String _authRoute = '${ApiEndpoints.baseUrl}/auth';
  static const String login = '$_authRoute/login';
  static const String signup = '$_authRoute/register';
  static const String forgetPassword = '$_authRoute/forget';
  static const String refreshToken = '$_authRoute/refresh-token';
  static const String verifyEmail = '$_authRoute/verify';
  static const String changePassword = '$_authRoute/change-password';
  static const String resetPassword = '$_authRoute/reset-password';
  static const String logout = '$_authRoute/logout';
}
