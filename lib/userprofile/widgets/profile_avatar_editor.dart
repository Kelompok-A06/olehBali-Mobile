import 'package:flutter/material.dart';

class ProfileAvatarEditor extends StatelessWidget {
  final String currentAvatarUrl;
  final ValueChanged<String> onAvatarChanged;

  const ProfileAvatarEditor({
    required this.currentAvatarUrl,
    required this.onAvatarChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(currentAvatarUrl),
          onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 50),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            // Simulate avatar change (e.g., open file picker or camera)
            // Replace this with actual implementation
            const newAvatarUrl = 'https://new-avatar-url.com/avatar.jpg';
            onAvatarChanged(newAvatarUrl);
          },
          child: const Text('Change Avatar'),
        ),
      ],
    );
  }
}
