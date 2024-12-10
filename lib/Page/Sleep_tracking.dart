// ignore_for_file: unused_import, unused_field

import 'package:app_login/Page/setting.dart';
import 'package:app_login/Page/sleep_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:app_login/Page/Dashboard.dart';
import 'package:app_login/Page/Quality_assessment.dart';
import 'package:app_login/Page/Sleep_analysis.dart';
import 'package:app_login/Page/Sleep_tracking.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Sleep_tracking extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  Sleep_tracking({Key? key, required this.characteristic}) : super(key: key);

  @override
  State<Sleep_tracking> createState() => _Sleep_trackingState();
}

class _Sleep_trackingState extends State<Sleep_tracking> {
  int _selectedIndex = 0;
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: const Alignment(0.8, 1),
          //       colors: [
          //         Color.fromRGBO(0, 0, 52, 0.875),
          //         Color.fromRGBO(12, 1, 69, 1),
          //       ],
          //     ),
          //   ),
          // ),
          DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: 'สัปดาห์'),
                        Tab(text: 'เดือน'),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(children: [
                  // ส่วนเนื้อหาของแท็บ 'สัปดาห์'
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  setState(() {
                                    now = now.subtract(const Duration(days: 7));
                                  });
                                },
                              ),
                              Text(
                                "${now.day}/${now.month}/${now.year} - ${now.add(const Duration(days: 6)).day}/${now.add(const Duration(days: 6)).month}/${now.add(const Duration(days: 6)).year}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  setState(() {
                                    now = now.add(const Duration(days: 7));
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const SizedBox(
                            width: double.infinity,
                            height: 170.0,
                            child: Card(
                              color: Colors.grey,
                              child: Stack(
                                children: [
                                  // ปุ่มดูข้อมูลเพิ่มเติม

                                  // ข้อความกลางใน Card
                                  Center(
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
                          SizedBox(height: 30),
                          Center(
                            child: Text(
                              "ข้อมูลการนอน",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Text(
                              "คุณมีคุณภาพการนอนทีดี",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ส่วนเนื้อหาของแท็บ 'เดือน'
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "ข้อมูลการนอนของเดือน ${now.month}/${now.year}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        // เพิ่ม Widget ที่ใช้แสดงข้อมูลการนอนตามเดือน ตามที่คุณต้องการ
                        // เช่น GridView, ListView, Chart, ฯลฯ
                      ],
                    ),
                  ),
                ]),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
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
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomAppBar(
          color: Colors.indigo[900],
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
