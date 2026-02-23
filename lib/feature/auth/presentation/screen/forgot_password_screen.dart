import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/auth_style.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/bob_logo_badge.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    Get.toNamed(
      AuthRouteNames.otpVerify,
      arguments: <String, String>{'email': _emailController.text.trim()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appTitle: 'The Bob App',
      showBack: true,
      startFromTop: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BobLogoBadge(size: 178),
          const SizedBox(height: 28),
          const Text(
            'Forgot Your Password\nand Continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthPalette.mainText,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 28),
          AuthInputField(
            label: 'Enter email/phone',
            hint: 'you@gmail.com',
            controller: _emailController,
          ),
          const SizedBox(height: 22),
          AuthPrimaryButton(title: 'Send Code', onTap: _submit),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => Get.offAllNamed(AuthRouteNames.login),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, color: AuthPalette.linkBlue, size: 30),
                SizedBox(width: 8),
                Text(
                  'Back to Log In',
                  style: TextStyle(
                    color: Color(0xFF1E2534),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
