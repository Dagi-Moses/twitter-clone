import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets.dart/chatwidget.dart';
import '../widgets.dart/tweetcard.dart';
class HomePage extends StatefulWidget  implements PreferredSizeWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
   @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight, );
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
    ScrollController _scrollController = ScrollController();
 TabController? _tabController;
  double _appBarHeight = kToolbarHeight;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.grey[900],
              floating: true,
              pinned: false,
              
              centerTitle: true,
              toolbarHeight: _appBarHeight,
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  
                  radius: 10,
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/200/300',
                  
                  ),
                ),
              ),
              title: Icon(FontAwesomeIcons.twitter, color: Colors.blue, size: 29,),
            bottom: TabBar(
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
            SliverToBoxAdapter(
              
              child: Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    
                    controller: _tabController,
                    children: [
                      
                    
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
                       return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder:(context, index){
                            DocumentSnapshot document = snapshot.data!.docs[index];
                            
                            return ChatWidget(
                              tweet: document['tweet'],
                              profilePicUrl: 'https://th.bing.com/th/id/OIP.bgWCNBaB9pZIsy5wV-Y2GAHaEK?pid=ImgDet&rs=1',
                              imageurl: document['photoUrl'],

                            );
                        
                       } 
                       );
                     }
                     ),
                   Container(
                     height: 500,
                    color: Colors.red,
                  ),
                    ]
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

