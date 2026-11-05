import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String errorMessage = '';

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await _authService.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Registration failed';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await _authService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } on FirebaseAuthException {
      setState(() {
        errorMessage = 'Invalid login credentials';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email required';
                  }

                  if (!value.contains('@')) {
                    return 'Enter valid email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 16),

              if (isLoading) const CircularProgressIndicator(),

              if (!isLoading)
                ElevatedButton(
                  onPressed: register,
                  child: const Text('Register'),
                ),

              if (!isLoading)
                ElevatedButton(onPressed: signIn, child: const Text('Sign In')),
            ],
          ),
        ),
      ),
    );
  }
}
