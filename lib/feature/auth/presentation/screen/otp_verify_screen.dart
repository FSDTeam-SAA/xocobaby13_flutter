import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/controller/forget_password_controller.dart';
import 'package:xocobaby13/feature/auth/controller/verify_email_controller.dart';
import 'package:pinput/pinput.dart';
import '../../../../src/core/constants/app_colors.dart';
import '../../../../src/core/constants/assets.dart';
import 'new_password_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key, required this.email});

  final String email;

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  late final VerifyEmailController _verifyEmailController;
  late final ForgetPasswordController _forgetPasswordController;

  @override
  void initState() {
    super.initState();
    final snackbarNotifier = SnackbarNotifier(context: context);
    _verifyEmailController = VerifyEmailController(snackbarNotifier);
    _forgetPasswordController = ForgetPasswordController(snackbarNotifier);
  }

  @override
  void dispose() {
    _otpController.dispose();
    _verifyEmailController.dispose();
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
                          SizedBox(height: spacer * 1.4),
                          _buildSubtitle(),
                          SizedBox(height: spacer * 1.6),
                          _buildOtpField(fieldHeight),
                          SizedBox(height: spacer),
                          _buildResendRow(),
                          SizedBox(height: spacer * 1.6),
                          _buildVerifyButton(fieldHeight),
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
    return Text(
      'Enter OTP',
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildOtpField(double fieldHeight) {
    final Color fillColor = Colors.white;
    final BorderRadius radius = BorderRadius.circular(12);

    final defaultPinTheme = PinTheme(
      width: fieldHeight,
      height: fieldHeight,
      textStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.dark().primaryColor,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: radius,
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.dark().primaryColor, width: 2.4),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.redAccent.shade200, width: 2.4),
    );

    return Column(
      children: [
        Pinput(
          length: 6,
          controller: _otpController,
          autofocus: true,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          errorPinTheme: errorPinTheme,
          separatorBuilder: (index) => SizedBox(width: fieldHeight * 0.22),
          validator: _validateOtp,
          cursor: Container(width: 2, color: AppColors.dark().primaryColor),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildResendRow() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        Text(
          "Didn't Receive OTP? ",
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: _resendOtp,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            foregroundColor: const Color(0xFF1c73c9),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Text('RESEND OTP'),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(double height) {
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
            'Verify Now',
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
    _verifyEmailController.email = widget.email;
    _verifyEmailController.otp = _otpController.text.trim();
    await _verifyEmailController.verifyEmail(
      onSuccess: () {
        Get.to(
          () => NewPasswordScreen(
            email: widget.email,
            otp: _otpController.text.trim(),
          ),
        );
      },
    );
  }

  Future<void> _resendOtp() async {
    _forgetPasswordController.email = widget.email;
    await _forgetPasswordController.sendForgetPasswordRequest(onSuccess: () {});
  }

  String? _validateOtp(String? value) {
    final String code = value?.trim() ?? '';
    if (code.length != 6) return 'Enter 6 digit code';
    return null;
  }

  double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }
}
