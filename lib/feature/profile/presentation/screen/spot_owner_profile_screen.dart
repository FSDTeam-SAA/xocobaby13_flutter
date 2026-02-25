import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_menu_content.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';

class SpotOwnerProfileScreen extends StatelessWidget {
  const SpotOwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotOwnerGradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[SpotOwnerProfileMenuContent()],
          ),
        ),
      ),
    );
  }
}
