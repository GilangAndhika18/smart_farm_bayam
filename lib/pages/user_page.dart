import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../app_globals.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserController controller = UserController(AppGlobals.refs);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FORM TAMBAH USER
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await controller.createUser(
                    emailController.text,
                    passwordController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User berhasil ditambahkan")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: const Text("Tambah User"),
            ),
            const SizedBox(height: 20),

            // FORM GANTI PASSWORD
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password baru"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await controller.updatePassword(passwordController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password berhasil diubah")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: const Text("Ganti Password"),
            ),
          ],
        ),
      ),
    );
  }
}
