import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_style.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_text_field.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _save() {
    final String current = _currentController.text.trim();
    final String newPassword = _newController.text.trim();
    final String confirm = _confirmController.text.trim();

    if (current.length < 6 || newPassword.length < 6 || confirm.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters.'),
        ),
      );
      return;
    }

    if (newPassword != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password and confirm password must match.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Password updated successfully.'),
        margin: const EdgeInsets.all(14),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withValues(alpha: 0.78),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileFlowScaffold(
      title: 'Update Password',
      showBack: true,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8),
            ProfileTextField(
              label: 'Current password',
              hint: '••••••',
              controller: _currentController,
              obscureText: true,
            ),
            const SizedBox(height: 14),
            ProfileTextField(
              label: 'New password',
              hint: '••••••',
              controller: _newController,
              obscureText: true,
            ),
            const SizedBox(height: 14),
            ProfileTextField(
              label: 'Confirm password',
              hint: '••••••',
              controller: _confirmController,
              obscureText: true,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ProfilePalette.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
