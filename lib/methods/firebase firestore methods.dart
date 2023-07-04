import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../pages/layout page.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
 // Post comment
  Future<String> postComment(String postId, String text, 
      ) async {
    String res = "Some error occurred";
     DocumentSnapshot snap = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
     String name = (snap.data()! as dynamic)['name'];
     String username = (snap.data()! as dynamic)['username'];
     String ? profilePic = (snap.data() as dynamic)?['profileImage'];
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profile': profilePic,
          'name': name,
          'username': username,
          'uid': _auth.currentUser!.uid,
          'photoUrl': '',
          'likes': [],
          'tweet': text,
          'commentId': commentId,
          'time': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(
    String uid,
    String followId
  ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      print(e.toString());
    }
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

Future<void> updateprofile({
  required BuildContext context,
  required String username,
required String location,
required String bio,
required DateTime birthDate,
})async{

try {
  await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      'bio': bio,
      'username': username,
      'dateOfBirth': Timestamp.fromDate(birthDate),
      'location': location,
      
    });
   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Successfully updated Profile'),
      duration: const Duration(seconds: 3),
    ),
  );
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
}}

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

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String?> uploadImageToFirebase(
    {required File file,
    required String childName,
    required String postId,
    required bool isPost}) async {
  Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid).child(postId);
  UploadTask uploadTask = ref.putFile(File(file.path));
  TaskSnapshot snap = await uploadTask;
  String downloadUrl = await snap.ref.getDownloadURL();
  return downloadUrl;
}

Future uploadPost({
  required String username,
  required String name,
  required String tweet,
  required String profilePhoto,
  required File? file,
}) async {
  String postId = Uuid().v1();
  if (file == null && tweet.isNotEmpty) {
    _firestore.collection('posts').doc(postId).set({
      'tweet': tweet,
      'uid': _auth.currentUser!.uid,
      'username': username,
      'name': name,
      'profile': profilePhoto,
      'postId': postId,
'photoUrl':'',
      'time': DateTime.now(),
      'likes': [],
     
    });
  }
 else if (file != null && tweet.isEmpty) {
    String? photoUrl = await uploadImageToFirebase(
        file: file, childName: 'posts', isPost: true, postId: postId);
    _firestore.collection('posts').doc(postId).set({
'tweet': '' ,
      'uid': _auth.currentUser!.uid,
      'username': username,
      'postId': postId,
      'name': name,
      'profile': profilePhoto,
      'photoUrl': photoUrl,
      'time': DateTime.now(),
      'likes': [],
      
    });
  } else {
    String? photoUrl = await uploadImageToFirebase(
        file: file!, childName: 'posts', isPost: true, postId: postId);

    _firestore.collection('posts').doc(postId).set({
      'tweet': tweet,
      'uid': _auth.currentUser!.uid,
      'username': username,
      'name': name,
      'profile': profilePhoto,
      'postId': postId,
      'photoUrl': photoUrl,
      'time': DateTime.now(),
      'likes': [],
     
    });
  }
}
