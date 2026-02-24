import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/auth_style.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/bob_logo_badge.dart';
import 'package:xocobaby13/feature/auth/controller/forget_password_controller.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/core/notifiers/button_status_notifier.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  late final ForgetPasswordController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ForgetPasswordController(
      SnackbarNotifier(context: context),
    );
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
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    _controller.sendForgetPasswordRequest(
      onSuccess: () {
        context.push(
          AuthRouteNames.otpVerify,
          extra: <String, String>{'email': _emailController.text.trim()},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        _controller.processStatusNotifier.status is LoadingStatus;
    final canSubmit = _controller.email.isNotEmpty && !isLoading;
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
            onChanged: (value) => _controller.email = value,
          ),
          const SizedBox(height: 22),
          AuthPrimaryButton(
            title: 'Send Code',
            onTap: canSubmit ? _submit : null,
            loading: isLoading,
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => context.go(AuthRouteNames.login),
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
