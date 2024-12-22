import 'dart:io';

import 'package:flutter/material.dart';
import 'package:olehbali_mobile/userprofile/widgets/profile_avatar_editor.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> currentData;

  const EditProfilePage({
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
  DateTime? selectedDate;

  File? selectedImageFile;
  bool isSaving = false;

  // void _handleAvatarChanged(String newUrl) {
  //   setState(() {
  //     newAvatarUrl = newUrl;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.currentData['name'] ?? '',
    );
    phoneController = TextEditingController(
      text: widget.currentData['phone_number'] ?? '',
    );
    emailController = TextEditingController(
      text: widget.currentData['email'] ?? '',
    );
    birthdateController = TextEditingController(
      text: widget.currentData['birthdate'] ?? '',
    );

    try {
      if (widget.currentData['birthdate'] != null) {
        selectedDate = DateTime.parse(widget.currentData['birthdate']);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthdateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> saveChanges() async {
  setState(() {
    isSaving = true;
  });

  try {
    final request = context.read<CookieRequest>();
    const url = 'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/userprofile/update_profile_flutter/';
    //const url = 'http://127.0.0.1:8000/userprofile/update_profile_flutter/';

    final updatedData = <String, dynamic>{};
    // var formData = <String, dynamic>{
    //     'name': nameController.text,
    //     'phone_number': phoneController.text,
    //     'email': emailController.text,
    //     'birthdate': birthdateController.text,
    //   };


    if (nameController.text != widget.currentData['name']) {
      updatedData['name'] = nameController.text;
    }
    if (phoneController.text != widget.currentData['phone_number']) {
      updatedData['phone_number'] = phoneController.text;
    }
    if (emailController.text != widget.currentData['email']) {
      updatedData['email'] = emailController.text;
    }
    if (birthdateController.text != widget.currentData['birthdate']) {
      updatedData['birthdate'] = birthdateController.text;
    }
    
    if (selectedImageFile != null) {
        try {
          print('Reading image file...');
          List<int> imageBytes = await selectedImageFile!.readAsBytes();
          print('Image size: ${imageBytes.length} bytes');
          String base64Image = "data:image/jpeg;base64," + base64Encode(imageBytes);
          print('Base64 image length: ${base64Image.length}');
          updatedData['avatar'] = base64Image;
        } catch (e, stackTrace) {
          print('Error processing image:');
          print('Error: $e');
          print('Stack trace: $stackTrace');
          throw Exception('Failed to process image file: $e');
        }
      }

    if (updatedData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes detected')),
      );
      return;
    }

    final response = await request.post(url, jsonEncode(updatedData));

    // Tambahkan file avatar jika ada
      

    // final response = await request.post(url, jsonEncode(formData));
    print('Response received: $response');

    if (response['status'] == 'success') {
      if (mounted) {
        Navigator.pop(context, response['data']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } else {
      throw Exception(response['message']);
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $e')),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        isSaving = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            onPressed: isSaving ? null : saveChanges,
            icon: const Icon(Icons.save),
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ProfileAvatarEditor(
                        currentAvatarUrl: widget.currentData['avatar'] ?? '',
                        onAvatarChanged: (File? file) {
                          setState(() {
                            selectedImageFile = file;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Name field
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Phone field
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    // Email field
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    // Birthdate field with date picker
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: birthdateController,
                          decoration: const InputDecoration(
                            labelText: 'Birthdate',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Save button fixed at the bottom
            ElevatedButton(
              onPressed: isSaving ? null : saveChanges,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}