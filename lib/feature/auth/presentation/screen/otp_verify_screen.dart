import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/controller/forget_password_controller.dart';
import 'package:xocobaby13/feature/auth/controller/verify_email_controller.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/auth_style.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/bob_logo_badge.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  late final String _email;
  late final VerifyEmailController _verifyController;
  late final ForgetPasswordController _resendController;
  late final SnackbarNotifier _snackbarNotifier;

  String _otp = '';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final dynamic arg = Get.arguments;
    final Map<String, dynamic> data = arg is Map<String, dynamic>
        ? arg
        : <String, dynamic>{};
    _email = (data['email'] ?? '').toString();
    _snackbarNotifier = SnackbarNotifier(context: context);
    _verifyController = VerifyEmailController(_snackbarNotifier);
    _resendController = ForgetPasswordController(_snackbarNotifier);
  }

  @override
  void dispose() {
    _verifyController.dispose();
    _resendController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    _verifyController.email = _email;
    _verifyController.otp = _otp;

    setState(() => _busy = true);
    await _verifyController.verifyEmail(
      onSuccess: () {
        Get.toNamed(
          AuthRouteNames.resetPassword,
          arguments: <String, String>{'email': _email, 'otp': _otp},
        );
      },
    );
    if (mounted) {
      setState(() => _busy = false);
    }
  }

  Future<void> _resendCode() async {
    _resendController.email = _email;
    await _resendController.sendForgetPasswordRequest(
      onSuccess: () {
        _snackbarNotifier.notifySuccess(message: 'A new code has been sent.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final PinTheme pinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        color: AuthPalette.mainText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: AuthPalette.fieldFill,
        shape: BoxShape.circle,
        border: Border.all(color: AuthPalette.fieldBorder, width: 1.6),
      ),
    );

    return AuthScaffold(
      appTitle: 'The Bob App',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BobLogoBadge(size: 178),
          const SizedBox(height: 28),
          const Text(
            'Verify Your Email to\nReset Your Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthPalette.mainText,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Enter 6-digit verification code',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthPalette.subtitleText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Pinput(
            length: 6,
            defaultPinTheme: pinTheme,
            focusedPinTheme: pinTheme.copyWith(
              decoration: pinTheme.decoration?.copyWith(
                border: Border.all(color: AuthPalette.linkBlue, width: 1.9),
              ),
            ),
            submittedPinTheme: pinTheme,
            separatorBuilder: (int index) => const SizedBox(width: 6),
            onChanged: (String value) => _otp = value,
          ),
          const SizedBox(height: 24),
          AuthPrimaryButton(title: 'Continue', onTap: _verify, loading: _busy),
          const SizedBox(height: 24),
          Center(
            child: Wrap(
              children: [
                const Text(
                  'Didn’t receive any code? ',
                  style: TextStyle(
                    color: AuthPalette.mutedText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: _resendCode,
                  child: const Text(
                    'Resend Code',
                    style: TextStyle(
                      color: Color(0xFF1D2230),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
