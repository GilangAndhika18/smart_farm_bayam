import '../models/config_model.dart';
import '../helper/manager.dart';

class ConfigController {
  final FirebaseRefs refs;

  ConfigController(this.refs);

  // Load config
  Future<ConfigModel?> loadConfig() async {
    final snapshot = await refs.configThresholdRef.get();
    if (!snapshot.exists) return null;

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return ConfigModel.fromMap(data);
  }

  // Save config
  Future<void> saveConfig(ConfigModel config) async {
    _validateConfig(config);
    await refs.configThresholdRef.set(config.toMap());
  }

  void _validateConfig(ConfigModel c) {
    final numericFields = {
      'ph_min': c.phMin,
      'ph_max': c.phMax,
      'tds_min_ppm': c.tdsMin,
      'tds_max_ppm': c.tdsMax,
      'ec_min_ms_cm': c.ecMin,
      'ec_max_ms_cm': c.ecMax,
      'temp_min_c': c.tempMin,
      'temp_max_c': c.tempMax,
    };

    // Label friendly untuk tampil di alert
    final friendlyLabels = {
      'ph_min': 'pH Minimum',
      'ph_max': 'pH Maximum',
      'tds_min_ppm': 'TDS Minimum',
      'tds_max_ppm': 'TDS Maximum',
      'ec_min_ms_cm': 'EC Minimum',
      'ec_max_ms_cm': 'EC Maximum',
      'temp_min_c': 'Temperature Minimum',
      'temp_max_c': 'Temperature Maximum',
    };

    for (var entry in numericFields.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value.isNaN) {
        throw Exception("${friendlyLabels[key]} harus berupa angka");
      }
      if (value.isInfinite) {
        throw Exception("${friendlyLabels[key]} tidak boleh infinite");
      }
      if (value < 0) {
        throw Exception("${friendlyLabels[key]} tidak boleh negatif");
      }
      if (value > 9999) {
        throw Exception("${friendlyLabels[key]} terlalu besar");
      }
    }

    // Validasi range
    if (c.phMin > c.phMax) {
      throw Exception("pH Minimum tidak boleh lebih besar dari pH Maximum");
    }
    if (c.tdsMin > c.tdsMax) {
      throw Exception("TDS Minimum tidak boleh lebih besar dari TDS Maximum");
    }
    if (c.ecMin > c.ecMax) {
      throw Exception("EC Minimum tidak boleh lebih besar dari EC Maximum");
    }
    if (c.tempMin > c.tempMax) {
      throw Exception(
        "Temperature Minimum tidak boleh lebih besar dari Temperature Maximum",
      );
    }

    // Validasi jam lampu
    if (c.lightOnHour < 0 || c.lightOnHour > 23) {
      throw Exception("Jam hidup lampu harus 0–23");
    }
    if (c.lightOffHour < 0 || c.lightOffHour > 23) {
      throw Exception("Jam mati lampu harus 0–23");
    }
  }
}
