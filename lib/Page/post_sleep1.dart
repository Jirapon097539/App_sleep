import 'package:flutter/material.dart';

class post_sleep1 extends StatelessWidget {
  const post_sleep1({Key? key}) : super(key: key);

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
        title: Text('6 สิ่งที่จะเปลี่ยนไป เมื่อคุณ..“นอนหลับสนิท”'),
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
                'https://www.naturebiotec.com/wp-content/uploads/2019/12/Content-Template-1200x625_%E0%B8%99%E0%B8%AD%E0%B8%99%E0%B8%AB%E0%B8%A5%E0%B8%B1%E0%B8%9A%E0%B8%AA%E0%B8%99%E0%B8%B4%E0%B8%97-1024x533.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.fill,
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
                    'โดย หมอฟ่าง กุลธิกา แป้นพยอม',
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
                      '1. ร่างกายซ่อมแซมได้เต็มที่                                            ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'ขณะนอนหลับ ร่างกายของคนเราจะผลิตโมเลกุลโปรตีนชนิดต่างๆ ที่ช่วยเสริมสร้างความแข็งแรงให้กับระบบภูมิคุ้มกันและซ่อมแซมความสึกหรอที่เกิดจากความเครียดหรือสัมผัสกับสารที่อาจเป็นอันตราย เช่น มลภาวะและแบคทีเรียที่เป็นสาเหตุของโรคติดเชื้อ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
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
                      '2. รักษาสุขภาพหัวใจให้แข็งแรง                                            ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'ระบบเส้นเลือดหัวใจของคนเราอยู่ภายใต้ความกดดันตลอดเวลา ซึ่งการนอนหลับจะช่วยลดระดับความเครียดและการอักเสบของร่างกายของคุณลง การอักเสบในร่างกายมีความเชื่อมโยงกับโรคหัวใจและหลอดเลือดสมองและการนอนหลับสามารถช่วยรักษาความดันโลหิต (ซึ่งมีบทบาทสำคัญต่อการเกิดโรคหัวใจ) ให้ลดลง',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
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
                      '3. ความเครียดลดลง                                            ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'การนอนหลับไม่เพียงช่วยลดความดันโลหิตเท่านั้น แต่ยังลดระดับฮอร์โมนความเครียดที่เพิ่มสูงขึ้นด้วย เช่น คอร์ติซอล ซึ่งมักจะเพิ่มขึ้นเนื่องจากความกดดันในชีวิตและการใช้ชีวิตที่เร่งรีบ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
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
                      '4. ทำให้ความจำ และสมาธิดีขึ้น                                            ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              ' การนอนหลับสนิทช่วยป้องกันปัญหาเหล่านี้ได้เพราะขณะหลับ สมองของคุณจะจัดการและเชื่อมโยงความทรงจำในช่วง 12 ชั่วโมงที่ผ่านมาและความทรงจำก่อนหน้านั้น โดยจะประมวลผลประสบการณ์และข้อเท็จจริงที่คุณได้รับ ทำให้คุณเข้าใจและจดจำเรื่องราวต่างๆ ได้มากขึ้น',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
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
                      '5. ช่วยควบคุมน้ำหนัก                                            ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              ' ไม่ค่อยมีคนทราบว่าการนอนช่วยควบคุมฮอร์โมนต่างๆ ที่มีผลต่อความอยากอาหาร ในปริมาณที่พอดีต่อร่างกาย และยังช่วยเพิ่มประสิทธิภาพในการเผาผลาญของร่างกายอีกด้วย',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
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
                      '6. ควบคุมอารมณ์ได้ดี                                            ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              ' แต่เมื่อนอนไม่พอ หลายคนจะรู้สึกหงุดหงิด หรืออารมณ์เสียในวันรุ่งขึ้น เกิดจากความสับสน และความล้าของร่างกาย ถ้าหากนอนน้อยจนเป็นปัญหาเรื้อรัง ผลการศึกษาชี้ว่าอาจส่งผลให้เกิดปัญหาด้านอารมณ์เรื้อรัง เช่น ซึมเศร้าหรือวิตกกังวลนั่นเอง',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 40),
            Text(
              'cr: https://www.naturebiotec.com/sleep-6-con-20191214/',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
