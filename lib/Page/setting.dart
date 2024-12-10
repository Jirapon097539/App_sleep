// ignore_for_file: unused_import

import 'package:app_login/Page/Dashboard.dart';
import 'package:app_login/Page/Quality_assessment.dart';
import 'package:app_login/Page/Sleep_analysis.dart';
import 'package:app_login/Page/Sleep_tracking.dart';
import 'package:app_login/form_login_signup.dart/Auth.dart';
import 'package:app_login/form_login_signup.dart/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Setting extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  const Setting({super.key, required this.characteristic});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ignore: unused_field
  int _selectedIndex = 0;
  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      return userDoc;
    } else {
      throw Exception("User not signed in");
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildProfileImage(String? imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      placeholder: (context, url) => Image.asset(
        'assets/images/avatar-default.jpg',
        fit: BoxFit.cover,
        width: 50,
        height: 50,
      ),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/avatar-default.jpg',
        fit: BoxFit.cover,
        width: 50,
        height: 50,
      ),
      fit: BoxFit.cover,
      width: 50,
      height: 50,
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ออกจากระบบ'),
          content: const Text('ต้องการออกจากระบบใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                AuthMethods().signOutGoogle();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route route) => false);
              },
              child: const Text('ตกลง'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          key: UniqueKey(),
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text('User data not found');
            }

            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 236, 233, 223),
                            radius: 40,
                            child: ClipOval(
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child:
                                    _buildProfileImage(userData['image_url']),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 40),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userData['name'] ?? '',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          // SingleChildScrollView()
                          Text(userData['email'] ?? ''),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Row(
                    children: [
                      SizedBox(width: 5),
                      Text(
                        "Account",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 35),
                    ],
                  ),
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.account_circle, color: Colors.blue),
                      title: const Text('แก้ไขผู้ใช้งาน'),
                      trailing: const Icon(Icons.navigate_next),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAccount(
                              onRefresh: _refreshSettingPage,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  const Row(
                    children: [
                      // SizedBox(width: 5),
                      // Text(
                      //   "Settings",
                      //   style: TextStyle(
                      //       fontSize: 20, fontWeight: FontWeight.bold),
                      // ),
                      SizedBox(height: 35),
                    ],
                  ),
                  // Card(
                  //   child: ListTile(
                  //     leading:
                  //         const Icon(Icons.notifications, color: Colors.blue),
                  //     title: const Text('แจ้งเตือน'),
                  //     trailing: const Icon(Icons.navigate_next),
                  //     onTap: () {},
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  // Card(
                  //   child: ListTile(
                  //     leading: const Icon(Icons.security, color: Colors.blue),
                  //     title: const Text('คู่มือการใช้งาน'),
                  //     trailing: const Icon(Icons.navigate_next),
                  //     onTap: () {},
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.blue,
                      ),
                      title: const Text('ออกจากระบบ'),
                      trailing: const Icon(Icons.navigate_next),
                      onTap: () {
                        showLogoutConfirmationDialog(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomAppBar(
          color: Colors.blue.shade900,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.dark_mode,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              // IconButton(
              //   icon: const Icon(
              //     Icons.access_alarms,
              //     color: Colors.white,
              //     size: 20,
              //   ),
              //   onPressed: () {
              //     _onItemTapped(3);
              //   },
              // ),
              // IconButton(
              //   icon: const Icon(
              //     Icons.assessment,
              //     color: Colors.white,
              //     size: 20,
              //   ),
              //   onPressed: () {
              //     _onItemTapped(2);
              //   },
              // ),
              IconButton(
                icon: const Icon(
                  Icons.auto_graph,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _onItemTapped(1);
                },
                iconSize: 10,
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _onItemTapped(4);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    characteristic: widget.characteristic,
                  )),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Quality_assessment(
                    characteristic: widget.characteristic,
                  )),
        );
        break;
      case 2:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => Sleep_analysis(
        //             characteristic: widget.characteristic,
        //           )),
        // );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Sleep_tracking(
                    characteristic: widget.characteristic,
                  )),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Setting(
                    characteristic: widget.characteristic,
                  )),
        );
        break;
    }
  }

  void _refreshSettingPage() {
    setState(() {});
  }
}

