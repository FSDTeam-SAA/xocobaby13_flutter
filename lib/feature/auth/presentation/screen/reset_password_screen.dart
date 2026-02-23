import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/controller/reset_password_controller.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/auth_style.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/bob_logo_badge.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final SnackbarNotifier _snackbarNotifier;
  late final ResetPasswordController _resetPasswordController;
  late final String _email;
  late final String _otp;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final dynamic arg = Get.arguments;
    final Map<String, dynamic> data = arg is Map<String, dynamic>
        ? arg
        : <String, dynamic>{};
    _email = (data['email'] ?? '').toString();
    _otp = (data['otp'] ?? '').toString();

    _snackbarNotifier = SnackbarNotifier(context: context);
    _resetPasswordController = ResetPasswordController(_snackbarNotifier);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _resetPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_email.isEmpty || _otp.isEmpty) {
      _snackbarNotifier.notifyError(
        message: 'Verification session expired. Please request code again.',
      );
      Get.offAllNamed(AuthRouteNames.forgotPassword);
      return;
    }

    _resetPasswordController.email = _email;
    _resetPasswordController.otp = _otp;
    _resetPasswordController.password = _passwordController.text;
    _resetPasswordController.confirmPassword = _confirmPasswordController.text;

    setState(() => _busy = true);
    await _resetPasswordController.resetPassword(
      onSuccess: () {
        Get.offAllNamed(AuthRouteNames.login);
      },
    );
    if (mounted) {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appTitle: 'The Bob App',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BobLogoBadge(size: 178),
          const SizedBox(height: 28),
          const Text(
            'Reset Your Password to Access\nYour Bob App Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthPalette.mainText,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 24),
          AuthInputField(
            label: 'Enter new password',
            hint: '••••••',
            controller: _passwordController,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFFC2C2C2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'Repeat new password',
            hint: '••••••',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFFC2C2C2),
              ),
            ),
          ),
          const SizedBox(height: 22),
          AuthPrimaryButton(
            title: 'Update Password',
            onTap: _submit,
            loading: _busy,
          ),
        ],
      ),
    );
  }
}
