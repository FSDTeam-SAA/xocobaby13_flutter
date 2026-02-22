import 'package:flutter/material.dart';
import 'package:xocobaby13/core/common/common/app_logo.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: AppLogo()));
  }
}
