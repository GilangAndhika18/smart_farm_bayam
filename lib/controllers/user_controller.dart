import '../helper/manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  final FirebaseRefs refs;
  UserController(this.refs);

  FirebaseAuth get auth => refs.auth;

  // ----------------------------------------------------
  // GET CURRENT USER
  // ----------------------------------------------------
  User? getCurrentUser() {
    return auth.currentUser;
  }

  // ----------------------------------------------------
  // BUAT USER BARU (login baru)
  // ----------------------------------------------------
  Future<void> createUser(String email, String password) async {
    await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ----------------------------------------------------
  // GANTI PASSWORD USER YANG SEDANG LOGIN
  // ----------------------------------------------------
  Future<void> updatePassword(String newPassword) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("Tidak ada user yang login");
    await user.updatePassword(newPassword);
  }

  // ----------------------------------------------------
  // HAPUS USER YANG SEDANG LOGIN (OPSIONAL)
  // ----------------------------------------------------
  Future<void> deleteCurrentUser() async {
    final user = auth.currentUser;
    if (user == null) throw Exception("Tidak ada user yang login");
    await user.delete();
  }
}
