import '../helper/manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  final FirebaseRefs refs;
  UserController(this.refs);

  // =====================
  // GET LIST USER
  // =====================
  Future<List<User>> getUsers() async {
    // Firebase Auth tidak menyediakan list all user di client,
    // biasanya ini harus via Cloud Functions / Admin SDK.
    // Untuk contoh ini, kita simulasikan:
    return [refs.auth.currentUser!]; // hanya current user
  }

  // =====================
  // TAMBAH USER (email + password)
  // =====================
  Future<void> createUser(String email, String password) async {
    await refs.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // =====================
  // GANTI PASSWORD
  // =====================
  Future<void> updatePassword(String newPassword) async {
    final user = refs.auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  // =====================
  // DELETE USER
  // =====================
  Future<void> deleteUser() async {
    final user = refs.auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }
}
