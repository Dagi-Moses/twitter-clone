import 'dart:io';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/pages/layout%20page.dart';

import '../methods/firebase firestore methods.dart';
import '../pages/allCommentsPage.dart';
import '../pages/commentpage.dart';
import '../pages/home page.dart';
import '../pages/user_profile.dart';
import 'likeAnimation.dart';

class ChatWidget extends StatefulWidget {

  final snap;
  final index;
  final bool isAllcommentsPage;

  ChatWidget({
    super.key,
    required this.snap,
    required this.index,
    required this.isAllcommentsPage,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  void nav (){
    Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: UserProfile(uid: widget.snap['uid'],canEdit: false),));
  }
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
    commentLen = snap.docs.length;
  }

  FirebaseAuth user = FirebaseAuth.instance;

  bool isAnimating = false;
  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 3, left: 8, right: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: AllCommentsPage(widget.snap)));
        },
        child: SizedBox(
          // height: widget.snap['photoUrl'] == '' ? null : 500,
          width: _screenSize.width,
          child: Column(
            children: [
              widget.index == 0
                  ? SizedBox()
                  : Divider(
                      thickness: 1,
                    ),
              SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Icon(
                      FontAwesomeIcons.retweet,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const Text(
                    '   The name of the person that retweeted',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isAllcommentsPage
                      ? SizedBox()
                      :GestureDetector(
                        onTap: (){
                           Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: UserProfile(uid: widget.snap['uid']),));
                        },
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.snap['profile']?? 'https://picsum.photos/200/300'),
                          ),
                      ),
                  Column(
                    children: [
                      Row(
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width:widget.isAllcommentsPage? _screenSize.width- 30: _screenSize.width - 70,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      !widget.isAllcommentsPage
                                          ? SizedBox()
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  widget.snap['profile']),
                                            ),
                                            SizedBox( width:!widget.isAllcommentsPage? 0 :10,),
                                      GestureDetector(
                                        onTap:(){
                                                  Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: UserProfile(uid: widget.snap['uid']),));
                        },
                                        
                                        child: Flex( direction: !widget.isAllcommentsPage? Axis.horizontal: Axis.vertical,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[ 
                                          
                                            Text(
                                                 widget.snap['username'],
                                                style: TextStyle(fontSize: 16)),
                                            Text(
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                                 '@' +
                                                    widget.snap['name'] ),
                                                    !widget.isAllcommentsPage?
                                                    Text(
                                                    ' .' +
                                                    timeago.format(
                                                        widget.snap['time']
                                                            .toDate(),
                                                        locale: 'en',
                                                        allowFromNow: true)): SizedBox(),],),
                                      )
                                       
                                    ]),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          //navigate to te tweet page
                                        },
                                        child: Icon(
                                          Icons.more_horiz,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                widget.snap['tweet'] == null
                                    ? SizedBox()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(widget.snap['tweet'],
                                                maxLines: 20,
                                                style:
                                                    TextStyle(fontSize: 16))),
                                      ),
                                widget.snap['photoUrl'] != ''
                                    ? Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          height: 350,
                                          width: widget.isAllcommentsPage
                                              ? MediaQuery.of(context)
                                                  .size
                                                  .width
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                widget.snap['photoUrl'],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  //  margin: const EdgeInsets.only(top: 8),
                                  width:
                                     widget.isAllcommentsPage ?MediaQuery.of(context).size.width* 0.88:MediaQuery.of(context).size.width * 0.75,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    //  RowItem('8', FontAwesomeIcons.heart),
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            if (!widget.isAllcommentsPage) {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .bottomToTop,
                                                      childCurrent: Layout(),
                                                      duration:
                                                          Duration(seconds: 1),
                                                      child: CommentPage(
                                                        name:
                                                            widget.snap['name'],
                                                        postId: widget
                                                            .snap['postId'],
                                                      )));
                                            }
                                          },
                                          child: SizedBox(
                                            width: 30,
                                            height: 20,
                                            child: RowItem(
                                                commentLen.toString(),
                                                FontAwesomeIcons.message),
                                          )),
                                      RowItem('8', FontAwesomeIcons.retweet),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              likePost(
                                                widget.snap['postId']
                                                    .toString(),
                                                user.currentUser!.uid,
                                                widget.snap['likes'],
                                              );
                                            },
                                            child: LikeAnimation(
                                              isAnimating: widget.snap['likes']
                                                  .contains(
                                                      user.currentUser!.uid),
                                              child: widget.snap['likes']
                                                      .contains(
                                                          user.currentUser!.uid)
                                                  ? const Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                      size: 15,
                                                    )
                                                  : const Icon(
                                                      Icons.favorite_border,
                                                      size: 15,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(widget.snap['likes'].length
                                              .toString()),
                                        ],
                                      ),
                                      RowItem('8', Icons.bar_chart),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget RowItem(String num, IconData icon) {
  return Row(
    children: [
      Icon(
        icon,
        size: 15,
      ),
      const SizedBox(
        width: 6,
      ),
      Text(num)
    ],
  );
}
