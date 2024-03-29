import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/pages/select%20photo.dart';
import 'package:twitter_clone/widgets.dart/follow%20back%20widget.dart';
import'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets.dart/chatwidget.dart';
import 'layout page.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  FirebaseAuth _auth = FirebaseAuth.instance; 
  
  double _appBarHeight = kToolbarHeight;

  @override
  void initState() {
    super.initState();
   
    _scrollController.addListener(() {
      double newHeight = kToolbarHeight - _scrollController.offset;
      setState(() {
        _appBarHeight = newHeight > 0 ? newHeight : 0;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? profileImage = ref.watch(profileImageUrlProvider);
     bool isDrawerOpen = ref.watch(isDrawerOpenProvider);
    return Scaffold(
      backgroundColor: isDrawerOpen ? Colors.grey[900]:Colors.black,
      body: CustomScrollView(
        // controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey[900],
            floating: true,
            pinned: false,
            centerTitle: true,
            //  toolbarHeight: _appBarHeight,
            leading:  Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage(
                  profileImage?? 'https://picsum.photos/200/300',
                ),
              ),
            ),
            title: const Text('Notifications'),
             actions: [
              Padding(
                padding: const EdgeInsets.only(right:10.0),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.settings_outlined)),
              ),
             ],
           
          ),
          SliverToBoxAdapter(
            child: StreamBuilder(
               stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                   // .orderBy('time', descending: true)
                    .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                 
                   if (!snapshot.hasData|| snapshot.data!.data()!['followers'] == null ) {
      return Container(
        height: screenSize!.height-150,
                  width: screenSize!.width, 
        child: Center(child: Text('your notifications will appear here')));
    }else{ 
       List<String> uids = [];
      if (snapshot.data!.data()!.containsKey('followers')) {
        uids = List<String>.from(snapshot.data!.data()!['followers']);
      }
              return Expanded(
                child: Container(
                  height: screenSize!.height,
                  width: screenSize!.width, 
                  child: ListView.builder(
                    
                     padding:  EdgeInsets.only(top: MediaQuery.of(context).padding.bottom),
                      itemCount: uids.length,
                      itemBuilder: (context, index) {
                        String ?uid = uids[index];
                        return FollowBackWidget(uid: uid,);
                      }),
                ),
              );} },
            ),
          )
        ],
      ),
    );
  }
}
