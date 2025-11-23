import 'package:flutter/material.dart';
import '../controllers/information_controller.dart';
import '../models/information_model.dart';
import '../app_globals.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final InformationController controller = InformationController(AppGlobals.refs);

  @override
  void initState() {
    super.initState();
    controller.createInitialInfos(); // Buat 5 info awal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informasi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          )
        ],
      ),
      body: StreamBuilder<List<InformationModel>>(
        stream: controller.getInformationStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final infos = snapshot.data!;
          return ListView.builder(
            itemCount: infos.length,
            itemBuilder: (context, index) {
              final info = infos[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(info.title),
                  subtitle: Text(info.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InformationDetailPage(info: info, index: index),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Informasi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Judul")),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: "Konten")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              await controller.addInformation(titleController.text, contentController.text);
              Navigator.pop(context);
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }
}

// Halaman Detail sama seperti sebelumnya
class InformationDetailPage extends StatelessWidget {
  final InformationModel info;
  final int index;

  const InformationDetailPage({super.key, required this.info, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = InformationController(AppGlobals.refs);

    return Scaffold(
      appBar: AppBar(title: Text(info.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            if (index >= 5)
              ElevatedButton.icon(
                onPressed: () async {
                  await controller.removeInformation(info.id, index);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete),
                label: const Text("Hapus Informasi"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
