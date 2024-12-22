import 'package:flutter/material.dart';
import 'package:olehbali_mobile/userprofile/screens/delete_account_page.dart';
import 'package:olehbali_mobile/userprofile/screens/edit_profile_page.dart';
import 'package:olehbali_mobile/userprofile/widgets/profile_buttons.dart';
import 'package:olehbali_mobile/wishlist/screens/WishlistScreen.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/profile.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  Map<String, dynamic> userProfile = {
    'name': '',
    'phone_number': '',
    'email': '',
    'birthdate': '',
    'role': '',
  };

  late Future<Profile> _profileFuture;
  final CookieRequest _request = CookieRequest();

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchUserProfile();
  }

  Future<Profile> _fetchUserProfile() async {
    Profile profile = Profile(
      model: "none", 
      pk: 1, 
      fields: Fields(
        user: 1, 
        name: "Fail", 
        phoneNumber: "Fail", 
        email: "Fail", 
        birthdate: "Fail", 
        avatar: "Fail"
      )
    );
    
    try {
      final response = await _request.get('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/userprofile/api/profile/');
      profile = Profile.fromJson(response[0]);
      final roleResponse = await _request.get('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/userprofile/api/get-role/');
      
      userProfile["name"] = profile.fields.name ?? '';
      userProfile["phone_number"] = profile.fields.phoneNumber ?? '';
      userProfile["email"] = profile.fields.email ?? '';
      userProfile["birthdate"] = profile.fields.birthdate ?? 'YYYY-MM-DD';
      userProfile["role"] = roleResponse['role'] ?? 'user';
      
      return profile;
    } catch (e) {
      print(e);
      userProfile["name"] = profile.fields.name ?? '';
      userProfile["phone_number"] = profile.fields.phoneNumber ?? '';
      userProfile["email"] = profile.fields.email ?? '';
      userProfile["birthdate"] = profile.fields.birthdate ?? 'YYYY-MM-DD';
      userProfile["role"] = 'user';
      return profile;
    }
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = _fetchUserProfile();
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    drawer: const LeftDrawer(),
    appBar: AppBar(
      backgroundColor: Colors.deepOrange,
      title: const Text(
        'Account Information',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevation: 0,
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
      child: FutureBuilder<Profile>(
        future: _profileFuture,
        builder: (context, AsyncSnapshot<Profile> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
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
                      _buildProfileField(
                        'Full Name',
                        userProfile['name'],
                        Icons.person_outline_rounded,
                      ),
                      _buildProfileField(
                        'Phone Number',
                        userProfile['phone_number'],
                        Icons.phone_outlined,
                      ),
                      _buildProfileField(
                        'Email Address',
                        userProfile['email'],
                        Icons.email_outlined,
                      ),
                      _buildProfileField(
                        'Birth Date',
                        userProfile['birthdate'],
                        Icons.calendar_today_outlined,
                      ),
                    ],
                  ),
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
                        _refreshProfile(); 
                      }
                    },
                    onMyWishlist: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const WishlistScreen(),
                      //   ),
                      // );
                    },
                    onDeleteAccount: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeleteAccountPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

  Widget _buildProfileField(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Colors.orange[300],
            size: 22,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.orange[200]!,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.orange[200]!,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          labelStyle: TextStyle(
            color: Colors.grey[800],
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}