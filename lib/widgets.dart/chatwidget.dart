import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatWidget extends StatefulWidget {
  String imageurl;
  final String tweet;
  final int likes;
  final int comments;
  final String profilePicUrl;
  ChatWidget(
      {super.key,
      required this.tweet,
      this.imageurl = '',
      required this.profilePicUrl,
      this.likes = 0,
      this.comments = 0});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, left: 8, right: 8),
      child: SizedBox(
        
        height: widget.imageurl == '' ? 135 : 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                  style: TextStyle(color: Colors.grey, ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.profilePicUrl),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(children: [
                          TextSpan(text: 'Username '),
                          TextSpan(
                              style: TextStyle(color: Colors.grey),
                              text: '@Account Name '),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(
                              widget.tweet,
                              maxLines: 20,
                            )),
                      ),
                      widget.imageurl != ''
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                  child: Image.network(
                                widget.imageurl,
                                height: 250,
                                width: MediaQuery.of(context).size.width * 0.74,
                              )),
                            )
                          : SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RowItem('8', FontAwesomeIcons.message),
                            RowItem('8', FontAwesomeIcons.retweet),
                            RowItem('8', FontAwesomeIcons.heart),
                            RowItem('8', Icons.bar_chart),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      //navigate to te tweet page
                    },
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.grey,
                    )),
              ],
            ),
            const Divider(
              thickness: 2,
            ),
          ],
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
        width: 4,
      ),
      Text(num)
    ],
  );
}
