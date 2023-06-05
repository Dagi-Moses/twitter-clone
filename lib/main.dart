import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twitter_clone/pages/firstpage.dart';
import 'package:twitter_clone/pages/layout%20page.dart';
import 'package:twitter_clone/pages/login%20page.dart';
import 'package:twitter_clone/pages/sidemenu.dart';
import 'package:twitter_clone/pages/sign%20up%20page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/pages/splash%20screen.dart';
import 'package:twitter_clone/pages/user_profile.dart';

import 'firebase_options.dart';



Future <void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
  );
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xff303234),));
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckAuthPage(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      
      theme: ThemeData.dark().copyWith(
         textTheme: TextTheme(
          
      bodyLarge: GoogleFonts.abel(),
      ),
      )
    );
  }
}

class CheckAuthPage extends StatefulWidget {
  @override
  State<CheckAuthPage> createState() => _CheckAuthPageState();
}

class _CheckAuthPageState extends State<CheckAuthPage> {
   @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return   _isLoading
        ? SplashScreen():StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        
        if (snapshot.hasData && snapshot.data != null) {
          // User is signed in and not null, return authorized page
          return Layout();
        } else {
          // User is either not signed in or null, return un-authorized page
          return LoginPage();
        }
      },
    );
  }
}

