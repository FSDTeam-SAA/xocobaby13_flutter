import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/navigation/presentation/routes/navigation_routes.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/auth_style.dart';
import 'package:xocobaby13/feature/auth/presentation/widgets/bob_logo_badge.dart';
import 'package:xocobaby13/feature/auth/controller/register_controller.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

enum SignupRole { fisherman, spotOwner }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final RegisterScreenController _registerController;

  SignupRole _selectedRole = SignupRole.fisherman;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _registerController = RegisterScreenController(
      SnackbarNotifier(context: context),
    );
    _registerController.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _registerController.removeListener(_onControllerChanged);
    _registerController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _roleValue(SignupRole role) {
    switch (role) {
      case SignupRole.fisherman:
        return 'fisherman';
      case SignupRole.spotOwner:
        return 'spotOwner';
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    _registerController
      ..fullName = _nameController.text
      ..email = _emailController.text
      ..password = _passwordController.text
      ..role = _roleValue(_selectedRole);
    _registerController.register(
      onSuccessNavigate: () => context.go(AuthRouteNames.login),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _registerController.isBusy;
    final canSubmit =
        _registerController.fullName.isNotEmpty &&
        _registerController.email.isNotEmpty &&
        _registerController.password.isNotEmpty &&
        !isLoading;
    return AuthScaffold(
      appTitle: 'The Bob App',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BobLogoBadge(size: 178),
          const SizedBox(height: 24),
          const Text(
            'Create a new account',
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
                onTap: () => context.go(AuthRouteNames.login),
                child: const Text(
                  'sign in to your existing account',
                  style: TextStyle(
                    color: AuthPalette.linkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          AuthInputField(
            label: 'Full name',
            hint: 'John Doe',
            controller: _nameController,
            onChanged: (value) => _registerController.fullName = value,
          ),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'Email address',
            hint: 'you@gmail.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => _registerController.email = value,
          ),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'Password',
            hint: '••••••',
            controller: _passwordController,
            obscureText: _obscurePassword,
            onChanged: (value) => _registerController.password = value,
            suffixIcon: AppIconButton(
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
          const Text(
            'I am registering as a',
            style: TextStyle(
              color: AuthPalette.mainText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _RoleButton(
                  title: 'Fisherman',
                  icon: Icons.person_outline_rounded,
                  selected: _selectedRole == SignupRole.fisherman,
                  onTap: () {
                    setState(() => _selectedRole = SignupRole.fisherman);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RoleButton(
                  title: 'Spot Owner',
                  icon: Icons.emoji_nature_outlined,
                  selected: _selectedRole == SignupRole.spotOwner,
                  onTap: () {
                    setState(() => _selectedRole = SignupRole.spotOwner);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AuthPrimaryButton(
            title: 'Create account',
            icon: Icons.person_add_alt_1_rounded,
            onTap: canSubmit ? _submit : null,
            loading: isLoading,
          ),
          const SizedBox(height: 22),
          Row(
            children: const [
              Expanded(child: Divider(color: AuthPalette.fieldBorder)),
              SizedBox(width: 10),
              Text(
                'Or continue with',
                style: TextStyle(
                  color: AuthPalette.linkBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
              Expanded(child: Divider(color: AuthPalette.fieldBorder)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: AuthPalette.fieldFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AuthPalette.fieldBorder),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => context.go(NavigationRouteNames.main),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                      image: AssetImage('assets/images/G_logo.png'),
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Google',
                      style: TextStyle(
                        color: AuthPalette.mutedText,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD2E5F4) : AuthPalette.fieldFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AuthPalette.linkBlue : AuthPalette.fieldBorder,
            width: 1.4,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? AuthPalette.linkBlue : AuthPalette.mainText,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: selected ? AuthPalette.linkBlue : AuthPalette.mainText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
