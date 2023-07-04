import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import'package:intl/intl.dart';

import '../widgets.dart/messagetile.dart';

Size? screenSize;

class ChatScreen extends StatefulWidget {
  final snap;
 final chatId;

  ChatScreen({required this.snap, 
  required this.chatId
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String currentUserId;
   String? chatId;
  
  TextEditingController _messageController = TextEditingController();
  bool _isTextEmpty = true;
  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser!.uid;
   
    chatId = widget.chatId;
    
    _messageController.addListener(_checkTextEmpty);
  }
void _checkTextEmpty() {
    setState(() {
      _isTextEmpty = _messageController.text.isEmpty;
    });
  }
 

 
  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isNotEmpty) {
      try {
        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .add({
          'senderId': currentUserId,
          'text': messageText,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _messageController.clear();
      } catch (e) {
        // Handle the error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CircleAvatar(
          backgroundImage: NetworkImage(widget.snap['profileImage']),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0, top: 5),
              child: Text(
                widget.snap['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                       var message = messages[index];

  
//  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

 
 // String formattedTimestamp = dateFormat.format(timestamp);

                 
                    return MessageTile(message: message['text'], sendByMe: message['senderId'] == _auth.currentUser!.uid, time:DateFormat.jm().format(message['timestamp'].toDate()) ,);
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                controller: _messageController,
                decoration: InputDecoration(
                  suffix:  !_isTextEmpty? GestureDetector(
                    onTap: () => sendMessage(_messageController.text),
                    child: CircleAvatar(
                    
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.send, color: Colors.white,)),
                  ): SizedBox(),
                  filled: true,
                  fillColor: Colors.grey[900],
                  hintText: 'Type a message',
                  hintStyle: TextStyle(),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
