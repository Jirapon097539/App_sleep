// ignore_for_file: unused_import, unused_field

import 'package:app_login/Page/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:app_login/Page/Dashboard.dart';
import 'package:app_login/Page/Quality_assessment.dart';
import 'package:app_login/Page/Sleep_analysis.dart';
import 'package:app_login/Page/Sleep_tracking.dart';

class Sleep_analysis extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  Sleep_analysis({Key? key, required this.characteristic}) : super(key: key);

  @override
  State<Sleep_analysis> createState() => _Sleep_analysisState();
}

class _Sleep_analysisState extends State<Sleep_analysis> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Text(
                  "วิเคราะห์การนอน",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  "คแนนคุณภาพการนอน _______/21",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  "คุณมีคุณภาพการนอนทีดี",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 170.0,
                child: Card(
                  color: Colors.grey,
                  child: Stack(
                    children: [
                      // ปุ่มดูข้อมูลเพิ่มเติม
                      Positioned(
                        bottom: 10,
                        left: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            // โค้ดเมื่อกดปุ่ม
                          },
                          child: const Text(
                            'เพิ่มเติม >>',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // ข้อความกลางใน Card
                      const Center(
                        child: Text(
                          'ข้อมูลแต่ละอาทิตย์',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 170.0,
                child: Card(
                  color: Colors.grey,
                  child: Stack(
                    children: [
                      // ปุ่มดูข้อมูลเพิ่มเติม
                      Positioned(
                        bottom: 10,
                        left: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            // โค้ดเมื่อกดปุ่ม
                          },
                          child: const Text(
                            'เพิ่มเติม >>',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // ข้อความกลางใน Card
                      const Center(
                        child: Text(
                          'ข้อมูลแต่ละอาทิตย์',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 170.0,
                child: Card(
                  color: Colors.grey,
                  child: Stack(
                    children: [
                      // ปุ่มดูข้อมูลเพิ่มเติม
                      Positioned(
                        bottom: 10,
                        left: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            // โค้ดเมื่อกดปุ่ม
                          },
                          child: const Text(
                            'เพิ่มเติม >>',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // ข้อความกลางใน Card
                      const Center(
                        child: Text(
                          'ข้อมูลแต่ละอาทิตย์',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 170.0,
                child: Card(
                  color: Colors.grey,
                  child: Stack(
                    children: [
                      // ปุ่มดูข้อมูลเพิ่มเติม
                      Positioned(
                        bottom: 10,
                        left: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            // โค้ดเมื่อกดปุ่ม
                          },
                          child: const Text(
                            'เพิ่มเติม >>',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // ข้อความกลางใน Card
                      const Center(
                        child: Text(
                          'ข้อมูลแต่ละอาทิตย์',
                          style: TextStyle(
                            color: Colors.white,
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
              IconButton(
                icon: const Icon(
                  Icons.access_alarms,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _onItemTapped(3);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.assessment,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _onItemTapped(2);
                },
              ),
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
    setState(() {
      _selectedIndex = index;
    });

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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Sleep_analysis(
                    characteristic: widget.characteristic,
                  )),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Sleep_tracking(
                    characteristic: widget.characteristic,
                  )),
        );
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
