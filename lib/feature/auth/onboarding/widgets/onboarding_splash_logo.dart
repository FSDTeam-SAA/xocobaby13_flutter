import 'package:flutter/material.dart';

class OnboardingSplashLogo extends StatelessWidget {
  const OnboardingSplashLogo({super.key, this.size = 200});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/bob_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
