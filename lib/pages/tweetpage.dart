import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/methods/firebase%20firestore%20methods.dart';
import 'package:twitter_clone/models/utils.dart';
import 'package:twitter_clone/widgets.dart/drawer%20widget.dart';

import '../methods/abstract methods.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TweetPage extends StatefulWidget {
  const TweetPage({super.key});

  @override
  State<TweetPage> createState() => _TweetPageState();
}

class _TweetPageState extends State<TweetPage> {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File ? image ;
  void onPickImages() async {
    image = await pickImage();
    setState(() {});
  }
  double sizedBoxHeight = 40;
  int maxLines = 1;
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();

  }
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserData() async {
  
    DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('user').doc(_auth.currentUser!.uid).get();
         String name = userData.data()?['username'] ?? '' ;
         setState(() {
           username = name;
         });
         return null;
   
}
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    
  }


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(fontSize: 18))),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text('Drafts', style: TextStyle(fontSize: 18))),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              
              onPressed: () async{
                if(image !=null ||_controller.text.isNotEmpty){
                setState(() {
                  isLoading = true;
                });
                await uploadPost(username: username, tweet: _controller.text, file: image!);
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);}
              },
              child: isLoading? Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.blue,)),
              ): Text('Tweet'),
              style: ElevatedButton.styleFrom(
                backgroundColor:  image !=null ||_controller.text.isNotEmpty ? Colors.blue : Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.pink,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_drop_down),
                    label: Text('Public'),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(50))),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.83,
                    //height: 300,
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                                onChanged: (value) {
                                  final lineCount = value.split('\n').length;
                                  for (int i = 1; i <= lineCount; i++) {
                                    setState(() {
                                      sizedBoxHeight += 20.0;
                                    });
                                  }
                                },
                                
                                controller: _controller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Whats happening?',
                                  hintStyle: TextStyle(fontSize: 18),
                                )),
                     
                              image !=null? Padding(
                                padding: const EdgeInsets.only(right:19.0),
                                child: SizedBox(
                                  child: Image.file(
                                    alignment: Alignment.topCenter,
                                    image!
                                   ,

                                   height: 400,
                                   ),
                                ),
                              ):SizedBox(),
                        
                          ],
                        ),
                      ],
                    )),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      container(Icons.explore_outlined, () {}),
                      container(Icons.camera_alt_outlined, () async {
                       onPickImages();
                      }),
                    ],
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.public),
                      label: Text('Everyone can reply')),
                  Divider(
                    thickness: 1.5,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.blue,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.photo_album,
                          color: Colors.blue,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.browse_gallery_rounded,
                          color: Colors.blue,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.sort,
                          color: Colors.blue,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget container(IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.blue,
      ),
    ),
  );
}
