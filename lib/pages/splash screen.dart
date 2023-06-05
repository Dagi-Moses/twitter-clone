import'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

   

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(child: Icon(FontAwesomeIcons.twitter, color: Colors.white , size: 40,),),
    );
  }
}