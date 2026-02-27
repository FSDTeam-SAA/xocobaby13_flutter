import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SpotOwnerProfilePalette {
  const SpotOwnerProfilePalette._();

  static const Color backgroundTop = Color(0xFFD2E7FA);
  static const Color backgroundBottom = Color(0xFFF5FAFF);
  static const Color blue = Color(0xFF1685CF);
  static const Color darkText = Color(0xFF1D232D);
  static const Color mutedText = Color(0xFF6E7A8A);
  static const Color card = Colors.white;
  static const Color cardBorder = Color(0xFFE0ECF8);
  static const Color cardIconBackground = Color(0xFFD7ECF9);
  static const Color fieldBorder = Color(0xFFB7D6F2);
  static const Color successGreen = Color(0xFF2DBE60);
  static const Color dangerRed = Color(0xFFD94444);
  static const Color dangerBackground = Color(0xFFFCE8E8);
}

class SpotOwnerGradientBackground extends StatelessWidget {
  final Widget child;

  const SpotOwnerGradientBackground({super.key, required this.child});

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
            SpotOwnerProfilePalette.backgroundTop,
            SpotOwnerProfilePalette.backgroundBottom,
          ],
        ),
      ),
      child: child,
    );
  }
}

class SpotOwnerFlowScaffold extends StatelessWidget {
  final String title;
  final bool showBack;
  final Widget child;

  const SpotOwnerFlowScaffold({
    super.key,
    required this.title,
    required this.child,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SpotOwnerGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        color: SpotOwnerProfilePalette.darkText,
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
