import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/profile/controller/profile_controller.dart';
import 'package:xocobaby13/feature/profile/presentation/routes/spot_owner_profile_routes.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/activity_card.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_avatar.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_settings_menu_tile.dart';

class SpotOwnerProfileMenuContent extends StatelessWidget {
  const SpotOwnerProfileMenuContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = ProfileController.instance();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          Center(
            child: SpotOwnerProfileAvatar(
              profile: controller.profile.value,
              size: 96,
              onEditTap: () =>
                  context.push(SpotOwnerProfileRouteNames.personalDetails),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              controller.profile.value.name,
              style: const TextStyle(
                color: SpotOwnerProfilePalette.darkText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('General Settings'),
          const SizedBox(height: 12),
          SpotOwnerSettingsMenuTile(
            icon: Icons.manage_accounts_outlined,
            title: 'Personal Details',
            onTap: () =>
                context.push(SpotOwnerProfileRouteNames.personalDetails),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Payments'),
          const SizedBox(height: 12),
          SpotOwnerSettingsMenuTile(
            icon: Icons.credit_card_outlined,
            title: 'Link Bank Account',
            onTap: () =>
                context.push(SpotOwnerProfileRouteNames.linkBankAccount),
          ),
          const SizedBox(height: 16),
          SpotOwnerSettingsMenuTile(
            icon: Icons.attach_money,
            title: 'Earnings',
            onTap: () => context.push(SpotOwnerProfileRouteNames.earnings),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Security & Privacy'),
          const SizedBox(height: 12),
          SpotOwnerSettingsMenuTile(
            icon: Icons.lock_outline,
            title: 'Update Password',
            onTap: () =>
                context.push(SpotOwnerProfileRouteNames.updatePassword),
          ),
          const SizedBox(height: 16),
          SpotOwnerSettingsMenuTile(
            icon: Icons.logout_rounded,
            title: 'Log Out',
            titleColor: SpotOwnerProfilePalette.dangerRed,
            iconColor: SpotOwnerProfilePalette.dangerRed,
            iconBackgroundColor: SpotOwnerProfilePalette.dangerBackground,
            showChevron: false,
            onTap: () => context.push(SpotOwnerProfileRouteNames.logout),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: SpotOwnerProfilePalette.darkText,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
