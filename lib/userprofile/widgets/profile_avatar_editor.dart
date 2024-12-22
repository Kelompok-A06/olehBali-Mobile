import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileAvatarEditor extends StatelessWidget {
  final String currentAvatarUrl;
  final ValueChanged<File?> onAvatarChanged;

  const ProfileAvatarEditor({
    required this.currentAvatarUrl,
    required this.onAvatarChanged,
    super.key,
  });

  Future<void> _pickImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        onAvatarChanged(File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: currentAvatarUrl.startsWith('http')
                  ? NetworkImage(currentAvatarUrl)
                  : currentAvatarUrl.startsWith('/')
                      ? NetworkImage('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/$currentAvatarUrl')
                      : null,
              child: currentAvatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).primaryColor,
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                  onPressed: () => _pickImage(context),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _pickImage(context),
          child: const Text('Change Profile Picture'),
        ),
      ],
    );
  }
}