import 'dart:async';

import 'package:app_login/Page/Dashboard.dart';
import 'package:app_login/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class sleep_mode extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  const sleep_mode({super.key, required this.characteristic});

  @override
  State<sleep_mode> createState() => _sleep_modeState();
}

class HealthData {
  String heartRate;
  String oxygen;

  HealthData({required this.heartRate, required this.oxygen});
}

class _sleep_modeState extends State<sleep_mode> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  HealthData healthData = HealthData(heartRate: '0', oxygen: '0');
  late Timer _timer;
  String _greeting = '';
  String _timeString = '';
  bool isRecordingSleep = false; // เริ่มต้นที่ยังไม่ได้บันทึกการนอน
  int sleepRecordCount = 0;

  @override
  void initState() {
    super.initState();
    _getTime();

    readCharacteristicValue();

    // widget.characteristic.setNotifyValue(true);
  }

  @override
  void dispose() {
    _timer.cancel(); // ยกเลิก Timer ก่อนที่วิดเจ็ตจะถูกทำลาย
    super.dispose();
  }

  Future<void> readCharacteristicValue() async {
    try {
      List<int> value = await widget.characteristic.read();
      String decodedValue = String.fromCharCodes(value);
      List<String> values = decodedValue.split(',');

      setState(() {
        if (values.length >= 2) {
          // Check if new values are available
          if (healthData.heartRate != values[0] ||
              healthData.oxygen != values[1]) {
            healthData = HealthData(heartRate: values[0], oxygen: values[1]);
          }
        }
      });
    } catch (e) {
      print('Read Error: $e');
      // Handle error by setting healthData to default values
      setState(() {
        healthData = HealthData(heartRate: '0', oxygen: '0');
      });
    }
  }

  bool isHealthAlertShown = false;

  void updateHealthData() {
    double heartRate = double.parse(healthData.heartRate);
    double oxygenLevel = double.parse(healthData.oxygen);

    if (!isHealthAlertShown &&
        ((heartRate < 60.0 &&
                heartRate !=
                    0.0) || // Check if heart rate is less than 60 and not zero
            (oxygenLevel < 92.0 && oxygenLevel != 0.0))) {
      // Check if oxygen level is less than 92 and not zero
      // แสดงการแจ้งเตือน
      print("Health alert triggered");
      showHealthAlertNotification(
          'Health Alert', 'Heart Rate: $heartRate, Oxygen Level: $oxygenLevel');

      // ปรับปรุงสถานะการแจ้งเตือน
      isHealthAlertShown = true;
    } else {
      // หากไม่ตรงเงื่อนไขสำหรับการแจ้งเตือน รีเซ็ตสถานะการแจ้งเตือน
      isHealthAlertShown = false;
    }
  }

  Future<void> showHealthAlertNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('health_alert_channel_id', 'Health Alerts',
            channelDescription: "Custom_Notification",
            importance: Importance.high,
            priority: Priority.defaultPriority,
            ticker: "ticker");
    const NotificationDetails platformAndroid =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformAndroid,
        payload: 'health_alert');
  }

  Future<void> startandstopAlertNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'health_alert_channel_id_1', 'start_stop Alerts',
            channelDescription: "Custom_Notification",
            importance: Importance.high,
            priority: Priority.defaultPriority,
            ticker: "ticker");
    const NotificationDetails platformAndroid =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(1, title, body, platformAndroid,
        payload: 'start_stop_alert');
  }

  void handleNotificationValue(List<int> value) {
    updateHealthData();
    String decodedValue = String.fromCharCodes(value);
    if (decodedValue.isNotEmpty) {
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
      } else {
        print("Invalid data format: $decodedValue");
      }
    } else {
      print("Empty data received");
    }

    // Check payload and show appropriate notification
    if (decodedValue.contains('health_alert')) {
      showHealthAlertNotification('Health Alert',
          'Heart Rate: ${healthData.heartRate}, Oxygen Level: ${healthData.oxygen}');
    } else if (decodedValue.contains('start_stop_alert')) {
      startandstopAlertNotification(
          'Notification', 'Your action triggered a notification.');
    }
  }

  Future<void> _initializeHealthData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userData = await _getUserData();
        String userId = user.uid;

        if (!userData.exists) {
          await FirebaseFirestore.instance.collection('users').doc(userId).set({
            'name': user.displayName ?? 'Unknown',
          });
        }

        await _ensureHealthDataCollectionExists(userId);
      } else {
        print("User not signed in");
      }
    } catch (e) {
      print('Error initializing health data: $e');
    }
  }

  Future<void> _ensureHealthDataCollectionExists(String userId) async {
    print("eun");
    try {
      String currentDate = _getCurrentDate();
      String currentTime = _getDTime();

      DocumentSnapshot<Map<String, dynamic>> healthDataDoc =
          await FirebaseFirestore.instance
              .collection('sleep_data')
              .doc(userId)
              .collection(currentDate)
              .doc(currentTime)
              .get();

      if (!healthDataDoc.exists) {
        await _createHealthDataInFirestore(userId);
      }
    } catch (e) {
      print('Error checking or creating health data collection: $e');
    }
  }

  void _getTime() {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);
    if (mounted) {
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
        _timeString = '${currentTime.hour}:${currentTime.minute}';
      });
      Future.delayed(const Duration(minutes: 1), _getTime);
    }
  }

  Future<void> _createHealthDataInFirestore(String userId) async {
    print("create");

    try {
      String currentDate = _getCurrentDate();
      String currentTime = _getDTime();
      // String currentDateTime = _getCurrentDateTime();
      Map<String, dynamic> initialData = {
        'heartRate': healthData.heartRate,
        'oxygen': healthData.oxygen,
        'createdTimeAt': currentTime,
        'createdDateAt': currentDate
      };

      await FirebaseFirestore.instance
          .collection('sleep_data')
          .doc(userId)
          .collection(currentDate)
          .doc(currentTime)
          .set(initialData);
      print(
          'Health data for $currentDate created heartRate ${healthData.heartRate} successfully');
    } catch (e) {
      print('Error creating health data in Firestore: $e');
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

  String _getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String _getDTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  String _getCurrentDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Image55.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 200,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$_greeting",
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "$_timeString",
                      style: const TextStyle(fontSize: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    if (isRecordingSleep) // เพิ่มเงื่อนไขตรวจสอบว่ากำลังทำงานหรือไม่
                      Column(
                        children: [
                          Lottie.asset(
                            "assets/animations/Animation_clock.json",
                            width: 150,
                          ),
                          const Text(
                            "กำลังบันทึก...", // แสดง "crud" เมื่อกำลังทำงาน
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Heart Rate: ${healthData.heartRate}',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Oxygen: ${healthData.oxygen}',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Dashboard(
                                characteristic: widget.characteristic,
                              )),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 8, right: 60, bottom: 50, left: 48),
        child: FloatingActionButton.extended(
          onPressed: () {
            if (isRecordingSleep) {
              // หยุดการบันทึกการนอน
              _timer.cancel(); // ยกเลิกการใช้งาน _timer
              isRecordingSleep = false;
              // หยุดการเรียกข้อมูลจาก Bluetooth
              widget.characteristic.setNotifyValue(false);
              setState(() {
                healthData = HealthData(
                    heartRate: '0', oxygen: '0'); // Reset health data
              });
              print("หยุดการบันทึกการนอน");
              if (mounted) {
                setState(() {}); // อัพเดตสถานะ UI
              }
              // แสดงการแจ้งเตือนเมื่อหยุดบันทึกการนอน
              print("Sleep recording stopped");
              startandstopAlertNotification(
                'หยุดบันทึกการนอน',
                'คุณได้ทำการหยุดบันทึกการนอนของคุณ.',
              );
            } else {
              widget.characteristic.value.listen((value) {
                handleNotificationValue(value);
              });
              widget.characteristic
                  .setNotifyValue(true); // Set characteristic notification
              // เริ่มการบันทึกการนอน
              _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
                _initializeHealthData();
              });
              isRecordingSleep = true;
              if (mounted) {
                setState(() {}); // อัพเดตสถานะ UI
              }
              // แสดงการแจ้งเตือนเมื่อเริ่มบันทึกการนอน
              print("เริ่มบันทึกการนอน");
              startandstopAlertNotification(
                'เริ่มบันทึกการนอน',
                'คุณมีการบันทึกการนอนขณะนี้.',
              );
            }
          },

          backgroundColor: isRecordingSleep
              ? Colors.red
              : Colors.blue.shade900, // ปรับสีตามสถานะ
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          label: Text(
            isRecordingSleep ? '🤗  หยุดบันทึกการนอน' : '😪 เริ่มบันทึกการนอน',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
