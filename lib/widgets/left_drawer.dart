import 'package:flutter/material.dart';
import 'package:olehbali_mobile/screens/menu.dart';
import 'package:olehbali_mobile/userprofile/screens/user_profile.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data dummy, ganti dengan data dinamis (misalnya dari Provider)
    // final String avatarUrl = 'https://your-avatar-url.com/avatar.jpg';
    // final String name = 'John Doe';
    // final String phoneNumber = '081234567890';
    // final String email = 'johndoe@example.com';
    // final String birthdate = '1990-01-01';
    // final String role = 'user'; // Bisa juga 'owner'
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'EasyShop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Ayo Cari Oleh-oleh di OlehBali!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('My Account'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyProfilePage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
