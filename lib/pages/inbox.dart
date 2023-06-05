import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class InboxPage extends StatefulWidget implements PreferredSizeWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
   @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight, );
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        // controller: _scrollController,
        slivers: [
          SliverAppBar(
            toolbarHeight: 70,
            backgroundColor: Colors.grey[900],
            floating: true,
            pinned: false,
            centerTitle: true,
            //  toolbarHeight: _appBarHeight,
            leading: const Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage(
                  'https://picsum.photos/200/300',
                ),
              ),
            ),
            title: const Text('Messages'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined)),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Container(
               // margin: EdgeInsets.only(top: 9),
                color: Colors.black,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left:20.0, right: 20),
                      child: TextField(
                        
                        decoration: InputDecoration(
                            
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 70),
                        filled: true,
                        fillColor: Colors.grey[850], 
                            
                          prefixIcon: Icon(Icons.search),
                       
                          hintText: 'Search Direct Messages',
                          border:OutlineInputBorder(
                            borderSide: BorderSide.none,
                            
                            borderRadius: BorderRadius.circular(30)
                          )
                        ),
                      ),
                    ),
                    Divider(thickness: 1.5,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
