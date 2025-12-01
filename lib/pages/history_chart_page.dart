import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryChartPage extends StatelessWidget {
  final String sensorKey;
  final Map<String, double> data;

  const HistoryChartPage({
    super.key,
    required this.sensorKey,
    required this.data,
  });

  String _getChartTitle() {
    return (sensorKey == "ph" ? "pH" : sensorKey)
        .replaceAll("_", " ")
        .toUpperCase();
  }

  Widget _buildChart() {
    List<String> ts = data.keys.toList()..sort();
    List<FlSpot> spots = [];

    for (int i = 0; i < ts.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[ts[i]]!));
    }

    if (spots.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada data untuk rentang waktu ini.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 18, left: 12, top: 24),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Color(0xfff3f3f3),
                strokeWidth: 1,
              );
            },
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Color(0xfff3f3f3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  return Text(value.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border:
                Border.all(color: const Color(0xfff3f3f3), width: 1),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.teal,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.teal.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FFF4),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "History: ${_getChartTitle()}",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          "Grafik tren data ${_getChartTitle()}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 300,
                          child: _buildChart(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Tombol Back sesuai gambar (di luar card)
            Padding(
              padding:
                  const EdgeInsets.only(left: 20, bottom: 20, top: 8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios,
                        color: Colors.teal, size: 24),
                    SizedBox(width: 4),
                    Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}