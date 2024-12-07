import 'package:flutter/material.dart';
import 'package:olehbali_mobile/userprofile/screens/edit_profile_page.dart';
import 'package:olehbali_mobile/userprofile/widgets/profile_avatar.dart';
import 'package:olehbali_mobile/userprofile/widgets/profile_buttons.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  // Data pengguna sebagai variabel biasa
  Map<String, dynamic> userProfile = {
    'avatarUrl': '',
    'name': '',
    'phoneNumber': '',
    'email': '',
    'birthdate': '',
    'role': '',
  };

  @override
  void initState() {
    super.initState();
    var request = CookieRequest();
    fetchUserProfile(request); // Panggil API untuk mengambil data awal
  }

  Future<Profile> fetchUserProfile(CookieRequest request) async {
    // Ambil data dari server
    // var url = Uri.parse('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/api/profile/');
    Profile profile = Profile(model: "none", pk: 1, fields: Fields(user: 1, name: "Fail", phoneNumber: "Fail", email: "Fail", birthdate: "Fail", avatar: "Fail"));
    try {
      final response = await request.get('http://127.0.0.1:8000/userprofile/api/profile/');
      // Melakukan decode response menjadi bentuk json
      print(response);
      profile = Profile.fromJson(response[0]);
      // Null check for each field before assignment
      userProfile["avatarURL"] = profile.fields.avatar;
      userProfile["name"]  = profile.fields.name;
      userProfile["phoneNumber"] = profile.fields.phoneNumber;
      userProfile["email"] = profile.fields.email;
      userProfile["birthdate"] = profile.fields.birthdate ?? 'Unknown';
      return profile;
    } catch (e) {
      print(e);
      print(profile);
      userProfile["avatarURL"] = profile.fields.avatar;
      userProfile["name"]  = profile.fields.name;
      userProfile["phoneNumber"] = profile.fields.phoneNumber;
      userProfile["email"] = profile.fields.email;
      userProfile["birthdate"] = profile.fields.birthdate;
      print(userProfile);
      return profile;
    }
  }

  void _updateUserProfile(Map<String, dynamic> updatedProfile) {
    setState(() {
      userProfile = updatedProfile; // Perbarui data profil
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        title: const Text('Account Information'),
      ),
      body: FutureBuilder(
        future: fetchUserProfile(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ProfileAvatar(avatarUrl: userProfile['avatarUrl']),
                  const SizedBox(height: 16),
                  _buildTextField('Name', userProfile['name']),
                  _buildTextField('Phone Number', userProfile['phoneNumber']),
                  _buildTextField('Email', userProfile['email']),
                  _buildTextField('Birthdate', userProfile['birthdate']),
                  const SizedBox(height: 32),
                  ProfileButtons(
                    role: userProfile['role'],
                    onEditProfile: () async {
                      final updatedProfile = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            currentData: userProfile,
                          ),
                        ),
                      );

                      if (updatedProfile != null) {
                        setState(() {
                          userProfile = updatedProfile;
                        });
                      }
                    },
                    onMyWishlist: () {
                      Navigator.pushNamed(context, '/wishlist');
                    },
                    onDeleteAccount: () {
                      Navigator.pushNamed(context, '/delete-account');
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
