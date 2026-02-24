import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_style.dart';

class SettingsMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const SettingsMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
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
              child: Icon(icon, size: 34, color: ProfilePalette.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: subtitle == null
                  ? Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF161A21),
                        fontSize: 16.3,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF161A21),
                            fontSize: 16.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: Color(0xFF8D95A2),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF777777), size: 34),
          ],
        ),
      ),
    );
  }
}
