import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_clone/pages/select%20photo.dart';
import 'package:twitter_clone/widgets.dart/chatwidget.dart';
import 'package:twitter_clone/widgets.dart/drawer%20widget.dart';
import 'package:twitter_clone/widgets.dart/editprofile%20bottom%20sheet.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../methods/firebase firestore methods.dart';
import '../models/utils.dart';
import 'layout page.dart';

class UserProfile extends ConsumerStatefulWidget {
  final String uid;
  final bool canEdit;

  UserProfile({
    required this.uid,
    this.canEdit = false,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileState();
}
final followersProvider = StateProvider<int>((ref) => 0);
final followingProvider = StateProvider<int>((ref) => 0);
final isfollowingProvider = StateProvider<bool>((ref) => false);
class _UserProfileState extends ConsumerState<UserProfile> {
  var userData = {};
  var postSnap;
  int postLen = 0;
  int? following;
  int? followers;
  bool? isFollowing;
 


  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getData() {
  var userRef = FirebaseFirestore.instance.collection('users').doc(widget.uid);

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream =
      userRef.snapshots();

  userStream.listen((userSnap) async{
    postSnap = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    postLen = postSnap.docs.length;
    userData = userSnap.data()!;
    ref.read(followersProvider.notifier).state =
        userSnap.data()!['followers'].length;
    ref.read(followingProvider.notifier).state =
        userSnap.data()!['following'].length;
    ref.read(isfollowingProvider.notifier).state = userSnap
        .data()!['followers']
        .contains(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
  });

  return userStream;
}
  final List<Widget> tabs = [
    const Tab(text: 'Tweets'),
    const Tab(text: 'Replies'),
    const Tab(text: 'Likes'),
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
     followers  = ref.watch(followersProvider);
     following  = ref.watch(followingProvider);
     isFollowing  = ref.watch(isfollowingProvider);
  
 
    return DefaultTabController(
      length: 3,
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
                      child: const CircleAvatar(
                          backgroundColor: Colors.black87,
                          radius: 5,
                          child: Icon(Icons.arrow_back)),
                    ),
                  ),
                  actions: const [
                    Padding(
                      padding: EdgeInsets.only(right: 11.0),
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
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectPhoto(
                                  isProfilePhoto: false,
                                ),
                                //  fullscreenDialog: true,
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'coverImage',
                            transitionOnUserGestures: true,
                            child: userData['coverImage'] != null
                                ? Image.network(
                                    userData['coverImage'],
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 150,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 7,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectPhoto(
                                  isProfilePhoto: true,
                                ),
                                //  fullscreenDialog: true,
                              ),
                            );
                          },
                          child: Hero(
                            transitionOnUserGestures: true,
                            tag: 'profileImage',
                            child: userData['profileImage'] != null
                                ? ClipOval(
                                    child: Image.network(
                                      userData['profileImage'],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 10,
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                    )),
                          ),
                        ),
                        height: 100,
                        width: 100,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {
                            if(FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid){
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: const EditProfileBottom()));}else{
                                      followUser(
        FirebaseAuth.instance.currentUser!.uid,
        widget.uid                                
                                      );
                                    }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          child:  FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid ?Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ):isFollowing!? Text(
                            'UnFollow',
                            style: TextStyle(
                              color: Colors.white,)
                            ):Text(
                            'Follow',
                            style: TextStyle(
                              color: Colors.white,),),
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
                          userData['username'] ?? userData['name'],
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData['name'],
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          userData['bio'] ?? 'On Twitter',
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.grey,
                            ),
                            Text(
                              userData['location'] ?? 'No location',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Icon(
                              Icons.pin_drop,
                              size: 20,
                              color: Colors.grey,
                            ),
                            Text(
                              // input the real birth value from firebase
                              ' Born ${DateFormat('dd MMMM yyyy').format(userData['dateOfBirth'].toDate())}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              size: 20,
                              color: Colors.grey,
                            ),
                            Text(
                              // input the real birth value from firebase
                              ' joined  ${DateFormat('dd MMMM yyyy').format(userData['dateJoined'].toDate())}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              // input the real birth value from firebase
                              following.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              // input the real birth value from firebase
                              'Following',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              // input the real birth value from firebase
                              followers.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
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
               // .orderBy('time', descending: true)
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid',
                            isEqualTo: widget.uid, )
                            
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text('No Tweets '),
                        );
                      }
                      return ListView(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.bottom),
                          children: List.generate(snapshot.data!.docs.length,
                              (index) {
                            DocumentSnapshot document =
                                snapshot.data!.docs[index];

                            return ChatWidget(
                              snap: document,
                              index: index,
                              isAllcommentsPage: false,
                            );
                          }));
                    }),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                         .doc().collection('comments')
                        .where('uid',
                          isEqualTo: widget.uid, )
                            
                       
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text('No Tweets '),
                        );
                      }
                      return ListView(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.bottom),
                          children: List.generate(snapshot.data!.docs.length,
                              (index) {
                            DocumentSnapshot document =
                                snapshot.data!.docs[index];

                            return ChatWidget(
                              snap: document,
                              index: index,
                              isAllcommentsPage: false,
                            );
                          }));
                    }),
                
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                         .where('likes',
                          arrayContains: widget.uid, )
                            
                            
                        .snapshots(),
   
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text('No Tweets '),
                        );
                      }
                      return ListView(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.bottom),
                          children: List.generate(snapshot.data!.docs.length,
                              (index) {
                            DocumentSnapshot document =
                                snapshot.data!.docs[index];

                            return ChatWidget(
                              snap: document,
                              index: index,
                              isAllcommentsPage: false,
                            );
                          }));
                    }),
                
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
  double get minExtent => _tabBar.preferredSize.height + 16;

  @override
  double get maxExtent => _tabBar.preferredSize.height + 16;

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
