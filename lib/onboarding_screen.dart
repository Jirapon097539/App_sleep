import 'dart:async';
import 'package:app_login/form_login_signup.dart/Intro_login_register.dart';
import 'package:app_login/intro_screens/intro_page_0.dart';
import 'package:app_login/intro_screens/intro_page_1.dart';
import 'package:app_login/intro_screens/intro_page_2.dart';
import 'package:app_login/intro_screens/intro_page_3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Timer.periodic(const Duration(seconds: 5), (timer) {
    //   if (!onLastPage) {
    //     _controller.animateToPage(
    //       currentPage + 1,
    //       duration: const Duration(milliseconds: 800),
    //       curve: Curves.easeInOut,
    //     );
    //   } else {
    //     timer.cancel();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage0(),
              IntroPage1(),
              // IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child:
                      const Text("ข้าม", style: TextStyle(color: Colors.white)),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    spacing: 8,
                    radius: 4,
                    dotWidth: 14,
                    dotHeight: 6,
                  ),
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }));
                        },
                        child: const Text("เสร็จสิ้น",
                            style: TextStyle(color: Colors.white)),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text("ถัดไป",
                            style: TextStyle(color: Colors.white)),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
