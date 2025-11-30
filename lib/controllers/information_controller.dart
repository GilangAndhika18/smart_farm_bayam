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
          'title': 'Cara Kerja Sistem',
          'content': '''
## Selamat Datang

Aplikasi ini bekerja berdasarkan **Konfigurasi Anda**.

1. Masuk ke menu **Config**.
2. Masukkan nilai **Min** dan **Max** yang Anda inginkan.
3. Sistem akan otomatis bekerja menjaga kondisi tanaman tetap berada di antara angka tersebut.

*Gunakan data rekomendasi di halaman sebelah sebagai acuan setting Anda.*
''',
        },

        {
          'title': 'Rekomendasi Setting Bayam',
          'content': '''
## Contekkan Setting Config

Agar bayam tumbuh optimal seperti di jurnal penelitian, Anda bisa memasukkan angka ini ke menu **Config**:

| Parameter | Set Min | Set Max |
|-----------|---------|---------|
| **pH Air** | 5.5     | 6.5     |
| **TDS (PPM)** | 1200    | 1600    |
| **EC (mS/cm)**| 1.2     | 2.3     |
| **Suhu Air** | 20°C    | 32°C    |

[cite_start]*Data ini berdasarkan hasil panen optimal tanaman bayam dengan tinggi rata-rata 28 cm.* [cite: 24, 569, 572]
''',
        },

        {
          'title': 'Logika Alarm',
          'content': '''
## Kapan Alarm Berbunyi?

Notifikasi peringatan akan muncul di HP Anda jika sensor membaca nilai di luar batas yang **telah Anda tentukan sendiri**.

* **Peringatan TINGGI:** Jika nilai sensor > Batas Max Config Anda.
* **Peringatan RENDAH:** Jika nilai sensor < Batas Min Config Anda.

*Pastikan Anda mengisi batas aman yang sesuai agar tidak terlalu sering mendapat notifikasi palsu.*
''',
        },

        {
          'title': 'Otomatisasi Pompa',
          'content': '''
## Kapan Pompa Menyala?

Pompa akan bekerja otomatis mengejar target **Nilai Config** Anda:

### 1. Pompa Nutrisi
* **Nyala (ON):** Saat nutrisi turun **di bawah Batas Min** yang Anda atur.
* **Mati (OFF):** Saat nutrisi sudah naik kembali mencapai target.

### 2. Pompa pH (Asam)
* **Nyala (ON):** Saat pH naik **melebihi Batas Max** yang Anda atur (terlalu basa).
* **Mati (OFF):** Saat pH sudah turun kembali ke range aman.

[cite_start]*Sistem bergantung sepenuhnya pada angka yang Anda masukkan.* [cite: 23, 302, 306]
''',
        },

        {
          'title': 'Tips Perawatan',
          'content': '''
## Tips Tambahan

Selain setting otomatis, perhatikan hal manual ini:

1.  **Suhu Air:** Jaga di range **20-30°C**. [cite_start]Jika Config Max suhu terlampaui, tambahkan es batu atau aerator karena suhu panas membuat pH tidak stabil. [cite: 577]
2.  **Fase Bibit:** Gunakan setting TDS rendah (sekitar **600-800 ppm**) di Config agar akar tidak busuk. [cite_start]Naikkan setting ke **1200+ ppm** saat daun sudah lebat. [cite: 571]
3.  **Kuras Tandon:** Ganti air total jika lumut sudah banyak, meskipun angka sensor masih bagus.
''',
        },
      ];

      for (var info in initialInfos) {
        await refs.informationRef.push().set(info);
      }
    }
  }
}
