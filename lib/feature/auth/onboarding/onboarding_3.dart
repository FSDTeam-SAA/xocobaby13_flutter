import 'package:flutter/material.dart';

import 'data/onboarding_page_data.dart';
import 'onboarding_4.dart';
import 'widgets/onboarding_template.dart';

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      data: onboardingPages[2],
      onNext: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const Onboarding4Screen()),
        );
      },
    );
  }
}
