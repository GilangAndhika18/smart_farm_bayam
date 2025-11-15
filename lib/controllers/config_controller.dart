import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/config_model.dart';

class ConfigController {
  final DatabaseReference _ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://smartfarmbayam-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("app/config/thresholds");

  // Load config
  Future<ConfigModel?> loadConfig() async {
    final snapshot = await _ref.get();
    if (!snapshot.exists) return null;

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return ConfigModel.fromMap(data);
  }

  // Save config
  Future<void> saveConfig(ConfigModel config) async {
    await _ref.set(config.toMap());
  }
}
