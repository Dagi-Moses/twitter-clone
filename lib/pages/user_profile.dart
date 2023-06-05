import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/widgets.dart/chatwidget.dart';
import 'package:twitter_clone/widgets.dart/drawer%20widget.dart';

import '../models/utils.dart';

class UserProfile extends ConsumerWidget {
  final List<Widget> tabs = [
   
    Tab(text: 'Tweets'),
    Tab(text: 'Replies'),
    Tab(text: 'Media'),
    Tab(text: 'Likes'),
  ];
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  leading: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.black87,
                          radius: 5,
                          child: Icon(Icons.arrow_back)),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 11.0),
                      child: CircleAvatar(
                          backgroundColor: Colors.black87,
                          radius: 17,
                          child: Icon(Icons.search)),
                    ),
                  ],
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  pinned: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          'https://wallsdesk.com/wp-content/uploads/2016/10/Barry-Allen-High-Definition-Wallpapers.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Positioned(
                        left: 7,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://wallsdesk.com/wp-content/uploads/2016/10/Barry-Allen-High-Definition-Wallpapers.png'),
                          radius: 45,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          'username',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@Dagi_moses',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Took me a week to come up with this bio',
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.grey,
                            ),
                            Text(
                              ' Central city',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(width: 15,),
                            Icon(
                              Icons.pin_drop,
                              size: 20,
                              color: Colors.grey,
                            ),
                            Text(
                              // input the real birth value from firebase
                              ' Born 20 january 2001',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
          
                            Icon(
                              Icons.calendar_month,
                              size: 20,
                              color: Colors.grey,
                            ),
                            Text(
                              // input the real birth value from firebase
                              ' joined 20 january 2001',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
          
                            
                            Text(
                              // input the real birth value from firebase
                              '4,031',
                              style: TextStyle(color: Colors.white, ),
                            ),
                            Text(
                              // input the real birth value from firebase
                              'Following',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(width: 6,),
                            Text(
                              // input the real birth value from firebase
                              '3,652',
                              style: TextStyle(color: Colors.white, ),
                            ),
                            Text(
                              // input the real birth value from firebase
                              'Followers',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),
                       
                        
                        
                      ],
                    ),
                  ),
                ),
                  SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    tabs: tabs,
                    indicatorColor: Colors.blue,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                  ),
                ),
                pinned: true,
              ),
              
              ];
            },
            body: TabBarView(
              children: [
                ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return ChatWidget(tweet: 'tweet', profilePicUrl: 'skdk');
                  },
                ),
                Center(child: Text('replies'),),
                Center(child: Text('Media'),),
                Center(child: Text('Likes'),),
              ],
            )),
      ),
    );
  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height +16;

  @override
  double get maxExtent => _tabBar.preferredSize.height+16;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          _tabBar,
           const Divider(color: Colors.white),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}