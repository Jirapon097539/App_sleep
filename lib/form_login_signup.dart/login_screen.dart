// ignore_for_file: use_build_context_synchronously, prefer_final_fields

// import 'package:app_login/Page/Navigation_Bar.dart';
import 'package:app_login/form_login_signup.dart/Auth.dart';
import 'package:app_login/form_login_signup.dart/Signup.dart';
import 'package:app_login/form_login_signup.dart/forgotPassword.dart';
import 'package:app_login/form_login_signup.dart/information.dart';
import 'package:app_login/main_Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  String _email = "";
  String _password = "";

  void _handleLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print("user Logged In: ${userCredential.user!.email}");

      // Check if the user has additional profile data in Firebase Database
      bool hasProfileData = await checkProfileData(userCredential.user!.uid);

      if (hasProfileData) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: ((context) => AlertDialog(
                    icon: const CircleAvatar(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.check),
                    ),
                    title: const Text("เข้าสู่ระบบสำเร็จ"),
                    content: Text(
                        "    ยินดีต้อนรับ, ${userCredential.user!.email}!"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FlutterBlueApp()),
                            );
                          },
                          child: const Text("ตกลง"))
                    ])));
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) => AlertDialog(
                icon: const CircleAvatar(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.check),
                ),
                title: const Text("เข้าสู่ระบบสำเร็จ"),
                content:
                    Text("   ยินดีต้อนรับ, ${userCredential.user!.email}!"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Welcome1()),
                        );
                      },
                      child: const Text("ตกลง"))
                ],
              )),
        );
      }
    } catch (e) {
      print("Error During Login: $e");
      // Show error alert dialog
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => AlertDialog(
              icon: const CircleAvatar(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                child: Icon(Icons.clear_outlined),
              ),
              title: const Text("กรุณาเข้าสู่ระบบใหม่อีกครั้ง"),
              content: const Text("         อีเมล หรือ รหัสผ่านไม่ถูกต้อง."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: const Text("ตกลง"))
              ],
            )),
      );
    }
  }

  Future<bool> checkProfileData(String userId) async {
    try {
      print("Checking profile data for userId: $userId");
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if the document exists
      if (!userDoc.exists) {
        print("User document not found for userId: $userId");
        return false;
      }

      // Check if the required fields are present in the document
      bool hasGender = userDoc['gender'] != null;
      bool hasWeight = userDoc['weight'] != null;
      bool hasHeight = userDoc['height'] != null;
      bool hasBirthdate = userDoc['birthdate'] != null;

      // Return true if all required fields are present, otherwise false
      return hasGender && hasWeight && hasHeight && hasBirthdate;
    } catch (e) {
      print("Error checking profile data: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "เข้าสู่ระบบ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "โปรดกรอกข้อมูล อีเมล และ รหัสผ่านของคุณ",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: "อีเมล",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "โปรดกรอกอีเมลของคุณ";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: "รหัสผ่าน",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "โปรดกรอกรหัสผ่านของคุณ";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ForgotPassword();
                              },
                            ));
                          },
                          child: const Text(
                            " ลืมรหัสผ่านหรือไม่?      ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.redAccent),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(0, 0, 0, 1),
                            Color.fromRGBO(0, 0, 139, 1),
                          ],
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _handleLogin();
                          }
                        },
                        child: const Center(
                          child: Text(
                            "เข้าสู่ระบบ",
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
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("คุณมีบัญชีผู้ใช้งานหรือไม่ ?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthenticationScreen(),
                          ));
                    },
                    child: const Text(
                      " สมัครสมาชิก",
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
      ),
    );
  }
}
