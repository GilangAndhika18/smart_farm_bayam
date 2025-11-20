import 'package:flutter/material.dart';
import '../controllers/history_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import '../app_globals.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryController controller = HistoryController(AppGlobals.refs);
  Map<String, double> thresholds = {};
  Map<String, Map<String, double>> historyData = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    thresholds = await controller.loadThresholds();
    historyData = await controller.loadHistoryData();
    setState(() => loading = false);
  }

  // Simpan threshold
  void _saveThresholds() async {
    await controller.saveThresholds(thresholds);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Threshold berhasil disimpan")),
    );
  }

  // Build TextField untuk threshold setting
  Widget buildThresholdField(String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: key.toUpperCase(),
          border: const OutlineInputBorder(),
        ),
        controller: TextEditingController(
          text: thresholds[key]?.toString() ?? '',
        ),
        onChanged: (val) {
          double? parsed = double.tryParse(val);
          if (parsed != null) thresholds[key] = parsed;
        },
      ),
    );
  }

  // Build chart per sensor (line chart)
  Widget buildChart(String sensor, Map<String, double> data) {
    List<FlSpot> spots = [];
    List<String> keys = data.keys.toList()..sort();
    for (int i = 0; i < keys.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[keys[i]]!));
    }

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              dotData: FlDotData(show: true),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  // Build tabel
  Widget buildTable() {
    List<String> sensors = ['ph', 'tds_ppm', 'ec_ms_cm', 'temp_c'];
    List<TableRow> rows = [
      TableRow(
        children: sensors
            .map(
              (s) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  s.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
            .toList(),
      ),
    ];

    // Ambil max length
    int maxLength = historyData.values
        .map((e) => e.length)
        .fold(0, (p, c) => c > p ? c : p);
    List<String> timestamps = [];
    for (int i = 0; i < maxLength; i++) {
      timestamps.add(i.toString());
    }

    for (int i = 0; i < maxLength; i++) {
      rows.add(
        TableRow(
          children: sensors.map((s) {
            final vals = historyData[s]?.values.toList() ?? [];
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Text(vals.length > i ? vals[i].toString() : "-"),
            );
          }).toList(),
        ),
      );
    }

    return Table(border: TableBorder.all(), children: rows);
  }

  Widget buildPillField(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8FFF4),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: TextEditingController(
              text: thresholds[key]?.toString() ?? "",
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              final parsed = double.tryParse(v);
              if (parsed != null) thresholds[key] = parsed;
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Input...",
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FFF4), // background hijau soft
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("History", style: TextStyle(color: Colors.black87)),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ==========================
                //   CARD SETTING THRESHOLD
                // ==========================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            "Setting Threshold",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6),
                        ],
                      ),
                      const SizedBox(height: 20),

                      buildPillField("pH", 'ph'),
                      buildPillField("TDS (PPM)", 'tds_ppm'),
                      buildPillField("EC (MS/CM)", 'ec_ms_cm'),
                      buildPillField("Temperature (°C)", 'temp_c'),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _saveThresholds,
                          child: const Text(
                            "Simpan Threshold",
                            style: TextStyle(color: Colors.white),  
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================
                //        CHART CARD SECTION
                // ==================================
                ...historyData.entries.map((e) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.key.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        buildChart(e.key, e.value),
                      ],
                    ),
                  );
                }),

                // ==================================
                //           TABLE SECTION
                // ==================================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Data Table",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      buildTable(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
