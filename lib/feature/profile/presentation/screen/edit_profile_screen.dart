import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/feature/profile/controller/profile_controller.dart';
import 'package:xocobaby13/feature/profile/presentation/routes/profile_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_avatar.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_style.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/settings_menu_tile.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = ProfileController.instance();

    return ProfileFlowScaffold(
      title: 'Edit Profile',
      showBack: true,
      child: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              Center(
                child: ProfileAvatar(
                  profile: controller.profile.value,
                  size: 112,
                  onEditTap: () =>
                      context.push(ProfileRouteNames.personalDetails),
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  controller.profile.value.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'General Settings',
                style: TextStyle(
                  color: Color(0xFF1D232D),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SettingsMenuTile(
                icon: Icons.perm_contact_calendar_outlined,
                title: 'Personal Details',
                onTap: () => context.push(ProfileRouteNames.personalDetails),
              ),
              const SizedBox(height: 10),
              SettingsMenuTile(
                icon: Icons.calendar_month_outlined,
                title: 'Activity',
                onTap: () => context.push(ProfileRouteNames.activity),
              ),
              const SizedBox(height: 18),
              const Text(
                'Security & Privacy',
                style: TextStyle(
                  color: Color(0xFF1D232D),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SettingsMenuTile(
                icon: Icons.lock_outline,
                title: 'Update Password',
                subtitle: 'Last updated 3 months ago',
                onTap: () => context.push(ProfileRouteNames.updatePassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
