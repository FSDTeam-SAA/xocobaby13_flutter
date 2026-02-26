import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/core/notifiers/button_status_notifier.dart';
import 'package:xocobaby13/core/notifiers/snackbar_notifier.dart';
import 'package:xocobaby13/feature/auth/controller/change_password_controller.dart';
import 'package:xocobaby13/feature/profile/presentation/routes/spot_owner_profile_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_text_field.dart';

class SpotOwnerUpdatePasswordScreen extends StatefulWidget {
  const SpotOwnerUpdatePasswordScreen({super.key});

  @override
  State<SpotOwnerUpdatePasswordScreen> createState() =>
      _SpotOwnerUpdatePasswordScreenState();
}

class _SpotOwnerUpdatePasswordScreenState
    extends State<SpotOwnerUpdatePasswordScreen> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  late final SnackbarNotifier _snackbarNotifier;
  late final ChangePasswordController _controller;

  @override
  void initState() {
    super.initState();
    _snackbarNotifier = SnackbarNotifier(context: context);
    _controller = ChangePasswordController(_snackbarNotifier);
    _currentController.addListener(_syncControllerState);
    _newController.addListener(_syncControllerState);
    _confirmController.addListener(_syncControllerState);
    _controller.processStatusNotifier.addListener(_onStateChanged);
    _controller.addListener(_onStateChanged);
  }

  void _syncControllerState() {
    _controller
      ..oldPassword = _currentController.text
      ..newPassword = _newController.text
      ..confirmPassword = _confirmController.text;
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _currentController.removeListener(_syncControllerState);
    _newController.removeListener(_syncControllerState);
    _confirmController.removeListener(_syncControllerState);
    _controller.processStatusNotifier.removeListener(_onStateChanged);
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    _syncControllerState();
    _controller.changePassword(
      onSuccess: () => context.go(SpotOwnerProfileRouteNames.home),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading =
        _controller.processStatusNotifier.status is LoadingStatus;
    final bool canSave = _controller.canChange() && !isLoading;

    return SpotOwnerFlowScaffold(
      title: 'Update Password',
      showBack: true,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 6),
            SpotOwnerProfileTextField(
              label: 'Current password',
              hint: '••••••',
              controller: _currentController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            SpotOwnerProfileTextField(
              label: 'New password',
              hint: '••••••',
              controller: _newController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            SpotOwnerProfileTextField(
              label: 'Confirm password',
              hint: '••••••',
              controller: _confirmController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: canSave ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SpotOwnerProfilePalette.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.1,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
