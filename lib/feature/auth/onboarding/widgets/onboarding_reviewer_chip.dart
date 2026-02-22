import 'package:flutter/material.dart';

class OnboardingReviewerChip extends StatelessWidget {
  const OnboardingReviewerChip({
    super.key,
    required this.avatarPath,
    required this.name,
    required this.rating,
  });

  final String avatarPath;
  final String name;
  final String rating;

  @override
  Widget build(BuildContext context) {
    final bool isAsset = avatarPath.startsWith('assets/');

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFC3CEDA),
            backgroundImage: isAsset
                ? AssetImage(avatarPath) as ImageProvider
                : NetworkImage(avatarPath),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 12.5,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.star, size: 17, color: Color(0xFFF7CC00)),
                  const SizedBox(width: 3),
                  Text(
                    rating,
                    style: const TextStyle(
                      color: Color(0xFF707070),
                      fontSize: 12.5,
                      height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