class EditAccount extends StatefulWidget {
  final VoidCallback? onRefresh;
  const EditAccount({Key? key, this.onRefresh}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _IdLineController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _refreshSettingPage() {
    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUser() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      return userDoc;
    } else {
      throw Exception("User not signed in");
    }
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      return Image.asset(
        'assets/images/avatar-default.jpg',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }

  Future<void> _getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          _nameController.text = userDoc['name'] ?? '';
          _emailController.text = userDoc['email'] ?? '';
          _phoneController.text = userDoc['phone'] ?? '';
          _genderController.text = userDoc['gender'] ?? '';
          _birthdateController.text = userDoc['birthdate'] ?? '';
          _heightController.text = userDoc['height']?.toString() ?? '';
          _weightController.text = userDoc['weight']?.toString() ?? '';
        });
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching user data: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '             แก้ไขข้อมูลส่วนตัว',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          shadowColor: Color.fromARGB(255, 0, 0, 0),
          bottomOpacity: 0.1,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: _getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text('User data not found');
              }

              Map<String, dynamic> userData =
                  snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 236, 233, 223),
                          radius: 70,
                          child: ClipOval(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: _buildImage(userData['image_url']),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Edit_Image(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 66, 146, 211),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _nameController,
                                labelText: 'ชื่อ-สกุล',
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _emailController,
                                labelText: 'อีเมล',
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _phoneController,
                                labelText: 'เบอร์โทรศัพท์',
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _genderController,
                                labelText: 'เพศ',
                              ),
                              const SizedBox(height: 20),
                              _buildDatePickerTextField(
                                controller: _birthdateController,
                                hintText: 'วันเกิด',
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _heightController,
                                labelText: 'ส่วนสูง',
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _weightController,
                                labelText: 'น้ำหนัก',
                              ),
                              const SizedBox(height: 20),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff0b1842),
                                      Color(0xff101cc6)
                                    ],
                                    stops: [0.35, 0.65],
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: _updateUserData,
                                  child: const Center(
                                    child: Text(
                                      "ยืนยันการบันทึก",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        labelStyle: TextStyle(color: Color.fromARGB(255, 54, 50, 49)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 12.0,
        ),
      ),
    );
  }

  Widget _buildDatePickerTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            width: 1.0,
            color: Colors.black,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.red),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 12.0,
        ),
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.black),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            controller.text = formattedDate;
          });
        }
      },
    );
  }

  void _updateUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'gender': _genderController.text,
          'birthdate': _birthdateController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
        });

        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }

        _refreshSettingPage();
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('บันทึกสำเร็จ!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating user data: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class Edit_Image extends StatefulWidget {
  const Edit_Image({Key? key}) : super(key: key);

  @override
  _Edit_ImageState createState() => _Edit_ImageState();
}

class _Edit_ImageState extends State<Edit_Image> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        print('Image picking canceled');
        return;
      }

      setState(() {
        _image = File(pickedFile.path);
        print('Image picked successfully: ${_image!.path}');
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImageToStorage() async {
    if (_image != null && await _image!.exists()) {
      try {
        final String imageUrl = await _uploadToFirebaseStorage();
        await saveImageUrlToFirestore(imageUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<String> _uploadToFirebaseStorage() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String tempFilePath =
          '$tempPath/${DateTime.now().millisecondsSinceEpoch}.png';

      await File(tempFilePath).writeAsBytes(await _image!.readAsBytes());

      final storageReference = FirebaseStorage.instance.ref().child(
            'images_prefile/${DateTime.now().millisecondsSinceEpoch}.png',
          );

      await storageReference.putFile(_image!);

      final String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      rethrow; // Rethrow the error to propagate it to the caller
    }
  }

  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      try {
        final DocumentReference<Map<String, dynamic>> userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        DocumentSnapshot<Map<String, dynamic>> userData = await userDoc.get();

        if (!userData.exists || userData.data()!['image_url'] == null) {
          await userDoc.update({'image_url': imageUrl});
        } else {
          await userDoc.update({
            'image_url': imageUrl,
          });
        }

        setState(() {});
        showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        await Future.delayed(const Duration(milliseconds: 1));
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('อัปโหลดรูปสำเร็จ! กรุณารอสักครู่'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EditAccount()),
        );
      } catch (error) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating image URL: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _showsProfileImage() {
    return _image != null
        ? Image.file(
            _image!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : CachedNetworkImage(
            imageUrl: 'assets/images/avatar-default.jpg',
            placeholder: (context, url) => Image.asset(
              'assets/images/avatar-default.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/avatar-default.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '                    แก้ไขรูปภาพ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        shadowColor: Color.fromARGB(255, 0, 0, 0),
        bottomOpacity: 0.1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            CircleAvatar(
              backgroundColor: Color.fromARGB(255, 236, 233, 223),
              radius: 120,
              child: ClipOval(
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: _showsProfileImage(),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 6, 17, 30),
                    Color.fromRGBO(255, 44, 118, 50),
                  ],
                ),
              ),
              child: TextButton(
                onPressed: _pickImage,
                child: const Center(
                  child: Text(
                    "เลือกรูปภาพ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 6, 17, 30),
                    Color.fromRGBO(255, 44, 118, 50),
                  ],
                ),
              ),
              child: TextButton(
                onPressed: _uploadImageToStorage,
                child: const Center(
                  child: Text(
                    "อัปโหลดรูปภาพ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
