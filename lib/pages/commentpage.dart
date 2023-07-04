import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/methods/abstract%20methods.dart';
import 'package:twitter_clone/methods/firebase%20firestore%20methods.dart';
import 'package:twitter_clone/pages/layout%20page.dart';
import 'package:twitter_clone/pages/select%20photo.dart';
import 'package:twitter_clone/pages/tweetpage.dart';

class CommentPage extends ConsumerStatefulWidget {
  final name;
  final String postId;
  CommentPage({
    super.key,
    required this.name,
    required this.postId,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentPageState();
}

class _CommentPageState extends ConsumerState<CommentPage> {
 
  File? file;
  final _isFilledProvider = StateProvider((ref) => false);
  final _isload = StateProvider((ref) => false);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _isFilled = ref.watch(_isFilledProvider);
    final _isLoading = ref.watch(_isload);
    final _image = ref.watch(profileImageUrlProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 13, right: 8, bottom: 8),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _controller.text.isNotEmpty
                      ? Colors.blue
                      : Colors.grey[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: ()async {
                  ref.read(_isload.notifier).state = true;
                  if(_controller.text.isNotEmpty){
                  await postComment(widget.postId, _controller.text);
                  Navigator.pop(context);
                   ref.read(_isload.notifier).state = false;}
                    ref.read(_isload.notifier).state = false;
                },
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text('Tweet')),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: screenSize!.height,
          width: screenSize!.width,
          child: Stack(
            children: [
              Column(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 30,
                              width: 2,
                              color: Colors.grey[600],
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  NetworkImage(_image??'https://picsum.photos/200/300'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(text: 'Replying to '),
                              TextSpan(
                                style: TextStyle(color: Colors.blue),
                                text: '@' + widget.name,
                              ),
                            ])),
                            SizedBox(width: 16.0),
                            Container(
 constraints: BoxConstraints(maxWidth: 300.0), 
                              child: TextField(
                                onChanged: (val){
                            ref.read(_isFilledProvider.notifier).state =  val.isNotEmpty;
                                },
                                controller: _controller,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: 'Tweet your reply',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          
                          ],
                        ),
                      ),
                    ],
                  ),
                    file != null ? Container(
                      constraints: BoxConstraints(maxHeight: 350),
                      child: Image.file(file!, height: 350,)):SizedBox(),
                ],
              ),
             
              Positioned(
                bottom: 0,
                child: Container(
                  width: screenSize!.width,
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Divider(
                      
                      height: 2, color:Colors.grey[700],),
                     IconButton(onPressed: ()async{
                       file = await pickImage();
                     }, icon: Icon(FontAwesomeIcons.image, color: Colors.blue, size: 18,)),

                  
                   ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
