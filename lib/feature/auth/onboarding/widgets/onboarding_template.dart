import 'package:flutter/material.dart';

import '../data/onboarding_page_data.dart';
import 'onboarding_page_indicator.dart';
import 'onboarding_photo_stack.dart';
import 'onboarding_primary_button.dart';
import 'onboarding_styles.dart';

class OnboardingTemplate extends StatelessWidget {
  const OnboardingTemplate({
    super.key,
    required this.data,
    required this.onNext,
  });

  final OnboardingPageData data;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingStyles.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: <Widget>[
                  OnboardingPhotoStack(
                    frontImagePath: data.frontImagePath,
                    backImagePath: data.backImagePath,
                    reviewerImagePath: data.reviewerImagePath,
                    reviewerName: data.reviewerName,
                    reviewerRating: data.reviewerRating,
                    badgeColor: data.badgeColor,
                    badgeIcon: data.badgeIcon,
                    badgeAssetPath: data.badgeAssetPath,
                    useExactAssetLayout: data.useExactAssetLayout,
                  ),
                  const SizedBox(height: 36),
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: OnboardingStyles.title,
                      fontSize: 15.2 * 1.9,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    child: Text(
                      data.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: OnboardingStyles.subtitle,
                        fontSize: 15,
                        height: 1.22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OnboardingPageIndicator(activeIndex: data.activeIndex),
                  // const Spacer(),
                  const SizedBox(height: 36),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: OnboardingPrimaryButton(onPressed: onNext),
                  ),
                  
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
