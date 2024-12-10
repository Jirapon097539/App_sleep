
import 'package:app_login/Page/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Welcome1 extends StatefulWidget {
  const Welcome1({super.key});
  
  get characteristic => null;

  @override
  State<Welcome1> createState() => _Welcome1State();
}

class _Welcome1State extends State<Welcome1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController dateinput = TextEditingController();
  String selectedGender = '';
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _clearData() {
    setState(() {
      dateinput.text = "";
      selectedGender = "";
      weightController.text = "";
      heightController.text = "";
      _phoneController.text = "";
    });
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกเบอร์โทรศัพท์ของคุณ";
    } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
      return "กรุณากรอกเฉพาะตัวเลขเท่านั้น";
    }
    return null;
  }

  Future<void> _saveUserData() async {
    try {
      if (_formKey.currentState!.validate()) {
        User? user = _auth.currentUser;

        if (user != null) {
          // ตรวจสอบว่ามีเอกสารที่ต้องการอัปเดตอยู่จริง
          DocumentSnapshot userDocument = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDocument.exists) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              'birthdate': dateinput.text,
              'gender': selectedGender,
              'weight': int.parse(weightController.text),
              'height': int.parse(heightController.text),
              'phone': _phoneController.text,
              // Add other fields as needed
            });
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              barrierDismissible:
                  false, // Prevents dialog from being dismissed by tapping outside

              builder: (BuildContext context) => AlertDialog(
                title: const Text('บันทึกข้อมูล'),
                content: const Text('คุณได้ทำการบันทึกข้อมูลส่วนตัวสำเร็จ'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Dashboard(characteristic: widget.characteristic,)),
                      );
                    },
                    child: const Text('ตกลง'),
                  ),
                ],
              ),
            );
          } else {
            print('User document does not exist');
          }
        }
      }
    } catch (error) {
      print('Error saving user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? _email = _auth.currentUser!.email;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/Image_4.png",
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "ข้อมูลส่วนตัว ! ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "ผู้ใช้งานชื่อ : $_email",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        "สำรวจข้อมูล สำหรับการประเมินการนอน",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: dateinput,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกวันเกิด';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "วันเกิด?",
                          labelText: "วันเกิด?",
                          prefixIcon: const Icon(Icons.calendar_today,
                              color: Colors.black),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());

                          if (pickedDate != null) {
                            print(pickedDate);
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              dateinput.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'คุณเพศอะไร?',
                          prefixIcon: const Icon(Icons.transgender_sharp,
                              color: Colors.black),
                        ),
                        value: selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณาเลือกเพศ';
                          }
                          return null;
                        },
                        items: <String>['', 'ชาย', 'หญิง', 'อื่นๆ']
                            .map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: value.isEmpty
                                  ? const Text(
                                      'คุณเพศอะไร?',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Text(value),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: weightController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกน้ำหนัก ';
                          } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                            return "กรุณากรอกเฉพาะตัวเลขเท่านั้น";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "น้ำหนักเท่าไหร่?(กิโลกรัม)",
                          labelText: "น้ำหนักเท่าไหร่?(กิโลกรัม)",
                          prefixIcon: const Icon(Icons.monitor_weight_outlined,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: heightController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกส่วนสูง';
                          } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                            return "กรุณากรอกเฉพาะตัวเลขเท่านั้น";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "คุณส่วนสูงเท่าไร?(เซนติเมตร)",
                          labelText: "คุณส่วนสูงเท่าไร?(เซนติเมตร)",
                          prefixIcon: const Icon(Icons.height_outlined,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _phoneController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          labelText: 'เบอร์โทรศัพท์(สำหรับแจ้งเตือน SMS)',
                        ),
                        validator: _validatePhone,
                      ),
                      const SizedBox(
                        height: 60.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _clearData,
                            child: Text(
                              "ล้างข้อมูล",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 220, 0, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: _saveUserData,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                "บันทึกข้อมูล",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
