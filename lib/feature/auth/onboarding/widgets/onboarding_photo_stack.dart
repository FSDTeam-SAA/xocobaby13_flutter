import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'onboarding_badge_bubble.dart';
import 'onboarding_image_card.dart';
import 'onboarding_reviewer_chip.dart';

class OnboardingPhotoStack extends StatelessWidget {
  const OnboardingPhotoStack({
    super.key,
    required this.frontImagePath,
    required this.backImagePath,
    required this.reviewerImagePath,
    required this.reviewerName,
    required this.reviewerRating,
    required this.badgeColor,
    this.badgeIcon,
    this.badgeAssetPath,
    this.useExactAssetLayout = false,
  });

  final String frontImagePath;
  final String backImagePath;
  final String reviewerImagePath;
  final String reviewerName;
  final String reviewerRating;
  final Color badgeColor;
  final IconData? badgeIcon;
  final String? badgeAssetPath;
  final bool useExactAssetLayout;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    if (useExactAssetLayout) {
      final double scale = screenWidth / 393;
      final double stackHeight = 445 * scale;
      final double badgeSize = 70 * scale;
      final double frontWidth = 206 * scale;
      final double backWidth = 228 * scale;

      return SizedBox(
        width: screenWidth,
        height: stackHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              left: 70 * scale,
              top: 84 * scale,
              child: OnboardingBadgeBubble(
                color: badgeColor,
                icon: badgeIcon,
                assetPath: badgeAssetPath,
                size: badgeSize,
              ),
            ),
            Positioned(
              left: 20 * scale,
              top: 172 * scale,
              child: Image.asset(
                backImagePath,
                width: backWidth,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              right: 18 * scale,
              top: 58 * scale,
              child: Image.asset(
                frontImagePath,
                width: frontWidth,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: 223 * scale,
              top: 355 * scale,
              child: Transform.scale(
                scale: scale.clamp(0.9, 1.05),
                alignment: Alignment.topLeft,
                child: OnboardingReviewerChip(
                  avatarPath: reviewerImagePath,
                  name: reviewerName,
                  rating: reviewerRating,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final double stackWidth = math.min(364, screenWidth - 32);
    final double stackHeight = stackWidth * 1.19;
    final double backCardWidth = stackWidth * 0.68;
    final double frontCardWidth = stackWidth * 0.69;
    final double badgeSize = stackWidth * 0.235;

    return SizedBox(
      width: stackWidth,
      height: stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            left: stackWidth * 0.16,
            top: stackWidth * 0.12,
            child: OnboardingBadgeBubble(
              color: badgeColor,
              icon: badgeIcon,
              assetPath: badgeAssetPath,
              size: badgeSize,
            ),
          ),
          Positioned(
            left: 0,
            top: stackWidth * 0.34,
            child: Transform.rotate(
              angle: -0.21,
              child: OnboardingImageCard(
                imagePath: backImagePath,
                width: backCardWidth,
                height: backCardWidth * (1103 / 912),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: stackWidth * 0.02,
            child: Transform.rotate(
              angle: 0.07,
              child: OnboardingImageCard(
                imagePath: frontImagePath,
                width: frontCardWidth,
                height: frontCardWidth * (1054 / 824),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: stackWidth * 0.78,
            child: OnboardingReviewerChip(
              avatarPath: reviewerImagePath,
              name: reviewerName,
              rating: reviewerRating,
            ),
          ),
        ],
      ),
    );
  }
}
