import 'package:flutter/material.dart';

class post_sleep2 extends StatelessWidget {
  const post_sleep2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('5 คุณประโยชน์ของการนอนที่ดี'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Card สำหรับรูปภาพ
            Card(
              elevation: 5,
              child: Image.network(
                'https://www.gj.mahidol.ac.th/main/wp-content/uploads/2023/03/%E0%B8%9B%E0%B8%81-Web-1024x726.png',
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            // เนื้อหา
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'โดย นพ. นพดล ตรีประทีปศิลป์ และ พญ. ศิริลักษณ์ ผลศิริปฐม (หน่วยโรคจากการนอนหลับ แผนกโสตนาสิกลาริงซ์)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '1. สมองและความจำสามารถทำงานได้อย่างมีประสิทธิภาพ  (Improve attention, concentration, learning and make memories)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '2. ช่วยพัฒนาสภาวะทางอารมณ์และความสัมพันธ์กับบุคคลรอบข้าง (Mood and relationship improvement)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '3. หัวใจที่แข็งแรง (Healthier heart)                                            ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '4. ช่วยควบคุมน้ำหนักและระดับน้ำตาล  (Maintain healthy weight and regulate blood sugar)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '5. เสริมสร้างภูมิคุ้มกัน (Germ fighting and immune enhancement)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'cr: https://www.gj.mahidol.ac.th/main/knowledge-2/surprising-reasons-to-get-more-sleep/',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
