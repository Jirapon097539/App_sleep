import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
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
              Color(
                  0xFF001C85), // Equivalent to Color.fromRGBO(0, 0, 52, 0.875)
              Color(0xFF0C0145), // Equivalent to Color.fromRGBO(12, 1, 69, 1)
              Color(0xD1000000), // Equivalent to Color.fromRGBO(0, 0, 0, 0.808)
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
                          height: 35,
                        ),
                        Stack(children: [
                          Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: Lottie.asset(
                                  "assets/animations/animation_2.json",
                                  width: 350),
                            ),
                          ),
                        ]),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Text(
                            "ติดตามการนอน        ด้วยตนเอง",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "ติดตามการนอน เพื่อให้ทราบเกี่ยวกับภาวะการนอน",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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
