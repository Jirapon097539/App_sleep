import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Quality_assessment extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  Quality_assessment({Key? key, required this.characteristic})
      : super(key: key);

  @override
  State<Quality_assessment> createState() => _Quality_assessmentState();
}

class _Quality_assessmentState extends State<Quality_assessment> {
  List<Map<String, dynamic>> assessmentQuestions = [
    {
      'question': ' นอนไม่หลับหลังจากเข้านอนไปแล้วนานกว่า 30 นาที ?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question':
          'รู้สึกตัวตื่นขึ้นระหว่างนอนหลับกลางดึก หรือตื่นเช้ากว่าเวลาที่ตั้งใจไว้ ?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question': 'ตื่นเพื่อไปห้องน้ำ?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question': 'หายใจไม่สะดวก ?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question': 'ไอ หรือ กรน เสียงดัง?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question': 'รู้สึกหนาวเกินไป ?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question': 'รู้สึกร้อนเกินไป?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question': 'ฝันร้าย?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question': 'รู้สึกปวดตัว?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question':
          'ในช่วงระยะเวลา 1 เดือนที่ผ่านมา  ท่านคิดว่าคุณภาพการนอนหลับโดยรวมของท่านเป็นอย่างไร?',
      'options': ['ดีมาก', 'ค่อนข้างดี', 'ค่อนข้างแย่', 'แย่มาก']
    },
    {
      'question':
          ' ในช่วงระยะเวลา 1 เดือนที่ผ่านมา  ท่านใช้ยเพื่อช่วยในการนอนหลับ  บ่อยเพียงใด  (ไม่ว่าจะตามใบสั่งแพทย์ หรือ หาซื้อมากินเอง) ?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question':
          ' ในช่วงระยะเวลา 1 เดือนที่ผ่านมา  ท่านมีปัญหาง่วงนอนหรือเผลอหลับ ขณะขับขี่ยานพาหนะ, ขณะรับประทาน อาหาร หรือขณะเข้าร่วมกิจกรรมทำงสังคมต่างๆ  บ่อยเพียงใด ?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
    {
      'question':
          ' ในช่วงระยะเวลา 1 เดือนที่ผ่านมา  ท่านมีปัญหาเกี่ยวกับความกระตือรือร้นในการทำงานให้สำเร็จมากน้อย เพียงใด ?',
      'options': [
        'ไม่เคยเลยในช่วงระยะเวลา 1 เดือนที่ผ่านมา ',
        'น้อยกว่า 1 ครั้งต่อสัปดาห์ ',
        '1-2 ครั้งต่อสัปดาห์',
        '3 ครั้งต่อสัปดาห์ขึ้นไป'
      ]
    },
  ];

  Map<int, dynamic> selectedOptions = {};

  void selectOption(int questionIndex, dynamic option) {
    setState(() {
      selectedOptions[questionIndex] = option;
    });
  }

  Future<void> addAssessmentData(
      int totalScore, List<Map<String, dynamic>> assessmentQuestions) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DateTime now = DateTime.now();
        String date = '${now.year}-${now.month}-${now.day}';
        CollectionReference assessmentCollection = FirebaseFirestore.instance
            .collection('assessment')
            .doc(user.uid)
            .collection('assessment_details');
        await assessmentCollection.doc(date).set({
          'total_score': totalScore,
          'date': date,
          'questions': assessmentQuestions
              .map((question) => {
                    'question': question['question'],
                    'answer':
                        selectedOptions[assessmentQuestions.indexOf(question)],
                  })
              .toList(),
        });
        print('Assessment data added successfully!');
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error adding assessment data: $e');
    }
  }

  int calculateScore() {
    int totalScore = 0;
    selectedOptions.forEach((key, value) {
      if (value == assessmentQuestions[key]['options'][0]) {
        totalScore += 5;
      } else if (value == assessmentQuestions[key]['options'][1]) {
        totalScore += 4;
      } else if (value == assessmentQuestions[key]['options'][2]) {
        totalScore += 3;
      } else if (value == assessmentQuestions[key]['options'][3]) {
        totalScore += 2;
      } else if (value == assessmentQuestions[key]['options'][4]) {
        totalScore += 1;
      }
    });
    return totalScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Assessment'),
      ),
      body: ListView.builder(
        itemCount: assessmentQuestions.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${index + 1}: ${assessmentQuestions[index]['question']}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        assessmentQuestions[index]['options'].length,
                        (optionIndex) {
                      return RadioListTile(
                        title: Text(
                            assessmentQuestions[index]['options'][optionIndex]),
                        value: assessmentQuestions[index]['options']
                            [optionIndex],
                        groupValue: selectedOptions.containsKey(index)
                            ? selectedOptions[index]
                            : null,
                        onChanged: (value) {
                          selectOption(index, value);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int totalScore = calculateScore();
          addAssessmentData(totalScore, assessmentQuestions);

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // title: Text('คะแนนรวม: $totalScore'),
                content: Text('ขอบคุณที่ทำแบบประเมิน '),
                contentPadding: EdgeInsets.fromLTRB(
                    24.0, 20.0, 24.0, 0.0), // Adjust content padding

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ปิด'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
