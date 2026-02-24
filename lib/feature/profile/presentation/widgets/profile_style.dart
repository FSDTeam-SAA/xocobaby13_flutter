import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePalette {
  const ProfilePalette._();

  static const Color backgroundTop = Color(0xFFD7E7F7);
  static const Color backgroundBottom = Color(0xFFE2E8F1);
  static const Color blue = Color(0xFF1787CF);
  static const Color darkText = Color(0xFF1D232D);
  static const Color card = Color(0xFFF2F2F2);
  static const Color cardIconBackground = Color(0xFFBFD8EA);
}

class ProfileGradientBackground extends StatelessWidget {
  final Widget child;

  const ProfileGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            ProfilePalette.backgroundTop,
            ProfilePalette.backgroundBottom,
          ],
        ),
      ),
      child: child,
    );
  }
}

class ProfileFlowScaffold extends StatelessWidget {
  final String title;
  final bool showBack;
  final Widget child;

  const ProfileFlowScaffold({
    super.key,
    required this.title,
    required this.child,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ProfileGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    if (showBack)
                      IconButton(
                        onPressed: () => context.pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Color(0xFF1E2530),
                        ),
                      ),
                    if (showBack) const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: ProfilePalette.darkText,
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
