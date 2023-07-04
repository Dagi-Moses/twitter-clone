import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../pages/chatpage.dart';
import '../pages/select photo.dart';

class InboxWidget extends ConsumerStatefulWidget {
  final snap;
  InboxWidget({super.key, required this.snap});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InboxWidgetState();
}

class _InboxWidgetState extends ConsumerState<InboxWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
   String? chatId;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _messageSubscription;
String lastMessage = '';
  @override
  void initState() {
    super.initState();
 
    
    Future.delayed(Duration(seconds: 5), (){
preview();
    });
  }

   String getChatId(String userId1, String userId2) {
    // Generate a unique chat ID based on the two user IDs
    return (userId1.hashCode <= userId2.hashCode)
        ? '$userId1-$userId2'
        : '$userId2-$userId1';
  }
  preview()
  {
    chatId = getChatId(currentUserId, widget.snap['uid']);
    _messageSubscription = FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .limit(1)
      .snapshots()
      .listen((QuerySnapshot snapshot) {
    if (snapshot.docs.isNotEmpty) {
      final lastMessageData = snapshot.docs.last.data() as Map<String, dynamic>;
      if (lastMessageData.containsKey('text')) {
        String messageContent = lastMessageData['text'];
        setState(() {
          lastMessage = messageContent;
        });
      } else {
        setState(() {
          lastMessage = '';
        });
      }
    } else {
      setState(() {
        lastMessage = '';
      });
    }
  }) ;
  }
  

  @override
  Widget build(BuildContext context) {
    final _profile = ref.watch(profileImageUrlProvider);
    return ListTile(
      
    leading: CircleAvatar(
      backgroundImage: NetworkImage(widget.snap['profileImage']),
    ),

    title: RichText(
        text: TextSpan(
            style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 15),
            children: [
          TextSpan(
            text: widget.snap['name'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '@' + widget.snap['name'] + '',
            style: TextStyle(color: Color.fromARGB(255, 75, 69, 69)),
          ),
          TextSpan(
              text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              style: TextStyle(color: Colors.grey[600])),
        ])),
    subtitle: Text(lastMessage),
    // trailing: Text(),
    onTap: () {
        Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: ChatScreen(
                snap: widget.snap, chatId: chatId,
               // chatId: chatId,
              ),
            ));
    },
  );
  }
}

