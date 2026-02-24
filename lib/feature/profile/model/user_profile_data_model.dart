import 'dart:typed_data';

import 'package:flutter/material.dart';

class UserProfileDataModel {
  final String name;
  final String email;
  final String phone;
  final String description;
  final String avatarAssetPath;
  final Uint8List? avatarBytes;

  const UserProfileDataModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.description,
    required this.avatarAssetPath,
    required this.avatarBytes,
  });

  ImageProvider get avatarImageProvider {
    if (avatarBytes != null) {
      return MemoryImage(avatarBytes!);
    }
    return AssetImage(avatarAssetPath);
  }

  UserProfileDataModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? description,
    String? avatarAssetPath,
    Uint8List? avatarBytes,
  }) {
    return UserProfileDataModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      avatarAssetPath: avatarAssetPath ?? this.avatarAssetPath,
      avatarBytes: avatarBytes ?? this.avatarBytes,
    );
  }
}
