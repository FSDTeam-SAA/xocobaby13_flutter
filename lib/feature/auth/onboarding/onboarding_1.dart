import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';

import 'data/onboarding_page_data.dart';
import 'widgets/onboarding_template.dart';

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      data: onboardingPages[0],
      onNext: () => Get.offNamed(AuthRouteNames.onboarding2),
    );
  }
}
