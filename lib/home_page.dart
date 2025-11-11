import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference dbRef;

@override
void initState() {
  super.initState();
  dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(), // <-- ini wajib
    databaseURL: "https://smartfarmbayam-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("sensor_data");
}

  Color getPhColor(double ph) {
    if (ph < 5.5) return Colors.red.shade200;
    if (ph > 7.5) return Colors.orange.shade200;
    return Colors.green.shade200;
  }

  Color getTdsColor(int tds) {
    if (tds < 300) return Colors.red.shade100;
    if (tds > 700) return Colors.orange.shade100;
    return Colors.green.shade100;
  }

  Color getEcColor(double ec) {
    if (ec < 1.0) return Colors.red.shade100;
    if (ec > 2.0) return Colors.orange.shade100;
    return Colors.green.shade100;
  }

  Future<void> _refreshData() async {
    setState(() {}); // StreamBuilder akan rebuild otomatis
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Sensor Smart Farm'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: StreamBuilder(
          stream: dbRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final dataSnapshot = snapshot.data!.snapshot.value;

            final Map<String, Map<String, dynamic>> dataMap =
                (dataSnapshot as Map<dynamic, dynamic>).map(
              (key, value) => MapEntry(
                key.toString(),
                Map<String, dynamic>.from(value as Map),
              ),
            );

            final sortedKeys = dataMap.keys.toList()
              ..sort((a, b) => b.compareTo(a));

            return ListView.builder(
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final key = sortedKeys[index];
                final sensor = dataMap[key]!;

                final ph = (sensor['ph'] as num).toDouble();
                final tds = (sensor['tds'] as num).toInt();
                final ec = (sensor['ec'] as num).toDouble();
                final temp = (sensor['temperature'] as num).toDouble();

                return Card(
                  color: getPhColor(ph).withOpacity(0.3),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      'pH: $ph, TDS: $tds ppm, EC: $ec mS/cm',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Suhu: $temp °C\nTimestamp: $key',
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
