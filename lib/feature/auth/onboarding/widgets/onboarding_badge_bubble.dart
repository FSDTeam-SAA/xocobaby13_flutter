import 'package:flutter/material.dart';

class OnboardingBadgeBubble extends StatelessWidget {
  const OnboardingBadgeBubble({
    super.key,
    required this.color,
    this.icon,
    this.assetPath,
    this.size = 76,
  });

  final Color color;
  final IconData? icon;
  final String? assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return ClipOval(
        child: Image.asset(
          assetPath!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            color.withValues(alpha: 0.95),
            color.withValues(alpha: 0.65),
          ],
          center: const Alignment(-0.2, -0.2),
        ),
      ),
      child: Icon(
        icon ?? Icons.phishing,
        size: size * 0.5,
        color: Colors.white.withValues(alpha: 0.92),
      ),
    );
  }
}
