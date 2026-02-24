import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_style.dart';

class ProfileActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showChevron;

  const ProfileActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 92,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: ProfilePalette.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: ProfilePalette.cardIconBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: ProfilePalette.blue, size: 34),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF161A21),
                  fontSize: 16.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (showChevron)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF777777),
                size: 34,
              ),
          ],
        ),
      ),
    );
  }
}
