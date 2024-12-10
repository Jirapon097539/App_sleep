import 'dart:async';

import 'package:app_login/Page/Quality_assessment.dart';
import 'package:app_login/Page/post_sleep1.dart';
import 'package:app_login/Page/post_sleep2.dart';
import 'package:app_login/Page/post_sleep3.dart';
import 'package:app_login/Page/setting.dart';
import 'package:app_login/Page/sleep_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Dashboard extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  Dashboard({required this.characteristic});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class HealthData {
  String heartRate;
  String oxygen;

  HealthData({required this.heartRate, required this.oxygen});
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  HealthData healthData = HealthData(heartRate: '0', oxygen: '0');
  String _greeting = '';
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime now = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();

    fetchDataFromFirestore(selectedDate);
    _loadEvents();

    _getTime();
    readCharacteristicValue();

    widget.characteristic.setNotifyValue(true);
    widget.characteristic.value.listen((value) {
      handleNotificationValue(value);
    });
  }

  void _loadEvents() async {
    DateTime currentDate = DateTime.now();
    await _getDataFromFirestore(currentDate);
  }

  Future<List<double>> getDataForMonth(
      int selectedMonth, int selectedYear) async {
    try {
      // กำหนดเดือนและปีที่เลือกในรูปแบบ 'YY-MM' เช่น '24-04' เพื่อใช้ในการค้นหาข้อมูล
      String formattedDate =
          '${selectedYear.toString().substring(2)}-${selectedMonth.toString().padLeft(2, '0')}';

      // ดึงข้อมูลผู้ใช้ปัจจุบัน
      User? user = _auth.currentUser;

      // สร้าง Query เพื่อดึงข้อมูลการนอนของเดือนและปีที่ระบุ และเรียงลำดับตามเวลาที่สร้างข้อมูล
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('sleep_data')
              .doc(user?.uid)
              .collection(formattedDate) // ใช้ formattedDate แทน 'sleep_data'
              .get();

      // สร้าง List เพื่อเก็บข้อมูลเวลาการนอน
      List<double> sleepData = [];

      // วนลูปเพื่อดึงข้อมูลการนอนแต่ละรายการ
      querySnapshot.docs.forEach((doc) {
        // ดึงข้อมูลเวลาการนอนจากเอกสาร
        double sleepHours = doc.data()['heartrate'];
        print(sleepHours);
        // เพิ่มข้อมูลการนอนเข้า List
        sleepData.add(sleepHours);
      });

      return sleepData;
    } catch (error) {
      // หากเกิดข้อผิดพลาดในการดึงข้อมูล
      print('Error retrieving sleep data: $error');
      return []; // ส่งกลับ List ว่าง
    }
  }

  late List<FlSpot> chartDataHeartRate = [];
  late List<FlSpot> chartDataOxygen = [];
  QueryDocumentSnapshot<Map<String, dynamic>>? lastDocument;

  Future<void> fetchDataFromFirestore(DateTime selectedDate) async {
    User? user = _auth.currentUser;

    try {
      // ดึงข้อมูลจาก Firestore
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('sleep_data')
          .doc(user?.uid)
          .collection(formattedDate)
          .orderBy('createdTimeAt');

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      // ลดจำนวนข้อมูลที่ดึงมาในแต่ละครั้งเป็น 10 ข้อมูล
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await query.limit(10).get();

      List<FlSpot> heartRateData = [];
      List<FlSpot> oxygenData = [];

      lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      snapshot.docs.forEach((doc) {
        final double? heartRate = double.tryParse(doc['heartRate'] ?? '0');
        final double? oxygen = double.tryParse(doc['oxygen'] ?? '0');

        if (heartRate != null && oxygen != null) {
          final String timestampString = doc['createdTimeAt'];

          final DateTime timestamp = DateFormat("HH:mm").parse(timestampString);
          final double y = double.parse(
              (timestamp.hour + timestamp.minute / 100).toStringAsFixed(2));

          heartRateData.add(FlSpot(y, heartRate));
          oxygenData.add(FlSpot(y, oxygen));
        }
      });

      setState(() {
        chartDataHeartRate.addAll(heartRateData);
        chartDataOxygen.addAll(oxygenData);
      });
      if (snapshot.docs.length < 10) {
        lastDocument = null;
      }
    } catch (e) {
      print('Error fetching health data from Firestore: $e');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      return userDoc;
    } else {
      throw Exception("User not signed in");
    }
  }

  DateTime selectedDate =
      DateTime.now(); // กำหนดค่าเริ่มต้นหรือให้ค่าจากการเลือกวันที่

