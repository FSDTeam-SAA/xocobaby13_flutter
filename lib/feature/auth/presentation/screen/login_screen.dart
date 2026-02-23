import 'package:flutter/material.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/controller/login_controller.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/auth_style.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/bob_logo_badge.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final SnackbarNotifier _snackbarNotifier;
  late final LoginsScreenController _loginController;

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _snackbarNotifier = SnackbarNotifier(context: context);
    _loginController = LoginsScreenController(_snackbarNotifier);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    _loginController.email = _emailController.text.trim();
    _loginController.password = _passwordController.text;

    setState(() => _busy = true);
    final bool success = await _loginController.login(
      needVerification: () {
        _snackbarNotifier.notifyError(
          message: 'Your account needs verification.',
        );
      },
    );
    if (mounted) {
      setState(() => _busy = false);
    }
    if (success) {
      Get.offAllNamed(AuthRouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 26),
          const BobLogoBadge(size: 178),
          const SizedBox(height: 24),
          const Text(
            'Sign in to your account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthPalette.mainText,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Or ',
                style: TextStyle(
                  color: AuthPalette.mainText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AuthRouteNames.signup),
                child: const Text(
                  'create a new account',
                  style: TextStyle(
                    color: AuthPalette.linkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          AuthInputField(
            label: 'Email address',
            hint: 'you@gmail.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          AuthInputField(
            label: 'Password',
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
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() => _rememberMe = value ?? false);
                        },
                        activeColor: AuthPalette.linkBlue,
                        side: const BorderSide(
                          color: AuthPalette.linkBlue,
                          width: 1.6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Flexible(
                      child: Text(
                        'Remember me',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AuthPalette.mainText,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AuthRouteNames.forgotPassword),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: AuthPalette.linkBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AuthPrimaryButton(
            title: 'Sign in',
            icon: Icons.login_rounded,
            onTap: _submit,
            loading: _busy,
          ),
        ],
      ),
    );
  }
}
