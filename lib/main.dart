import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';
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

import 'package:timeago/timeago.dart' as timeago;
class MyCustomMessages implements LookupMessages {

  @override String prefixAgo() => '';
  @override String prefixFromNow() => '';
  @override String suffixAgo() => '';
  @override String suffixFromNow() => '';
  @override String lessThanOneMinute(int seconds) => 'just now';
  @override String aboutAMinute(int minutes) => '${minutes}m';
  @override String minutes(int minutes) => '${minutes}m';
  @override String aboutAnHour(int minutes) => '${minutes}m';
  @override String hours(int hours) => '${hours}h';
  @override String aDay(int hours) => '${hours}h';
  @override String days(int days) => '${days}d';
  
  @override String aboutAMonth(int days) => '${days}d';
  @override String months(int months) => '${months}mo';
  @override String aboutAYear(int year) => '${year}y';
  @override String years(int years) => '${years}y';
  @override String wordSeparator() => ' ';
}
Future <void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
  );
  //SystemChrome.setEnabledSystemUIMode(overlays: );
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,));
  runApp( ProviderScope(child: MyApp()));
   timeago.setLocaleMessages('en', MyCustomMessages( ));

   
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
        scaffoldBackgroundColor: Colors.black, // Set the default background color for Scaffold
        appBarTheme: AppBarTheme(
          color: Colors.grey[900], // Set the default background color for AppBar
        ),
         textTheme: TextTheme(
        
      bodyLarge: GoogleFonts.roboto(),
      bodySmall: GoogleFonts.roboto(),
      bodyMedium: GoogleFonts.roboto(),
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

