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

  final TextEditingController newUserEmail = TextEditingController();
  final TextEditingController newUserPassword = TextEditingController();

  final TextEditingController changePassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================
            // PROFILE SECTION
            // ======================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, color: Colors.white, size: 35),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      AppGlobals.refs.auth.currentUser?.email ??
                          "Tidak ada email",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ======================
            // TAMBAH USER BARU
            // ======================
            const Text(
              "Tambah User Baru",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: newUserEmail,
              decoration: const InputDecoration(
                labelText: "Email baru",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: newUserPassword,
              decoration: const InputDecoration(
                labelText: "Password baru",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await controller.createUser(
                      newUserEmail.text,
                      newUserPassword.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User berhasil ditambahkan"),
                      ),
                    );
                    newUserEmail.clear();
                    newUserPassword.clear();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                },
                child: const Text("Tambah User"),
              ),
            ),

            const SizedBox(height: 30),

            // ======================
            // GANTI PASSWORD SENDIRI
            // ======================
            const Text(
              "Ganti Password Anda",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: changePassword,
              decoration: const InputDecoration(
                labelText: "Password baru",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await controller.updatePassword(changePassword.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password berhasil diubah"),
                      ),
                    );
                    changePassword.clear();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                },
                child: const Text("Update Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
