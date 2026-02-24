import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/auth_style.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/bob_logo_badge.dart';
import 'package:xocobaby13/feature/auth/controller/verify_email_controller.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/core/notifiers/button_status_notifier.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;

  const OtpVerifyScreen({super.key, this.email = ''});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  late final VerifyEmailController _controller;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _controller = VerifyEmailController(
      SnackbarNotifier(context: context),
    );
    _controller.email = widget.email;
    _controller.processStatusNotifier.addListener(_onStatusChanged);
    _controller.addListener(_onStatusChanged);
  }

  void _onStatusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.processStatusNotifier.removeListener(_onStatusChanged);
    _controller.removeListener(_onStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  void _verify() {
    FocusScope.of(context).unfocus();
    _controller.verifyEmail(
      onSuccess: () {
        context.push(
          AuthRouteNames.resetPassword,
          extra: <String, String>{
            'email': widget.email,
            'otp': _controller.otp,
          },
        );
      },
    );
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code resend is disabled for now.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        _controller.processStatusNotifier.status is LoadingStatus;
    final canSubmit = _otp.trim().length == 6 && !isLoading;
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
      startFromTop: true,
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
            onChanged: (String value) {
              _otp = value;
              _controller.otp = value;
              if (mounted) {
                setState(() {});
              }
            },
          ),
          const SizedBox(height: 24),
          AuthPrimaryButton(
            title: 'Continue',
            onTap: canSubmit ? _verify : null,
            loading: isLoading,
          ),
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
