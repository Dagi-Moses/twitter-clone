import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_clone/pages/search%20page.dart';
import 'package:twitter_clone/pages/select%20photo.dart';
import 'package:twitter_clone/pages/space.dart';
import 'package:twitter_clone/pages/tweetpage.dart';
import 'package:riverpod/riverpod.dart';

import '../common/app_icon.dart';
import '../widgets.dart/drawer widget.dart';
import 'home page.dart';
import 'inbox.dart';
import 'notifications page.dart';

class Layout extends ConsumerStatefulWidget {
  const Layout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LayoutState();
}

final BProvider = StateProvider<DateTime?>((ref) => null);
final JProvider = StateProvider<DateTime?>((ref) => null);
final nameProvider = StateProvider<String?>((ref) => null);
final datejoinedProvider = StateProvider<String?>((ref) => null);
final usernameProvider = StateProvider<String?>((ref) => null);
final bioProvider = StateProvider<String?>((ref) => null);
final locationProvider = StateProvider<String?>((ref) => null);
final birthdateProvider = StateProvider<String?>((ref) => null);
final isDrawerOpenProvider = StateProvider<bool>((ref) => false);

final sizeProvider = StateProvider<Size>((ref) => screenSize!);
Size? screenSize;
StateProvider<AnimationController?>? animationController;
class _LayoutState extends ConsumerState<Layout>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
   
  final PageController _pageController = PageController();
  bool? isDrawerOpen;

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();

    animationController = StateProvider<AnimationController>((ref) =>   AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    ));
  }

  @override
  void dispose() {
   // _animationController!.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(
        index,
      );
    });
  }

  double get _maxSlideWidth => 320.0;
  double _mainPageLeftPosition = 0;
  @override
  Widget build(BuildContext context) {
     final _animationController = ref.read( animationController!);
    final scrollController = ref.read(scrollControllerProvider);
    screenSize = MediaQuery.of(context).size;
    String? profileImage = ref.watch(profileImageUrlProvider);
    isDrawerOpen = ref.watch(isDrawerOpenProvider);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;

          Future.delayed(Duration(seconds: 1), () {
            final Timestamp timestamp = data?['dateOfBirth'] as Timestamp;

            final DateTime dateTime = timestamp.toDate();
            final Timestamp stamp = data?['dateJoined'] as Timestamp;

            final DateTime Time = stamp.toDate();
            ref.read(profileImageUrlProvider.notifier).state =
                data?['profileImage'];
            ref.read(nameProvider.notifier).state = data?['name'];
            ref.read(coverImageUrlProvider.notifier).state =
                data?['coverImage'];
            ref.read(bioProvider.notifier).state = data?['bio'];
            ref.read(usernameProvider.notifier).state = data?['username'];
            ref.read(locationProvider.notifier).state = data?['location'];
            ref.read(birthdateProvider.notifier).state =
                DateFormat.yMd().format(dateTime);
            ref.read(BProvider.notifier).state = dateTime;
            ref.read(JProvider.notifier).state = Time;

            ref.read(datejoinedProvider.notifier).state =
                DateFormat.yMd().format(Time);
            ;
          });

          String? profileImage = ref.watch(profileImageUrlProvider);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
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
                  double slide = 1.0 - _animationController.value;

                  return Stack(
                    children: [
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.0),
                          end: Offset(
                              _maxSlideWidth /
                                  MediaQuery.of(context).size.width,
                              0.0),
                        ).animate(_animationController),
                        child: Scaffold(
                          backgroundColor: Colors.black,
                          body: PageView(
                              allowImplicitScrolling: false,
                              physics: const NeverScrollableScrollPhysics(),
                              pageSnapping: true,
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              children: const [
                                HomePage(),
                                 SearchPage(),
                                
                                NotificationsPage(),
                                 InboxPage(),

                              ]),
                          floatingActionButton: FloatingActionButton(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                _selectedIndex == 3
                                    ? Icons.mark_email_read_outlined
                                    
                                        : Icons.add,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: TweetPage()));
                              }),
                          bottomNavigationBar: BottomNavigationBar(
                            iconSize: 25,
                            selectedIconTheme: const IconThemeData(
                              size: 28,
                              color: Colors.blue,
                            ), // set the size and color of the selected icon
                            unselectedIconTheme: const IconThemeData(
                                size: 25, color: Colors.white),
                            selectedItemColor: Colors.blue,
                            backgroundColor: isDrawerOpen!
                                ? Color.fromARGB(255, 29, 28, 28)
                                : Colors.black,
                            currentIndex: _selectedIndex,
                            onTap: _onItemTapped,
                            type: BottomNavigationBarType.fixed,
                            items: <BottomNavigationBarItem>[
                              BottomNavigationBarItem(
                                icon: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (_selectedIndex == 0) {
                                      scrollController.animateTo(
                                        0,
                                        duration: Duration(milliseconds: 100),
                                        curve: Curves.easeIn,
                                      );
                                    }
                                  },
                                  child: Icon(
                                    _selectedIndex == 0
                                        ? AppIcon.homeFill
                                        : AppIcon.home
                                  ),
                                ),
                                label: '',
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(_selectedIndex == 1
                                    ? AppIcon.searchFill
                                    : AppIcon.search),
                                label: '',
                              ),
                            
                              BottomNavigationBarItem(
                                icon: Icon(_selectedIndex == 2
                                    ? AppIcon.notificationFill
                                    : AppIcon.notification),
                                label: '',
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(_selectedIndex == 3
                                    ? AppIcon.messageFill
                                    : AppIcon.messageEmpty),
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
                            backgroundColor: Colors.black,
                            child: DrawerWidget(profileImage: profileImage),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          );
        });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    try {
      if (isDrawerOpen! && details.delta.dx < 0) {
       ref.read(animationController!.notifier).state!.value = details.primaryDelta! / 500;
      } else if (!isDrawerOpen! &&
          details.delta.dx > 0 &&
          details.primaryDelta! > 0) {
        ref.read(animationController!.notifier).state!.value = details.primaryDelta! / 500;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (ref.read(animationController!.notifier).state!.value > 0) {
      _openDrawer();
    } else {
      _closeDrawer();
    }
  }

  void _openDrawer() {
    ref.read(animationController!.notifier).state!.forward();
    // setState(() {isDrawerOpen = true; });
    ref.read(isDrawerOpenProvider.notifier).state = true;
  }

  void _closeDrawer() {
   ref.read(animationController!.notifier).state!.reverse();
    // setState(() {isDrawerOpen = false; });
    ref.read(isDrawerOpenProvider.notifier).state = false;
  }
}
