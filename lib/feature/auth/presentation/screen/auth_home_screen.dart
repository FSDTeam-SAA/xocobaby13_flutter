import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/auth_style.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/bob_logo_badge.dart';

class AuthHomeScreen extends StatelessWidget {
  const AuthHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appTitle: 'The Bob App',
      child: Column(
        children: [
          const SizedBox(height: 40),
          const BobLogoBadge(size: 216),
          const SizedBox(height: 30),
          const Text(
            'Welcome to The Bob App',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthPalette.mainText,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'You are signed in successfully.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthPalette.subtitleText,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 30),
          AuthPrimaryButton(
            title: 'Sign out',
            icon: Icons.logout,
            onTap: () => Get.offAllNamed(AuthRouteNames.login),
          ),
        ],
      ),
    );
  }
}
