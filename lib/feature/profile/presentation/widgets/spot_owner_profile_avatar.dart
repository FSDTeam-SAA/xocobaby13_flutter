import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/profile/model/user_profile_data_model.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';

class SpotOwnerProfileAvatar extends StatelessWidget {
  final UserProfileDataModel profile;
  final double size;
  final VoidCallback? onEditTap;

  const SpotOwnerProfileAvatar({
    super.key,
    required this.profile,
    required this.size,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: Image(
                fit: BoxFit.cover,
                image: profile.avatarImageProvider,
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: size * 0.26,
                height: size * 0.26,
                decoration: BoxDecoration(
                  color: SpotOwnerProfilePalette.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: size * 0.12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
