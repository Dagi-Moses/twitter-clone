import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/select%20photo.dart';

import '../widgets.dart/inboxwidget.dart';

import 'layout page.dart';

class InboxPage extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const InboxPage({super.key});

  @override
  ConsumerState<InboxPage> createState() => _InboxPageState();
  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight,
      );
}

class _InboxPageState extends ConsumerState<InboxPage> {
  TextEditingController _controller = TextEditingController();
  Size? screenSize;
  @override
  Widget build(BuildContext context) {
    String? profileImage = ref.watch(profileImageUrlProvider);
    screenSize = MediaQuery.of(context).size;
    bool isDrawerOpen = ref.watch(isDrawerOpenProvider);
    return Scaffold(
      backgroundColor: isDrawerOpen ? Colors.grey[900] : Colors.black,
      body: CustomScrollView(
        // controller: _scrollController,
        slivers: [
          SliverAppBar(
            toolbarHeight: 70,
            backgroundColor: Colors.grey[900],
            floating: true,
            pinned: false,
            centerTitle: true,
            //  toolbarHeight: _appBarHeight,
            leading: Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage(
                  profileImage ?? 'https://picsum.photos/200/300',
                ),
              ),
            ),
            title: const Text('Messages'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined)),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Container(
                // margin: EdgeInsets.only(top: 9),
                color: isDrawerOpen ? Colors.grey[900] : Colors.black,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 70),
                            filled: true,
                            fillColor: Colors.grey[850],
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search Direct Messages',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30))),
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              height: screenSize!.height,
              width: screenSize!.width,
              child: StreamBuilder(
                  stream: _controller.text.isEmpty
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('users')
                          .where(
                            'name',
                            isGreaterThanOrEqualTo: _controller.text,
                          )
                          .snapshots(),
                  builder: (context, snapshot) {
                    final users = snapshot.data!.docs;
                      
                          
                  return Column(
                      
                        // padding: EdgeInsets.only(
                        //     top: MediaQuery.of(context).padding.bottom),
                        children:
                            List.generate(snapshot.data!.docs.length, (index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];

                          return InboxWidget(snap: document);
                        }));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
