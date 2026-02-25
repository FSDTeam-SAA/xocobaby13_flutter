import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password updated successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SpotOwnerProfilePalette.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
