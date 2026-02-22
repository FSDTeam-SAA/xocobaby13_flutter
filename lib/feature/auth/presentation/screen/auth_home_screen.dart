import 'package:flutter/material.dart';

class AuthHomeScreen extends StatelessWidget {
  const AuthHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Home')),
      body: const Center(child: Text('Login successful')),
    );
  }
}
