import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/widgets.dart/follow%20back%20widget.dart';

import '../widgets.dart/chatwidget.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  double _appBarHeight = kToolbarHeight;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          // controller: _scrollController,
          slivers: [
            SliverAppBar(
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
              title: const Text('Notifications'),
               actions: [
                Padding(
                  padding: const EdgeInsets.only(right:10.0),
                  child: IconButton(onPressed: (){}, icon: const Icon(Icons.settings_outlined)),
                ),
               ],
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                controller: _tabController,
                tabs: [
                  const Tab(
                    text: 'All',
                  ),
                  const Tab(
                    text: 'Verified',
                  ),
                  const Tab(
                    text: 'Mentions',
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(controller: _tabController, children: [
                    ListView.builder(
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return const FollowBackWidget();
                        }),
                    Container(
                      height: 500,
                      color: Colors.red,
                    ),
                    Container(
                      height: 500,
                      color: Colors.orangeAccent,
                    ),
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
