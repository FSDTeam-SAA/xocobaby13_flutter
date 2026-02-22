import 'package:flutter/material.dart';

import 'data/onboarding_page_data.dart';
import 'onboarding_7.dart';
import 'widgets/onboarding_template.dart';

class Onboarding6Screen extends StatelessWidget {
  const Onboarding6Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      data: onboardingPages[1],
      onNext: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const Onboarding7Screen()),
        );
      },
    );
  }
}
