import 'package:flutter/material.dart';

class post_sleep3 extends StatelessWidget {
  const post_sleep3({Key? key}) : super(key: key);

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
        title: Text('สุขภาพการนอนของเราเป็นยังไง?'),
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
                'https://lunio.co.th/wp-content/uploads/2021/12/NOV30-SEO-%E0%B8%AA%E0%B8%B8%E0%B8%82%E0%B8%A0%E0%B8%B2%E0%B8%9E%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B8%99%E0%B8%AD%E0%B8%99%E0%B8%82%E0%B8%AD%E0%B8%87%E0%B9%80%E0%B8%A3%E0%B8%B2%E0%B9%80%E0%B8%9B%E0%B9%87%E0%B8%99%E0%B8%A2%E0%B8%B1%E0%B8%87%E0%B9%84%E0%B8%87-01-1024x513.jpg.webp',
                width: double.infinity,
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
                    'การนอนหลับที่มีคุณภาพดี ไม่ใช่ดูแค่จำนวนชั่วโมงในการนอนเท่านั้น แต่ยังเกี่ยวกับเวลา ความสม่ำเสมอ และคุณภาพในขณะที่เรากำลังหลับใหลด้วย เพราะถึงแม้เราจะนอนหลับพักผ่อนอย่างเพียงพอ แต่หากการนอนนั้นมีคุณภาพต่ำ ก็อาจทำให้ร่างกายของเราได้ประโยชน์จากการนอนได้น้อยอยู่ดี',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Image.network(
                'https://lunio.co.th/wp-content/uploads/2021/12/NOV30-SEO-%E0%B8%AA%E0%B8%B8%E0%B8%82%E0%B8%A0%E0%B8%B2%E0%B8%9E%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B8%99%E0%B8%AD%E0%B8%99%E0%B8%82%E0%B8%AD%E0%B8%87%E0%B9%80%E0%B8%A3%E0%B8%B2%E0%B9%80%E0%B8%9B%E0%B9%87%E0%B8%99%E0%B8%A2%E0%B8%B1%E0%B8%87%E0%B9%84%E0%B8%87-03-1024x513.jpg.webp',
                width: double.infinity,
                height: 200,
                fit: BoxFit.fill,
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
                      '1. หลับเร็วเกินไป                                            ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'การนอนหลับเร็วเกินไปหรือการเผลอหลับไปภายในไม่กี่วินาที เป็นสัญญาณว่าก่อนหน้านี้เรานอนน้อยเกินไป และยังเป็นการนอนที่ไม่มีคุณภาพอีกด้วย ทั้งนี้เราอาจหลับได้เร็วและลึกมากก็จริง แต่นั่นก็เป็นเพราะว่าเรามีหนี้การนอนสะสมอยู่ ร่างกายจึงเกิดความต้องการในการนอนหลับที่สูงตาม',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '2. หลับช้าเกินไป                                            ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'การนอนไม่หลับในตอนกลางคืนก็เป็นปัญหาเช่นกัน เพราะร่างกายมีความต้องการในการนอนหลับน้อยลง ทำให้เวลานอนหลับอาจนอนหลับได้ไม่ลึกและทำให้หลับได้ยากขึ้น อีกทั้งปัจจัยอื่น ๆ อย่างการงีบหลับเมื่อใกล้เวลานอน ก็จะไปทำให้ความต้องการในการนอนลดลงและทำให้หลับยากขึ้น ดังนั้นทางที่ดีควรจัดเวลาเข้านอนและกำหนดเวลางีบหลับในช่วงกลางวันบ้าง เพื่อหลีกเลี่ยงการทำให้นอนหลับยากในตอนกลางคืน',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 40),
            Text(
              'cr: https://lunio.co.th/',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
