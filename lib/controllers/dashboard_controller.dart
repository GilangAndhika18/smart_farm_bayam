import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class DashboardController {
  // Realtime readings
  DatabaseReference get dataRef {
    return FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://smartfarmbayam-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("devices/esp32_001/readings");
  }

  // History per sensor
  DatabaseReference get historyRef {
    return FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://smartfarmbayam-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("devices/esp32_001/history");
  }

  // Threshold perubahan
  final Map<String, double> thresholds = {
    'ph': 1.0,
    'tds_ppm': 50.0,
    'ec_ms_cm': 0.5,
    'temp_c': 5.0,
  };

  // Ambil data terakhir untuk UI
  Stream<Map<String, dynamic>?> getLastSensorData() {
    return dataRef.onValue.map((event) {
      if (event.snapshot.value == null) return null;
      final readings = Map<String, dynamic>.from(event.snapshot.value as Map);
      if (readings.isEmpty) return null;
      final lastKey = readings.keys.last;
      final lastData = Map<String, dynamic>.from(readings[lastKey]);
      return lastData;
    });
  }

  // Helper aman untuk ambil nilai terakhir dari snapshot history
  double? getLastValue(DataSnapshot snapshot) {
    if (!snapshot.exists) return null;
    final val = snapshot.value;
    if (val is Map) {
      final values = val.values.toList();
      if (values.isEmpty) return null;
      final last = values.last;
      if (last is num) return last.toDouble();
      if (last is String) return double.tryParse(last);
      return null;
    } else if (val is num) {
      return val.toDouble();
    } else if (val is String) {
      return double.tryParse(val);
    }
    return null;
  }

  // Pindahkan data lama ke history per sensor dan hapus dari readings
  Future<void> moveOldDataToHistory(DateTime loginTime) async {
    final snapshot = await dataRef.get();
    if (!snapshot.exists) return;

    final readings = Map<String, dynamic>.from(snapshot.value as Map);
    final futures = <Future>[];

    for (var entry in readings.entries) {
      final timestampMs = int.tryParse(entry.key);
      if (timestampMs == null) continue;

      final entryTime = DateTime.fromMillisecondsSinceEpoch(
        timestampMs,
      ); // waktu data
      if (entryTime.isBefore(loginTime)) {
        final value = entry.value;
        Map<String, dynamic> data;

        // Pastikan data bisa diubah ke Map
        if (value is Map) {
          data = Map<String, dynamic>.from(value);
        } else {
          // Jika bukan Map, buat Map kosong atau simpan sebagai sensor tunggal
          continue; // skip entry yang bukan Map
        }

        // Simpan ke history per sensor sesuai threshold
        for (var key in thresholds.keys) {
          final sensorValue = data[key];
          if (sensorValue == null) continue;

          final lastSnapshot = await historyRef.child(key).limitToLast(1).get();
          final lastValue = getLastValue(lastSnapshot);

          if (lastValue == null ||
              (sensorValue - lastValue).abs() >= thresholds[key]!) {
            futures.add(
              historyRef.child(key).child(entry.key).set(sensorValue),
            );
          }
        }

        // Hapus dari readings
        futures.add(dataRef.child(entry.key).remove());
      }
    }

    await Future.wait(futures); // tunggu semua selesai
  }

  // Simpan data baru jika ada perubahan threshold
  Future<void> saveIfChanged(Map<String, dynamic> currentData) async {
    final futures = <Future>[];

    for (var key in thresholds.keys) {
      final value = currentData[key];
      if (value == null) continue;

      final lastSnapshot = await historyRef.child(key).limitToLast(1).get();
      final lastValue = getLastValue(lastSnapshot);

      if (lastValue == null || (value - lastValue).abs() >= thresholds[key]!) {
        final nowMs = DateTime.now().millisecondsSinceEpoch.toString();
        futures.add(historyRef.child(key).child(nowMs).set(value));
      }
    }

    await Future.wait(futures);
  }
}
