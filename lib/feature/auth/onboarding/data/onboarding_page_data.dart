import 'package:flutter/material.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.badgeColor,
    this.badgeIcon,
    this.badgeAssetPath,
    required this.frontImagePath,
    required this.backImagePath,
    required this.reviewerImagePath,
    required this.reviewerName,
    required this.reviewerRating,
    required this.title,
    required this.subtitle,
    required this.activeIndex,
    this.useExactAssetLayout = false,
  });

  final Color badgeColor;
  final IconData? badgeIcon;
  final String? badgeAssetPath;
  final String frontImagePath;
  final String backImagePath;
  final String reviewerImagePath;
  final String reviewerName;
  final String reviewerRating;
  final String title;
  final String subtitle;
  final int activeIndex;
  final bool useExactAssetLayout;
}

const List<OnboardingPageData> onboardingPages = <OnboardingPageData>[
  OnboardingPageData(
    badgeColor: Color(0xFF8A76EE),
    badgeAssetPath: 'assets/onboarding/frame_2147229719.png',
    frontImagePath: 'assets/onboarding/rectangle_3463712.png',
    backImagePath: 'assets/onboarding/rectangle_3463713.png',
    reviewerImagePath: 'assets/onboarding/avatar_mr_raja.jpg',
    reviewerName: 'Mr. Raja',
    reviewerRating: '4.5',
    title: 'Explore Waters Freely,\nCatch Every Moment',
    subtitle:
        'Find the best fishing spots, track conditions and turn every trip into a perfect catch.',
    activeIndex: 0,
    useExactAssetLayout: true,
  ),
  OnboardingPageData(
    badgeColor: Color(0xFFCEE0ED),
    badgeIcon: Icons.phishing,
    frontImagePath:
        'https://images.unsplash.com/photo-1579468297905-a01d60244f85?auto=format&fit=crop&w=900&q=80',
    backImagePath:
        'https://images.unsplash.com/photo-1504274066651-8d31a536b11a?auto=format&fit=crop&w=900&q=80',
    reviewerImagePath:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
    reviewerName: 'Mr. Perua',
    reviewerRating: '4.5',
    title: 'Your Fishing Journey\nStarts Here',
    subtitle:
        'Find the best fishing spots, track conditions and turn every trip into a perfect catch.',
    activeIndex: 1,
  ),
  OnboardingPageData(
    badgeColor: Color(0xFF56B7E7),
    badgeIcon: Icons.emoji_nature,
    frontImagePath:
        'https://images.unsplash.com/photo-1452421822248-d4c2b47f0c81?auto=format&fit=crop&w=900&q=80',
    backImagePath:
        'https://images.unsplash.com/photo-1511732351661-32c94d3f0e85?auto=format&fit=crop&w=900&q=80',
    reviewerImagePath:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
    reviewerName: 'Rani Roy',
    reviewerRating: '4.5',
    title: 'Rent out Your Private\nFishing Spot to Earn',
    subtitle: 'Make extra income from your fishing spot, safely and simply.',
    activeIndex: 2,
  ),
  OnboardingPageData(
    badgeColor: Color(0xFFCEE0ED),
    badgeIcon: Icons.phishing,
    frontImagePath:
        'https://images.unsplash.com/photo-1579468297905-a01d60244f85?auto=format&fit=crop&w=900&q=80',
    backImagePath:
        'https://images.unsplash.com/photo-1504274066651-8d31a536b11a?auto=format&fit=crop&w=900&q=80',
    reviewerImagePath:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
    reviewerName: 'Mr. Perua',
    reviewerRating: '4.5',
    title: 'Turn Your Lake Into a\nDestination',
    subtitle:
        'Find the best fishing spots, track conditions and turn every trip into a perfect catch.',
    activeIndex: 3,
  ),
];
