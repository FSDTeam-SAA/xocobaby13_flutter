import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/feature/profile/controller/profile_controller.dart';
import 'package:xocobaby13/feature/profile/presentation/routes/profile_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_action_card.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = ProfileController.instance();

    return Obx(
      () => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 48),
              Center(
                child: ProfileAvatar(
                  profile: controller.profile.value,
                  size: 112,
                  onEditTap: () => context.push(ProfileRouteNames.editProfile),
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
              const SizedBox(height: 102),
              const Text(
                'Settings',
                style: TextStyle(
                  color: Color(0xFF1F252F),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              ProfileActionCard(
                icon: Icons.settings_outlined,
                label: 'Account Settings',
                onTap: () => context.push(ProfileRouteNames.editProfile),
                showChevron: true,
              ),
              const SizedBox(height: 16),
              ProfileActionCard(
                icon: Icons.logout_rounded,
                label: 'Log Out',
                onTap: () => context.push(ProfileRouteNames.logout),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
