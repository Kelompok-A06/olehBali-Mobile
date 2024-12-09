import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olehbali_mobile/screens/login.dart';
import 'package:olehbali_mobile/userprofile/widgets/delete_account_widgets.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _isConfirmed = false;
  bool _isLoading = false;

  Future<void> _deleteAccount(CookieRequest request) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await request.post(
        'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/userprofile/delete-account-flutter/',
        jsonEncode({
          'confirm': true,
        }),
      );

      if (response['status'] == 'success') {
        if (context.mounted) {
          // Clear all navigation stack and go to login page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(), // Make sure to import your LoginPage
            ),
            (Route<dynamic> route) => false,
          );
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account successfully deleted'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to delete account'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while deleting account'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Warning!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to delete your account? This action cannot be undone and you will lose all your data.',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            DeleteAccountConfirmationCheckbox(
              value: _isConfirmed,
              onChanged: (bool? value) {
                setState(() {
                  _isConfirmed = value ?? false;
                });
              },
            ),
            const SizedBox(height: 24),
            DeleteAccountButton(
              isConfirmed: _isConfirmed,
              isLoading: _isLoading,
              onPressed: () {
                if (_isConfirmed) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteAccountConfirmationDialog(
                        onConfirm: () {
                          Navigator.pop(context); // Close dialog
                          _deleteAccount(request);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
