
import 'package:flutter/material.dart';
import 'package:olehbali_mobile/userprofile/widgets/editable_text_field.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
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

  // File? selectedImageFile;
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
    // const url = 'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/userprofile/update_profile_flutter/';
    const url = 'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/userprofile/update_profile_flutter/';

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
    
    // if (selectedImageFile != null) {
    //     try {
    //       print('Reading image file...');
    //       // Masih salah di sini
    //       List<int> imageBytes = await selectedImageFile!.readAsBytes();
    //       print('Image size: ${imageBytes.length} bytes');
    //       String base64Image = "data:image/jpeg;base64," + base64Encode(imageBytes);
    //       print('Base64 image length: ${base64Image.length}');
    //       updatedData['avatar'] = base64Image;
    //     } catch (e, stackTrace) {
    //       print('Error processing image:');
    //       print('Error: $e');
    //       print('Stack trace: $stackTrace');
    //       throw Exception('Failed to process image file: $e');
    //     }
    //   }

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
      //   Navigator.pop(context, response['data']);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Profile updated successfully')),
      //   );
      // }
      final updatedProfileData = Map<String, dynamic>.from(widget.currentData);
        updatedData.forEach((key, value) {
          updatedProfileData[key] = value;
        });

        // Pop with the updated data
        Navigator.pop(context, updatedProfileData);
        
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
      drawer: const LeftDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: isSaving ? null : saveChanges,
              icon: const Icon(Icons.save_rounded, color: Colors.white),
              tooltip: 'Save Changes',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange[50]!,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.deepOrange,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.orange[100],
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.orange[900],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      EditableTextField(
                        controller: nameController,
                        label: 'Full Name',
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      EditableTextField(
                        controller: phoneController,
                        label: 'Phone Number',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      EditableTextField(
                        controller: emailController,
                        label: 'Email Address',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      EditableTextField(
                        controller: birthdateController,
                        label: 'Birth Date',
                        prefixIcon: Icons.calendar_today_outlined,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isSaving ? null : saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}