import 'package:flutter/material.dart';

class OnboardingImageCard extends StatelessWidget {
  const OnboardingImageCard({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    this.borderRadius = 28,
    this.borderWidth = 5,
  });

  final String imagePath;
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(borderRadius);
    final bool isAsset = imagePath.startsWith('assets/');

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: Colors.white, width: borderWidth),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: isAsset
            ? Image.asset(imagePath, fit: BoxFit.cover)
            : Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF9CB1C3),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 40,
                  ),
                ),
              ),
      ),
    );
  }
}
