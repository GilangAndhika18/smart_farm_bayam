class DeviceModel {
  bool pumpAcid;
  bool pumpNutrient;

  DeviceModel({
    required this.pumpAcid,
    required this.pumpNutrient,
  });

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      pumpAcid: map['pump_acid'] ?? false,
      pumpNutrient: map['pump_nutrient'] ?? false
    );
  }

  Map<String, dynamic> toMap() {
    return {'pump_acid': pumpAcid, 'pump_nutrient': pumpNutrient};
  }
}
