import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/profile/model/user_profile_data_model.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/profile_style.dart';

class ProfileAvatar extends StatelessWidget {
  final UserProfileDataModel profile;
  final double size;
  final VoidCallback? onEditTap;

  const ProfileAvatar({
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
              border: Border.all(color: const Color(0xFFF3F3F3), width: 6),
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
            bottom: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: size * 0.29,
                height: size * 0.29,
                decoration: BoxDecoration(
                  color: ProfilePalette.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF2F2F2), width: 3),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: size * 0.15,
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
