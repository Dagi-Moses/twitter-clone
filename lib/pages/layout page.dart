import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_clone/pages/search%20page.dart';
import 'package:twitter_clone/pages/space.dart';
import 'package:twitter_clone/pages/tweetpage.dart';

import '../widgets.dart/drawer widget.dart';
import 'home page.dart';
import 'inbox.dart';
import 'notifications page.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}
//final isDrawer = StateProvider<bool>((ref) => false);
//final isDrawerOpen = useProvider(myBoolProvider.state);
bool isDrawerOpen = false;
// ValueNotifier<bool> globalBool = ValueNotifier<bool>(isDrawerOpen); 
class _LayoutState extends State<Layout> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
 

 
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const SearchPage(),
    const Space(),
    NotificationsPage(),
    const InboxPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
   double get _maxSlideWidth => 320.0;
double _mainPageLeftPosition = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) {
        _handleDragUpdate(details);
      },
      onHorizontalDragEnd: (details) {
       // print(MediaQuery.of(context).size.width).
        _handleDragEnd(details);
      },
      child: AnimatedBuilder(
        //left:_mainPageLeftPosition
          animation: _animationController!,
          builder: (context, child) {
            double slide = 1.0 - _animationController!.value;

            return Stack(
              children: [
                SlideTransition(
                  position: Tween<Offset>(
          begin: const Offset(0.0, 0.0),
          end: Offset(_maxSlideWidth / MediaQuery.of(context).size.width, 0.0),
        ).animate(_animationController!),
                  child: Scaffold(
                    backgroundColor:  Colors.black,
                    body: _widgetOptions.elementAt(_selectedIndex),
                    floatingActionButton: FloatingActionButton(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          _selectedIndex == 4
                              ? Icons.mark_email_read_outlined
                              : _selectedIndex == 2
                                  ? Icons.explore_outlined
                                  : Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:TweetPage()));
    }),
                    bottomNavigationBar: BottomNavigationBar(
                      iconSize: 25,
                      selectedIconTheme: const IconThemeData(
                        size: 28,
                        color: Colors.blue,
                      ), // set the size and color of the selected icon
                      unselectedIconTheme:
                          const IconThemeData(size: 25, color: Colors.white),
                      selectedItemColor: Colors.blue,
                      backgroundColor: Colors.black,
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                      type: BottomNavigationBarType.fixed,
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(
                            _selectedIndex == 0
                                ? Icons.home_filled
                                : Icons.home_outlined,
                          ),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(_selectedIndex == 1
                              ? Icons.search
                              : Icons.search_outlined),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            _selectedIndex == 2
                                ? Icons.explore
                                : Icons.explore_outlined,
                          ),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(_selectedIndex == 3
                              ? Icons.notifications
                              : Icons.notifications_none_outlined),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(_selectedIndex == 4
                              ? Icons.mail
                              : Icons.mail_outline),
                          label: '',
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(slide * -320, 0),
                  child: Container(
                   // color: Colors.black87,
                    width: 320,
                    child: Drawer(
                      backgroundColor: Color.fromARGB(255, 39, 39, 39),
                      child: DrawerWidget(),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    try {
      if (isDrawerOpen && details.delta.dx < 0) {
        _animationController!.value =
            details.primaryDelta! / 500;
      } else if (!isDrawerOpen &&
          details.delta.dx > 0 &&
          details.primaryDelta! > 0) {
        _animationController!.value = details.primaryDelta! / 500;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController!.value > 0) {
      _openDrawer();
    } else {
      _closeDrawer();
    }
  }

  void _openDrawer() {
    _animationController!.forward();
    setState(() {
      isDrawerOpen = true;
      
    });
  }

  void _closeDrawer() {
    _animationController!.reverse();
    setState(() {
      isDrawerOpen = false;
     
    });
  }
}

