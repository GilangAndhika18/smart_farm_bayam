import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading sementara
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Kalau user sudah login
        if (snapshot.hasData) {
          // langsung ke dashboard
          Future.microtask(() {
            Navigator.pushReplacementNamed(context, "/dashboard");
          });
          return const SizedBox();
        }

        // Kalau belum login
        Future.microtask(() {
          Navigator.pushReplacementNamed(context, "/login");
        });
        return const SizedBox();
      },
    );
  }
}
