import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 13, 144),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: [
              Color.fromRGBO(0, 0, 52, 0.875),
              Color.fromRGBO(12, 1, 69, 1),
              Color.fromRGBO(0, 0, 0, 0.808),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 70.0),
                          child: Text(
                            "ยินดีตอนรับสู่การประเมิน           คุณภาพการนอน",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        Stack(children: [
                          Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: Lottie.asset(
                                  "assets/animations/welcome_1.json"),
                            ),
                          ),
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Text(
                                "มีปัญหาการนอนหลับ ? ไม่ต้องกังวล !",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
