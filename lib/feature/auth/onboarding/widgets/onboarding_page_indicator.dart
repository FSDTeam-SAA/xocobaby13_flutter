import 'package:flutter/material.dart';

import 'onboarding_styles.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.activeIndex,
    this.total = 4,
  });

  final int activeIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(total, (int index) {
        final bool isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 30 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive
                ? OnboardingStyles.button
                : OnboardingStyles.indicatorInactive,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
