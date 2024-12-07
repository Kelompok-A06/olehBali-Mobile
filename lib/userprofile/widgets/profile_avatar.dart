import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String avatarUrl;

  const ProfileAvatar({required this.avatarUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(avatarUrl),
      onBackgroundImageError: (error, stackTrace) =>
          const Icon(Icons.person, size: 50),
    );
  }
}
