import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../controllers/information_controller.dart';
import '../models/information_model.dart';
import '../app_globals.dart';

class InformationDetailPage extends StatelessWidget {
  final InformationModel info;
  final int index;

  const InformationDetailPage({
    super.key,
    required this.info,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final controller = InformationController(AppGlobals.refs);

    return Scaffold(
      backgroundColor: const Color(0xFFE0FFF2),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🔥 Full Markdown rendering
                      Expanded(
                        child: Markdown(
                          data: info.content,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(fontSize: 16, height: 1.4),
                            h1: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                            h2: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                            listBullet: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (index >= 5)
                        ElevatedButton.icon(
                          onPressed: () async {
                            await controller.removeInformation(info.id, index);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Hapus Informasi"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size.fromHeight(46),
                          ),
                        ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: const [
                            Icon(Icons.arrow_back, color: Color(0xFF009f7f)),
                            SizedBox(width: 6),
                            Text(
                              "Back",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF009f7f),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
