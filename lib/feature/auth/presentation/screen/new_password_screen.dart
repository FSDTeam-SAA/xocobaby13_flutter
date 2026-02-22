import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/controller/reset_password_controller.dart';

import '../../../../src/core/constants/app_colors.dart';
import '../../../../src/core/constants/assets.dart';
import 'login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late final ResetPasswordController _resetPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _resetPasswordController = ResetPasswordController(
      SnackbarNotifier(context: context),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _resetPasswordController.dispose();
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
                      maxWidth: _clamp(size.width * 0.9, 340, 520),
                      minHeight: constraints.maxHeight - size.height * 0.06,
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _buildBackButton(),
                          ),
                          SizedBox(height: spacer * 0.5),
                          _buildLogo(logoSize),
                          SizedBox(height: spacer),
                          _buildTitle(),
                          SizedBox(height: spacer * 1.4),
                          _buildSubtitle(),
                          SizedBox(height: spacer * 1.6),
                          _buildLabel('Password'),
                          SizedBox(height: spacer * 0.5),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Enter your Password',
                            icon: Icons.lock_outline,
                            fieldHeight: fieldHeight,
                            validator: _validatePassword,
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
                          SizedBox(height: spacer * 1.4),
                          _buildLabel('Confirm Password'),
                          SizedBox(height: spacer * 0.5),
                          _buildTextField(
                            controller: _confirmPasswordController,
                            hint: 'Confirm your Password',
                            icon: Icons.lock_outline,
                            fieldHeight: fieldHeight,
                            validator: _validateConfirmPassword,
                            textInputAction: TextInputAction.done,
                            obscureText: _obscureConfirm,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                                size: fieldHeight * 0.38,
                              ),
                              onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                            ),
                          ),
                          SizedBox(height: spacer * 1.8),
                          _buildContinueButton(fieldHeight),
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

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Get.back(),
        splashRadius: 22,
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

  Widget _buildSubtitle() {
    return Column(
      children: [
        Text(
          'Reset password',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set New Password',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.85),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
    final double innerRadiusValue = fieldHeight;
    final Color neutralBorder = Colors.white.withOpacity(0.75);
    final Color focusBorder = AppColors.dark().primaryColor;

    return FormField<String>(
      initialValue: controller.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      builder: (field) {
        final bool hasError = field.hasError;
        final BorderSide enabledSide = BorderSide(
          color: hasError ? Colors.redAccent : neutralBorder,
          width: 2,
        );
        final BorderSide focusedSide = BorderSide(
          color: hasError ? Colors.redAccent : focusBorder,
          width: 2.2,
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
                validator: (_) => null,
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

  Widget _buildContinueButton(double height) {
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
            'Continue',
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

  Future<void> _submit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    _resetPasswordController.email = widget.email;
    _resetPasswordController.otp = widget.otp;
    _resetPasswordController.password = _passwordController.text;
    _resetPasswordController.confirmPassword = _confirmPasswordController.text;

    await _resetPasswordController.resetPassword(
      onSuccess: () {
        Get.offAll(() => const LoginScreen());
      },
    );
  }

  String? _validatePassword(String? value) {
    final String password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final String confirmPassword = value ?? '';
    final String password = _passwordController.text;

    if (confirmPassword.isEmpty) return 'Confirm password is required';
    if (confirmPassword != password) return 'Passwords do not match';
    return null;
  }

  double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }
}
