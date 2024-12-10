import 'package:app_login/form_login_signup.dart/information.dart';
import 'package:app_login/main_Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  Future<void> signOutGoogle() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    Map<String, dynamic> userInfoMap = {
      "email": userDetails!.email,
      "name": userDetails.displayName,
      "imgUrl": userDetails.photoURL,
      "id": userDetails.uid
    };
    await DatabaseMethods().addUser(context, userDetails.uid, userInfoMap);
    bool hasProfileData =
        await DatabaseMethods().checkProfileData(userDetails.uid);
    if (hasProfileData) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FlutterBlueApp()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Welcome1()));
    }
  }
}

class DatabaseMethods {
  Future<void> addUser(BuildContext context, String userId,
      Map<String, dynamic> userInfoMap) async {
    try {
      // ตรวจสอบว่ามีผู้ใช้ในฐานข้อมูลหรือไม่
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // ถ้ามีผู้ใช้ในฐานข้อมูลแล้ว ให้อัปเดตข้อมูล
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .update(userInfoMap);
        print("User profile updated successfully");
        // แสดง Dialog เมื่ออัปเดตข้อมูลผู้ใช้สำเร็จ
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('เข้าสู่ระบบสำเร็จ'),
            content: const Text('ยินดีต้อนรับ ขอให้โชคดีกับการนอน!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // ถ้ายังไม่มีผู้ใช้ในฐานข้อมูล ให้เพิ่มข้อมูลใหม่
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .set(userInfoMap);
        print("User added successfully");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('เข้าสู่ระบบสำเร็จ'),
            content: const Text('ยินดีต้อนรับ ขอให้โชคดีกับการนอน!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error adding/updating user: $e");
      // จัดการข้อผิดพลาดหากเกิดข้อผิดพลาดในการเพิ่ม/อัปเดตข้อมูล
    }
  }

  Future<bool> checkProfileData(String userId) async {
    try {
      print("Checking profile data for userId: $userId");

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      // Check if the document exists
      if (!userDoc.exists) {
        print("User document not found for userId: $userId");
        return false;
      }

      // Check if the required fields exist in the document
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      bool hasRequiredFields = userData != null &&
          userData.containsKey('gender') &&
          userData.containsKey('weight') &&
          userData.containsKey('height') &&
          userData.containsKey('birthdate') &&
          userData.containsKey('IdLine') &&
          userData.containsKey('phone');

      return hasRequiredFields;
    } catch (e) {
      print("Error checking profile data: $e");
      return false;
    }
  }
}
