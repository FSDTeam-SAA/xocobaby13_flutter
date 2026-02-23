import 'package:flutter/material.dart';

class BobLogoBadge extends StatelessWidget {
  final double size;
  final String assetPath;

  const BobLogoBadge({
    super.key,
    this.size = 178,
    this.assetPath = 'assets/images/bob_logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stack) {
                return Container(
                  width: size,
                  height: size,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF2F90D5), Color(0xFF153E82)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'BOB',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 34,
                      letterSpacing: 1.2,
                    ),
                  ),
                );
              },
        ),
      ),
    );
  }
}
