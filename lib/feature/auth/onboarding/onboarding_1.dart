import 'package:flutter/material.dart';

import 'data/onboarding_page_data.dart';
import 'onboarding_2.dart';
import 'widgets/onboarding_template.dart';

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      data: onboardingPages[0],
      onNext: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const Onboarding2Screen()),
        );
      },
    );
  }
}
