import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/select%20photo.dart';

import '../methods/firebase firestore methods.dart';
import '../widgets.dart/chatwidget.dart';
import 'layout page.dart';

class AllCommentsPage extends ConsumerStatefulWidget {
  final snap;
  AllCommentsPage(this.snap, {super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllCommentsPageState();
}

class _AllCommentsPageState extends ConsumerState<AllCommentsPage> {
  TextEditingController _textEditingController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _username = ref.watch(nameProvider);
    final _photo = ref.watch(profileImageUrlProvider);
    return Scaffold(
      body: NestedScrollView(
        //  controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.grey[900],
              elevation: 0,
              floating: true,
              snap: true,
              title: Text(
                'Tweet',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          ];
        },
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.snap['postId'])
                .collection('comments')
                .orderBy('time', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //         if (snapshot.connectionState == ConnectionState.waiting) {
              // return const Center(
              //   child: CircularProgressIndicator(),
              // );
              //  }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.bottom),
                children: [ 
                  ChatWidget(snap: widget.snap, index: 1, isAllcommentsPage: true),
                  ...List.generate(
                  snapshot.data!.docs.length,
                  (index) {
                    final ind = index + 1;
                    DocumentSnapshot document = snapshot.data!.docs[index];

                    return ChatWidget(
                      snap: document,
                      index: 1,
                      isAllcommentsPage: false,
                    );
                  },
                ),],
              );
            }),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(_photo!),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    maxLines: 10,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Tweet your reply',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: ()  async{
                  setState(() {
                    _isLoading = true;
                  });
                  FocusScope.of(context).unfocus();
                 
                 await postComment(
                  widget.snap['postId'],
                  _textEditingController.text,
                
                );
                 _textEditingController.clear();
                   setState(() {
                    _isLoading = false;
                  });
                },
                child: Container(
                  padding:
                       EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: _isLoading?SizedBox(height: 15, width:15, child:CircularProgressIndicator()):Text(
                    'Tweet',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  } 
}
