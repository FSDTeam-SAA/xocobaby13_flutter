import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/controller/login_controller.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/auth_home_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/reset_password_screen.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/signup_screen.dart';

import '../../../../src/core/constants/app_colors.dart';
import '../../../../src/core/constants/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final SnackbarNotifier _snackbarNotifier;
  late final LoginsScreenController _loginController;

  bool _rememberMe = false;
  bool _obscurePassword = true;

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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double horizontalPadding = _clamp(size.width * 0.08, 20, 36);
    final double fieldHeight = _clamp(size.height * 0.07, 52, 68);
    final double logoSize = _clamp(size.width * 0.42, 160, 240);
    final double spacer = size.height * 0.02;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0c2c56), Color(0xFF081735)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: size.height * 0.03,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: _clamp(size.width * 0.9, 340, 480),
                      minHeight: constraints.maxHeight - size.height * 0.06,
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildLogo(logoSize),
                          SizedBox(height: spacer),
                          _buildTitle(),
                          SizedBox(height: spacer * 1.5),
                          _buildLabel('Email'),
                          SizedBox(height: spacer * 0.5),
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Enter your Email',
                            icon: Icons.mail_outline,
                            fieldHeight: fieldHeight,
                            validator: _validateEmail,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: spacer * 1.4),
                          _buildLabel('Password'),
                          SizedBox(height: spacer * 0.5),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Enter your Password',
                            icon: Icons.lock_outline,
                            fieldHeight: fieldHeight,
                            validator: _validatePassword,
                            textInputAction: TextInputAction.done,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                                size: fieldHeight * 0.38,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          SizedBox(height: spacer),
                          _buildActionsRow(),
                          SizedBox(height: spacer * 1.8),
                          _buildSignInButton(fieldHeight),
                          SizedBox(height: spacer * 1.5),
                          _buildBottomPrompt(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(double size) {
    final BorderRadius borderRadius = BorderRadius.circular(size * 0.22);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF1c73c9), Color(0xFF0e4585)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          Assets.appLogo,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1c73c9), Color(0xFF0e4585)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Icon(
              Icons.all_inclusive,
              color: Colors.white.withOpacity(0.9),
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'IfinityFX',
      style: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFDDFDFF),
        letterSpacing: 0.4,
        shadows: const [
          Shadow(
            color: Color(0xAA7FE6FF),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required double fieldHeight,
    required String? Function(String?) validator,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    final BorderRadius radius = BorderRadius.circular(fieldHeight);
    final double innerRadiusValue =
        fieldHeight; // keep inner border curvature aligned with the outer pill
    final Color neutralBorder = Color(0xff0A4390CC);
    final Color focusBorder = AppColors.dark().primaryColor;

    return FormField<String>(
      initialValue: controller.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      builder: (field) {
        final bool hasError = field.hasError;
        final BorderSide enabledSide = BorderSide(
          color: hasError ? Colors.redAccent : neutralBorder,
        );
        final BorderSide focusedSide = BorderSide(
          color: hasError ? Colors.redAccent : focusBorder,
          width: hasError ? 2.2 : 2.2,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: fieldHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF0f3d76),
                borderRadius: radius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: fieldHeight * 0.14),
              child: TextFormField(
                controller: controller,
                textInputAction: textInputAction,
                obscureText: obscureText,
                textAlignVertical: TextAlignVertical.center,
                onChanged: field.didChange,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: Colors.white,
                validator: (_) => null, // handled by outer FormField
                decoration: InputDecoration(
                  isCollapsed: true,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: fieldHeight * 0.16,
                    horizontal: fieldHeight * 0.1,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(innerRadiusValue),
                    borderSide: enabledSide,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(innerRadiusValue),
                    borderSide: enabledSide,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(innerRadiusValue),
                    borderSide: focusedSide,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(innerRadiusValue),
                    borderSide: BorderSide(
                      color: Colors.redAccent.shade200,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(innerRadiusValue),
                    borderSide: BorderSide(
                      color: Colors.redAccent.shade200,
                      width: 2.2,
                    ),
                  ),
                  prefixIcon: Icon(
                    icon,
                    color: Colors.white,
                    size: fieldHeight * 0.38,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: fieldHeight * 0.98,
                  ),
                  suffixIcon: suffixIcon,
                  hintText: hint,
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: EdgeInsets.only(
                  top: fieldHeight * 0.16,
                  left: fieldHeight * 0.1,
                ),
                child: Text(
                  field.errorText ?? '',
                  style: GoogleFonts.poppins(
                    color: Colors.redAccent.shade100,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildActionsRow() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (value) => setState(() => _rememberMe = value ?? false),
            activeColor: const Color(0xFF1c73c9),
            checkColor: Colors.white,
            side: BorderSide(color: Colors.white.withOpacity(0.85), width: 1.4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Remember me',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Get.to(() => const ResetPasswordScreen()),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            foregroundColor: const Color(0xFF1c73c9),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Forgot password?'),
        ),
      ],
    );
  }

  Widget _buildSignInButton(double height) {
    final BorderRadius radius = BorderRadius.circular(height);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: const LinearGradient(
            colors: [Color(0xFF1c73c9), Color(0xFF0f3d76)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 22,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: radius),
          ),
          onPressed: _submit,
          child: Text(
            'Sign in',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPrompt() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () => Get.to(() => const SignupScreen()),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            foregroundColor: const Color(0xFF1c73c9),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Sign Up Here'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    _loginController.email = _emailController.text.trim();
    _loginController.password = _passwordController.text;

    final didLogin = await _loginController.login(
      needVerification: () {
        _snackbarNotifier.notifyError(
          message: 'Please verify your email before logging in.',
        );
      },
    );

    if (didLogin) {
      Get.offAll(() => const AuthHomeScreen());
    }
  }

  String? _validateEmail(String? value) {
    final String email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';

    final RegExp regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    final String password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Must be at least 6 characters';
    return null;
  }

  double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }
}
