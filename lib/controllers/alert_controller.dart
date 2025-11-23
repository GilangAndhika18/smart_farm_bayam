import 'package:firebase_database/firebase_database.dart';
import '../models/alert_model.dart';

class AlertController {
  final DatabaseReference ref;
  AlertController(this.ref);

  Stream<List<AlertModel>> getAlerts() {
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists) return [];
      final Map<String, dynamic> map = Map<String, dynamic>.from(snapshot.value as Map);
      return map.entries
          .map((e) => AlertModel.fromMap(e.key, Map<String, dynamic>.from(e.value)))
          .toList();
    });
  }

  Future<void> removeAlert(String id) async {
    await ref.child(id).remove();
  }
}
