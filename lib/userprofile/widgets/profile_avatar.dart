import 'package:flutter/material.dart';

// class ProfileAvatar extends StatelessWidget {
//   final String avatarUrl;

//   const ProfileAvatar({required this.avatarUrl, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       radius: 50,
//       backgroundImage: NetworkImage(avatarUrl),
//       onBackgroundImageError: (error, stackTrace) =>
//           const Icon(Icons.person, size: 50),
//     );
//   }
// }

class ProfileAvatar extends StatelessWidget {
  final String avatarUrl;

  const ProfileAvatar({required this.avatarUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[200],
      backgroundImage: _getAvatarImage(),
      child: _getAvatarChild(),
    );
  }

  ImageProvider? _getAvatarImage() {
    if (avatarUrl.isEmpty) {
      return null;
    }
    
    if (avatarUrl.startsWith('http')) {
      return NetworkImage(avatarUrl);
    } else if (avatarUrl.startsWith('/')) {
      return NetworkImage('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/$avatarUrl');
    }
    return null;
  }

  Widget? _getAvatarChild() {
    if (avatarUrl.isEmpty) {
      return const Icon(Icons.person, size: 50, color: Colors.grey);
    }
    return null;
  }
}
