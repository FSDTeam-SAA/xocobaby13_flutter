import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/controller/forget_password_controller.dart';

import '../../../../src/core/constants/app_colors.dart';
import '../../../../src/core/constants/assets.dart';
import 'otp_verify_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  late final ForgetPasswordController _forgetPasswordController;

  @override
  void initState() {
    super.initState();
    _forgetPasswordController = ForgetPasswordController(
      SnackbarNotifier(context: context),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _forgetPasswordController.dispose();
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
                          SizedBox(height: spacer * 0.4),
                          _buildSubtitle(),
                          SizedBox(height: spacer * 1.8),
                          _buildLabel('Email'),
                          SizedBox(height: spacer * 0.5),
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Enter your Email',
                            icon: Icons.mail_outline,
                            fieldHeight: fieldHeight,
                            validator: _validateEmail,
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: spacer * 2),
                          _buildSendOtpButton(fieldHeight),
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
          'Enter your email to receive the OTP',
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
                obscureText: false,
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

  Widget _buildSendOtpButton(double height) {
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
            'Send OTP',
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
    _forgetPasswordController.email = _emailController.text.trim();
    await _forgetPasswordController.sendForgetPasswordRequest(
      onSuccess: () {
        Get.to(() => OtpVerifyScreen(email: _emailController.text.trim()));
      },
    );
  }

  String? _validateEmail(String? value) {
    final String email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';

    final RegExp regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }
}
