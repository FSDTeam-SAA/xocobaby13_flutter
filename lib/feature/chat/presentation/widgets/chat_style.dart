import 'package:flutter/material.dart';

class ChatPalette {
  const ChatPalette._();

  static const Color surface = Colors.white;
  static const Color titleText = Color(0xFF1E2530);
  static const Color subtitleText = Color(0xFF9AA0A6);
  static const Color bodyText = Color(0xFF6C6C6C);
  static const Color searchFill = Color(0xFFF2F2F2);
  static const Color searchHint = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFE6E6E6);
  static const Color incomingBubble = Color(0xFF1787CF);
  static const Color outgoingBubble = Color(0xFFF2F2F2);
  static const Color outgoingText = Color(0xFF3C4655);
  static const Color incomingText = Colors.white;
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color actionBlue = Color(0xFF1787CF);
  static const Color dangerRed = Color(0xFFE34C4C);
  static const Color neutralButton = Color(0xFFE6E6E6);
  static const Color statusDot = Color(0xFFF4A261);
}

class ChatLayout {
  const ChatLayout._();

  static const double maxWidth = 390;
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
}
