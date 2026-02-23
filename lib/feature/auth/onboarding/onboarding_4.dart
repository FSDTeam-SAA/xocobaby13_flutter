import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/login_screen.dart';

import 'data/onboarding_page_data.dart';
import 'widgets/onboarding_template.dart';

class Onboarding4Screen extends StatelessWidget {
  const Onboarding4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      data: onboardingPages[3],
      onNext: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        );
      },
    );
  }
}
