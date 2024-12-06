import 'package:flutter/material.dart';
import 'package:olehbali_mobile/userprofile/widgets/editable_text_field.dart';
import 'package:olehbali_mobile/userprofile/widgets/profile_avatar_editor.dart';

class EditProfilePage extends StatefulWidget {
  Map<String, dynamic> currentData;

  EditProfilePage({
    required this.currentData,
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController birthdateController;

  String? newAvatarUrl;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentData['name']);
    phoneController = TextEditingController(text: widget.currentData['phoneNumber']);
    emailController = TextEditingController(text: widget.currentData['email']);
    birthdateController = TextEditingController(text: widget.currentData['birthdate']);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  void saveChanges() {
    Navigator.pop(context, {
      'avatarUrl': newAvatarUrl ?? widget.currentData['avatarUrl'],
      'name': nameController.text,
      'phoneNumber': phoneController.text,
      'email': emailController.text,
      'birthdate': birthdateController.text,
      'role': widget.currentData['role'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            onPressed: saveChanges,
            icon: const Icon(Icons.save),
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileAvatarEditor(
              currentAvatarUrl: widget.currentData['avatarUrl'],
              onAvatarChanged: (newUrl) {
                setState(() {
                  newAvatarUrl = newUrl;
                });
              },
            ),
            const SizedBox(height: 16),
            EditableTextField(
              controller: nameController,
              label: 'Name',
            ),
            const SizedBox(height: 16),
            EditableTextField(
              controller: phoneController,
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            EditableTextField(
              controller: emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            EditableTextField(
              controller: birthdateController,
              label: 'Birthdate',
              keyboardType: TextInputType.datetime,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
