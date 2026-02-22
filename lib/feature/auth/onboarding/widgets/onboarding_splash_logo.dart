import 'package:flutter/material.dart';

class OnboardingSplashLogo extends StatelessWidget {
  const OnboardingSplashLogo({super.key, this.size = 168});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/onboarding/logo_zocobaby.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
