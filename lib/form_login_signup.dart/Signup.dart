// ignore_for_file: use_build_context_synchronously

import 'package:app_login/form_login_signup.dart/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    try {
      if (_formKey.currentState!.validate()) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await userCredential.user!.updateDisplayName(_nameController.text);

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
        });
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) => AlertDialog(
                contentPadding: const EdgeInsets.fromLTRB(
                    20.0, 20.0, 20.0, 0.0), // ปรับขนาดตามต้องการ
                insetPadding: const EdgeInsets.all(20.0), // ปรับขนาดตามต้องการ
                title: const Text("สมัครสมาชิกสำเร็จ"),
                content: Text(
                  " ${userCredential.user!.email}!",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text("เข้าสู่ระบบ"),
                  ),
                ],
              )),
        );
      }
    } catch (e) {
      print('Registration error: $e');

      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: const Text("สมัครสมาชิกไม่สำเร็จ"),
      //       content: Text(
      //         "อีเมลนี้มีการสมัครใช้งานไปแล้ว กรุณาเข้าสู่ระบบ",
      //         textAlign: TextAlign.center,
      //       ),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop(); // Close the error dialog
      //           },
      //           child: const Text("ตกลง"),
      //         ),
      //       ],
      //     );
      // },
      // );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "โปรดกรอกอีเมลของคุณ";
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return "รูปแบบอีเมบไม่ถูกต้อง";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "โปรดกรอกรหัสผ่านของคุณ";
    } else if (value.length < 6) {
      return "รหัสผ่านต้องมากกว่า 6 ตัว";
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "โปรดกรอกชื่อของคุณ";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "โปรดยืนยันรหัสผ่านของคุณ";
    } else if (value != _passwordController.text) {
      return "รหัสผ่านกับการยืนยันรหัสผ่านไม่ต้องกัน";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: Center(
                      child: Lottie.asset(
                          "assets/animations/Animation_stars.json",
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.fill)),
                ),
              ]),
              const SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "สมัครสมาชิก",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "โปรดกรอกข้อมูล สมัครสมาชิก",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(height: 35),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: 'ชื่อผู้ใช้งาน',
                      ),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: "อีเมล",
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: 'รหัสผ่าน',
                      ),
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: 'ยืนยันรหัสผ่าน',
                      ),
                      obscureText: true,
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 25),
                    Column(
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(0, 0, 0, 1),
                                Color.fromRGBO(0, 0, 139, 1),
                              ],
                            ),
                          ),
                          child: TextButton(
                            onPressed: _register,
                            child: const Center(
                              child: Text(
                                "สมัครสมาชิก",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("คุณมีบัญชีผู้ใช้อยู่แล้วหรือไม่ ?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                          child: const Text(
                            " เข้าสู่ระบบ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.redAccent),
                          ),
                        )
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