// ฟังก์ชันที่เรียกเมื่อผู้ใช้เปลี่ยนวันที่
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate =
            picked; // อัปเดตค่า selectedDate เมื่อผู้ใช้เลือกวันที่ใหม่
      });
      chartDataHeartRate.clear();
      chartDataOxygen.clear();
      setState(() {
        fetchDataFromFirestore(selectedDate);
      });
    }
  }

  Future<Map<String, dynamic>> testSleepData(DateTime selectedDate) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;

      if (user != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
            .collection('sleep_data')
            .doc(user.uid)
            .collection(formattedDate)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // ดึงข้อมูลเวลาการนอน
          List<QueryDocumentSnapshot> sleepDataList = querySnapshot.docs;
          // เวลาการนอนครั้งแรก
          QueryDocumentSnapshot firstSleepData = sleepDataList.first;
          Map<String, dynamic> firstSleepDataMap =
              firstSleepData.data() as Map<String, dynamic>;
          String firstCreatedTimeAt = firstSleepDataMap['createdTimeAt'] ?? '';

          // เวลาการนอนครั้งสุดท้าย
          QueryDocumentSnapshot lastSleepData = sleepDataList.last;
          Map<String, dynamic> lastSleepDataMap =
              lastSleepData.data() as Map<String, dynamic>;
          String lastCreatedTimeAt = lastSleepDataMap['createdTimeAt'] ?? '';

          // แปลงเวลาเริ่มต้นและเวลาสิ้นสุดของการนอนเป็นวินาที
          int startSleepSeconds = timeToSeconds(firstCreatedTimeAt);
          int endSleepSeconds = timeToSeconds(lastCreatedTimeAt);

          // คำนวณระยะเวลาการนอนในวินาที
          int sleepDurationSeconds = endSleepSeconds - startSleepSeconds;

          // แปลงระยะเวลาการนอนเป็นชั่วโมงและนาที
          int sleepDurationHours = sleepDurationSeconds ~/ 3600; //หารปัดเศษ
          int sleepDurationMinutes = (sleepDurationSeconds % 3600) ~/ 60;

          Map<String, dynamic> sleepData = {
            'firstCreatedTimeAt': firstCreatedTimeAt,
            'lastCreatedTimeAt': lastCreatedTimeAt,
            'sleepDurationHours': sleepDurationHours,
            'sleepDurationMinutes': sleepDurationMinutes,
          };

          return sleepData;
        } else {
          // กรณีไม่พบข้อมูลเวลาการนอนในฐานข้อมูล
          print('ไม่พบข้อมูลเวลาการนอนในฐานข้อมูล');
          return {};
        }
      } else {
        // หากไม่มีผู้ใช้ที่ลงชื่อเข้าใช้
        throw Exception("User not signed in");
      }
    } catch (e) {
      print('Error fetching sleep data from Firestore: $e');
      throw e; // ส่งข้อผิดพลาดต่อไปเพื่อให้การจัดการข้อผิดพลาดเป็นไปตามปกติ
    }
  }

