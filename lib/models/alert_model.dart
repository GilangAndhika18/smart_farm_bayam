class AlertModel {
  final String id; // key di firebase
  final String type;
  final double value;
  final int startMs;
  final int endMs;

  AlertModel({
    required this.id,
    required this.type,
    required this.value,
    required this.startMs,
    required this.endMs,
  });

  factory AlertModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return AlertModel(
      id: id,
      type: map['type'] ?? '',
      value: (map['value'] ?? 0).toDouble(),
      startMs: map['start_ms'] ?? 0,
      endMs: map['end_ms'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'value': value,
      'start_ms': startMs,
      'end_ms': endMs,
    };
  }
}
