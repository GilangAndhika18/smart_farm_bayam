import '../helper/manager.dart';
import '../models/information_model.dart';

class InformationController {
  final FirebaseRefs refs;
  InformationController(this.refs);

  // Stream untuk menampilkan informasi
  Stream<List<InformationModel>> getInformationStream() {
    return refs.informationRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries
          .map((e) => InformationModel.fromMap(e.value, e.key))
          .toList();
    });
  }

  // Tambah informasi
  Future<void> addInformation(String title, String content) async {
    final newRef = refs.informationRef.push();
    await newRef.set({'title': title, 'content': content});
  }

  // Hapus informasi (tapi cek jika index > 4)
  Future<void> removeInformation(String id, int index) async {
    if (index < 5) return; // 5 pertama tidak bisa dihapus
    await refs.informationRef.child(id).remove();
  }

  Future<void> createInitialInfos() async {
    final snapshot = await refs.informationRef.get();
    if (!snapshot.exists) {
      final initialInfos = [
        {
          'title': 'Selamat Datang',
          'content': '''
## Selamat Datang

Aplikasi ini membantu memantau tanaman bayam hidroponik Anda.

- Lihat data sensor
- Pantau kondisi tanaman
- Kendalikan perangkat secara otomatis
''',
        },

        {
          'title': 'Tips Tanaman',
          'content': '''
## Tips Perawatan Bayam

Berikut beberapa tips dasar:

1. Cahaya cukup 6–8 jam.
2. Nutrisi stabil.
3. Air tidak boleh kotor.
''',
        },

        {
          'title': 'Alarm Sensor',
          'content': '''
## Alarm Sensor

Aplikasi akan memberi notifikasi jika:

- pH terlalu tinggi atau rendah
- EC abnormal
- Suhu naik drastis
''',
        },

        {
          'title': 'Kontrol Pompa',
          'content': '''
## Kontrol Pompa

Anda bisa:

- Menyalakan pompa nutrisi
- Menjadwalkan waktu otomatis
- Mengecek status pompa
''',
        },

        {
          'title': 'Lampu & Nutrisi',
          'content': '''
## Lampu dan Nutrisi

Panduan singkat:

| Item      | Aturan                   |
|-----------|--------------------------|
| Lampu     | 6–12 jam per hari        |
| Nutrisi   | Ganti setiap 7 hari      |
| Intensitas| Sesuaikan kebutuhan tanaman |
''',
        },
      ];

      for (var info in initialInfos) {
        await refs.informationRef.push().set(info);
      }
    }
  }
}
