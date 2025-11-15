import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class HistoryController {
  final DatabaseReference _configRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://smartfarmbayam-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("app/config/history_thresholds");

  final DatabaseReference _historyRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://smartfarmbayam-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("devices/esp32_001/history");

  // Load threshold setting dari Firebase
  Future<Map<String, double>> loadThresholds() async {
    final snapshot = await _configRef.get();
    if (!snapshot.exists) return {};
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }

  // Simpan threshold setting ke Firebase
  Future<void> saveThresholds(Map<String, double> thresholds) async {
    await _configRef.set(thresholds);
  }

  // Load history data untuk chart/table
  Future<Map<String, Map<String, double>>> loadHistoryData() async {
    Map<String, Map<String, double>> result = {};
    List<String> sensors = ['ph', 'tds_ppm', 'ec_ms_cm', 'temp_c'];
    for (var sensor in sensors) {
      final snapshot = await _historyRef.child(sensor).get();
      if (!snapshot.exists) {
        result[sensor] = {};
      } else {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        result[sensor] = data.map((k, v) => MapEntry(k, (v as num).toDouble()));
      }
    }
    return result;
  }
}
