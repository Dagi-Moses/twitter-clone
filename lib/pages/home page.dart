import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/pages/select%20photo.dart';

import '../widgets.dart/chatwidget.dart';
import '../widgets.dart/tweetcard.dart';
import 'layout page.dart';

class HomePage extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight,
      );
}
final scrollControllerProvider = Provider<ScrollController>((ref) {
  return ScrollController();
});
final followingUserIds  = StateProvider<List<String> ?>((ref) {
 return null;
});

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
     String _uid = FirebaseAuth.instance.currentUser!.uid;
  Size? screenSize;
   ScrollController ?_scrollController;
  TabController? _tabController;
  double _appBarHeight = kToolbarHeight;
  var userData;
  var postSnap;

  @override
  void initState() {
    super.initState();
getFollowingStream;
    _tabController = TabController(length: 2, vsync: this);
    _scrollController?.addListener(() {
      double newHeight = kToolbarHeight - _scrollController!.offset;
      setState(() {
        _appBarHeight = newHeight > 0 ? newHeight : 0;
      });
    });
  }

Stream get getFollowingStream{
 final snap = FirebaseFirestore.instance.collection('users').doc(_uid).snapshots() ;
 snap.listen((snapshot) { 
  print(followingUserIds);
  ref.read(followingUserIds.notifier).state =  List<String>.from(snapshot.data()!['following']);
 });
return snap;
}







  @override
  void dispose() {
    _scrollController!.dispose();
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final _scrollController = ref.read(scrollControllerProvider);
    screenSize = MediaQuery.of(context).size;
    bool isDrawerOpen = ref.watch(isDrawerOpenProvider);
    final followId = ref.watch(followingUserIds);
    String? profileImage = ref.watch(profileImageUrlProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: isDrawerOpen ? Colors.grey[900] : Colors.black,
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.grey[900],
              expandedHeight: 100,
              floating: true,
              snap: true,
              pinned: false,
              centerTitle: true,
              toolbarHeight: _appBarHeight,
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(
                    profileImage ?? 'https://picsum.photos/200/300',
                  ),
                ),
              ),
              title: Icon(
                FontAwesomeIcons.twitter,
                color: Colors.blue,
                size: 29,
              ),
              bottom: TabBar(
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.label,
                controller: _tabController,
                tabs: [
                  Tab(
                    text: 'For You',
                  ),
                  Tab(
                    text: 'Following',
                  ),
                ],
              ),
            ),
            ];},
          body:  TabBarView(

            controller: _tabController, children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    padding:  EdgeInsets.only(top: MediaQuery.of(context).padding.bottom),
                      children: 
                      List.generate (snapshot.data!.docs.length, (index) {
                        DocumentSnapshot document =
                            snapshot.data!.docs[index];
          
                  
          
                        return ChatWidget(
                          snap: document, index: index, isAllcommentsPage: false,
                        );
                      })
                      );
                }),
            
             StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid',whereIn:followId )
                      //.orderBy('time', descending: true)
                      .snapshots()
                      ,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      padding:  EdgeInsets.only(top: MediaQuery.of(context).padding.bottom),
                        children: 
                        List.generate (snapshot.data!.docs.length, (index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];
                      
                    
                      
                          return ChatWidget(
                            snap: document, index: index, isAllcommentsPage: false,
                          );
                        }));
                 
               },
              
            ),
            
          ])
          
        ),
      ),
    );
  }
}