// ฟังก์ชันแปลงเวลาเป็นวินาที
  int timeToSeconds(String time) {
    List<String> timeParts = time.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2]);
    return hours * 3600 + minutes * 60 + seconds;
  }

  Map<DateTime, List<String>> _events = {};

  Future<void> _getDataFromFirestore(DateTime selectedDay) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
      print('Fetching data for date: $formattedDate');
      User? user = _auth.currentUser;

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('sleep_data')
          .doc(user?.uid)
          .collection(formattedDate)
          .get();

      List<String> eventData = []; // Initialize event data list
      double totalHeartRate = 0;
      double totalOxygenLevel = 0;
      int count = 0;

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        double heartRate = double.parse(doc['heartRate']);
        double oxygenLevel = double.parse(doc['oxygen']);
        totalHeartRate += heartRate;
        totalOxygenLevel += oxygenLevel;
        count++;
      }

      double averageHeartRate = totalHeartRate / count;
      double averageOxygenLevel = totalOxygenLevel / count;
      String formattedOxygenLevel = averageOxygenLevel.toStringAsFixed(2);
      String formattedHeartRate = averageHeartRate.toStringAsFixed(2);

      print('Average Heart rate: $formattedOxygenLevel bpm');
      print('Average Oxygen level: $formattedHeartRate%');

      if (!averageHeartRate.isNaN && !averageOxygenLevel.isNaN) {
        eventData.add(
            'Heart rate: $formattedHeartRate bpm, Oxygen level: $formattedOxygenLevel%');
      }

      setState(() {
        _events[selectedDay] = eventData;
      });

      print('Events for $formattedDate: $eventData');
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Future<List<Map<String, dynamic>>> fetchSleepData() async {
    List<Map<String, dynamic>> sleepData = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('sleep_data').get();

    querySnapshot.docs.forEach((doc) {
      sleepData.add(doc.data());
    });

    return sleepData;
  }

  List<HealthData> healthDataList = [];
  Future<void> _getHealthDataFromFirestore(DateTime selectedDate) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot<Map<String, dynamic>> healthDataDocs =
            await FirebaseFirestore.instance
                .collection('sleep_data')
                .doc(user.uid)
                .collection(formattedDate)
                .get();

        if (healthDataDocs.docs.isNotEmpty) {
          // สร้าง List เพื่อเก็บข้อมูลที่ได้จาก Firestore
          List<HealthData> dataList = [];
          for (QueryDocumentSnapshot<Map<String, dynamic>> doc
              in healthDataDocs.docs) {
            Map<String, dynamic> data = doc.data();
            dataList.add(HealthData(
              heartRate: data['heartRate'] ?? '0',
              oxygen: data['oxygen'] ?? '0',
            ));
          }
          setState(() {
            healthDataList =
                dataList; // กำหนดข้อมูลที่ได้ให้กับตัวแปรในส่วนของ State
          });
        } else {
          // หากไม่มีข้อมูล
          setState(() {
            healthDataList = []; // กำหนดให้ List เป็นว่าง
          });
        }
      } else {
        throw Exception("User not signed in");
      }
    } catch (e) {
      print('Error fetching health data from Firestore: $e');
    }
  }

  String _getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String _getDTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  String _getCurrentDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  Future<void> readCharacteristicValue() async {
    try {
      List<int> value = await widget.characteristic.read();
      String decodedValue = String.fromCharCodes(value);
      List<String> values = decodedValue.split(',');

      setState(() {
        if (healthData.heartRate != values[0] ||
            healthData.oxygen != values[1]) {
          healthData = HealthData(heartRate: values[0], oxygen: values[1]);
        }
      });
    } catch (e) {
      print('Read Error: $e');
    }
  }

  void _getTime() {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);

    setState(() {
      if (currentTime.hour < 12) {
        _greeting = 'สวัสดีตอนเช้า';
      } else if (currentTime.hour < 17) {
        _greeting = 'สวัสดีตอนบ่าย';
      } else if (currentTime.hour < 20) {
        _greeting = 'สวัสดีตอนเย็น';
      } else {
        _greeting = 'สวัสดีตอนกลางคืน';
      }
    });
    Timer.periodic(const Duration(minutes: 1), (Timer t) => _getTime());
  }

  void handleNotificationValue(List<int> value) {
    String decodedValue = String.fromCharCodes(value);
    List<String> values = decodedValue.split(',');
    if (values.length >= 2) {
      if (mounted) {
        setState(() {
          if (healthData.heartRate != values[0] ||
              healthData.oxygen != values[1]) {
            healthData = HealthData(heartRate: values[0], oxygen: values[1]);
          }
        });
      }
    }
  }

  Future<double> getAverageHeartRate(DateTime selectedDate) async {
    try {
      User? user = _auth.currentUser;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      QuerySnapshot<Map<String, dynamic>> healthDataDocs =
          await FirebaseFirestore.instance
              .collection('sleep_data')
              .doc(user?.uid)
              .collection(formattedDate)
              .get();

      if (healthDataDocs.docs.isNotEmpty) {
        // สร้าง List เพื่อเก็บข้อมูลอัตราการเต้นของหัวใจ
        List<double> heartRatesList = [];
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in healthDataDocs.docs) {
          Map<String, dynamic> data = doc.data();
          final double? heartRate = double.tryParse(data['heartRate'] ?? '0');
          if (heartRate != null) {
            heartRatesList.add(heartRate);
          }
        }
        // คำนวณค่าเฉลี่ยของอัตราการเต้นของหัวใจ
        double averageHeartRate = heartRatesList.isNotEmpty
            ? heartRatesList.reduce((a, b) => a + b) / heartRatesList.length
            : 0.0;

        return averageHeartRate;
      } else {
        throw Exception('0');
      }
    } catch (e) {
      print('Error fetching average heart rate: $e');
      rethrow; // ส่งข้อผิดพลาดต่อไป
    }
  }

  Future<double> getAverageOxygen(DateTime selectedDate) async {
    try {
      User? user = _auth.currentUser;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      QuerySnapshot<Map<String, dynamic>> healthDataDocs =
          await FirebaseFirestore.instance
              .collection('sleep_data')
              .doc(user?.uid)
              .collection(formattedDate)
              .get();

      if (healthDataDocs.docs.isNotEmpty) {
        // สร้าง List เพื่อเก็บข้อมูลอัตราการเต้นของหัวใจ
        List<double> oxygenList = [];
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in healthDataDocs.docs) {
          Map<String, dynamic> data = doc.data();
          final double? oxygen = double.tryParse(data['oxygen'] ?? '0');
          if (oxygen != null) {
            oxygenList.add(oxygen);
          }
        }
        // คำนวณค่าเฉลี่ยของอัตราการเต้นของหัวใจ
        double averageOxygen = oxygenList.isNotEmpty
            ? oxygenList.reduce((a, b) => a + b) / oxygenList.length
            : 0.0;

        return averageOxygen;
      } else {
        throw Exception('0');
      }
    } catch (e) {
      print('Error fetching average oxygen: $e');
      rethrow; // ส่งข้อผิดพลาดต่อไป
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _greeting,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          FutureBuilder(
                            future: _getUserData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text("Error: ${snapshot.error}"),
                                );
                              } else {
                                var userData = snapshot.data!;
                                var userName =
                                    userData.data()!['name'] ?? 'No Name';

                                return Text(
                                  "   $userName 😴 ",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: DefaultTabController(
                length: 2, // จำนวนแท็บ
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(50.0),
                    child: AppBar(
                      automaticallyImplyLeading: false, // ไม่แสดงปุ่มย้อนกลับ
                      backgroundColor:
                          Colors.transparent, // ตั้งค่าสีพื้นหลังให้เป็นโปร่งใส
                      elevation: 0, // ลบเงาของ Appbar
                      bottom: const TabBar(
                        tabs: [
                          Tab(text: 'วัน'),
                          Tab(text: 'สัปดาห์'),
                          // Tab(text: 'เดือน'),
                        ],
                      ),
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      // ส่วนเนื้อหาของแท็บ 'วัน'
                      SingleChildScrollView(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _selectDate(
                                        context); // เรียกใช้งานฟังก์ชันเพื่อให้ผู้ใช้เลือกวันที่
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("เลือกวันที่"),
                                      Text(
                                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.indigo[100],
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, right: 20.0, bottom: 30),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FutureBuilder<Map<String, dynamic>>(
                                            future: testSleepData(selectedDate),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<
                                                        Map<String, dynamic>>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                  'เกิดข้อผิดพลาด: ${snapshot.error}',
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                );
                                              } else {
                                                // แสดงข้อมูลเวลาการนอน
                                                final data = snapshot.data;
                                                if (data != null &&
                                                    data.isNotEmpty) {
                                                  final firstCreatedTimeAt =
                                                      data[
                                                          'firstCreatedTimeAt'];
                                                  final lastCreatedTimeAt =
                                                      data['lastCreatedTimeAt'];
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            '                เวลานอน',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            '   $firstCreatedTimeAt - $lastCreatedTimeAt ',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          TextButton.icon(
                                                              onPressed: () {
                                                                setState(() {});
                                                                chartDataHeartRate
                                                                    .clear();
                                                                chartDataOxygen
                                                                    .clear();
                                                                fetchDataFromFirestore(
                                                                    selectedDate);
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .arrow_circle_right,
                                                                color: Colors
                                                                    .green,
                                                                size: 24.0,
                                                              ),
                                                              label: const Text(
                                                                  ''))
                                                        ],
                                                      ),
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .brightness_1_rounded,
                                                                color:
                                                                    Colors.red,
                                                                size: 30.0,
                                                              ),
                                                              Text("ออกซิเจน "),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .brightness_1_rounded,
                                                                color:
                                                                    Colors.blue,
                                                                size: 30.0,
                                                              ),
                                                              Text(
                                                                  " อัตราการเต้นของหัวใจ"),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 25.0),
                                                            child: Text(
                                                                "Heartrate/oxygen"),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 230,
                                                        width: 280,
                                                        child: LineChart(
                                                          LineChartData(
                                                            lineTouchData:
                                                                const LineTouchData(
                                                                    enabled:
                                                                        true),
                                                            borderData:
                                                                FlBorderData(
                                                                    show:
                                                                        false),
                                                            lineBarsData: [
                                                              LineChartBarData(
                                                                spots:
                                                                    chartDataHeartRate,
                                                                isCurved: true,
                                                                color:
                                                                    Colors.blue,
                                                                barWidth: 2,
                                                                belowBarData:
                                                                    BarAreaData(
                                                                        show:
                                                                            false),
                                                                dotData:
                                                                    const FlDotData(
                                                                        show:
                                                                            true),
                                                              ),
                                                              LineChartBarData(
                                                                spots:
                                                                    chartDataOxygen,
                                                                isCurved: true,
                                                                color:
                                                                    Colors.red,
                                                                barWidth: 2,
                                                                belowBarData:
                                                                    BarAreaData(
                                                                        show:
                                                                            false),
                                                                dotData:
                                                                    const FlDotData(
                                                                        show:
                                                                            true),
                                                              ),
                                                            ],
                                                            titlesData:
                                                                const FlTitlesData(
                                                              rightTitles:
                                                                  AxisTitles(
                                                                axisNameSize:
                                                                    24,
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      false,
                                                                  reservedSize:
                                                                      0,
                                                                ),
                                                              ),
                                                              topTitles:
                                                                  AxisTitles(
                                                                axisNameWidget:
                                                                    Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start, // จัดจากซ้ายไปขวา
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            40), // ระยะห่างระหว่างข้อความกับกราฟ

                                                                    Text(
                                                                        ""), // ข้อความที่แสดงด้านบนของแกน y
                                                                    SizedBox(
                                                                        height:
                                                                            42), // ระยะห่างระหว่างข้อความกับกราฟ
                                                                  ],
                                                                ),
                                                                sideTitles:
                                                                    SideTitles(
                                                                  reservedSize:
                                                                      0,
                                                                  showTitles:
                                                                      true,
                                                                ),
                                                              ),
                                                              bottomTitles:
                                                                  AxisTitles(
                                                                axisNameWidget:
                                                                    Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text("Time")
                                                                  ],
                                                                ),
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      true,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        'ไม่มีข้อมูล เนื่องจากคุณยังไม่ได้บันทึกการนอน',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .brightness_1_rounded,
                                                                color:
                                                                    Colors.red,
                                                                size: 30.0,
                                                              ),
                                                              Text("ออกซิเจน "),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .brightness_1_rounded,
                                                                color:
                                                                    Colors.blue,
                                                                size: 30.0,
                                                              ),
                                                              Text(
                                                                  " อัตราการเต้นของหัวใจ"),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 25.0),
                                                            child: Text(
                                                                "Heartrate/oxygen"),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 230,
                                                        width: 280,
                                                        child: LineChart(
                                                            LineChartData(
                                                          minX: 0,
                                                          maxX: 23.00,
                                                          minY: 0,
                                                          maxY: 100,
                                                          lineTouchData:
                                                              const LineTouchData(
                                                                  enabled:
                                                                      false),
                                                          borderData:
                                                              FlBorderData(
                                                            show: false,
                                                            border: Border.all(
                                                                color: Color(
                                                                    0xff37434d),
                                                                width: 1),
                                                          ),
                                                          lineBarsData: [
                                                            LineChartBarData(
                                                              isCurved: true,
                                                              color:
                                                                  Colors.blue,
                                                              dotData:
                                                                  const FlDotData(
                                                                      show:
                                                                          false),
                                                              belowBarData:
                                                                  BarAreaData(
                                                                      show:
                                                                          false),
                                                            ),
                                                          ],
                                                          titlesData:
                                                              const FlTitlesData(
                                                            rightTitles:
                                                                AxisTitles(
                                                              axisNameWidget:
                                                                  Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [],
                                                              ),
                                                              sideTitles:
                                                                  SideTitles(
                                                                showTitles:
                                                                    true,
                                                                reservedSize: 0,
                                                              ),
                                                            ),
                                                            topTitles:
                                                                AxisTitles(
                                                              axisNameWidget:
                                                                  Row(
                                                                children: [
                                                                  Text(""),
                                                                ],
                                                              ),
                                                              sideTitles:
                                                                  SideTitles(
                                                                reservedSize: 0,
                                                                showTitles:
                                                                    true,
                                                              ),
                                                            ),
                                                            bottomTitles:
                                                                AxisTitles(
                                                              axisNameWidget:
                                                                  Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text("Time")
                                                                ],
                                                              ),
                                                              sideTitles:
                                                                  SideTitles(
                                                                showTitles:
                                                                    true,
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                      )
                                                    ],
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const SizedBox(
                                  child: Text(
                                    "ข้อมูลการนอน",
                                    style: TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 354,
                                      height: 200,
                                      child: Card(
                                        color: Colors.teal[700],
                                        child: Center(
                                          child: FutureBuilder<
                                              Map<String, dynamic>>(
                                            future: testSleepData(selectedDate),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<
                                                        Map<String, dynamic>>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'เกิดข้อผิดพลาด: ${snapshot.error}');
                                              } else {
                                                // แสดงข้อมูลเวลาการนอน
                                                final data = snapshot.data;
                                                if (data != null &&
                                                    data.isNotEmpty) {
                                                  final sleepDurationHours =
                                                      data[
                                                          'sleepDurationHours'];
                                                  final sleepDurationMinutes =
                                                      data[
                                                          'sleepDurationMinutes'];

                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                          Icons.dark_mode,
                                                          color: Colors.white,
                                                          size: 50),
                                                      const Text(
                                                          'ระยะเวลาการนอน',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      Text(
                                                          ' $sleepDurationHours ชั่วโมง $sleepDurationMinutes นาที',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      20)),
                                                    ],
                                                  );
                                                } else {
                                                  return const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(' 0 ชั่วโมง 0 นาที',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    ],
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      height: 200,
                                      child: Card(
                                        color: Colors.red[300],
                                        child: Center(
                                          child: FutureBuilder<double>(
                                            future: getAverageHeartRate(
                                                selectedDate),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<double>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                    ' ${snapshot.error}');
                                              } else {
                                                double averageHeartRate =
                                                    snapshot.data ?? 0;
                                                return Column(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 5,
                                                                  left: 70,
                                                                  top: 10),
                                                          child: Icon(
                                                            Icons.heart_broken,
                                                            color: Colors.white,
                                                            size: 50,
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  top: 10),
                                                          child: Text(
                                                            'ค่าเฉลี่ย HeartRate',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10,
                                                                  top: 5),
                                                          child: Text(
                                                            '${averageHeartRate.toStringAsFixed(2)} bpm',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 25,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      height: 200,
                                      child: Card(
                                        color: Colors.blueAccent[400],
                                        child: Center(
                                          child: FutureBuilder<double>(
                                            future:
                                                getAverageOxygen(selectedDate),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<double>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                    ' ${snapshot.error}');
                                              } else {
                                                double averageOxygen =
                                                    snapshot.data ?? 0;
                                                return Column(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 70,
                                                                  top: 10),
                                                          child: Icon(
                                                            Icons
                                                                .star_rate_outlined,
                                                            color: Colors.white,
                                                            size: 50,
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          child: Text(
                                                            'ค่าเฉลี่ย Oxygen',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10,
                                                                  top: 5),
                                                          child: Text(
                                                            '${averageOxygen.toStringAsFixed(2)} %',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 25,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  child: Text(
                                    "ความรู้ทั่วไป",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 280.0,
                                          height: 170.0,
                                          child: Card(
                                            color: Colors.green,
                                            child: Stack(
                                              children: [
                                                // รูปภาพ
                                                Positioned.fill(
                                                  child: Image.asset(
                                                    'assets/images/sleep2.jpg', // URL ของรูปภาพ
                                                    fit: BoxFit
                                                        .fill, // ปรับขนาดรูปภาพให้พอดีกับพื้นที่
                                                  ),
                                                ),
                                                // ปุ่มดูข้อมูลเพิ่มเติม
                                                Positioned(
                                                  bottom: 10,
                                                  left: 10,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const post_sleep1(),
                                                          ));
                                                    },
                                                    child: const Text(
                                                      'เพิ่มเติม >>',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 280.0,
                                          height: 170.0,
                                          child: Card(
                                            color: Colors.green,
                                            child: Stack(
                                              children: [
                                                // รูปภาพ
                                                Positioned.fill(
                                                  child: Image.asset(
                                                    'assets/images/sleep1.png', // URL ของรูปภาพ
                                                    fit: BoxFit
                                                        .fill, // ปรับขนาดรูปภาพให้พอดีกับพื้นที่
                                                  ),
                                                ),
                                                // ปุ่มดูข้อมูลเพิ่มเติม
                                                Positioned(
                                                  bottom: 10,
                                                  left: 10,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const post_sleep2(),
                                                          ));
                                                    },
                                                    child: const Text(
                                                      'เพิ่มเติม >>',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 280.0,
                                          height: 170.0,
                                          child: Card(
                                            color: Colors.green,
                                            child: Stack(
                                              children: [
                                                // รูปภาพ
                                                Positioned.fill(
                                                  child: Image.asset(
                                                    'assets/images/sleep_3.jpg', // URL ของรูปภาพ
                                                    fit: BoxFit
                                                        .cover, // ปรับขนาดรูปภาพให้พอดีกับพื้นที่
                                                  ),
                                                ),
                                                // ปุ่มดูข้อมูลเพิ่มเติม
                                                Positioned(
                                                  bottom: 10,
                                                  left: 10,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const post_sleep3(),
                                                          ));
                                                    },
                                                    child: const Text(
                                                      'เพิ่มเติม >>',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
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
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // ส่วนเนื้อหาของแท็บ 'สัปดาห์'
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 24, right: 24, bottom: 0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TableCalendar(
                                  firstDay: DateTime.utc(2020, 1, 1),
                                  lastDay: DateTime.utc(2030, 12, 31),
                                  focusedDay: _focusedDay,
                                  calendarFormat: _calendarFormat,
                                  eventLoader: _getEventsForDay,
                                  onFormatChanged: (format) {
                                    setState(() {
                                      _calendarFormat = format;
                                    });
                                  },
                                  onDaySelected: (selectedDay, focusedDay) {
                                    setState(() {
                                      _selectedDay = selectedDay;
                                      _focusedDay = focusedDay;
                                      _getDataFromFirestore(
                                          selectedDay); // Call _getDataFromFirestore with the selected day
                                    });
                                  },
                                  selectedDayPredicate: (day) {
                                    return isSameDay(_selectedDay, day);
                                  },
                                ),

                                SizedBox(height: 10),
                                _selectedDay != null
                                    ? Text(
                                        'Events for ${DateFormat('yyyy-MM-dd').format(_selectedDay!)}:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Container(),
                                // แสดงเหตุการณ์สำหรับวันที่เลือก
                                _selectedDay != null &&
                                        _events.containsKey(_selectedDay!)
                                    ? SizedBox(
                                        height: 200, // กำหนดความสูงของ ListView
                                        child: ListView(
                                          children:
                                              _getEventsForDay(_selectedDay!)
                                                  .map((event) {
                                            // แยกข้อมูลเหตุการณ์เพื่อรับชื่อเหตุการณ์และระดับออกซิเจน
                                            List<String> eventData =
                                                event.split(', ');

                                            if (eventData.length == 2) {
                                              String heartRate =
                                                  eventData[0].substring(12);
                                              String oxygenLevel =
                                                  eventData[1].substring(14);
                                              return Column(
                                                children: [
                                                  Card(
                                                    color: Colors.red,
                                                    child: ListTile(
                                                      title: Text(
                                                          'Oxygen level: $oxygenLevel'),
                                                    ),
                                                  ),
                                                  Card(
                                                    color: Colors.blue,
                                                    child: ListTile(
                                                      title: Text(
                                                          'Heart rate: $heartRate '),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                            // ถ้าข้อมูลเหตุการณ์ไม่ถูกต้อง ให้คืนค่าวิดเจ็ตว่าง
                                            return Container(
                                              child: Text("data"),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 30,
                                        child: Text("ไม่มีข้อมูลสำหรับวันนี้"),
                                      ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // ส่วนเนื้อหาของแท็บ 'เดือน'
                      // Container(
                      //   padding: EdgeInsets.all(16),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         "ข้อมูลการนอนของเดือน $selectedMonth/$selectedYear",
                      //         style: TextStyle(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       SizedBox(height: 16),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text("เลือกเดือน: "),
                      //           DropdownButton<int>(
                      //             value: selectedMonth,
                      //             onChanged: (int? newValue) {
                      //               if (newValue != null) {
                      //                 setState(() {
                      //                   selectedMonth = newValue;
                      //                 });
                      //               }
                      //             },
                      //             items: List.generate(12, (index) => index + 1)
                      //                 .map((int value) {
                      //               return DropdownMenuItem<int>(
                      //                 value: value,
                      //                 child: Text(value.toString()),
                      //               );
                      //             }).toList(),
                      //           ),
                      //           Text(" เลือกปี: "),
                      //           DropdownButton<int>(
                      //             value: selectedYear,
                      //             onChanged: (int? newValue) {
                      //               if (newValue != null) {
                      //                 setState(() {
                      //                   selectedYear = newValue;
                      //                 });
                      //               }
                      //             },
                      //             items: List.generate(
                      //                     DateTime.now().year - 2010 + 1,
                      //                     (index) =>
                      //                         DateTime.now().year - index)
                      //                 .map((int value) {
                      //               return DropdownMenuItem<int>(
                      //                 value: value,
                      //                 child: Text(value.toString()),
                      //               );
                      //             }).toList(),
                      //           ),
                      //         ],
                      //       ),
                      //       StreamBuilder(
                      //         stream: FirebaseFirestore.instance
                      //             .collection('sleep_data')
                      //             .snapshots(),
                      //         builder: (context,
                      //             AsyncSnapshot<QuerySnapshot> snapshot) {
                      //           if (snapshot.connectionState ==
                      //               ConnectionState.waiting) {
                      //             return CircularProgressIndicator();
                      //           }
                      //           if (snapshot.hasError) {
                      //             return Text('Error: ${snapshot.error}');
                      //           }
                      //           final documents = snapshot.data!.docs;
                      //           return ListView.builder(
                      //             itemCount: documents.length,
                      //             itemBuilder: (context, index) {
                      //               final document = documents[index];
                      //               // ทำการประมวลผลหรือแสดงข้อมูลตามที่ต้องการ
                      //               return ListTile(
                      //                 title: Text(document['title']),
                      //                 subtitle: Text(document['subtitle']),
                      //               );
                      //             },
                      //           );
                      //         },
                      //       ),
                      //       SizedBox(height: 16),
                      //       ElevatedButton(
                      //         onPressed: () {
                      //           getDataForMonth(selectedMonth, selectedYear);
                      //         },
                      //         child: Text('แสดงข้อมูลวันที่เลือก'),
                      //       ),
                      //       Column(
                      //         children: [
                      //           SizedBox(
                      //             width: 280.0,
                      //             height: 170.0,
                      //             child: Card(
                      //               color: Colors.green,
                      //               child: Stack(
                      //                 children: [
                      //                   // รูปภาพ
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 50,
        child: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('กรุณาตรวจสอบการวางนิ้วบนเซ็นเซอร์'),
                content: const Text(
                    ' กรุณาตรวจสอบการวางนิ้วบนเซ็นเซอร์ของคุณค้าง 10 วินาที ก่อนดำเนินการ'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sleep_mode(
                                  characteristic: widget.characteristic,
                                )),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          backgroundColor: Colors.blue.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          label: const Text(
            'บันทึกการนอน',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.dark_mode, color: Colors.white, size: 25),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomAppBar(
          color: Colors.blue.shade900,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.dark_mode,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              // IconButton(
              //   icon: const Icon(
              //     Icons.access_alarms,
              //     color: Colors.white,
              //     size: 20,
              //   ),
              //   onPressed: () {
              //     _onItemTapped(3);
              //   },
              // ),
              // IconButton(
              //   icon: const Icon(
              //     Icons.assessment,
              //     color: Colors.white,
              //     size: 20,
              //   ),
              //   onPressed: () {
              //     _onItemTapped(2);
              //   },
              // ),
              IconButton(
                icon: const Icon(
                  Icons.auto_graph,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _onItemTapped(1);
                },
                iconSize: 10,
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _onItemTapped(4);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {});

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    characteristic: widget.characteristic,
                  )),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Quality_assessment(
                    characteristic: widget.characteristic,
                  )),
        );
        break;
      case 2:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => Sleep_analysis(
        //             characteristic: widget.characteristic,
        //           )),
        // );
        break;
      case 3:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => Sleep_tracking(
        //             characteristic: widget.characteristic,
        //           )),
        // );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Setting(
                    characteristic: widget.characteristic,
                  )),
        );
        break;
    }
  }
}
