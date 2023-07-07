import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/methods/firebase%20firestore%20methods.dart';

class FollowBackWidget extends ConsumerStatefulWidget {
  final String? uid;
  FollowBackWidget({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FollowBackWidgetState();
}

class _FollowBackWidgetState extends ConsumerState<FollowBackWidget> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String? name;
  String? username;
  String? profilepic;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final data = await firestore.collection('users').doc(widget.uid).get();
    name = data['name'];
    username = data['username'];
    profilepic = data['profileImage'];
  }

  final userFollowersStreamProvider =
      StreamProvider.family<bool, String>((ref, uid) {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    return firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      final followers = snapshot.data()?['followers'] ?? [];
      return followers.contains(auth.currentUser!.uid);
    });
  });
  @override
  Widget build(BuildContext context) {
    final followerStream = ref.watch(userFollowersStreamProvider(widget.uid!));
    Color color = Colors.white;
    String text = 'Follow Back';
     Color forecolor = Colors.black;
    followerStream.whenData((followerData) {
      if (followerData == true) {
        color = Colors.black;
        text = 'Following';
        forecolor = Colors.white;
      } else {
       Color color = Colors.white;
    String text = 'Follow Back';
     Color forecolor = Colors.black;
      }
    });
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 46.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person,
                color: Colors.blue,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' Followed you',
                            // style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: 100,
                      width: 300,
                      decoration: BoxDecoration(
                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Color.fromARGB(255, 51, 63, 56))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.purpleAccent,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: color,
                                    foregroundColor: forecolor,
                                    
                                    shape: RoundedRectangleBorder(
                                    
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () {
                                  followUser(
                                      auth.currentUser!.uid, widget.uid!);
                                },
                                child: Text(text),
                              ),
                            ],
                          ),
                          Text(name!),
                          Text(
                            '@${username ?? name}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1.5,
        ),
      ],
    );
  }
}
