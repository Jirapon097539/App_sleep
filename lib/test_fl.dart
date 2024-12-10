import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FlChartFromFirebase extends StatefulWidget {
  const FlChartFromFirebase({Key? key}) : super(key: key);

  @override
  State<FlChartFromFirebase> createState() => _FlChartFromFirebaseState();
}

class _FlChartFromFirebaseState extends State<FlChartFromFirebase> {
  late List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      // ดึงข้อมูลจาก Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('sleep_data')
          .doc("mfbMZwJtNaVppE9U1qesPISMno83")
          .collection("2024-04-01")
          .get();

      // แปลงข้อมูลจาก Firestore เป็นรูปแบบของ FlSpot
      List<FlSpot> data = [];

      snapshot.docs.forEach((doc) {
        final double heartRate = double.parse(doc['heartRate'] ?? '0');
        final String timestampString =
            doc['createdTimeAt']; // อ่านเวลาจาก Firestore ในรูปแบบ String
        final DateTime timestamp =
            DateFormat("HH:mm:ss").parse(timestampString);
// แปลง DateTime เป็น String ในรูปแบบที่ต้องการ

        final double x = heartRate; // heart rate เป็นแกน x
        final double y = timestamp.hour.toDouble() +
            (timestamp.minute.toDouble() / 60) +
            (timestamp.second.toDouble() /
                3600); // เวลาในรูปแบบทศนิยม เช่น 13.5 เป็น 1:30:00 หลังเที่ยง
        data.add(FlSpot(y, x));
      });

      // กำหนดข้อมูลที่ได้ให้กับตัวแปร chartData และอัพเดท UI
      setState(() {
        chartData = data;
      });
    } catch (e) {
      print('Error fetching health data from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Flutter Chart Example'),
            backgroundColor: Colors.green),
        body: Center(
          child: SizedBox(
            width: 260,
            height: 250,
            child: LineChart(
              LineChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  lineBarsData: [
                    // LineChartBarData(spots: chartData),
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      color: Colors.blue, // กำหนดสีของเส้นกราฟ
                      barWidth: 4, // กำหนดความหนาของเส้นกราฟ
                      belowBarData:
                          BarAreaData(show: false), // ซ่อนพื้นที่ใต้กราฟ
                      dotData: FlDotData(show: true), // แสดงจุดบนเส้นกราฟ
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(),
                        ),
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        getTitlesWidget: (value, meta) => Container(),
                      ),
                    ),
                  )),
            ),
          ),
        ));
  }
}
