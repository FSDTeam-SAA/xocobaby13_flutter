import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/auth_style.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/bob_logo_badge.dart';
import 'package:xocobaby13/feature/auth/controller/reset_password_controller.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/core/notifiers/button_status_notifier.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({super.key, this.email = '', this.otp = ''});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late final ResetPasswordController _controller;
  late final SnackbarNotifier _snackbarNotifier;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _snackbarNotifier = SnackbarNotifier(context: context);
    _controller = ResetPasswordController(_snackbarNotifier);
    _controller
      ..email = widget.email
      ..otp = widget.otp;
    _controller.processStatusNotifier.addListener(_onStatusChanged);
  }

  void _onStatusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.processStatusNotifier.removeListener(_onStatusChanged);
    _controller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_passwordController.text != _confirmPasswordController.text) {
      _snackbarNotifier.notifyError(
        message: 'Passwords do not match. Please try again.',
      );
      return;
    }
    _controller.resetPassword(
      onSuccess: () => context.go(AuthRouteNames.login),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        _controller.processStatusNotifier.status is LoadingStatus;
    final canSubmit =
        _controller.password.isNotEmpty &&
        _controller.confirmPassword.isNotEmpty &&
        _controller.password == _controller.confirmPassword &&
        !isLoading;
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
            onChanged: (value) => _controller.password = value,
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
            onChanged: (value) => _controller.confirmPassword = value,
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
            onTap: canSubmit ? _submit : null,
            loading: isLoading,
          ),
        ],
      ),
    );
  }
}
