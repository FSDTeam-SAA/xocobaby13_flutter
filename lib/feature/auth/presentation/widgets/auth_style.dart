import 'package:flutter/material.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

class AuthPalette {
  const AuthPalette._();

  static const Color backgroundTop = Color(0xFFD7E7F7);
  static const Color backgroundBottom = Color(0xFFE2E8F1);
  static const Color titleBlue = Color(0xFF1787CF);
  static const Color buttonBlue = Color(0xFF1787CF);
  static const Color mainText = Color(0xFF252B36);
  static const Color subtitleText = Color(0xFF3B475A);
  static const Color mutedText = Color(0xFF6D7482);
  static const Color linkBlue = Color(0xFF1587CF);
  static const Color fieldFill = Color(0xFFF1F1F2);
  static const Color fieldBorder = Color(0xFFA5D9FA);
  static const Color hintText = Color(0xFFB9BCC2);
}

class AuthScaffold extends StatelessWidget {
  final String? appTitle;
  final bool showBack;
  final bool startFromTop;
  final Widget child;

  const AuthScaffold({
    super.key,
    required this.child,
    this.appTitle,
    this.showBack = false,
    this.startFromTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AuthPalette.backgroundTop, AuthPalette.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Align(
            alignment: startFromTop ? Alignment.topCenter : Alignment.center,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 390),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (appTitle != null || showBack)
                      SizedBox(
                        height: 40,
                        child: Stack(
                          children: [
                            if (showBack)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: AppIconButton(
                                  onPressed: () =>
                                      Navigator.of(context).maybePop(),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: AuthPalette.titleBlue,
                                    size: 28,
                                  ),
                                ),
                              ),
                            if (appTitle != null)
                              Center(
                                child: Text(
                                  appTitle!,
                                  style: const TextStyle(
                                    color: AuthPalette.titleBlue,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    if (appTitle != null || showBack)
                      const SizedBox(height: 18),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;

  const AuthInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AuthPalette.subtitleText,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          style: const TextStyle(
            color: AuthPalette.mainText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AuthPalette.hintText,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: AuthPalette.fieldFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AuthPalette.fieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AuthPalette.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AuthPalette.linkBlue,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool loading;

  const AuthPrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: AppElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthPalette.buttonBlue,
          disabledBackgroundColor: AuthPalette.buttonBlue.withValues(
            alpha: 0.6,
          ),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 24),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
