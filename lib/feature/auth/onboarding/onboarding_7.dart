import 'package:flutter/material.dart';

import 'data/onboarding_page_data.dart';
import 'onboarding_8.dart';
import 'widgets/onboarding_template.dart';

class Onboarding7Screen extends StatelessWidget {
  const Onboarding7Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      data: onboardingPages[2],
      onNext: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const Onboarding8Screen()),
        );
      },
    );
  }
}
