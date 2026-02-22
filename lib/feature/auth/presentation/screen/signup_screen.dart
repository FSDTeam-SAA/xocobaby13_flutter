import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/controller/register_controller.dart';
import 'package:xocobaby13/feature/auth/presentation/screen/login_screen.dart';

import '../../../../src/core/constants/app_colors.dart';
import '../../../../src/core/constants/assets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late final RegisterScreenController _registerController;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;
  bool _showTermsError = false;

  @override
  void initState() {
    super.initState();
    _registerController = RegisterScreenController(
      SnackbarNotifier(context: context),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _registerController.dispose();
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
                          _buildLabel('Name'),
                          SizedBox(height: spacer * 0.5),
                          _buildTextField(
                            controller: _nameController,
                            hint: 'Enter your Full Name',
                            icon: Icons.person_outline,
                            fieldHeight: fieldHeight,
                            validator: _validateName,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: spacer * 1.2),
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
                          SizedBox(height: spacer * 1.2),
                          _buildLabel('Phone Number'),
                          SizedBox(height: spacer * 0.5),
                          _buildTextField(
                            controller: _phoneController,
                            hint: 'Enter your Phone Number',
                            icon: Icons.phone_outlined,
                            fieldHeight: fieldHeight,
                            validator: _validatePhone,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: spacer * 1.2),
                          _buildLabel('Password'),
                          SizedBox(height: spacer * 0.5),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Enter your Password',
                            icon: Icons.lock_outline,
                            fieldHeight: fieldHeight,
                            validator: _validatePassword,
                            textInputAction: TextInputAction.next,
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
                          SizedBox(height: spacer * 1.2),
                          _buildLabel('Confirm Password'),
                          SizedBox(height: spacer * 0.5),
                          _buildTextField(
                            controller: _confirmPasswordController,
                            hint: 'Confirm a Password',
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
                          SizedBox(height: spacer * 1.3),
                          _buildTermsRow(fieldHeight),
                          SizedBox(height: spacer * 1.6),
                          _buildSignUpButton(fieldHeight),
                          SizedBox(height: spacer * 1.2),
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
        onPressed: () => Navigator.of(context).maybePop(),
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
    TextInputType? keyboardType,
  }) {
    final BorderRadius radius = BorderRadius.circular(fieldHeight);
    final double innerRadiusValue = fieldHeight;
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
                keyboardType: keyboardType,
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

  Widget _buildTermsRow(double fieldHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _agreeTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeTerms = value ?? false;
                    if (_agreeTerms) _showTermsError = false;
                  });
                },
                activeColor: const Color(0xFFF99B07),
                checkColor: Colors.white,
                side: BorderSide(
                  color: Colors.white.withOpacity(0.85),
                  width: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'I agree to the Terms and Conditions and Privacy Policy *',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.92),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        if (_showTermsError)
          Padding(
            padding: EdgeInsets.only(top: fieldHeight * 0.12, left: 4),
            child: Text(
              'Please accept the terms to continue',
              style: GoogleFonts.poppins(
                color: Colors.redAccent.shade100,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSignUpButton(double height) {
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
            'Sign up',
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
          "Don’t have an account? ",
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () => Get.offAll(() => const LoginScreen()),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            foregroundColor: const Color(0xFF1c73c9),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Sign in Here'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    final bool termsOk = _agreeTerms;

    setState(() => _showTermsError = !termsOk);
    if (!isValid || !termsOk) return;

    FocusScope.of(context).unfocus();
    _registerController.name = _nameController.text.trim();
    _registerController.email = _emailController.text.trim();
    _registerController.phone = _phoneController.text.trim();
    _registerController.password = _passwordController.text;
    _registerController.confirmPassword = _confirmPasswordController.text;

    await _registerController.register(
      onSuccessNavigate: () => Get.offAll(() => const LoginScreen()),
    );
  }

  String? _validateName(String? value) {
    final String name = value?.trim() ?? '';
    if (name.isEmpty) return 'Name is required';
    if (name.length < 3) return 'Enter at least 3 characters';
    return null;
  }

  String? _validateEmail(String? value) {
    final String email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';

    final RegExp regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? value) {
    final String phone = value?.trim() ?? '';
    if (phone.isEmpty) return 'Phone number is required';
    final RegExp regex = RegExp(r'^[0-9]{8,}$');
    if (!regex.hasMatch(phone)) return 'Enter a valid phone number';
    return null;
  }

  String? _validatePassword(String? value) {
    final String password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final String confirm = value ?? '';
    if (confirm.isEmpty) return 'Please confirm your password';
    if (confirm != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }
}
