import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/profile/controller/profile_controller.dart';
import 'package:xocobaby13/feature/profile/model/user_profile_data_model.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_avatar.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_style.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_text_field.dart';

class FishermanPersonalDetailsScreen extends StatefulWidget {
  const FishermanPersonalDetailsScreen({super.key});

  @override
  State<FishermanPersonalDetailsScreen> createState() =>
      _FishermanPersonalDetailsScreenState();
}

class _FishermanPersonalDetailsScreenState
    extends State<FishermanPersonalDetailsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _descriptionController;
  late UserProfileDataModel _draft;

  @override
  void initState() {
    super.initState();
    final ProfileController controller = ProfileController.instance();
    final UserProfileDataModel profile = controller.profile.value;
    _draft = profile;
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _descriptionController = TextEditingController(text: profile.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final ProfileController controller = ProfileController.instance();
    await controller.pickAvatarFromGallery();
    setState(() {
      _draft = controller.profile.value;
    });
  }

  void _save() {
    final ProfileController controller = ProfileController.instance();
    final UserProfileDataModel updated = _draft.copyWith(
      name: _nameController.text.trim().isEmpty
          ? _draft.name
          : _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    controller.updateProfile(updated);
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Personal details updated.'),
        margin: const EdgeInsets.all(14),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withValues(alpha: 0.78),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileFlowScaffold(
      title: 'Personal Details',
      showBack: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 6),
            Center(
              child: ProfileAvatar(
                profile: _draft,
                size: 86,
                onEditTap: _pickAvatar,
              ),
            ),
            const SizedBox(height: 14),
            ProfileTextField(
              label: 'Full name',
              controller: _nameController,
              hint: 'Mr. Mack',
            ),
            const SizedBox(height: 14),
            ProfileTextField(
              label: 'Email address',
              controller: _emailController,
              hint: 'you@gmail.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            ProfileTextField(
              label: 'Phone Number',
              controller: _phoneController,
              hint: '(217) 555-0113',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            ProfileTextField(
              label: 'Write A Description About You',
              controller: _descriptionController,
              hint: '',
              maxLines: 4,
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
