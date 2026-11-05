import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  final passwordController = TextEditingController();

  String message = '';

  Future<void> updatePassword() async {
    try {
      await _authService.changePassword(passwordController.text.trim());

      setState(() {
        message = 'Password updated successfully';
      });
    } catch (_) {
      setState(() {
        message = 'Password update failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Signed In User',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(user?.email ?? 'No Email Found'),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: updatePassword,
              child: const Text('Update Password'),
            ),

            const SizedBox(height: 10),

            Text(message),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await _authService.signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
