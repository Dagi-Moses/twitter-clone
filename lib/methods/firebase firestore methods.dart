import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../pages/layout page.dart';

Future<void> signUpAndStoreUserData(
    String name,
    String phoneNumber,
    String email,
    String password,
    DateTime dateOfBirth,
    BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'uid': userCredential.user!.uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'dateJoined': DateTime.now(),
      'followers': [],
      'following': [],
    });
    Navigator.push(context,
        PageTransition(type: PageTransitionType.rightToLeft, child: Layout()));
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> signInUser(
    {required String email,
    required String password,
    required BuildContext context}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    Navigator.push(context,
        PageTransition(type: PageTransitionType.rightToLeft, child: Layout()));
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Credential'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> resetPassword(
    {required BuildContext context, required String email}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Reset Email Sent'),
          content: Text(
              'An email with instructions to reset your password has been sent to $email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content:
              Text('Failed to send password reset email. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String?> uploadImageToFirebase(
    {required File file,
    required String childName,
    required bool isPost}) async {
  Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
  UploadTask uploadTask = ref.putFile(File(file.path));
  TaskSnapshot snap = await uploadTask;
  String downloadUrl = await snap.ref.getDownloadURL();
  return downloadUrl;
}

Future uploadPost({
  required String username,
  required String tweet,
  required File? file,
}) async {
  String postId = Uuid().v1();
  if (file == null && tweet.isNotEmpty) {
    _firestore.collection('posts').doc(postId).set({
      'tweet': tweet,
      'uid': _auth.currentUser!.uid,
      'username': username,
      'postId': postId,
//'photoUrl':photoUrl,
      'time': DateTime.now(),
      'likes': [],
      'comments': []
    });
  }
  if (file != null && tweet.isEmpty) {
    String? photoUrl = await uploadImageToFirebase(
        file: file, childName: 'posts', isPost: true);
    _firestore.collection('posts').doc(postId).set({
//'tweet': tweet ,
      'uid': _auth.currentUser!.uid,
      'username': username,
      'postId': postId,
      'photoUrl': photoUrl,
      'time': DateTime.now(),
      'likes': [],
      'comments': []
    });
  } else {
    String? photoUrl = await uploadImageToFirebase(
        file: file!, childName: 'posts', isPost: true);

    _firestore.collection('posts').doc(postId).set({
      'tweet': tweet,
      'uid': _auth.currentUser!.uid,
      'username': username,
      'postId': postId,
      'photoUrl': photoUrl,
      'time': DateTime.now(),
      'likes': [],
      'comments': []
    });
  }
}
