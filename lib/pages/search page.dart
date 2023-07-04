import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/select%20photo.dart';

import '../widgets.dart/chatwidget.dart';
import 'layout page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  TextEditingController _controller = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    String? profileImage = ref.watch(profileImageUrlProvider);
    bool isDrawerOpen = ref.watch(isDrawerOpenProvider);
    return Scaffold(
      backgroundColor: isDrawerOpen ? Colors.grey[900] : Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey[900],
            leading: Padding(
              padding: EdgeInsets.only(left: 8, bottom: 5, right: 8, top: 5),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  profileImage ?? 'https://picsum.photos/200/300',
                ),
              ),
            ),
            title: SizedBox(
              height: 40,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 70),
                    filled: true,
                    fillColor: Colors.grey[850],
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search Twitter',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.settings_outlined)),
              ),
            ],
          ),
          SliverFillRemaining(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where(

                      'tweet',
                      isGreaterThanOrEqualTo: _controller.text,
                    )
                    
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return const Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  // }
                  //  if (!snapshot.hasData) {

                  // }
                  if (snapshot.hasData && _controller.text.isNotEmpty) {
                    return ListView(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.bottom),
                        children:
                            List.generate(snapshot.data!.docs.length, (index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];

                          return ChatWidget(
                            snap: document,
                            index: index,
                            isAllcommentsPage: false,
                          );
                        }));
                  }
                    return Center(
                            child: Text(' Search Tweets', style: TextStyle(fontWeight: FontWeight.bold),),
                          );
                }),
          ),
        ],
      ),
    );
  }
}
